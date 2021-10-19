pids_dir="/omics/odcf/analysis/OE0290_projects/pediatric_tumor/panel_sequencing/results_per_pid/"
module_load_CMD="module load samtools/1.2 java"
picard_jar="/omics/groups/OE0436/data/puranach/packages/picard.jar"

PIDs=""

reference_fasta="/icgc/ngs_share/assemblies/hg19_GRCh37_1000genomes/indexes/bwa/bwa06_1KGRef_Phix/hs37d5_PhiX.fa"
interval_file="/icgc/dkfzlsdf/analysis/OE0290_projects/pediatric_tumor/panel_sequencing/target_regions/panel_target_coverage_plain.interval_list"
READ_LENGTH=100
for pid in ${PIDs}; do
	pid_dir=${pids_dir}/${pid}/
        alignment_dir=${pid_dir}/alignment/
        umi_alignment_dir=${pid_dir}/alignment_umi/

	sample_bams=$(find ${alignment_dir} -name "*merged.mdup.bam")

	for sample_bam in ${sample_bams}; do

        	logdir="${alignment_dir}/stat_coverage/logfiles"
        	mkdir -p ${logdir}
		CMD="${module_load_CMD};samtools view -q20 -f3 -u ${sample_bam} | java -jar ${picard_jar} CollectWgsMetrics I=/dev/stdin R=${reference_fasta} O=${alignment_dir}/stat_coverage/$(basename ${sample_bam} .bam)_CollectWgsMetrics.txt INCLUDE_BQ_HISTOGRAM=true READ_LENGTH=${READ_LENGTH} INTERVALS=${interval_file} CAP=10000" 
		echo ${CMD} | bsub -R "rusage[mem=10GB]" -q verylong -J "CollectWgsMetrics_$(basename ${sample_bam} .bam)" -oo ${logdir} 

        done

	#continue
	if [ ! -d "${umi_alignment_dir}" ]; then
		continue
	fi
	sample_umi_bams=$(find ${umi_alignment_dir} -name "*callConsensus_realigned.bam")

	for sample_umi_bam in ${sample_umi_bams}; do
		logdir="${umi_alignment_dir}/stat_coverage/logfiles"
		mkdir -p ${logdir}
		mkdir -p ${umi_alignment_dir}/stat_coverage
	 	CMD="${module_load_CMD};samtools view -q20 -f3 -F1024 -u ${sample_umi_bam} | java -jar ${picard_jar} CollectWgsMetrics I=/dev/stdin R=${reference_fasta} O=${umi_alignment_dir}/stat_coverage/$(basename ${sample_umi_bam} .bam)_CollectWgsMetrics.txt INCLUDE_BQ_HISTOGRAM=true READ_LENGTH=${READ_LENGTH} INTERVALS=${interval_file} CAP=10000"
		echo ${CMD} | bsub -R "rusage[mem=10GB]" -q verylong -J "CollectWgsMetrics_umi_$(basename ${sample_umi_bam} .bam)" -oo ${logdir}
	done
done
