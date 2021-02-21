#!/bin/bash
#------- qsub option ----------- 
#PBS -A XMP
#PBS -q gpu
#PBS -b 1
#PBS -l elapstim_req=24:00:00 
#PBS -T openmpi
#PBS -v NQSV_MPI_VER=gdr/4.0.3/gcc8.3.1-cuda10.2
#PBS -v OMP_NUM_THREADS=6
#------- Program execution ----------- 
module load openmpi/gdr/4.0.3/gcc8.3.1-cuda10.2
INP=gpcr.inp
cd $PBS_O_WORKDIR
mpirun ${NQSII_MPIOPTS} -np 4 -npernode 4 ./3drism-cuda-mpi -l 0.025 $INP
mv *.ad ad1-0.025
mpirun ${NQSII_MPIOPTS} -np 4 -npernode 4 ./3drism-cuda-mpi -l 0.05 $INP
mv *.ad ad1-0.05
mpirun ${NQSII_MPIOPTS} -np 4 -npernode 4 ./3drism-cuda-mpi -l 0.075 $INP
mv *.ad ad1-0.075
mpirun ${NQSII_MPIOPTS} -np 4 -npernode 4 ./3drism-cuda-mpi -l 0.1 $INP
mv *.ad ad1-0.1
mpirun ${NQSII_MPIOPTS} -np 4 -npernode 4 ./3drism-cuda-mpi -l 0.125 $INP
mv *.ad ad1-0.125
mpirun ${NQSII_MPIOPTS} -np 4 -npernode 4 ./3drism-cuda-mpi -l 0.15 $INP
mv *.ad ad1-0.15
mpirun ${NQSII_MPIOPTS} -np 4 -npernode 4 ./3drism-cuda-mpi -l 0.175 $INP
mv *.ad ad1-0.175
mpirun ${NQSII_MPIOPTS} -np 4 -npernode 4 ./3drism-cuda-mpi -l 0.2 $INP
mv *.ad ad1-0.2
mpirun ${NQSII_MPIOPTS} -np 4 -npernode 4 ./3drism-cuda-mpi -l 0.225 $INP
mv *.ad ad1-0.225
mpirun ${NQSII_MPIOPTS} -np 4 -npernode 4 ./3drism-cuda-mpi -l 0.25 $INP
mv *.ad ad1-0.25
mpirun ${NQSII_MPIOPTS} -np 4 -npernode 4 ./3drism-cuda-mpi -l 0.275 $INP
mv *.ad ad1-0.275
mpirun ${NQSII_MPIOPTS} -np 4 -npernode 4 ./3drism-cuda-mpi -l 0.3 $INP
mv *.ad ad1-0.3
mpirun ${NQSII_MPIOPTS} -np 4 -npernode 4 ./3drism-cuda-mpi -l 0.325 $INP
mv *.ad ad1-0.325
mpirun ${NQSII_MPIOPTS} -np 4 -npernode 4 ./3drism-cuda-mpi -l 0.35 $INP
mv *.ad ad1-0.35
mpirun ${NQSII_MPIOPTS} -np 4 -npernode 4 ./3drism-cuda-mpi -l 0.375 $INP
mv *.ad ad1-0.375
mpirun ${NQSII_MPIOPTS} -np 4 -npernode 4 ./3drism-cuda-mpi -l 0.4 $INP
mv *.ad ad1-0.4
mpirun ${NQSII_MPIOPTS} -np 4 -npernode 4 ./3drism-cuda-mpi -l 0.425 $INP
mv *.ad ad1-0.425
mpirun ${NQSII_MPIOPTS} -np 4 -npernode 4 ./3drism-cuda-mpi -l 0.45 $INP
mv *.ad ad1-0.45
mpirun ${NQSII_MPIOPTS} -np 4 -npernode 4 ./3drism-cuda-mpi -l 0.475 $INP
mv *.ad ad1-0.475
mpirun ${NQSII_MPIOPTS} -np 4 -npernode 4 ./3drism-cuda-mpi -l 0.5 $INP
mv *.ad ad1-0.5
mpirun ${NQSII_MPIOPTS} -np 4 -npernode 4 ./3drism-cuda-mpi -l 0.525 $INP
mv *.ad ad1-0.525
mpirun ${NQSII_MPIOPTS} -np 4 -npernode 4 ./3drism-cuda-mpi -l 0.55 $INP
mv *.ad ad1-0.55
mpirun ${NQSII_MPIOPTS} -np 4 -npernode 4 ./3drism-cuda-mpi -l 0.575 $INP
mv *.ad ad1-0.575
mpirun ${NQSII_MPIOPTS} -np 4 -npernode 4 ./3drism-cuda-mpi -l 0.6 $INP
mv *.ad ad1-0.6
mpirun ${NQSII_MPIOPTS} -np 4 -npernode 4 ./3drism-cuda-mpi -l 0.625 $INP
mv *.ad ad1-0.625
mpirun ${NQSII_MPIOPTS} -np 4 -npernode 4 ./3drism-cuda-mpi -l 0.65 $INP
mv *.ad ad1-0.65
mpirun ${NQSII_MPIOPTS} -np 4 -npernode 4 ./3drism-cuda-mpi -l 0.675 $INP
mv *.ad ad1-0.675
mpirun ${NQSII_MPIOPTS} -np 4 -npernode 4 ./3drism-cuda-mpi -l 0.7 $INP
mv *.ad ad1-0.7
mpirun ${NQSII_MPIOPTS} -np 4 -npernode 4 ./3drism-cuda-mpi -l 0.725 $INP
mv *.ad ad1-0.725
mpirun ${NQSII_MPIOPTS} -np 4 -npernode 4 ./3drism-cuda-mpi -l 0.75 $INP
mv *.ad ad1-0.75
mpirun ${NQSII_MPIOPTS} -np 4 -npernode 4 ./3drism-cuda-mpi -l 0.775 $INP
mv *.ad ad1-0.775
mpirun ${NQSII_MPIOPTS} -np 4 -npernode 4 ./3drism-cuda-mpi -l 0.8 $INP
mv *.ad ad1-0.8
mpirun ${NQSII_MPIOPTS} -np 4 -npernode 4 ./3drism-cuda-mpi -l 0.825 $INP
mv *.ad ad1-0.825
mpirun ${NQSII_MPIOPTS} -np 4 -npernode 4 ./3drism-cuda-mpi -l 0.85 $INP
mv *.ad ad1-0.85
mpirun ${NQSII_MPIOPTS} -np 4 -npernode 4 ./3drism-cuda-mpi -l 0.875 $INP
mv *.ad ad1-0.875
mpirun ${NQSII_MPIOPTS} -np 4 -npernode 4 ./3drism-cuda-mpi -l 0.9 $INP
mv *.ad ad1-0.9
mpirun ${NQSII_MPIOPTS} -np 4 -npernode 4 ./3drism-cuda-mpi -l 0.925 $INP
mv *.ad ad1-0.925
mpirun ${NQSII_MPIOPTS} -np 4 -npernode 4 ./3drism-cuda-mpi -l 0.95 $INP
mv *.ad ad1-0.95
mpirun ${NQSII_MPIOPTS} -np 4 -npernode 4 ./3drism-cuda-mpi -l 0.975 $INP
mv *.ad ad1-0.975
mpirun ${NQSII_MPIOPTS} -np 4 -npernode 4 ./3drism-cuda-mpi -l 1.0 $INP
mv *.ad ad1-1.0
mpirun ${NQSII_MPIOPTS} -np 4 -npernode 4 ./3drism-cuda-mpi -e 0.001 $INP
mv *.ad ad2-0.001
mpirun ${NQSII_MPIOPTS} -np 4 -npernode 4 ./3drism-cuda-mpi -e 0.005 $INP
mv *.ad ad2-0.005
mpirun ${NQSII_MPIOPTS} -np 4 -npernode 4 ./3drism-cuda-mpi -e 0.01 $INP
mv *.ad ad2-0.01
mpirun ${NQSII_MPIOPTS} -np 4 -npernode 4 ./3drism-cuda-mpi -e 0.025 $INP
mv *.ad ad2-0.025
mpirun ${NQSII_MPIOPTS} -np 4 -npernode 4 ./3drism-cuda-mpi -e 0.05 $INP
mv *.ad ad2-0.05
mpirun ${NQSII_MPIOPTS} -np 4 -npernode 4 ./3drism-cuda-mpi -e 0.075 $INP
mv *.ad ad2-0.075
mpirun ${NQSII_MPIOPTS} -np 4 -npernode 4 ./3drism-cuda-mpi -e 0.1 $INP
mv *.ad ad2-0.1
mpirun ${NQSII_MPIOPTS} -np 4 -npernode 4 ./3drism-cuda-mpi -e 0.125 $INP
mv *.ad ad2-0.125
mpirun ${NQSII_MPIOPTS} -np 4 -npernode 4 ./3drism-cuda-mpi -e 0.15 $INP
mv *.ad ad2-0.15
mpirun ${NQSII_MPIOPTS} -np 4 -npernode 4 ./3drism-cuda-mpi -e 0.175 $INP
mv *.ad ad2-0.175
mpirun ${NQSII_MPIOPTS} -np 4 -npernode 4 ./3drism-cuda-mpi -e 0.2 $INP
mv *.ad ad2-0.2
mpirun ${NQSII_MPIOPTS} -np 4 -npernode 4 ./3drism-cuda-mpi -e 0.225 $INP
mv *.ad ad2-0.225
mpirun ${NQSII_MPIOPTS} -np 4 -npernode 4 ./3drism-cuda-mpi -e 0.25 $INP
mv *.ad ad2-0.25
mpirun ${NQSII_MPIOPTS} -np 4 -npernode 4 ./3drism-cuda-mpi -e 0.275 $INP
mv *.ad ad2-0.275
mpirun ${NQSII_MPIOPTS} -np 4 -npernode 4 ./3drism-cuda-mpi -e 0.3 $INP
mv *.ad ad2-0.3
mpirun ${NQSII_MPIOPTS} -np 4 -npernode 4 ./3drism-cuda-mpi -e 0.325 $INP
mv *.ad ad2-0.325
mpirun ${NQSII_MPIOPTS} -np 4 -npernode 4 ./3drism-cuda-mpi -e 0.35 $INP
mv *.ad ad2-0.35
mpirun ${NQSII_MPIOPTS} -np 4 -npernode 4 ./3drism-cuda-mpi -e 0.375 $INP
mv *.ad ad2-0.375
mpirun ${NQSII_MPIOPTS} -np 4 -npernode 4 ./3drism-cuda-mpi -e 0.4 $INP
mv *.ad ad2-0.4
mpirun ${NQSII_MPIOPTS} -np 4 -npernode 4 ./3drism-cuda-mpi -e 0.425 $INP
mv *.ad ad2-0.425
mpirun ${NQSII_MPIOPTS} -np 4 -npernode 4 ./3drism-cuda-mpi -e 0.45 $INP
mv *.ad ad2-0.45
mpirun ${NQSII_MPIOPTS} -np 4 -npernode 4 ./3drism-cuda-mpi -e 0.475 $INP
mv *.ad ad2-0.475
mpirun ${NQSII_MPIOPTS} -np 4 -npernode 4 ./3drism-cuda-mpi -e 0.5 $INP
mv *.ad ad2-0.5
mpirun ${NQSII_MPIOPTS} -np 4 -npernode 4 ./3drism-cuda-mpi -e 0.525 $INP
mv *.ad ad2-0.525
mpirun ${NQSII_MPIOPTS} -np 4 -npernode 4 ./3drism-cuda-mpi -e 0.55 $INP
mv *.ad ad2-0.55
mpirun ${NQSII_MPIOPTS} -np 4 -npernode 4 ./3drism-cuda-mpi -e 0.575 $INP
mv *.ad ad2-0.575
mpirun ${NQSII_MPIOPTS} -np 4 -npernode 4 ./3drism-cuda-mpi -e 0.6 $INP
mv *.ad ad2-0.6
mpirun ${NQSII_MPIOPTS} -np 4 -npernode 4 ./3drism-cuda-mpi -e 0.625 $INP
mv *.ad ad2-0.625
mpirun ${NQSII_MPIOPTS} -np 4 -npernode 4 ./3drism-cuda-mpi -e 0.65 $INP
mv *.ad ad2-0.65
mpirun ${NQSII_MPIOPTS} -np 4 -npernode 4 ./3drism-cuda-mpi -e 0.675 $INP
mv *.ad ad2-0.675
mpirun ${NQSII_MPIOPTS} -np 4 -npernode 4 ./3drism-cuda-mpi -e 0.7 $INP
mv *.ad ad2-0.7
mpirun ${NQSII_MPIOPTS} -np 4 -npernode 4 ./3drism-cuda-mpi -e 0.725 $INP
mv *.ad ad2-0.725
mpirun ${NQSII_MPIOPTS} -np 4 -npernode 4 ./3drism-cuda-mpi -e 0.75 $INP
mv *.ad ad2-0.75
mpirun ${NQSII_MPIOPTS} -np 4 -npernode 4 ./3drism-cuda-mpi -e 0.775 $INP
mv *.ad ad2-0.775
mpirun ${NQSII_MPIOPTS} -np 4 -npernode 4 ./3drism-cuda-mpi -e 0.8 $INP
mv *.ad ad2-0.8
mpirun ${NQSII_MPIOPTS} -np 4 -npernode 4 ./3drism-cuda-mpi -e 0.825 $INP
mv *.ad ad2-0.825
mpirun ${NQSII_MPIOPTS} -np 4 -npernode 4 ./3drism-cuda-mpi -e 0.85 $INP
mv *.ad ad2-0.85
mpirun ${NQSII_MPIOPTS} -np 4 -npernode 4 ./3drism-cuda-mpi -e 0.875 $INP
mv *.ad ad2-0.875
mpirun ${NQSII_MPIOPTS} -np 4 -npernode 4 ./3drism-cuda-mpi -e 0.9 $INP
mv *.ad ad2-0.9
mpirun ${NQSII_MPIOPTS} -np 4 -npernode 4 ./3drism-cuda-mpi -e 0.925 $INP
mv *.ad ad2-0.925
mpirun ${NQSII_MPIOPTS} -np 4 -npernode 4 ./3drism-cuda-mpi -e 0.95 $INP
mv *.ad ad2-0.95
mpirun ${NQSII_MPIOPTS} -np 4 -npernode 4 ./3drism-cuda-mpi -e 0.975 $INP
mv *.ad ad2-0.975
mpirun ${NQSII_MPIOPTS} -np 4 -npernode 4 ./3drism-cuda-mpi -e 1.0 $INP
mv *.ad ad2-1.0

