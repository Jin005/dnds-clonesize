#!/bin/sh
#$ -cwd            # Set the working directory for the job to the current directory
#$ -pe smp 1       # Request 1 core
#$ -l h_rt=240:0:0 # Request 24 hour runtime
#$ -l h_vmem=5G    # Request 1GB RAM
source /data/home/hfx042/bin/snakemake/bin/activate

snakemake --jobs 80 \
  --cluster-config cluster.yaml \
  --cluster "qsub -cwd -l h_rt={cluster.time} -l h_vmem={cluster.mem} -pe smp {threads} -o {cluster.output} -j y -N {cluster.name}"
