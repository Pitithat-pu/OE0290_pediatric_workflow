result_per_pid_dir="/icgc/dkfzlsdf/analysis/OE0290_projects/pediatric_tumor/panel_sequencing/results_per_pid/"
exon_result_per_pid_dir="/icgc/dkfzlsdf/analysis/OE0290_projects/pediatric_tumor/exon_sequencing/results_per_pid/"
PIPELINE_DIR=/icgc/dkfzlsdf/analysis/OE0290_projects/pediatric_tumor/panel_sequencing/processing_scripts/addBAMinfo/
config_file="${PIPELINE_DIR}/addBAMinfo_Params_PANEL_functional_snv.config"

PIDs="OE0290-PED_1LB-001 OE0290-PED_1LB-002 OE0290-PED_1LB-003 OE0290-PED_1LB-004 OE0290-PED_1LB-005 OE0290-PED_1LB-006 OE0290-PED_1LB-007 OE0290-PED_1LB-008 OE0290-PED_1LB-009 OE0290-PED_1LB-010 OE0290-PED_1LB-011 OE0290-PED_1LB-012 OE0290-PED_1LB-013 OE0290-PED_1LB-014 OE0290-PED_1LB-015 OE0290-PED_1LB-016 OE0290-PED_1LB-017 OE0290-PED_1LB-018 OE0290-PED_1LB-019 OE0290-PED_1LB-020 OE0290-PED_1LB-021 OE0290-PED_1LB-022 OE0290-PED_1LB-023 OE0290-PED_1LB-024 OE0290-PED_1LB-025 OE0290-PED_1LB-026 OE0290-PED_1LB-027 OE0290-PED_1LB-028 OE0290-PED_1LB-029 OE0290-PED_1LB-030 OE0290-PED_1LB-031 OE0290-PED_1LB-033 OE0290-PED_1LB-042 OE0290-PED_1LB-044 OE0290-PED_1LB-045 OE0290-PED_1LB-046 OE0290-PED_1LB-047 OE0290-PED_1LB-048 OE0290-PED_1LB-053 OE0290-PED_1LB-054 OE0290-PED_1LB-056 OE0290-PED_1LB-059 OE0290-PED_1LB-060 OE0290-PED_1LB-061 OE0290-PED_1LB-062 OE0290-PED_1LB-064 OE0290-PED_1LB-066 OE0290-PED_1LB-068 OE0290-PED_1LB-069 OE0290-PED_2LB-002 OE0290-PED_2LB-005 OE0290-PED_2LB-008 OE0290-PED_2LB-010 OE0290-PED_2LB-011 OE0290-PED_2LB-017 OE0290-PED_2LB-021 OE0290-PED_2LB-022 OE0290-PED_2LB-023 OE0290-PED_2LB-025 OE0290-PED_2LB-026 OE0290-PED_2LB-029 OE0290-PED_2LB-030 OE0290-PED_2LB-031 OE0290-PED_2LB-034 OE0290-PED_2LB-035 OE0290-PED_2LB-037 OE0290-PED_2LB-038 OE0290-PED_2LB-039 OE0290-PED_2LB-040 OE0290-PED_2LB-041 OE0290-PED_2LB-042 OE0290-PED_2LB-043 OE0290-PED_2LB-044 OE0290-PED_2LB-045 OE0290-PED_2LB-046 OE0290-PED_2LB-047 OE0290-PED_2LB-048 OE0290-PED_2LB-049 OE0290-PED_2LB-050 OE0290-PED_2LB-051 OE0290-PED_2LB-053 OE0290-PED_2LB-054 OE0290-PED_2LB-055 OE0290-PED_2LB-056 OE0290-PED_2LB-058 OE0290-PED_2LB-059 OE0290-PED_2LB-061 OE0290-PED_2LB-062 OE0290-PED_2LB-063 OE0290-PED_2LB-066 OE0290-PED_2LB-067 OE0290-PED_2LB-068 OE0290-PED_2LB-069 OE0290-PED_2LB-070 OE0290-PED_2LB-071 OE0290-PED_2LB-072 OE0290-PED_2LB-073 OE0290-PED_2LB-075 OE0290-PED_2LB-078 OE0290-PED_2LB-079 OE0290-PED_2LB-080 OE0290-PED_2LB-081 OE0290-PED_2LB-083 OE0290-PED_2LB-084 OE0290-PED_2LB-085 OE0290-PED_2LB-086 OE0290-PED_2LB-087 OE0290-PED_2LB-088 OE0290-PED_2LB-089 OE0290-PED_2LB-090 OE0290-PED_2LB-091 OE0290-PED_2LB-092 OE0290-PED_2LB-093 OE0290-PED_2LB-094 OE0290-PED_2LB-096 OE0290-PED_2LB-097 OE0290-PED_2LB-098 OE0290-PED_2LB-099 OE0290-PED_2LB-100 OE0290-PED_2LB-101 OE0290-PED_2LB-102 OE0290-PED_2LB-107 OE0290-PED_2LB-108 OE0290-PED_2LB-109 OE0290-PED_2LB-113 OE0290-PED_3LB-003 OE0290-PED_3LB-004 OE0290-PED_3LB-005 OE0290-PED_3LB-006 OE0290-PED_4LB-002 OE0290-PED_4LB-003 OE0290-PED_4LB-004 OE0290-PED_4LB-005 OE0290-PED_4LB-006 OE0290-PED_4LB-007 OE0290-PED_4LB-008 OE0290-PED_5LB-001"
for pid in ${PIDs}; do
	sample_pid_dir=${result_per_pid_dir}/${pid}/
	
	if [ ! -d ${exon_result_per_pid_dir}/${pid} ]; then
		echo "Tumor exon doesn't exist : ${pid}."
		continue
	fi
	tumor_bams=$(find ${exon_result_per_pid_dir}/${pid}/alignment/ ! -name "plasma*.bam" -a ! -name "serum*.bam" -a ! -name "csf*.bam" -a ! -name "ascites*.bam" -a ! -name "blood*.bam" -a ! -name "control*.bam" -a -name "*.bam")
	sample_mpileup_dir=${exon_result_per_pid_dir}/${pid}/mpileup/

	cfDNA_alignment_dir=${sample_pid_dir}/alignment_umi/
	if [ ! -d ${cfDNA_alignment_dir} ]; then
		cfDNA_alignment_dir=${sample_pid_dir}/alignment
	fi

	cfDNA_bams=$(find ${cfDNA_alignment_dir} -name "plasma*on-target.bam" -o -name "serum*on-target.bam" -o -name "csf*on-target.bam" -o -name "ascites*on-target.bam")
	for tumor_bam in ${tumor_bams}; do
		tumor_id=$(basename ${tumor_bam} | cut -f1 -d "_")
		tumor_mpileup_dirs=$(find ${sample_mpileup_dir} -maxdepth 1 -type d -name "${tumor_id}_*")

		for tumor_mpileup_dir in ${tumor_mpileup_dirs}; do
			tumor_vcf=$(find ${tumor_mpileup_dir} -name "snvs_*_somatic_functional_snvs_conf_8_to_10.vcf")
			for cfDNA_bam in ${cfDNA_bams}; do
				addBaminfo_cmd="${PIPELINE_DIR}/run_addBAMinfo.sh -c ${config_file} ${tumor_vcf} ${tumor_bam} ${cfDNA_bam}"	
				${addBaminfo_cmd}
			done
		done

	done

done

config_file="${PIPELINE_DIR}/addBAMinfo_Params_PANEL_functional_indel.config"
for pid in ${PIDs}; do
        sample_pid_dir=${result_per_pid_dir}/${pid}/

	if [ ! -d ${exon_result_per_pid_dir}/${pid} ]; then
                echo "Tumor exon doesn't exist : ${pid}."
                continue
        fi

        tumor_bams=$(find ${exon_result_per_pid_dir}/${pid}/alignment/ ! -name "plasma*.bam" -a ! -name "serum*.bam" -a ! -name "csf*.bam" -a ! -name "ascites*.bam" -a ! -name "blood*.bam" -a ! -name "control*.bam" -a -name "*.bam")
        sample_mpileup_dir=${exon_result_per_pid_dir}/${pid}/indels/
	cfDNA_alignment_dir=${sample_pid_dir}/alignment_umi/
        if [ ! -d ${cfDNA_alignment_dir} ]; then
                cfDNA_alignment_dir=${sample_pid_dir}/alignment
        fi

        cfDNA_bams=$(find ${cfDNA_alignment_dir} -name "plasma*on-target.bam" -o -name "serum*on-target.bam" -o -name "csf*on-target.bam" -o -name "ascites*on-target.bam")
        for tumor_bam in ${tumor_bams}; do
                tumor_id=$(basename ${tumor_bam} | cut -f1 -d "_")
                tumor_mpileup_dirs=$(find ${sample_mpileup_dir} -maxdepth 1 -type d -name "${tumor_id}_*")
                for tumor_mpileup_dir in ${tumor_mpileup_dirs}; do
                        tumor_vcf=$(find ${tumor_mpileup_dir} -name "indel_*_somatic_functional_indels_conf_8_to_10.vcf")
                        for cfDNA_bam in ${cfDNA_bams}; do
                                #echo "${pid} ${tumor_id}:$(basename ${cfDNA_bam} | cut -f1 -d "_")"
                                addBaminfo_cmd="${PIPELINE_DIR}/run_addBAMinfo.sh -c ${config_file} ${tumor_vcf} ${tumor_bam} ${cfDNA_bam}"
                                ${addBaminfo_cmd}
                        done
                done

        done

done
