#!/bin/bash

#cd $PBS_SCRATCH_DIR/$PBS_JOBID
cd /local/$USER/$LSB_JOBID

source $CONFIG_FILE
set -o pipefail
set -x
module load samtools

# temp files to be created
tmpfile=basis.tmp
alloverlap=alloverlap.tmp

touch $RESULT.tmp
if [ ! -f $RESULT.tmp ]
then
	echo could not create $RESULT.tmp
	exit 13
fi

# determine compression by extension (bgzip default is gz)
# use tabix if the file is compressed => major speedup bc. no need to go over whole vcf for each chrom
suffix=${SNVFILE##*.}
if [ "$suffix" == "gz" ] 
then
	use_tabix=1
fi

# make pileup for the positions in the mutation table
for chr in ${CHROMOSOME_INDICES[@]}
do
	chrn=${CHR_PREFIX}${chr}$CHR_SUFFIX
	if [ "$DIFFERCHROM" == 1 ]
	then
		if [ "$use_tabix" == "1" ]
		then
			tabix $SNVFILE $chrn | perl -lane 'BEGIN {$chromosome=shift; $newprefix = shift; $newsuffix=shift;$oldprefix = shift; $oldsuffix=shift;} @a=split(/\t/); if ($a[0] eq $chromosome){$a[0] =~ s/^$oldprefix//; $a[0] =~ s/$oldsuffix$//; $a[0]=$newprefix.$a[0].$newsuffix; $,="\t"; print @a}' $chrn "$BAMCHR_PREFIX" "$BAMCHR_SUFFIX" "$CHR_PREFIX" "$CHR_SUFFIX" > $tmpfile
		else	# need to go over whole vcf and get matching entries
			cat $SNVFILE | perl -lane 'BEGIN {$chromosome=shift; $newprefix = shift; $newsuffix=shift;$oldprefix = shift; $oldsuffix=shift;} @a=split(/\t/); if ($a[0] eq $chromosome){$a[0] =~ s/^$oldprefix//; $a[0] =~ s/$oldsuffix$//; $a[0]=$newprefix.$a[0].$newsuffix; $,="\t"; print @a}' $chrn "$BAMCHR_PREFIX" "$BAMCHR_SUFFIX" "$CHR_PREFIX" "$CHR_SUFFIX" > $tmpfile
		fi
		# evaluation below needs updated pattern
		chrn=$BAMCHR_PREFIX$chr$BAMCHR_SUFFIX
	else	# no need to juggle with pre- and suffixes
		if [ "$use_tabix" == "1" ]
		then
			tabix $SNVFILE $chrn > $tmpfile
		else
			cat $SNVFILE | awk '($1 == "'"$chrn"'") {print $0}'  > $tmpfile
		fi
	fi

	if [[ "$?" != 0 ]]
	then
		echo "There was a non-zero exit code in creating temp position file on local scratch, exiting."
		exit 21
	fi

	# pileup only makes sense if there was something for the chromosome!
	lines=`cat $tmpfile | wc -l`
	echo $chrn has $lines entries
	if [ "$lines" -ge 1 ]
	then
		# BAM2 is optional, empty in case only 1 was provided
		$SAMTOOLS mpileup $MPILEUP_PARAMS -l $tmpfile -f $REFERENCE_GENOME -r ${chrn} $BAM $BAM2 | perl $PIPELINE_DIR/vcf_pileup_compare_2samples.pl $tmpfile - no $ADD_TYPE $SAMPLES >> $alloverlap
		if [[ "$?" != 0 ]]
		then
			echo "There was a non-zero exit code in the mpileup-vcf compare pipe, exiting."
			exit 22
		fi
	fi
done

# get the last line of the header and append additional info
if [ "$use_tabix" == "1" ]
then
	tabix -h $SNVFILE 0 | perl -ne 'BEGIN {$add1=shift; $add2=shift;} if ($_ =~ /^#CHROM/) {chomp; print $_, "\tINFO_$add1(VAF=variant_allele_fraction;TSR=total_variant_supporting_reads_incl_lowqual)\tANNOTATION_$add1\tVARIANTREADS_$add1"; if (defined $add2){print "\tINFO_$add2(VAF=variant_allele_fraction;TSR=total_variant_supporting_reads_incl_lowqual)\tANNOTATION_$add2\tVARIANTREADS_$add2";}print "\n";}' $ADD1 $ADD2 > $RESULT.tmp
else
	cat $SNVFILE | head -n 1000 | perl -ne 'BEGIN {$add1=shift; $add2=shift;} if ($_ =~ /^#CHROM/) {chomp; print $_, "\tINFO_$add1(VAF=variant_allele_fraction;TSR=total_variant_supporting_reads_incl_lowqual)\tANNOTATION_$add1\tVARIANTREADS_$add1"; if (defined $add2){print "\tINFO_$add2(VAF=variant_allele_fraction;TSR=total_variant_supporting_reads_incl_lowqual)\tANNOTATION_$add2\tVARIANTREADS_$add2";}print "\n";}' $ADD1 $ADD2 > $RESULT.tmp
fi

# check for existence of a header (file size > 0)
if [[ -s $RESULT.tmp ]]
then
	cat $alloverlap >> $RESULT.tmp && mv $RESULT.tmp $RESULT
else
	echo "header creation and writing to result file had error, result file not moved back."
	exit 23
fi

rm $alloverlap $tmpfile

# in case of indels, need to look $INDEL_PADDING bp around the position; this only works for 1 BAM at a time
if [ ! -z $INDEL_PADDING ]
then
	# first (or only) BAM
	perl ${TOOLS_DIR}/indel_annotate_with_germline_mpileup.pl --tumorFile=$RESULT --germlineBam=$BAM --columnName=${INDEL_MPILEUP_COL}_$ADD1 --padding=$INDEL_PADDING --samtools_bin=$SAMTOOLS --referenceGenome=$REFERENCE_GENOME --toolsDir=$TOOLS_DIR --mpileupOptions="$MPILEUP_PARAMS" --scratchDir="$PBS_SCRATCH_DIR/$PBS_JOBID" | perl $TOOLS_DIR/padding_evaluation_indels.pl - ${INDEL_MPILEUP_COL}_$ADD1 ANNOTATION_$ADD1 > $RESULT.tmp
	if [[ "$?" != 0 ]]
	then
		echo "indel padding pipeline for $ADD1 returned non-zero exit code, result file not moved back."
		exit 24
	else
		mv $RESULT.tmp $RESULT
	fi
	# second sample? then repeat the procedure
	if [ ! -z $SAMPLES ]
	then
		perl ${TOOLS_DIR}/indel_annotate_with_germline_mpileup.pl --tumorFile=$RESULT --germlineBam=$BAM2 --columnName=${INDEL_MPILEUP_COL}_$ADD2 --padding=$INDEL_PADDING --samtools_bin=$SAMTOOLS --referenceGenome=$REFERENCE_GENOME --toolsDir=$TOOLS_DIR --mpileupOptions="$MPILEUP_PARAMS" --scratchDir="$PBS_SCRATCH_DIR/$PBS_JOBID" | perl $TOOLS_DIR/padding_evaluation_indels.pl - ${INDEL_MPILEUP_COL}_$ADD2 ANNOTATION_$ADD2 > $RESULT.tmp
		if [[ "$?" != 0 ]]
		then
			echo "indel padding pipeline for $ADD2 returned non-zero exit code, result file not moved back."
			exit 25
		else
			mv $RESULT.tmp $RESULT
		fi
	fi
fi

# compress with bgzip and tabix?
if [ "$COMPRESS_RESULT" == "1" ]
then
	bgzip -f $RESULT && tabix -f -p vcf $RESULT.gz
fi
