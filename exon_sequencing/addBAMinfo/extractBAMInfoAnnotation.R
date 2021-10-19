file_path = "/icgc/dkfzlsdf/analysis/OE0290_projects/pediatric_tumor/exon_sequencing/results_per_pid/"
# setwd(file_path)
mutation_type="snvs"
#mutation_type="indel"
calculate_VAF_from_DP4 = function(vcf_DP4){
  all_DPs= sapply(vcf_DP4, function(dp_text){
    unlist(strsplit(dp_text,"="))[2]
  })
  all_AFs = strsplit(unlist(all_DPs),",")
  all_VAF = sapply(all_AFs, function(all_AF){
    all_AF = as.numeric(all_AF)
    ref_fw  = all_AF[1]
    ref_rw  = all_AF[2]
    non_ref_fw = all_AF[3]
    non_ref_rw = all_AF[4]
    return(round((non_ref_fw + non_ref_rw) / (ref_fw + ref_rw + non_ref_fw + non_ref_rw),digits = 4))
  })
}
## Get all compare files in directory
#sample_ids = c("LB-I023_004", "LB-I023_006","LB-I049_002","LB-I063_001")
# all_files = dir(path = getwd(), pattern = paste(mutation_type,"*",sep=""),full.names = FALSE)

pids = c("OE0290-PED_1LB-001","OE0290-PED_1LB-005",
               "OE0290-PED_1LB-006","OE0290-PED_1LB-007",
               "OE0290-PED_1LB-008","OE0290-PED_1LB-010",
               "OE0290-PED_1LB-011","OE0290-PED_1LB-014","OE0290-PED_1LB-016",
               "OE0290-PED_1LB-017","OE0290-PED_1LB-021","OE0290-PED_1LB-023","OE0290-PED_1LB-024","OE0290-PED_1LB-026","OE0290-PED_1LB-029","OE0290-PED_1LB-030","OE0290-PED_1LB-031","OE0290-PED_1LB-031","OE0290-PED_1LB-033","OE0290-PED_1LB-044","OE0290-PED_1LB-045","OE0290-PED_1LB-046","OE0290-PED_1LB-047","OE0290-PED_1LB-048","OE0290-PED_1LB-053","OE0290-PED_1LB-054","OE0290-PED_1LB-056","OE0290-PED_1LB-059","OE0290-PED_1LB-060","OE0290-PED_1LB-064","OE0290-PED_1LB-066","OE0290-PED_1LB-069","OE0290-PED_2LB-001","OE0290-PED_2LB-007","OE0290-PED_2LB-021","OE0290-PED_2LB-022","OE0290-PED_2LB-029","OE0290-PED_2LB-030","OE0290-PED_2LB-031","OE0290-PED_2LB-035","OE0290-PED_2LB-038","OE0290-PED_2LB-041","OE0290-PED_2LB-042","OE0290-PED_2LB-043","OE0290-PED_2LB-045","OE0290-PED_2LB-047","OE0290-PED_2LB-048","OE0290-PED_2LB-049","OE0290-PED_2LB-049","OE0290-PED_2LB-049","OE0290-PED_2LB-049","OE0290-PED_2LB-049","OE0290-PED_2LB-050","OE0290-PED_2LB-052","OE0290-PED_2LB-053","OE0290-PED_2LB-054","OE0290-PED_2LB-055","OE0290-PED_2LB-056","OE0290-PED_2LB-057","OE0290-PED_2LB-058","OE0290-PED_2LB-059","OE0290-PED_2LB-061","OE0290-PED_2LB-062","OE0290-PED_2LB-063","OE0290-PED_2LB-064","OE0290-PED_2LB-065","OE0290-PED_2LB-067","OE0290-PED_2LB-069","OE0290-PED_2LB-070","OE0290-PED_2LB-072","OE0290-PED_2LB-073","OE0290-PED_2LB-074","OE0290-PED_2LB-075","OE0290-PED_2LB-078","OE0290-PED_2LB-079","OE0290-PED_2LB-080","OE0290-PED_2LB-085","OE0290-PED_2LB-086","OE0290-PED_2LB-087","OE0290-PED_2LB-088","OE0290-PED_2LB-089","OE0290-PED_2LB-090","OE0290-PED_2LB-091","OE0290-PED_2LB-093","OE0290-PED_2LB-094","OE0290-PED_2LB-095","OE0290-PED_2LB-096","OE0290-PED_2LB-097","OE0290-PED_2LB-101","OE0290-PED_2LB-102","OE0290-PED_2LB-109","OE0290-PED_3LB-002","OE0290-PED_3LB-003","OE0290-PED_3LB-003","OE0290-PED_3LB-004","OE0290-PED_3LB-005","OE0290-PED_3LB-006","OE0290-PED_4LB-002","OE0290-PED_4LB-003","OE0290-PED_4LB-004","OE0290-PED_4LB-005","OE0290-PED_4LB-006","OE0290-PED_4LB-008","OE0290-PED_4LB-008","OE0290-PED_5LB-001","OE0290-PED_5LB-001","OE0290-PED_5LB-002","OE0290-PED_5LB-004","OE0290-PED_5LB-006","OE0290-PED_5LB-009","OE0290-PED_5LB-013","OE0290-PED_5LB-013","OE0290-PED_5LB-027")

annotation_df_list = list()
for (pid in pids) {
  addAnnotation_dir=paste0(file_path,"/",pid,"/addAnnotation")
  addAnnotation_files = list.files(addAnnotation_dir,
                    pattern = paste0("*_compareSOLiD_",mutation_type),
                    recursive = TRUE,full.names = TRUE)
  for (addAnnotation_file in addAnnotation_files) {
    vcf_df = read.delim(addAnnotation_file,sep = "\t", stringsAsFactors = FALSE)
    sample_id = basename(dirname(addAnnotation_file))
    ANNOTATION_cfDNA = vcf_df$ANNOTATION_cfDNA
    not_presented = length(which(ANNOTATION_cfDNA=="not_present"))
    not_covered = length(which(ANNOTATION_cfDNA=="pos_not_covered"))
    var_presented = length(which(ANNOTATION_cfDNA=="var_present"))
    pos_unclear = length(which(ANNOTATION_cfDNA=="pos_unclear"))
    sample_annotation_df = data.frame(PID=pid,Sample.ID=sample_id,
                               'Not Presented'= not_presented,
                               'Not Covered'= not_covered,
                               'Variant Presented'=var_presented,
                               'Position Unclear'=pos_unclear)
    annotation_df_list[[paste0(pid,"-",sample_id)]] = sample_annotation_df
  }
  
}

# colnames(annotation_df) = annotation_df_colname
# annotation_df$PID = sample_ids
snvs_annotation_df = do.call(rbind,annotation_df_list)

write.table(snvs_annotation_df,file = paste("table_ANNOTATION",mutation_type,"plasma.tsv",sep="_"),sep="\t",quote = FALSE,row.names = FALSE)



vcf_df_var_presented = data.frame()
# pids = pids[1]
for (pid in pids){
  if (mutation_type == "snvs") {
    query_column = c("X.CHROM","POS","ID","REF","ALT","GENE","INFO",
                     "ANNOVAR_FUNCTION","EXONIC_CLASSIFICATION",
                     "INFO_tumor.VAF.variant_allele_fraction.TSR.total_variant_supporting_reads_incl_lowqual.",
                     "INFO_cfDNA.VAF.variant_allele_fraction.TSR.total_variant_supporting_reads_incl_lowqual.",
                     "ANNOTATION_control","CONFIDENCE", "COSMIC",
                     "ANNOTATION_tumor","VARIANTREADS_tumor","ANNOTATION_cfDNA","VARIANTREADS_cfDNA")
    
    # vcf_file = paste(mutation_type,pid,"somatic",mutation_type,"conf_8_to_10.vcf_compareSOLiD",sep="_")
  } else {
    query_column = c("X.CHROM","POS","ID","REF","ALT","GENE","INFO",
                     "ANNOVAR_FUNCTION","EXONIC_CLASSIFICATION",
                     "INFO_tumor.VAF.variant_allele_fraction.TSR.total_variant_supporting_reads_incl_lowqual.",
                     "INFO_cfDNA.VAF.variant_allele_fraction.TSR.total_variant_supporting_reads_incl_lowqual.",
                     "CONFIDENCE", "COSMIC",
                     "ANNOTATION_tumor","VARIANTREADS_tumor","ANNOTATION_cfDNA","VARIANTREADS_cfDNA")
    
    # vcf_file = paste(mutation_type,sample_id,"somatic_",mutation_type,"_conf_8_to_10.vcf_compareSOLiD",sep="_")
  }
  addAnnotation_dir=paste0(file_path,"/",pid,"/addAnnotation")
  addAnnotation_files = list.files(addAnnotation_dir,
                                   pattern = paste0("*_compareSOLiD_",mutation_type),
                                   recursive = TRUE,full.names = TRUE)
  for (addAnnotation_file in addAnnotation_files) {
    sample_id = basename(dirname(addAnnotation_file))
    vcf_df = read.delim(addAnnotation_file,sep = "\t", stringsAsFactors = FALSE)
    vcf_df_var_presented_temp = vcf_df[which(vcf_df$ANNOTATION_cfDNA=="var_present"),query_column]
    if (nrow(vcf_df_var_presented_temp) == 0) {
      next
    }
    vcf_df_var_presented_temp$PID = pid
    vcf_df_var_presented_temp$cfDNA_sample.ID=sample_id
    ## Getting tumor VAF
    vcf_tumor_INFO = vcf_df_var_presented_temp$INFO_tumor.VAF.variant_allele_fraction.TSR.total_variant_supporting_reads_incl_lowqual.
    vcf_INFO_split = strsplit(vcf_tumor_INFO,c(";"))
    vcf_tumor_DP = sapply(vcf_INFO_split, function(info){
      index = which(startsWith(info,"DP="))
      DP = unlist(strsplit(info[index],"="))[2]
    })
    
    vcf_tumor_DP4 = sapply(vcf_INFO_split, function(info){
      #index = which(startsWith(info,"DP4"))
      index = which(startsWith(info,"DP5="))
      info[index]
    })
    vcf_tumor_VAF = calculate_VAF_from_DP4(vcf_tumor_DP4)
    ###
    ## Getting plasma VAF
    vcf_plasma_INFO = vcf_df_var_presented_temp$INFO_cfDNA.VAF.variant_allele_fraction.TSR.total_variant_supporting_reads_incl_lowqual.
    vcf_INFO_split = strsplit(vcf_plasma_INFO,c(";"))
    vcf_plasma_DP = sapply(vcf_INFO_split, function(info){
      index = which(startsWith(info,"DP="))
      DP = unlist(strsplit(info[index],"="))[2]
      #print(DP)
    })
    
    vcf_plasma_DP5 = sapply(vcf_INFO_split, function(info){
      index = which(startsWith(info,"DP5="))
      info[index]
    })
    vcf_plasma_VAF = calculate_VAF_from_DP4(vcf_plasma_DP5)
    vcf_df_var_presented_temp$tumor_DP = vcf_tumor_DP
    vcf_df_var_presented_temp$tumor_VAF = vcf_tumor_VAF
    vcf_df_var_presented_temp$plasma_DP = vcf_plasma_DP
    vcf_df_var_presented_temp$plasma_VAF = unname(vcf_plasma_VAF)
    vcf_df_var_presented = rbind(vcf_df_var_presented,vcf_df_var_presented_temp)
    
    
    
    vcf_df_var_not_presented = vcf_df[which(vcf_df$ANNOTATION_plasma=="not_present"),query_column]
    
  }
  
  
  # vcf_df = read.delim(vcf_file,sep="\t")
  
 
}

# PID = vcf_df_var_presented$PID
# 
# vcf_df_var_presented$PID = NULL
# vcf_df_var_presented = cbind(PID,vcf_df_var_presented)
write.table(vcf_df_var_presented, file=paste("all_presented",mutation_type,"variants.tsv",sep="_"),sep="\t",quote = FALSE,row.names = FALSE)

## Figure out what is DP5 and DP5all ?
