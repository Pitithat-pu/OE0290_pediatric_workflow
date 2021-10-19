pid_dir="/icgc/dkfzlsdf/analysis/OE0290_projects/pediatric_tumor/panel_sequencing/results_per_pid/"
picard_bin="java -jar /abi/data/puranach/packages/picard.jar "
reference_fasta="/icgc/ngs_share/assemblies/hg19_GRCh37_1000genomes/sequence/1KGRef_Phix/hs37d5_PhiX.fa"

for bamfile in ${pid_dir}/OE0290-PED_*/alignment/*_merged.mdup.bam; do
        sample_dir=$(dirname $(dirname ${bamfile}))
        output_dir=${sample_dir}/picard_CollectOxoGMetrics/
        mkdir -p ${output_dir}
        CollectOxoGMetrics_CMD="${picard_bin} CollectOxoGMetrics I=${bamfile} O=${output_dir}/$(basename ${bamfile} .bam)_oxoG_metrics.txt R=${reference_fasta}"
        echo ${CollectOxoGMetrics_CMD} | bsub -J CollectOxoGMetrics_$(basename ${bamfile} .bam) -q verylong -R "rusage[mem=7GB]"
	#echo ${CollectOxoGMetrics_CMD}
done

