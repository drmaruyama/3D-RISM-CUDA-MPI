#include <iostream>
#include <fstream>
#include <stdio.h>
#include <mpi.h>
#include "rism3d.h"
#include "extension.h"

void RISM3D :: output_guv() {
    
  if (myrank == 0) {
    cout << "outputting Guv to file:  " << fname + extguv << "  ..." << endl;
  }

  MPI_Status *status;
  MPI_File file_guv;
  MPI_File_open(MPI_COMM_WORLD, (fname + extguv).c_str(),
                MPI_MODE_WRONLY + MPI_MODE_CREATE, MPI_INFO_NULL, &file_guv);

  if (myrank == 0) {
    int nn = sv -> natv;
    int * g = ce -> grid;
    double * b = ce -> box;
    MPI_File_write(file_guv, &nn, 1, MPI_INTEGER, status);
    MPI_File_write(file_guv, &g[0], 3, MPI_INTEGER, status);
    MPI_File_write(file_guv, &b[0], 3, MPI_DOUBLE_PRECISION, status);
  }

  double * work = new double[ce -> mgrid * sv -> natv];
  for (int iv = 0; iv < sv -> natv; ++iv) {
    int i = ce -> mgrid * iv;
    for (int ig = 0; ig < ce -> mgrid; ++ig) {
      work[i + ig] = guv[iv][ig].real();
    }
  }

  int num = ce -> grid[0] * ce -> grid[1] / yprocs;
  for (int iv = 0; iv < sv -> natv; ++iv) {
    for (int k = 0; k < ce -> grid[2] / zprocs; ++k) {
      int p = sizeof(int) * 4 + sizeof(double) * (3 + yrank * num
              + k * num * yprocs + zrank * ce -> mgrid * yprocs 
              + ce -> ngrid * iv);
      MPI_File_seek(file_guv, p, MPI_SEEK_SET);
      int i = k * num + ce -> mgrid * iv;
      MPI_File_write_all(file_guv, &work[i], num,
                         MPI_DOUBLE_PRECISION, status);
    }
  }

  MPI_File_close(&file_guv);

  if (myrank == 0) cout << "done." << endl;
} 
