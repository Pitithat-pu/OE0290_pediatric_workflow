#!/bin/bash
### This script create directory and symbolic links in the analysis directory defined by TARGET_RPP_FOLDER from the base project directory Project_FOLDER.
### All PIDs that exist in the project directory will be linked. Otherwise one can just defin the variable PATIENT_IDs. for example: PATIENT_IDs="PID1 PID2 PID3"
### This script will link alignment files and QC files

SOURCE_FOLDER="/omics/odcf/project/B062/pediatric_tumor/sequencing/whole_genome_sequencing/view-by-pid/"
TARGET_RPP_FOLDER="/omics/odcf/analysis/OE0290_projects/pediatric_tumor/whole_genome_sequencing/results_per_pid/"

PATIENT_IDs=$(find ${SOURCE_FOLDER} -name "OE0290-PED_*LB*" -type d -maxdepth 1 -printf "%f\n")



for PID in ${PATIENT_IDs[@]}; do
    #SOURCE_BAMFILES=`readlink -f ${SOURCE_FOLDER}/${PID}/*/paired/merged-alignment/*_merged.mdup.bam*`
    SOURCE_BAMFILES=$(find ${SOURCE_FOLDER}/${PID}/*/paired/merged-alignment/ -maxdepth 1 -name "*_merged.mdup.bam*")
    #echo ${SOURCE_BAMFILES}
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
        done
done


