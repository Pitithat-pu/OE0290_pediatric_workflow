pids_dir="/icgc/dkfzlsdf/analysis/OE0290_projects/pediatric_tumor/panel_sequencing/results_per_pid/"

PIDs=""
module_load_CMD="module load samtools bedtools;"
target_regions_bed="/icgc/dkfzlsdf/analysis/OE0290_projects/pediatric_tumor/panel_sequencing/target_regions/panel_target_coverage_plain.bed"

for pid in ${PIDs}; do
	pid_dir=${pids_dir}/${pid}/
        #alignment_dir=${pid_dir}/alignment/
        umi_alignment_dir=${pid_dir}/alignment_umi/
	if [ ! -d ${umi_alignment_dir} ]; then
		umi_alignment_dir=${pid_dir}/alignment
	fi


	output_dir=${umi_alignment_dir}


	sample_umi_bams=$(find  ${umi_alignment_dir} -name "*_callConsensus_realigned.bam" -o -name "*.mdup.bam")

	for sample_umi_bam in ${sample_umi_bams}; do
                if [ ! -f ${sample_umi_bam} ]; then
                        continue
                else
			sample_id=$(basename ${sample_umi_bam} | cut -f1 -d"_")
			echo "${sample_id}_${pid}"
			output_filename=$(basename ${sample_umi_bam} | sed 's/.bam/.on-target.bam/g')
			extract_ontarget_CMD="${module_load_CMD} bedtools intersect -abam ${sample_umi_bam} -b ${target_regions_bed} > ${output_dir}/${output_filename};"
			create_index_cmd="${module_load_CMD}; samtools index ${output_dir}/${output_filename};"
			bsub_CMD_file=${output_dir}/${sample_id}_${pid}_bsub_extract_ontarget_reads.sh
			echo -e ${extract_ontarget_CMD} ${create_index_cmd} > ${bsub_CMD_file}
			chmod 764 ${bsub_CMD_file}
			bsub -J extract_ontarget_reads_${sample_id}_${pid} -R "rusage[mem=3GB]" -q verylong < ${bsub_CMD_file} 
		fi
	done

done
