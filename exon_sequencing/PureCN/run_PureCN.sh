module_load_cmd="module load R/3.6.0;\n"

coverage_file=${1}
result_per_pid_dir="/icgc/dkfzlsdf/analysis/OE0290_projects/pediatric_tumor/exon_sequencing/results_per_pid/"
PURECN="/home/puranach/R/x86_64-pc-linux-gnu-library/3.6/PureCN/extdata/"
PureCN_normaldb="/icgc/dkfzlsdf/analysis/OE0290_projects/pediatric_tumor/exon_sequencing/processing_scripts/PureCN/selected_PoN/normalDB_agilent_v7_hg19.rds"
mappingbias_file="/icgc/dkfzlsdf/analysis/OE0290_projects/pediatric_tumor/exon_sequencing/processing_scripts/PureCN/selected_PoN/mapping_bias_agilent_v7_hg19.rds"
internal_file="/icgc/dkfzlsdf/analysis/OE0290_projects/pediatric_tumor/exon_sequencing/processing_scripts/PureCN/target_beds/Agilent7withoutUTRs_plain_bait.intervals"
snp_blacklist_file="/icgc/dkfzlsdf/analysis/OE0290_projects/pediatric_tumor/exon_sequencing/processing_scripts/PureCN/resources/SimpleRepeat_hg19_plain.bed"

# PureCN_args="--genome hg19 --force --minpurity 0.05 --minaf 0.01 --error 0.0005 --maxploidy 4 --maxcopynumber 8 --padding 50 --model betabin --funsegmentation PSCBS"

PureCN_args="--genome hg19 --force --minpurity 0.05 --minaf 0.01 --error 0.0005 --maxploidy 3 --maxcopynumber 8 --padding 25 --model betabin --funsegmentation PSCBS --postoptimize"
bsub_option="#!/bin/bash\n#BSUB -q verylong\n#BSUB -R \"rusage[mem=30GB]\"\n"

if [ ! -f ${coverage_file} ]; then
	echo "Cannot find ${coverage_file}; Quit"
	exit 1
fi 

sample_PureCN_dir=$(dirname ${coverage_file})
outdir="${sample_PureCN_dir}"
sample_id=$(basename ${sample_PureCN_dir})
mutect_vcf=$(find ${sample_PureCN_dir} -maxdepth 1 -name "${sample_id}*merged.mdup.vcf.gz")
mutect_statfile=${mutect_vcf}.stats
bsubExecution_dir=${outdir}/bsubExecutionfiles/
[ ! -d "${bsubExecution_dir}" ] && mkdir "${bsubExecution_dir}"
	
pureCN_cmd="Rscript $PURECN/PureCN.R --out ${outdir} --tumor ${coverage_file} --sampleid ${sample_id} --vcf ${mutect_vcf} --statsfile ${mutect_statfile} --normaldb ${PureCN_normaldb} --mappingbiasfile ${mappingbias_file} --intervals ${internal_file} --snpblacklist ${snp_blacklist_file} ${PureCN_args} "

echo -e ${bsub_option} ${module_load_cmd} ${pureCN_cmd} > ${bsubExecution_dir}/run_PureCN.sh

pureCN_job_id=$(bsub -J ${sample_id}_run_PureCN  < ${bsubExecution_dir}/run_PureCN.sh | awk '/is submitted/{print substr($2, 2, length($2)-2);}')
echo "Submit ${sample_id}_run_PureCN : job id ${pureCN_job_id}"


