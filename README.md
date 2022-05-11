## Overview

These are the scripts and container definition files for running run QC by mapping the fastqc files and extracting various metrics.

## QC workflow
* Run mapping QC on all fastqc files (illuminaQC.pl)
* Create run specific QC html files (QC_html_PE_illumina.pl)
* Update index for all QC runs

	
## illuminaQC

This script acts as a launcher, creating and submitting slurms scripts for the fastq files detected in the input directory.

The script can apply map all samples against the same reference geneome:

```
DIR=/data09/incoming/220406_M03762_0171_000000000-DFVKK/Data/Intensities/BaseCalls
OUT=/data09/QCtest
CPUTHREADS=10

illuminaQC.pl -t $CPUTHREADS -i $DIR -o $OUT -ref hg19
```

Or, can apply a different genome according to the project code identified in the sample name:

```
DIR=/data09/incoming/220406_M03762_0171_000000000-DFVKK/Data/Intensities/BaseCalls
OUT=/data09/QCtest
CPUTHREADS=10

illuminaQC.pl -t $CPUTHREADS -i $DIR -o $OUT -refs R120:hg19,R100:mm10
```

By default, Undetermined reads are mapped against the phiX genome.



Settings are found at the top of the file and include:

```
$SLURM_PARTITION="c_compute_cg1";
$SLURM_ACCOUNT="scwNNN";
$SLURM_CORES=10;
$SLURM_WALLTIME="0-6:00";

$RUNSE="/data09/QC_pipelines/workflow/runSE.sh";
$RUNPE="/data09/QC_pipelines/workflow/runPE.sh";

$QCOUTPUTDIR="/data09/QCtest";
```
	
## Run scripts (runPE.sh and runSE.sh)

These files act as the link between the illuminaQC script and the container containing the mapping workflow.

System specific changes that might be required include, the path to various genome references:

```
refpath=/data09/QC_pipelines/genomes/UCSC/mm10/mm10
```

And the bind paths for singularity to be able to write to various filesystem locations.

```
singularity exec --bind /data09:/data09 /data09/QC_pipelines/workflow/WGPQC-v1.0.sif QC_map_PE_illumina.pl \
```



## Create genome indexes
This scripts gives examples of using bwa index genome fasta files for incorporation with these scripts.


After creating additional indexes, these would need to be added to the runPE.sh and runSE.sh scripts citing the reference name and the index location.

e.g.
```
if [ "${ref}" == "hg19" ]; then
    refpath=/data09/QC_pipelines/genomes/UCSC/hg19/hg19
fi
```


## MappingQC_singularity

This directory contains all the custom code and libraries necessary along with a singularity definitions file needed to create a sif file to run the key QC pipeline.

The key commands generated used for mapping paried-end (PE) and single-end (SE) fastq files and then generating various QC metrics and files are then:

```
singularity exec WGPQC-v1.0.sif QC_map_PE_illumina.pl
singularity exec WGPQC-v1.0.sif QC_map_SE_illumina.pl

```