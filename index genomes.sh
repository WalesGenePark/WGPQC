




# hg19
# ----------------------------------------------------------------------------

mkdir -p /scratch/c.wptpjg/data09/UCSC/hg19
cd /scratch/c.wptpjg/data09/UCSC/hg19

wget https://wotan.cardiff.ac.uk/containers/bwa-0.7.17.sif
cp /gluster/wgp/wgp/resources/human/UCSC/hg19/hg19_regular.fasta .

module load singularity
singularity exec bwa-0.7.17.sif bwa index -a bwtsw -p hg19 hg19_regular.fasta

mkdir -p /data09/genomes/UCSC/hg19
cp /scratch/c.wptpjg/data09/UCSC/hg19/* /data09/genomes/UCSC/hg19



# mm10
# ----------------------------------------------------------------------------

mkdir -p /scratch/c.wptpjg/data09/UCSC/mm10
cd /scratch/c.wptpjg/data09/UCSC/mm10

wget https://wotan.cardiff.ac.uk/containers/bwa-0.7.17.sif
cp /gluster/wgp/wgp/resources/mouse/UCSC/mm10/mm10_regular.fa.gz .

module load singularity
singularity exec bwa-0.7.17.sif bwa index -a bwtsw -p mm10 mm10_regular.fa.gz

mkdir -p /data09/genomes/UCSC/mm10
cp /scratch/c.wptpjg/data09/UCSC/mm10/* /data09/genomes/UCSC/mm10

