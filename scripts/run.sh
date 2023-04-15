#!/bin/bash

# FORMAT: ./run.sh -v [version: selector, ctf, both] 
#                  -n [# cores] -N [# nodes] 
#                  -h [HWPC set: 0:none, 1:L1DA/L1DM/L1IA/L1IM, 2:L2DR/L2DM/L2IR/L2IM, 3:TLBDM/TLBIM, 4:BRINS/BRMSP, 5:INS/CYC]

# Capture flags
while getopts v:n:N: flag
do
    case "${flag}" in
        v) application=${OPTARG};;
        n) cores=${OPTARG};;
        N) nodes=${OPTARG};;
        h) hwpc=${OPTARG};;
    esac
done

export CORES=$cores
export NODES=$nodes
export HWPC=$hwpc

# Run sbatch files corresponding to application version from  user
if [ $application=="selector" ] ; then
  echo "Running evaluations of the Selector application using $cores cores and $nodes nodes"
  #sbatch $PWD/scripts/jaccard_selector.sbatch $cores $nodes $hwpc
  sbatch -N $NODES -n $CORES --export=$HWPC $PWD/scripts/jaccard_selector.sbatch
elif [ $application=="ctf" ] ; then
  echo "Running evaluations of the GenomeAtScale application using $cores cores and $nodes nodes"
  sbatch $PWD/scripts/jaccard_ctf.sbatch $cores $nodes $hwpc
else
  echo "Running evaluations of both the Selector application and the GenomeAtScale application using $cores cores and $nodes nodes"
  sbatch $PWD/scripts/jaccard_selector.sbatch $cores $nodes $hwpc
  sbatch $PWD/scripts/jaccard_ctf.sbatch $cores $nodes $hwpc
fi

echo "---------------------------------------------------------------------------------------------------------------"
echo "Job(s) submitted! Please check job status for completion and see README for output interpretation instructions."
echo "---------------------------------------------------------------------------------------------------------------"


