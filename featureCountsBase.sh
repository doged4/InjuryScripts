# /bin/bash
mkdir mappedOut
for i in $(ls -d *);  do\
           echo ${i};
           cd  ${i};
           featureCounts -T 45 -a /genome/genomes/hg19.gtf -o ${i}.mapped Aligned.out.sam  #first ovation test command, needs to be converted
#	   featureCounts -T 45 -a /genome/Homo_sapiens_AWS/UCSC/hg19/Annotation/Genes/genes.gtf -o ${i}.mapped Aligned.out.sam # based on qucke data run
          python3 /injury/scripts2/ucsctoGenename.py ${i}.mapped

	   cd ..;
done;
