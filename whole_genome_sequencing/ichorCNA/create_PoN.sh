#wigfilelist_file=$1
#output_file=$2
module load R/3.6.0

PIDs="OE0290-PED_0LB-034 OE0290-PED_0LB-032 OE0290-PED_0LB-039 OE0290-PED_0LB-031 OE0290-PED_0LB-036 OE0290-PED_0LB-035 OE0290-PED_0LB-033 OE0290-PED_0LB-030 OE0290-PED_0LB-037 OE0290-PED_0LB-038" ### Healthy samples

result_per_pid_dir="/icgc/dkfzlsdf/analysis/OE0290_projects/pediatric_tumor/whole_genome_sequencing/results_per_pid/"

alignment_dirname="alignment_umi"
output_wiglist="/icgc/dkfzlsdf/analysis/OE0290_projects/pediatric_tumor/whole_genome_sequencing/processing_scripts/ichorCNA/PoN_wigfile_10healthy_umi.txt"
if [ -f ${output_wiglist} ]; then
	echo "${output_wiglist} exists; Remove."
	rm ${output_wiglist};
fi

for pid in ${PIDs}; do
	echo "running readCounter on PID ${pid}"
	sample_alignment_dir=${result_per_pid_dir}/${pid}/${alignment_dirname}/
	bamfiles=$(find ${sample_alignment_dir} -maxdepth 1 -name "*_callConsensus_realigned.bam")
	echo "Find sample bam file $(echo ${bamfiles} | xargs -n1 basename )"
	for bamfile in ${bamfiles}; do 
		output_file="$(dirname ${bamfile})/$(basename ${bamfile} .bam).wig"	
		echo "Running readCounter."
		/omics/groups/OE0436/data/puranach/.local/bin/readCounter --window 1000000 --quality 20 --chromosome "1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,X,Y" ${bamfile} > ${output_file}
		
		#${readCounter_cmd}

		if [ -f ${output_file} ]; then
			echo "Appending wig file to WIG file list."
			echo -e "${output_file}\n" >> ${output_wiglist}
		fi 
	done
done

if [ -f ${output_wiglist} ]; then
	echo "Running ichorCNA createPanelOfNormals.R script"
	Rscript /icgc/dkfzlsdf/analysis/hipo2/hipo_K42R/whole_genome_sequencing/processing_scripts/packages/ichorCNA/scripts/createPanelOfNormals.R --filelist ${output_wiglist} --gcWig /icgc/dkfzlsdf/analysis/hipo2/hipo_K42R/whole_genome_sequencing/processing_scripts/packages/ichorCNA/inst/extdata/gc_hg19_1000kb.wig --centromere /icgc/dkfzlsdf/analysis/hipo2/hipo_K42R/whole_genome_sequencing/processing_scripts/packages/ichorCNA/inst/extdata/GRCh37.p13_centromere_UCSC-gapTable.txt --mapWig /icgc/dkfzlsdf/analysis/hipo2/hipo_K42R/whole_genome_sequencing/processing_scripts/packages/ichorCNA/inst/extdata/map_hg19_1000kb.wig --outfile $(echo ${output_wiglist%.txt})
fi

if [ ! -f ${output_wiglist} ]; then
	echo "Error! ${output_wiglist} doesn't exist"
fi

