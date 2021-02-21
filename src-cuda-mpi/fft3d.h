#ifndef FFT3D_H
#define FFT3D_H
#include <valarray>
#include <complex>
#include <mpi.h>
#include <cufft.h>
#include "cell.h"
using namespace std;

class FFT3D {
 public:
  FFT3D () {}
  ~FFT3D () {}
  void initialize (Cell *, int, int, int, int, MPI_Comm, MPI_Comm, int);
  void execute (double2 *, int);
 private:
  void forward (double2 *);
  void backward (double2 *);
  MPI_Comm ICOMMY, ICOMMZ;
  cufftHandle planx, plany, planz;
  dim3 gr, gk, grx, gry, grz, gkx, gky, gkz;
  dim3 br, bk, brx, bry, brz, bkx, bky, bkz;
  double2 * dkf;
  double2 * work;
  double2 * tmps;
  double2 * tmpr;
  int * dir;
  int * dik;
  double volf, volb;
  int devid;
  int ngrid;
  int nx, ny, nz;
  int nnxy, nnyy, nnyz, nnzz;
  int npuy, npuz;
};

#endif 
