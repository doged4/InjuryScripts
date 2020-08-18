# /bin/bash
mkdir sjOuts
for i in $(ls -d *);  do\
    	echo ${i};
        #cp ${i}/SJ.out.tab  sjOuts/${i}.SJ.out.tab
	cp ${i}/${i}.SJ.out.tab  sjOuts
done;
