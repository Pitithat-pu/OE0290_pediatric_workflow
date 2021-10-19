pids_dir="/icgc/dkfzlsdf/analysis/OE0290_projects/pediatric_tumor/panel_sequencing/results_per_pid/"
module_load_CMD="module load samtools/1.2"
PIDs="OE0290-PED_4LB-002"
bed_file="/icgc/dkfzlsdf/analysis/OE0290_projects/pediatric_tumor/panel_sequencing/target_regions/panel_target_coverage_plain.bed"

for pid in ${PIDs}; do
        pid_dir=${pids_dir}/${pid}/
        alignment_dir=${pid_dir}/alignment/
        umi_alignment_dir=${pid_dir}/alignment_umi/

        sample_bams=$(find ${alignment_dir} -name "*merged.mdup.bam")

	 for sample_bam in ${sample_bams}; do

                logdir="${alignment_dir}/stat_coverage/logfiles"
                mkdir -p ${logdir}
                CMD="${module_load_CMD};samtools depth ${sample_bam} -b ${bed_file} -q 20 > ${alignment_dir}/stat_coverage/$(basename ${sample_bam} .bam)_depth.tsv; if [ -f ${alignment_dir}/stat_coverage/$(basename ${sample_bam} .bam)_depth.tsv ]; then sort -k3 -n ${alignment_dir}/stat_coverage/$(basename ${sample_bam} .bam)_depth.tsv | awk ' { a[i++]=\$3; }  END { x=int((i+1)/2); if (x < (i+1)/2) print (a[x-1]+a[x])/2; else print a[x-1]; }' > ${alignment_dir}/stat_coverage/$(basename ${sample_bam} .bam)_mediumdepth.txt ;fi"

                echo ${CMD} | bsub -R "rusage[mem=10GB]" -q verylong -J "SamtoolsDepth_$(basename ${sample_bam} .bam)" -oo ${logdir}


        done

	if [ ! -d "${umi_alignment_dir}" ]; then
                continue
        fi
        sample_umi_bams=$(find ${umi_alignment_dir} -name "*callConsensus_realigned.bam")

        for sample_umi_bam in ${sample_umi_bams}; do
		logdir="${umi_alignment_dir}/stat_coverage/logfiles"
                mkdir -p ${logdir}
                mkdir -p ${umi_alignment_dir}/stat_coverage
		CMD="${module_load_CMD};samtools depth ${sample_umi_bam} -b ${bed_file} -q 20 > ${umi_alignment_dir}/stat_coverage/$(basename ${sample_umi_bam} .bam)_depth.tsv; if [ -f ${umi_alignment_dir}/stat_coverage/$(basename ${sample_umi_bam} .bam)_depth.tsv ]; then sort -k3 -n ${umi_alignment_dir}/stat_coverage/$(basename ${sample_umi_bam} .bam)_depth.tsv | awk ' { a[i++]=\$3; }  END { x=int((i+1)/2); if (x < (i+1)/2) print (a[x-1]+a[x])/2; else print a[x-1]; }' > ${umi_alignment_dir}/stat_coverage/$(basename ${sample_umi_bam} .bam)_mediumdepth.txt ;fi"
		echo ${CMD} | bsub -R "rusage[mem=10GB]" -q verylong -J "SamtoolsDepth_umi_$(basename ${sample_umi_bam} .bam)" -oo ${logdir}
	done
done
