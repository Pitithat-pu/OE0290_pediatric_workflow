### This script create directory and symbolic links in the analysis directory defined by TARGET_RPP_FOLDER from the base project directory Project_FOLDER. 
### All PIDs that exist in the project directory will be linked. Otherwise one can just defin the variable PATIENT_IDs. for example: PATIENT_IDs="PID1 PID2 PID3"
### This script will link alignment files and result files of SNV and INDEL calling workflow

Project_FOLDER="/omics/odcf/project/OE0290/pediatric_tumor/sequencing/exon_sequencing/view-by-pid/"

PATIENT_IDs=$(readlink -f /icgc/dkfzlsdf/project/OE0290/pediatric_tumor/sequencing/exon_sequencing/view-by-pid/OE0290* | xargs -n1 basename)

TARGET_RPP_FOLDER="/omics/odcf/analysis/OE0290_projects/pediatric_tumor/exon_sequencing/results_per_pid"

echo "Start linking bam files"
for PID in ${PATIENT_IDs[@]}; do
    SOURCE_BAMFILES=`readlink -f ${Project_FOLDER}/${PID}/*/paired/merged-alignment/*_merged.mdup.bam*`
        if [ ! -d ${TARGET_RPP_FOLDER}/${PID}/alignment ]; then
            mkdir -p ${TARGET_RPP_FOLDER}/${PID}/alignment
            chmod 770 ${TARGET_RPP_FOLDER}/${PID}
            chmod 770 ${TARGET_RPP_FOLDER}/${PID}/alignment
            fi
        echo ${TARGET_RPP_FOLDER}/${PID}



        for bamfile in ${SOURCE_BAMFILES}; do
            basename=`basename $bamfile`
            # fix buffy_coat to buffycoat
            if [[ $basename =~ ^buffy_coat_.* ]]; then
                basename=buffy${basename#*_}
            fi

            if [[ $basename =~ ^buffy_coat02_.* ]]; then
                basename=buffy${basename#*_}
            fi
            targetBamFile=${TARGET_RPP_FOLDER}/${PID}/alignment/${basename}
            [[ ! -f ${targetBamFile} ]] && ln -sf ${bamfile} ${targetBamFile}
	    targetQC_dir=${TARGET_RPP_FOLDER}/${PID}/alignment/qualitycontrol/
	    [[ ! -d ${targetQC_dir} ]] && mkdir ${targetQC_dir}
	    qcfile=`find $(dirname ${SOURCE_BAMFILES})/qualitycontrol/merged/ -maxdepth 1 -name "*_${PID}_wroteQcSummary.txt"`
	    #qc_filename=$(basename ${qcfile})
	    #[[ ! -f ${targetQC_dir}/${qc_filename} ]] && ln -sf ${qcfile} ${targetQC_dir}
	    ln -sf ${qcfile} ${targetQC_dir}
        done
done
echo "Done : linking bam and QC files"

echo "Linking SNV/Indels"

for PID in ${PATIENT_IDs[@]}; do
        snvs_pairs=`ls -d ${Project_FOLDER}/${PID}/snv_results/paired/*`
        TARGET_SNV_FOLDER=${TARGET_RPP_FOLDER}/${PID}/mpileup

        if [ ! -d ${TARGET_SNV_FOLDER} ]; then
                mkdir ${TARGET_SNV_FOLDER}
                chmod 770 ${TARGET_SNV_FOLDER}
        fi
        for snvs_pair in ${snvs_pairs}; do
                pair_name=$(basename ${snvs_pair})
                PAIR_TARGET_SNV_FOLDER=${TARGET_SNV_FOLDER}/${pair_name}/
                if [ ! -d ${PAIR_TARGET_SNV_FOLDER} ]; then
                        mkdir ${PAIR_TARGET_SNV_FOLDER}
                        chmod 770 ${PAIR_TARGET_SNV_FOLDER}
                fi
                SOURCE_SNV_FOLDER=$(ls -d ${snvs_pair}/results_SNVCallingWorkflow* | tail -n1 )
                ln -sf ${SOURCE_SNV_FOLDER}/snv* ${PAIR_TARGET_SNV_FOLDER}
        done

        indels_pairs=`ls -d ${Project_FOLDER}/${PID}/indel_results/paired/*`
        TARGET_INDEL_FOLDER=${TARGET_RPP_FOLDER}/${PID}/indels
        if [ ! -d ${TARGET_INDEL_FOLDER} ]; then
                mkdir ${TARGET_INDEL_FOLDER}
                chmod 770 ${TARGET_INDEL_FOLDER}
        fi
        for indels_pair in ${indels_pairs};do
                pair_name=$(basename ${indels_pair})
                PAIR_TARGET_INDEL_FOLDER=${TARGET_INDEL_FOLDER}/${pair_name}/
                if [ ! -d ${PAIR_TARGET_INDEL_FOLDER} ]; then
                        mkdir ${PAIR_TARGET_INDEL_FOLDER}
                        chmod 770 ${PAIR_TARGET_INDEL_FOLDER}
                fi
                if [ ! -d ${PAIR_TARGET_INDEL_FOLDER}/screenshots ]; then
                        mkdir ${PAIR_TARGET_INDEL_FOLDER}/screenshots
                        chmod 770 ${PAIR_TARGET_INDEL_FOLDER}/screenshots
                fi
                SOURCE_INDEL_FOLDER=$(ls -d ${indels_pair}/results_IndelCallingWorkflow* | tail -n1 )
                ln -sf ${SOURCE_INDEL_FOLDER}/indel* ${PAIR_TARGET_INDEL_FOLDER}
                ln -sf ${SOURCE_INDEL_FOLDER}/screenshots/* ${PAIR_TARGET_INDEL_FOLDER}/screenshots
        done

done


