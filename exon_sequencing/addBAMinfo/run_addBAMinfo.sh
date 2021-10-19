#!/bin/bash

#sh run_addBAMinfo.sh -c <parameters_dir>/addBAMinfo_Params.txt SNV_FILE TUMOR_BAMFILE PLASMA_BAMFILE

# get parameters 
while getopts 'c:vCFA' OPTION
do
	case $OPTION in
		c)      cflag=1
		CONFIG_FILE="$OPTARG"
		;;
		v)      vflag=1 # verbose
		;;
		?)      printf "Usage: %s -c CONFIG_FILE [-v] SNV_FILE TUMOR_BAMFILE PLASMA_BAMFILE\n" $(basename $0) >&2
		exit 2
		;;
	esac
done

# everything after the flagged arguments are input files
shift $(($OPTIND - 1))
#PIDS=$*
SNV_FILE=$1
TUMOR_BAMFILE=$2
PLASMA_BAMFILE=$3

if [[ -z $CONFIG_FILE || ! -f $CONFIG_FILE ]]
	then
	printf "Config file %s not found. Exiting...\n" $CONFIG_FILE >&2
	exit 2
fi
source $CONFIG_FILE
if [ "$vflag" == 1 ] 
then
	grep -v '###' $CONFIG_FILE   ### FIXME make nicer output
	printf "%s\n" "`mpileup | head -n1`"
	printf "PIDs are: %s\n" "$PIDS"
fi

if [ ! -d $PIPELINE_DIR ]
then 
	printf "Analysis tools directory not found. Exiting...\n" >&2
	exit 2
fi

if [ ! -d $TOOLS_DIR ]
then 
	printf "Common tools directory not found. Exiting...\n" >&2
	exit 2
fi


addbam2=""
samples=""

eval "snvfile=$SNV_FILE"
	if [ ! -f $snvfile ]; then echo "SNV annotation file $snvfile not found for PID $pid; Skipping..."; continue; fi
	
eval "addbam=${TUMOR_BAMFILE}"

if [ ! -e $addbam ]; then 
	echo "BAM file for additional annotation not found for $addbam ;"
	exit 1;
fi

if [ ! -e ${addbam}.bai ]; then 
	echo "BAM file $addbam has no index for $addbam (${addbam}.bai)";
	exit 1;
fi

if [ ! -z $PLASMA_BAMFILE ]; then
	samples=2
	eval "addbam2=$PLASMA_BAMFILE"
	if [ ! -e $addbam2 ]; then
		echo "second BAM file $addbam2 for additional annotation not found for ${addbam2}";
		exit 1;
	fi
	if [ ! -e ${addbam2}.bai ]; then
		echo "second BAM file $addbam2 has no index for ${addbam2} (${addbam2}.bai)";
		exit 1;
	fi
fi

	#if [ ! -d $ADD_SUBDIR ]; then mkdir $ADD_SUBDIR; fi

TUMOR_PID=$(basename $(dirname $(dirname ${addbam})))	
plasma_sample_id=$(basename ${PLASMA_BAMFILE} | cut -f1 -d "_")
add_dir=${RESULTS_PER_PIDS_DIR}/${TUMOR_PID}/$ADD_SUBDIR
if [ ! -d ${add_dir} ]; then mkdir ${add_dir}; fi
add_dir=${add_dir}/${plasma_sample_id}/
if [ ! -d ${add_dir} ]; then mkdir ${add_dir}; fi

bsublog_dir=${add_dir}/bsublog
if [ ! -d ${bsublog_dir} ]; then mkdir ${bsublog_dir}; fi

prefix=$(basename `dirname ${snvfile}`)_${plasma_sample_id}

resultfile=$add_dir/${prefix}$ADD_OUTPUT_SUFFIX

if [ "$samples" == "2" ]; then
	append=",BAM2=$addbam2,SAMPLES=$samples"
fi
	
EO_MAIL_OPTS="-eo ${bsublog_dir}/${prefix}_addbaminfo.eo -oo ${bsublog_dir}/${prefix}_addbaminfo.oo"
#echo ""	
#echo "bsub $EO_MAIL_OPTS -J addAnnotation_${prefix} $ADD_PBS_RESOURCES -env \"all, SNVFILE=$snvfile,RESULT=$resultfile,CONFIG_FILE=$CONFIG_FILE,BAM=${addbam}$append\" $PIPELINE_DIR/pileupAddition.sh"

addjob=`bsub $EO_MAIL_OPTS -J addAnnotation_${prefix} $ADD_PBS_RESOURCES -env "all, SNVFILE=$snvfile,RESULT=$resultfile,CONFIG_FILE=$CONFIG_FILE,BAM=${addbam}$append" $PIPELINE_DIR/pileupAddition.sh | cut -d "." -f 1`
echo submitted addAnnotation for PID $pid , job ID $addjob

