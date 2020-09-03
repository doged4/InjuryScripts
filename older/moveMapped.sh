# /bin/bash
mkdir mappedOut
for i in $(ls -d *);  do\
    	echo ${i};
        cp ${i}/${i}.mapped*  mappedOut/ 
done;
