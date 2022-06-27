python /injury/someTools/rmats-turbo/rmats.py  --b1 /injury/MegaFolderB/Nassa.out/controls.txt --b2 /injury/MegaFolderB/Nassa.out/coll.txt --gtf /genome/genomes/hg19_Homo_sapiens_UCSC/UCSC/hg19/Annotation/Archives/archive-2015-07-17-14-32-32/Genes/genes.gtf --bi /genome/genomes/hg19STARbase --variable-read-length --allow-clipping --nthread 45 -t paired --readLength 150 --novelSS --od /injury/MegaFolderB/Nassa.out/rmats.out.novel.3.ucsc._contvscoll --tmp  /injury/MegaFolderB/Nassa.out/rmats.tempnovel.3.ucsc_contvscoll;

python3 /injury/scripts2/argmanchRMATspython.py /injury/MegaFolderB/Nassa.out/rmats.out.novel.3.ucsc._contvscoll contvscoll_novel

python /injury/someTools/rmats-turbo/rmats.py --b1 /injury/MegaFolderB/Nassa.out/coll.txt --b2 /injury/MegaFolderB/Nassa.out/trap.txt --gtf /genome/genomes/hg19_Homo_sapiens_UCSC/UCSC/hg19/Annotation/Archives/archive-2015-07-17-14-32-32/Genes/genes.gtf --bi /genome/genomes/hg19STARbase --variable-read-length --allow-clipping --nthread 45 -t paired --readLength 150 --novelSS --od /injury/MegaFolderB/Nassa.out/rmats.out.novel.3.ucsc._collvstrap --tmp  /injury/MegaFolderB/Nassa.out/rmats.tempnovel.3.ucsc_collvstrap;

python3 /injury/scripts2/argmanchRMATspython.py /injury/MegaFolderB/Nassa.out/rmats.out.novel3.ucsc._collvstrap collvstrap_novel

python /injury/someTools/rmats-turbo/rmats.py --b1 /injury/MegaFolderB/Nassa.out/controls.txt --b2 /injury/MegaFolderB/Nassa.out/trap.txt --gtf /genome/genomes/hg19_Homo_sapiens_UCSC/UCSC/hg19/Annotation/Archives/archive-2015-07-17-14-32-32/Genes/genes.gtf --bi /genome/genomes/hg19STARbase --variable-read-length --allow-clipping --nthread 45 -t paired --readLength 150 --novelSS --od /injury/MegaFolderB/Nassa.out/rmats.out.novel3.ucsc._convstrap --tmp  /injury/MegaFolderB/Nassa.out/rmats.tempnovel.3ucsc_convstrap;

python3 /injury/scripts2/argmanchRMATspython.py /injury/MegaFolderB/Nassa.out/rmats.out.novel3.ucsc._convstrap convstrap_novel

#Novel below

python /injury/someTools/rmats-turbo/rmats.py --b1 /injury/MegaFolderB/Nassa.out/controls.txt --b2 /injury/MegaFolderB/Nassa.out/coll.txt --gtf /genome/genomes/hg19_Homo_sapiens_UCSC/UCSC/hg19/Annotation/Archives/archive-2015-07-17-14-32-32/Genes/genes.gtf --bi /genome/genomes/hg19STARbase --variable-read-length --allow-clipping --nthread 45 -t paired --readLength 150 --od /injury/MegaFolderB/Nassa.out/rmats.out3.ucsc._contvscoll --tmp  /injury/MegaFolderB/Nassa.out/rmats.temp.3.ucsc_contvscoll;

python3 /injury/scripts2/argmanchRMATspython.py /injury/MegaFolderB/Nassa.out/rmats.out3.ucsc._contvscoll contvscoll

python /injury/someTools/rmats-turbo/rmats.py --b1 /injury/MegaFolderB/Nassa.out/coll.txt --b2 /injury/MegaFolderB/Nassa.out/trap.txt --gtf /genome/genomes/hg19_Homo_sapiens_UCSC/UCSC/hg19/Annotation/Archives/archive-2015-07-17-14-32-32/Genes/genes.gtf --bi /genome/genomes/hg19STARbase --variable-read-length --allow-clipping --nthread 45 -t paired --readLength 150 --od /injury/MegaFolderB/Nassa.out/rmats.out3.ucsc._collvstrap --tmp  /injury/MegaFolderB/Nassa.out/rmats.temp.3.ucsc_collvstrap;

python3 /injury/scripts2/argmanchRMATspython.py /injury/MegaFolderB/Nassa.out/rmats.out3.ucsc._collvstrap collvstrap

python /injury/someTools/rmats-turbo/rmats.py --b1 /injury/MegaFolderB/Nassa.out/controls.txt --b2 /injury/MegaFolderB/Nassa.out/trap.txt --gtf /genome/genomes/hg19_Homo_sapiens_UCSC/UCSC/hg19/Annotation/Archives/archive-2015-07-17-14-32-32/Genes/genes.gtf --bi /genome/genomes/hg19STARbase --variable-read-length --allow-clipping --nthread 45 -t paired --readLength 150 --novelSS --od /injury/MegaFolderB/Nassa.out/rmats.out3.ucsc._convstrap --tmp  /injury/MegaFolderB/Nassa.out/rmats.temp.3.ucsc_convstrap;

python3 /injury/scripts2/argmanchRMATspython.py /injury/MegaFolderB/Nassa.out/rmats.out3.ucsc._convstrap convstrap 

