#!/bin/bash

mkdir ./chimeric_STAR.Ensembl.Out;
thisdir=$(pwd);


# Seems from STAR manual that we should remove --sjdbGTFfile setting from STAR calls and use shared memory


#run from folder with all the fastqs, so that the for(ls) works

#for i in $(ls *R2_001.fastq.gz | rev | cut -c 17- | rev | uniq);  do\
filename="./samples.txt"
n=1

# Seems that cannot do 'on the fly junction insertion' with shared genome?
# Command works
/STAR/bin/Linux_x86_64/STAR --runMode alignReads \
	--genomeLoad LoadAndExit \
	--runThreadN 50  \
	--genomeDir /genome/genomes/Ensembl_Grch38/STAR.Ensembl.GRCh38 


while read line
do
	echo "-------------------------------------"
	ID=$(echo $line | awk -F',' '{print $2}')
	echo "ID:"
	echo ${ID};
	R1_path=$(echo $line | awk -F',' '{print $1}')
	R2_path=$(echo $R1_path | sed "s/R1/R2/")

	echo "R1 path: "
	echo $R1_path
	echo "R2 path: "
	echo $R2_path




   	mkdir ./chimeric_STAR.Ensembl.Out/${ID};
    	cd  ./chimeric_STAR.Ensembl.Out/${ID};

	# outputs sorted bams


	#	Parameters taken from DCC circular RNA guidelines, here:
	#	https://github.com/dieterich-lab/DCC


       /STAR/bin/Linux_x86_64/STAR --runMode alignReads --runThreadN 50 --chimOutType Junctions SeparateSAMold \
	      	--outSJfilterOverhangMin 15 15 15 15 \
	     	--alignSJoverhangMin 15 \
	    	--alignSJDBoverhangMin 15 \
		--outFilterMultimapNmax 20 \
		--outFilterScoreMin 1 \
		--outFilterMatchNmin 1 \
		--outFilterMismatchNmax 2 \
       		--chimSegmentMin 15 \
		--chimScoreMin 15 \
		--chimScoreSeparation 10 \
		--chimJunctionOverhangMin 15 \
		--genomeDir /genome/genomes/Ensembl_Grch38/STAR.Ensembl.GRCh38   --readFilesIn  ${R1_path}   ${R2_path}   --outFileNamePrefix $thisdir/chimeric_STAR.Ensembl.Out/${ID}/${ID}_chimeric_.  --outSAMtype BAM Unsorted --readFilesCommand zcat;


	echo "Sorting unambigous bam"
	samtools sort -@32 -m 4G -o ${ID}_sorted.bam ${ID}_chimeric_.Aligned.out.bam     && rm ${ID}_chimeric_.Aligned.out.bam
	echo "Indexing unambiguous bam"
	samtools index ${ID}_sorted.bam

	echo "Converting chimeric sam to bam"
	samtools view -S -b ${ID}_chimeric_.Chimeric.out.sam > ${ID}.Chimeric.out.bam     && rm ${ID}_chimeric_.Chimeric.out.sam
	echo "Sorting chimeric bam"
	samtools sort -@32 -m 4G -o ${ID}.Chimeric_sorted.out.bam ${ID}.Chimeric.out.bam   && rm  ${ID}.Chimeric.out.bam
	echo "Indexing chimeric bam"
	samtools index ${ID}.Chimeric_sorted.out.bam


	cd ..; cd ..;
done < $filename





/STAR/bin/Linux_x86_64/STAR --runMode alignReads --genomeLoad Remove --runThreadN 50 --genomeDir /genome/genomes/Ensembl_Grch38/STAR.Ensembl.GRCh38




cd  ./chimeric_STAR.Ensembl.Out

/home/ysantos/bin/feature_count_from_bam.sh



#		CHANGES TO MAKE:
#
#
#		If possible- As soon as alignment is finished,
#		start sorting AND aligning the next sample.
#





