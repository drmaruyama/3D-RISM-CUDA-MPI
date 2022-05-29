#!/bin/bash
#------- qsub option ----------- 
#PBS -A PRORISM
#PBS -q gpu
#PBS -b 1
#PBS -l elapstim_req=01:00:00 
#PBS -T openmpi
#PBS -v NQSV_MPI_VER=gcc8.3.1-cuda10.2-ucx1.7.0
#PBS -v OMP_NUM_THREADS=6
#------- Program execution ----------- 
module load use.own
module load gcc8.3.1-cuda10.2-ucx1.7.0
cd $PBS_O_WORKDIR
mpirun ${NQSII_MPIOPTS} -np 4 -npernode 4 ../src-cuda-mpi/3drism-cuda-mpi test2.inp
