module load groovy/2.4.15
# The Roddy execution mode is "testrerun" if you just want to see what jobs would be submitted and which files would be produced.
# For actually submitting jobs, please use "rerun".
MODE="rerun"
 
# Project directory (for instance "/icgc/dkfzlsdf/project/hipo2/hipo_K48R")
PROJECT_DIRECTORY="/omics/odcf/project/OE0290/pediatric_tumor"
 
# The path to a directory with PID subdirectories. For the OTP-generated filesystem layout this usually is 
# called "view-by-pid" and located below the PROJECT_DIRECTORY as follows.
INPUT_DIRECTORY="$PROJECT_DIRECTORY/sequencing/panel_sequencing/view-by-pid"
 
# With the OTP-configuration the workflow creates all files directly in the output directory.
#OUTPUT_DIRECTORY="/icgc/dkfzlsdf/analysis/hipo2/hipo_K42R/panel_sequencing/results_per_pid"
 
# Specification of PIDs. This can be a comma separated list of PIDs that need to be present and accessible as subdirectories in the INPUT_DIRECTORY. OTP always uses a single PID here.


# PIDS="OE0290-PED_2LB-099 OE0290-PED_3LB-006 OE0290-PED_4LB-002 OE0290-PED_4LB-003 OE0290-PED_4LB-004 OE0290-PED_4LB-005 OE0290-PED_4LB-006 OE0290-PED_4LB-007 OE0290-PED_4LB-008" ## serum samples

PIDS="OE0290-PED_0LB-041 OE0290-PED_0LB-042 OE0290-PED_0LB-043 OE0290-PED_0LB-044 OE0290-PED_2LB-041 OE0290-PED_2LB-048 OE0290-PED_2LB-050 OE0290-PED_2LB-056 OE0290-PED_2LB-081 OE0290-PED_2LB-086 OE0290-PED_2LB-091 OE0290-PED_2LB-048"

# Dependent on whether you want to align data from a tumor or a control fill in the full sample name. The parameters have a more general meaning when processing multiple samples, which is, however, not the way OTP uses the workflow.
#CONTROL_SAMPLE_NAME_PREFIXES="plasma1-01"
TUMOR_SAMPLE_NAME_PREFIXES="plasma"
#TUMOR_SAMPLE_NAME_PREFIXES="serum"
#TUMOR_SAMPLE_NAME_PREFIXES="csf" 
#TUMOR_SAMPLE_NAME_PREFIXES="ascites"
# OTP processes only one sample per Roddy call. The FASTQs are then provided as a **semicolon** separated list of FASTQ
# files with alternating R1 and R2 files, e.g.: f1_R1.fastq.gz;f1_R2.fastq.gz;f2_R1.fastq.gz;f2_R2.fastq.gz
# Make sure to follow this convention, or Roddy may do the wrong thing! Don't forget to quote the value here, 
# because ';' is a special character in the shell!

 
# The base path of the Roddy installation used by OTP
OTP_RODDY_INSTALLATION="/tbi/software/x86_64/otp/roddy/"
 
# The Roddy version you want to use.
RODDY_VERSION="3.5.4"
 
# The path to the roddy executable (script).
RODDY="$OTP_RODDY_INSTALLATION/roddy/$RODDY_VERSION/roddy.sh"
 
# Application properties file in INI format, which contains e.g. the global cluster configuration.
# Note that the file also contains the plugin directory path.
APP_INI="$OTP_RODDY_INSTALLATION/applicationProperties.ini"
# The feature toggle file is used to turn on Roddy features that are not yet standard in Roddy merely
#  for the sake of backwards compatibility, but are anyway useful and increase execution safety and error reporting.
FEATURE_TOGGLE_FILE="$OTP_RODDY_INSTALLATION/configs/featureToggles.ini"
 
# Roddy supports to separate the configuration into multiple files:
# (1) For every OTP project (for which a workflow is configured) there is a dedicated configuration directory
# under `$projectName/configFiles/$workflowName`. These configurations are called the "project configs". 
# (2) There is the global/OTP wide configuration of workflows. 
# (3) OTP has a dedicated set of configurations to specify execution resources, such as queues, memory, or walltime.
#CONFIG_DIRECTORIES="$PROJECT_DIRECTORY/configFiles/PANCAN_ALIGNMENT,$OTP_RODDY_INSTALLATION/configs,$OTP_RODDY_INSTALLATION/configs/resource/lsf"
CONFIG_DIRECTORIES="$PROJECT_DIRECTORY/configFiles/PANCAN_ALIGNMENT,$OTP_RODDY_INSTALLATION/configs,$OTP_RODDY_INSTALLATION/configs/resource/lsf,/omics/odcf/analysis/OE0290_projects/pediatric_tumor/panel_sequencing/RoddyConfig"
# Roddy plugins have a powerful versioning system. If you do not have already processed data
# Note that all 1.2.73-* versions produce the same results. So it should be safe to take the newest version.
# Please refer to the plugin directory listed in the APP_INI to get a list of currently installed plugins for OTP.
PLUGIN_VERSION="1.2.73-2"
 
# Configuration name. Here an example following the template that OTP uses for the project configurations:
CONFIG_NAME="PANCAN_ALIGNMENT_WES_PAIRED_AlignmentAndQCWorkflows:${PLUGIN_VERSION}_v1_0.config@WES"
#CONFIG_NAME="AlignmentAndQCWorkflows:${PLUGIN_VERSION}_v1_0.config@WES" 


# Base-path of OTP-managed reference data.
REFDATA_BASE="/omics/odcf/project/ODCF/reference_genomes"
ASSEMBLY_ID="bwa06_1KGRef_PhiX"
 
# The path to genome assembly FASTA and the BWA indices.
INDEX_PREFIX="$REFDATA_BASE/$ASSEMBLY_ID/hs37d5_PhiX.fa"
 
# Simple file with A, C, G, T counts per chromosome.
CHROM_SIZES_FILE="$REFDATA_BASE/$ASSEMBLY_ID/stats/hs37d5_PhiX.fa.chrLenOnlyACGT_realChromosomes.tab"
 
# The fingerprints file can be useful for identifying sample swaps. Fingerprinting can be turned off by setting
# "runFingerprinting" to false (see Roddy call below).
FINGERPRINTS_FILE="$REFDATA_BASE/$ASSEMBLY_ID/fingerPrinting/snp138Common.n1000.vh20140318.bed"
 
# In principle the WGS and WES workflows are identical, but the WES workflow provides QC statistics
# specifically tuned to the fact, that reads are only expected in certain genomic regions. These 
# regions need to be provided to the workflow with two variables.
 
# You need to specifically check which target regions have been selected for your WES data and provide
# this information as BED3 file. This value must not be empty!
TARGET_REGIONS_FILE="/omics/odcf/analysis/OE0290_projects/pediatric_tumor/panel_sequencing/target_regions/panel_target_coverage_plain.bed"
 
# The summed length or the annotated exome. Must not be empty!
TARGETSIZE="897805"

PIDS=${PIDS//,/\ }
for PID in ${PIDS}; do
	FASTQ_ARRAY=()
        OUTPUT_DIRECTORY="/omics/odcf/analysis/OE0290_projects/pediatric_tumor/panel_sequencing/results_per_pid/${PID}/alignment"
        if [ ! -d ${OUTPUT_DIRECTORY} ]; then
                mkdir -p ${OUTPUT_DIRECTORY}
                echo "Create Output Directory ${OUTPUT_DIRECTORY}"
        fi
        run_dirs=$(find ${INPUT_DIRECTORY}/${PID}/${TUMOR_SAMPLE_NAME_PREFIXES}*/paired/ -name run* -type d)
        if [[ -z ${run_dirs} ]]; then 
		echo "No run dir found in ${INPUT_DIRECTORY}/${PID}/${TUMOR_SAMPLE_NAME_PREFIXES}*/paired/"
		echo "Skip ${PID}"
		continue 
	fi

	for run_dir in ${run_dirs}; do
                sequence_dir=${run_dir}/sequence
                fastq_files=$(find ${sequence_dir}/ -name *R[1,2].fastq.gz | sort)
                FASTQ_ARRAY+=(${fastq_files})
        done
	#echo ${FASTQ_ARRAY[*]}

	FASTQ_LIST=$(printf ";%s" "${FASTQ_ARRAY[@]}")
	FASTQ_LIST=${FASTQ_LIST:1}
	
	"$RODDY" \
   	"$MODE" \
   	"$CONFIG_NAME" \
   	"$PID" \
   	--useconfig="$APP_INI" \
	--usefeaturetoggleconfig="$FEATURE_TOGGLE_FILE" \
   	--usePluginVersion="AlignmentAndQCWorkflows:$PLUGIN_VERSION" \
   	--configurationDirectories="$CONFIG_DIRECTORIES" \
   	--useiodir="$INPUT_DIRECTORY,$OUTPUT_DIRECTORY" \
   	--additionalImports="AlignmentAndQCWorkflows:$PLUGIN_VERSION-wes" \
   	--cvalues="INDEX_PREFIX:$INDEX_PREFIX,GENOME_FA:$INDEX_PREFIX,CHROM_SIZES_FILE:$CHROM_SIZES_FILE,possibleControlSampleNamePrefixes:$CONTROL_SAMPLE_NAME_PREFIXES,possibleTumorSampleNamePrefixes:$TUMOR_SAMPLE_NAME_PREFIXES,runFingerprinting:true,fingerprintingSitesFile:$FINGERPRINTS_FILE,fastq_list:$FASTQ_LIST,TARGET_REGIONS_FILE:$TARGET_REGIONS_FILE,TARGETSIZE:$TARGETSIZE,sharedFilesBaseDirectory:/icgc/ngs_share" \
   	--useRoddyVersion="$RODDY_VERSION"
done


