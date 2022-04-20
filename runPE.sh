#!/bin/bash

module load singularity

singularity run ${SINGDIR}/WGPQC-v1.0.sif QC_map_PE_illumina.pl \
    -1 $R1 \
    -2 $R2 \
    -o $outdir \
    -s $sample \
    -l $lanestr \
    -t $threads \
    -r $ref \
    -f $fraction \
    -e 33