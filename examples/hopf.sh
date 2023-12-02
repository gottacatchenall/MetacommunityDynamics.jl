#!/bin/bash
#SBATCH --account=def-gonzalez
#SBATCH --job-name=hopf_inference 
#SBATCH --output=slurm-hopf_inference.%A.%a.out
#SBATCH --nodes=1               
#SBATCH --ntasks=1               
#SBATCH --cpus-per-task=1        
#SBATCH --mem-per-cpu=16G 
#SBATCH --array=1-256 
#SBATCH --time=45:00         


module load julia/1.9.1
julia cluster_hopf_inference.jl