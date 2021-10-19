result_per_pid_dir="/icgc/dkfzlsdf/analysis/OE0290_projects/pediatric_tumor/exon_sequencing/results_per_pid/"
PIPELINE_DIR=/icgc/dkfzlsdf/analysis/OE0290_projects/pediatric_tumor/exon_sequencing/processing_scripts/addBAMinfo/
config_file="${PIPELINE_DIR}/addBAMinfo_Params_WES_functional_snv.config"


PIDs="OE0290-PED_5LB-010 OE0290-PED_5LB-034"
for pid in ${PIDs}; do
	sample_pid_dir=${result_per_pid_dir}/${pid}/
	tumor_bams=$(find ${sample_pid_dir}/alignment/ ! -name "plasma*.bam" -a ! -name "serum*.bam" -a ! -name "csf*.bam" -a ! -name "ascites*.bam" -a ! -name "blood*.bam" -a ! -name "control*.bam" -a -name "*.bam")
	sample_mpileup_dir=${sample_pid_dir}/mpileup/
	cfDNA_bams=$(find ${sample_pid_dir}/alignment/ -name "plasma*merged.mdup.on-target.bam" -o -name "serum*merged.mdup.on-target.bam" -o -name "csf*merged.mdup.on-target.bam" -o -name "ascites*merged.mdup.on-target.bam")
	for tumor_bam in ${tumor_bams}; do
		tumor_id=$(basename ${tumor_bam} | cut -f1 -d "_")
		tumor_mpileup_dirs=$(find ${sample_mpileup_dir} -maxdepth 1 -type d -name "${tumor_id}_*")
		for tumor_mpileup_dir in ${tumor_mpileup_dirs}; do
			tumor_vcf=$(find ${tumor_mpileup_dir} -name "snvs_*_somatic_functional_snvs_conf_8_to_10.vcf")
			for cfDNA_bam in ${cfDNA_bams}; do
				echo "${pid} ${tumor_id}:$(basename ${cfDNA_bam} | cut -f1 -d "_")"
				addBaminfo_cmd="${PIPELINE_DIR}/run_addBAMinfo.sh -c ${config_file} ${tumor_vcf} ${tumor_bam} ${cfDNA_bam}"	
				${addBaminfo_cmd}
			done
		done

	done

done

config_file="${PIPELINE_DIR}/addBAMinfo_Params_WES_functional_indel.config"
for pid in ${PIDs}; do
        sample_pid_dir=${result_per_pid_dir}/${pid}/
        tumor_bams=$(find ${sample_pid_dir}/alignment/ ! -name "plasma*.bam" -a ! -name "serum*.bam" -a ! -name "csf*.bam" -a ! -name "ascites*.bam" -a ! -name "blood*.bam" -a ! -name "control*.bam" -a -name "*.bam")
        sample_mpileup_dir=${sample_pid_dir}/indels/
        cfDNA_bams=$(find ${sample_pid_dir}/alignment/ -name "plasma*merged.mdup.on-target.bam" -o -name "serum*merged.mdup.on-target.bam" -o -name "csf*merged.mdup.on-target.bam" -o -name "ascites*merged.mdup.on-target.bam")
        for tumor_bam in ${tumor_bams}; do
                tumor_id=$(basename ${tumor_bam} | cut -f1 -d "_")
                tumor_mpileup_dirs=$(find ${sample_mpileup_dir} -maxdepth 1 -type d -name "${tumor_id}_*")
                for tumor_mpileup_dir in ${tumor_mpileup_dirs}; do
                        tumor_vcf=$(find ${tumor_mpileup_dir} -name "indel_*_somatic_functional_indels_conf_8_to_10.vcf")
                        for cfDNA_bam in ${cfDNA_bams}; do
                                echo "${pid} ${tumor_id}:$(basename ${cfDNA_bam} | cut -f1 -d "_")"
                                addBaminfo_cmd="${PIPELINE_DIR}/run_addBAMinfo.sh -c ${config_file} ${tumor_vcf} ${tumor_bam} ${cfDNA_bam}"
                                ${addBaminfo_cmd}
                        done
                done

        done

done
