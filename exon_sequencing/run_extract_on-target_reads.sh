pids_dir="/icgc/dkfzlsdf/analysis/OE0290_projects/pediatric_tumor/exon_sequencing/results_per_pid/"



PIDs="OE0290-PED_5LB-010 OE0290-PED_5LB-034 OE0290-PED_5LB-056 OE0290-PED_5LB-057 OE0290-PED_5LB-058 OE0290-PED_5LB-065"

module_load_CMD="module load samtools bedtools;"
target_regions_bed="/icgc/ngs_share/assemblies/hg19_GRCh37_1000genomes/targetRegions/Agilent7withoutUTRs_plain.bed.gz"
#target_regions_bed="/icgc/ngs_share/assemblies/hg19_GRCh37_1000genomes/targetRegions/Agilent5withoutUTRs_plain.bed.gz"

#target_regions_bed="/icgc/ngs_share/assemblies/hg19_GRCh37_1000genomes/targetRegions/Agilent6withoutUTRs_plain.bed.gz"

for pid in ${PIDs}; do
	pid_dir=${pids_dir}/${pid}/
        alignment_dir=${pid_dir}/alignment/
	sample_bams=$(find ${alignment_dir} -name "plasma*merged.mdup.bam" -o -name "serum*merged.mdup.bam" -o -name "csf*merged.mdup.bam" -o -name "ascites*merged.mdup.bam" )
	output_dir=${pid_dir}/alignment/
	for sample_bam in ${sample_bams}; do
		bam_filename=$(basename ${sample_bam})
                sample_id=$(echo ${bam_filename} | cut -f1 -d"_")
                echo "Found sample bam : ${bam_filename}"
		output_filename=$(basename ${sample_bam} | sed 's/.bam/.on-target.bam/g')
		extract_ontarget_CMD="${module_load_CMD} bedtools intersect -abam ${sample_bam} -b ${target_regions_bed} > ${output_dir}/${output_filename}; samtools index ${output_dir}/${output_filename}"
		bsub_CMD_file=${output_dir}/bsub_extract_ontarget_reads_${sample_id}_${pid}.sh
		echo -e ${extract_ontarget_CMD} > ${bsub_CMD_file}
		chmod 764 ${bsub_CMD_file}
		bsub -J extract_ontarget_reads_${sample_id}_${pid} -R "rusage[mem=3GB]" -q long < ${bsub_CMD_file} 
	done

done
# bedtools intersect -abam ${bamfile} -b ${target_regions_bed} > ${output_dir}/${output_filename}
