#include <stdlib.h>
#include <iostream>
#include "cell.h"
using namespace std;

void Cell :: setup(int procs, int yprocs, int zprocs, 
		       int myrank, int yrank, int zrank) {
  MPI_Bcast(box, 3, MPI_DOUBLE, 0, MPI_COMM_WORLD);
  MPI_Bcast(grid, 3, MPI_INT, 0, MPI_COMM_WORLD);

  //  if (grid[1] != grid[2]) {
  //    if (myrank == 0) cout << "Please set Ny = Nz!" << endl;
  //    exit(1);
  //  }

  volume = box[0] * box[1] * box[2];
  ngrid = grid[0] * grid[1] * grid[2];
  dv = volume / ngrid;
  dr[0] = box[0] / grid[0];
  dr[1] = box[1] / grid[1];
  dr[2] = box[2] / grid[2];

  setup_mpi(procs, yprocs, zprocs, myrank, yrank, zrank);
}

void Cell :: setup_mpi(int procs, int yprocs, int zprocs, 
		       int myrank, int yrank, int zrank) {

  yrsize = grid[1] / yprocs;
  zrsize = grid[2] / zprocs;
  xksize = grid[0] / yprocs;
  yksize = grid[1] / zprocs;

  ystart = yrsize * yrank;
  zstart = zrsize * zrank;

  xks = xksize * yrank;
  yks = yksize * zrank;

  mgrid = grid[0] * yrsize * zrsize;
  int mgrid2 = xksize * yksize * grid[2] ;

  if (mgrid2 > mgrid) mgrid = mgrid2;
}
