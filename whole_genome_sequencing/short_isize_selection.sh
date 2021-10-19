input_file=$1  ## full path if qsub
filename=$(basename "$input_file" ".bam")
output_dir=$(dirname ${input_file})
module load samtools/1.6

echo "$(echo ${filename} | cut -f1,2,3 -d"_") :  Selecting specific insert size"

samtools view -h ${input_file} | awk '( $9 >= 50 && $9 <= 150) || ($9 >=-150 && $9 <= -50 ) || /^@/' | samtools view -b > $output_dir/${filename}.shortinsert.bam

samtools index $output_dir/${filename}.shortinsert.bam



#echo "samtools view -h ${input_file} | awk '( $9 > 150 ) || ($9 <-150 ) || /^@/' | samtools view -b > $output_dir/${filename}.longinsert.bam"
#samtools view -h ${input_file} | awk '( $9 > 150 ) || ($9 <-150 ) || /^@/' | samtools view -b > $output_dir/${filename}.longinsert.bam

#samtools index $output_dir/${filename}.longinsert.bam

echo "done"
