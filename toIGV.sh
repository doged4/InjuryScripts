#!/bin/bash

NAME=$(echo $1 | rev | cut -c 5- | rev)
echo $(echo $1 | rev | cut -c 5- | rev)

#samtools view -S -b ${NAME}.sam > ${NAME}.bam
samtools sort -@ 30 ${NAME}.bam -o ${NAME}.sorted.bam
samtools index -@ 30  ${NAME}.sorted.bam
