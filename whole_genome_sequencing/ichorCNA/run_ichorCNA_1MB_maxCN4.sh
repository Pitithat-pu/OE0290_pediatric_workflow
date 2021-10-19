#PATHichorCNA="/abi/data/puranach/packages/ichorCNA/"
PATHichorCNA="/icgc/dkfzlsdf/analysis/OE0290_projects/pediatric_tumor/whole_genome_sequencing/processing_scripts/packages/ichorCNA/"
input_file=$1
fullpath=$(readlink -f $input_file)
sample_name=$(basename ${input_file} .bam)
PATHtumor=$(dirname $fullpath)
result_folder=$2
#module load R/3.6.0
readCounter_bin="/omics/groups/OE0436/data/puranach/.local/bin/readCounter"
PoN_rds_file="/icgc/dkfzlsdf/analysis/OE0290_projects/pediatric_tumor/whole_genome_sequencing/processing_scripts/ichorCNA/PoN_umi_1Mb_97_NIPTeR_median.rds" ### for Accel-NGS 2S Plus DNA


#PoN_rds_file="/icgc/dkfzlsdf/analysis/OE0290_projects/pediatric_tumor/whole_genome_sequencing/processing_scripts/ichorCNA/PoN_nonumi_1Mb_97_NIPTeR_median.rds"  ## for high-coverage WGS Picoplex 1 ng input xxx-0x-02...mdup.bam or xxx-0x-03...mdup.bam (2LB-098 2LB-087 2LB-065 2LB-062)

#PoN_rds_file="/icgc/dkfzlsdf/analysis/OE0290_projects/pediatric_tumor/whole_genome_sequencing/processing_scripts/ichorCNA/PoN_umi_1Mb_97_NIPTeR_short_isize_median.rds" ## for short fragments selection samples.

#PoN_rds_file="/icgc/dkfzlsdf/analysis/OE0290_projects/pediatric_tumor/whole_genome_sequencing/processing_scripts/ichorCNA/PoN_1Mb_Picoplex_median.rds" ## for lcWGS Picoplex low input xxx-0x-01...mdup.bam

#PoN_rds_file="/icgc/dkfzlsdf/analysis/OE0290_projects/pediatric_tumor/whole_genome_sequencing/processing_scripts/ichorCNA/PoN_wigfile_10healthy_umi_median.rds" ## pon from 10 healthy samples.



mkdir -p ${result_folder}

bsub_option="#!/bin/bash\n#BSUB -q verylong\n#BSUB -R \"rusage[mem=50GB]\"\n#BSUB -J ichorCNA_1MB_${sample_name}"

#params="input_file=${input_file}; result_folder=${result_folder}; PoN_rds_file=${PoN_rds_file};"

readCounter_cmd="${readCounter_bin} --window 1000000 --quality 20 --chromosome \"1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,X,Y\" $fullpath > $result_folder/$(basename $input_file .bam).wig"



ichorCNA_cmd="module load R/3.6.0;Rscript $PATHichorCNA/scripts/runIchorCNA.R --id $(basename $input_file .bam) \
  --WIG $result_folder/$(basename $input_file .bam).wig --ploidy \"c(2,3)\" --normal \"c(0.8,0.9,0.95,0.99,0.995)\" --maxCN 4 \
  --gcWig $PATHichorCNA/inst/extdata/gc_hg19_1000kb.wig \
  --mapWig $PATHichorCNA/inst/extdata/map_hg19_1000kb.wig \
  --centromere $PATHichorCNA/inst/extdata/GRCh37.p13_centromere_UCSC-gapTable.txt \
  --normalPanel ${PoN_rds_file} \
  --includeHOMD False --chrs \"c(1:22, \\\"X\\\")\" --chrTrain \"c(1:22)\" \
  --estimateNormal True --estimatePloidy True --estimateScPrevalence FALSE \
  --scStates \"c()\" --txnE 0.9999 --txnStrength 10000 --outDir $result_folder
"
polished_plot_cmd="module unload R/3.6.0; module load R/4.0.0; Rscript /omics/groups/OE0436/internal/puranach/ctDNA/RStudioServer_Project/OE0290-pediatric-cfDNA/Rscripts/plot_cfDNA_ichorCNA.R ${result_folder} ${result_folder}"


ichorCNA_file=${result_folder}/$(basename $input_file .bam)_ichorCNA_script.sh

echo -e "${bsub_option}\n ${readCounter_cmd}\n ${ichorCNA_cmd}\n ${polished_plot_cmd}\n" > ${ichorCNA_file}
chmod 764 ${ichorCNA_file}

bsub < ${ichorCNA_file}
