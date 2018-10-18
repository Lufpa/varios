#!/bin/bash
#SBATCH --mem=100
#SBATCH --qos=1day
#SBATCH --job-name=subBam
#SBATCH --cpus-per-task=1
#SBATCH --output="%A_%a.out"
#SBATCH --error="%A_%a.error"
#SBATCH --array=1-48

# run the script from the folder where the bam files are located

outdir=subsample
downsample=bamlist_downsample  #one column file with the number of reads needed
list=bamlist  #one column file with the name of the bam files

bam=`awk -v file=$SLURM_ARRAY_TASK_ID '{if (NR==file) print $0}' $list`
subsample=`awk -v file=$SLURM_ARRAY_TASK_ID '{if (NR==file) print $0}' $downsample`
subbam=${bam%uniq*}sub.bam
FACTOR=$(samtools flagstat $bam | grep "in total" | cut -f1 -d " "| awk -v s=$subsample '{print s/$1 * 1000000}') # factor cannot have decimal points
samtools view -s 99.$FACTOR -b $bam > $outdir/$subbam




