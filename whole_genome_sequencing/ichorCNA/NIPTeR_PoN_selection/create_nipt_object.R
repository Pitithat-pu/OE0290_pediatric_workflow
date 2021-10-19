library("NIPTeR")

args <- commandArgs(T)
if (length(args) < 1)
  stop("Usage: Rscript create_nipt_object.R bamfile")
bamfile <- args[1]

nipt_obj_gc = gc_correct(bin_bam_sample(bam_filepath = bamfile, do_sort=F,
                          separate_strands=T),method="LOESS")

# cat("Correcting GC-bias")
# nipt_obj_gc <- gc_correct(nipt_object = nipt_obj,
#                                   method="LOESS")

cat("Correcting GC-bias done")

output_dir = dirname(bamfile)
output_filename = tools::file_path_sans_ext(basename(bamfile))

cat("Writing result to ",output_dir)
saveRDS(nipt_obj_gc,file = paste0(output_dir,"/",output_filename,".rds"))
cat("\nDone")

