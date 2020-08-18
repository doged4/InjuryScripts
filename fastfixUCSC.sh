# /bin/bash
mkdir mappedOut
for i in $(ls -d *);  do\
           echo ${i};
           cd  ${i};
#           featureCounts -T 45 -a /genome/genomes/hg19.gtf -o ${i}.mapped Aligned.out.sam
           python3 /injury/scripts2/ucsctoGenename.py ${i}.mapped
	   cd ..;
done;
