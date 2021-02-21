#include <iostream>
#include "rism3d.h"

void RISM3D :: set_mpi () {
  void factor(int, int *);
  MPI_Comm_size(MPI_COMM_WORLD, &procs);
  MPI_Comm_rank(MPI_COMM_WORLD, &myrank);

  int * ip = new int[3];
  factor(procs, ip);
  zprocs = pow(2, (ip[0]  + 1) / 2) * pow(3, (ip[1]  + 1) / 2) 
    * pow(5, (ip[2] + 1) / 2);
  yprocs = procs / zprocs;

  int ycolor = myrank / yprocs;
  int zcolor = myrank % yprocs;
  MPI_Comm_split(MPI_COMM_WORLD, ycolor, 0, &ICOMMY);
  MPI_Comm_split(MPI_COMM_WORLD, zcolor, 0, &ICOMMZ);

  MPI_Comm_rank(ICOMMY, &yrank);
  MPI_Comm_rank(ICOMMZ, &zrank);

  MPI_Bcast(&adswitch, 1, MPI_INT, 0, MPI_COMM_WORLD);
  MPI_Bcast(&lambda, 1, MPI_DOUBLE, 0, MPI_COMM_WORLD);
}
