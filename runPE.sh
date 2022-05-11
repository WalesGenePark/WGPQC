#!/bin/bash

module load singularity

if [ "${ref}" == "hg19" ]; then
    refpath=/data09/QC_pipelines/genomes/UCSC/hg19/hg19
fi

if [ "${ref}" == "mm10" ]; then
    refpath=/data09/QC_pipelines/genomes/UCSC/mm10/mm10
fi

singularity exec --bind /data09:/data09 /data09/QC_pipelines/workflow/WGPQC-v1.0.sif QC_map_PE_illumina.pl \
    -1 ${R1} \
    -2 ${R2} \
    -o ${outdir} \
    -s ${sample} \
    -l ${lanestr} \
    -t ${threads} \
    -r ${refpath} \
    -f ${fraction} \
    -e 33
    




