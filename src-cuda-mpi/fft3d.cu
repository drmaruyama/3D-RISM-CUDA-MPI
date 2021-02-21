#include <iostream>
#include "fft3d.h"

void FFT3D :: initialize (Cell * ce, int procs, int yprocs, int zprocs, 
                          int myrank, MPI_Comm ICY, MPI_Comm ICZ, int devid) {
  __global__ void setkf(double2 * dkf, int nx, int ny, int nz, int, int);
  __global__ void setir(int *, int, int);
  __global__ void setik(int *, int, int);

//  cudaSetDevice(devid);

  ngrid = ce -> mgrid;
  volf = ce -> dv;
  volb = 1.0 / ce -> volume;

  nx = ce -> grid[0];
  ny = ce -> grid[1];
  nz = ce -> grid[2];
  nnxy = ce -> xksize;
  nnyy = ce -> yrsize;
  nnyz = ce -> yksize;
  nnzz = ce -> zrsize;
  npuy = yprocs;
  npuz = zprocs;
  ICOMMY = ICY;
  ICOMMZ = ICZ;

  br.x = ce -> grid[0];
  gr.x = ce -> yrsize;
  gr.y = ce -> zrsize;
  bk.x = ce -> xksize;
  gk.x = ce -> yksize;
  gk.y = ce -> grid[2];

  brx.x = ce -> grid[0];
  grx.x = nnyy;
  grx.y = nnzz;
  bry.x = ce -> grid[1];
  gry.x = nnzz;
  gry.y = nnxy;
  brz.x = ce -> grid[2];
  grz.x = nnxy;
  grz.y = nnyz;

  bkx.x = nnyy;
  gkx.x = nnzz;
  gkx.y = ce -> grid[0];
  bky.x = nnzz;
  gky.x = nnxy;
  gky.y = ce -> grid[1];
  bkz.x = nnxy;
  gkz.x = nnyz;
  gkz.y = ce -> grid[2];

  cudaMallocHost(&tmps, ngrid * sizeof(double2));
  cudaMallocHost(&tmpr, ngrid * sizeof(double2));
  cudaMalloc(&work, ngrid * sizeof(double2));
  cudaMalloc(&dkf, ngrid * sizeof(double2));
  cudaMalloc(&dir, ngrid * sizeof(int));
  cudaMalloc(&dik, ngrid * sizeof(int));
  cufftPlan1d(&planx, nx, CUFFT_Z2Z, nnyy * nnzz);
  cufftPlan1d(&plany, ny, CUFFT_Z2Z, nnzz * nnxy);
  cufftPlan1d(&planz, nz, CUFFT_Z2Z, nnxy * nnyz);

  setkf <<< gr, br >>> (dkf, ce -> grid[0], ce -> grid[1], ce -> grid[2], 
		        ce -> ystart, ce -> zstart);
  setir <<< gr, br >>> (dir, ce -> ystart, ce -> zstart);
  setik <<< gk, bk >>> (dik, ce -> xks, ce -> yks);
}


void FFT3D :: execute (double2 * da, int key) {
  if (key == - 1) {
    forward(da);
  } else {
    backward(da);
  }
}


void FFT3D :: forward (double2 * da) {
  __global__ void timeirvolf(double2 *, double2 *, int *, double);
  __global__ void timekf(double2 *, double2 *, int *);
  __global__ void ztransf(double2 *, const double2 * __restrict__);
  __global__ void mztransf(double2 *, double2 *, int);

  timekf <<< gr, br >>> (da, dkf, dir);
  cufftExecZ2Z(planx, da, da, CUFFT_FORWARD);
  ztransf <<< grx, brx, brx.x * sizeof(double2) >>> (work, da);    

#ifdef GDR
  cudaDeviceSynchronize();
  MPI_Alltoall(work, ngrid / npuy, MPI_DOUBLE_COMPLEX, da, ngrid / npuy,
	       MPI_DOUBLE_COMPLEX, ICOMMY);
#else
  cudaMemcpy(tmpr, work, ngrid * sizeof(double2), cudaMemcpyDefault);
  MPI_Alltoall(tmpr, ngrid / npuy, MPI_DOUBLE_COMPLEX, tmps, ngrid / npuy,
               MPI_DOUBLE_COMPLEX, ICOMMY);
  cudaMemcpyAsync(da, tmps, ngrid * sizeof(double2), cudaMemcpyDefault);
#endif

  mztransf <<< gkx, bkx >>> (work, da, npuy);
  cufftExecZ2Z(plany, work, work, CUFFT_FORWARD);
  ztransf <<< gry, bry, bry.x * sizeof(double2) >>> (da, work);    

#ifdef GDR
  cudaDeviceSynchronize();
  MPI_Alltoall(da, ngrid / npuz, MPI_DOUBLE_COMPLEX, work, ngrid / npuz,
	       MPI_DOUBLE_COMPLEX, ICOMMZ);
#else
  cudaMemcpy(tmpr, da, ngrid * sizeof(double2), cudaMemcpyDefault);
  MPI_Alltoall(tmpr, ngrid / npuz, MPI_DOUBLE_COMPLEX, tmps, ngrid / npuz,
	       MPI_DOUBLE_COMPLEX, ICOMMZ);
  cudaMemcpyAsync(work, tmps, ngrid * sizeof(double2), cudaMemcpyDefault);
#endif
  mztransf <<< gky, bky >>> (da, work, npuz);
  cufftExecZ2Z(planz, da, da, CUFFT_FORWARD);
  ztransf <<< grz, brz, brz.x * sizeof(double2) >>> (work, da);    
  timeirvolf <<< gk, bk >>> (da, work, dik, volf);
}


void FFT3D :: backward (double2 * da) {
  __global__ void timeirvolb(double2 *, int *);
  __global__ void timekb(double2 *, double2 *, double2 *, int *, double);
  __global__ void ztransb(double2 *, const double2 * __restrict__);
  __global__ void mztransb(double2 *, double2 *, int);

  timeirvolb <<< gk, bk >>> (da, dik);
  ztransb <<< grz, brz, brz.x * sizeof(double2) >>> (work, da);    
  cufftExecZ2Z(planz, work, work, CUFFT_INVERSE);
  mztransb <<< grz, brz >>> (da, work, npuz);

#ifdef GDR
  cudaDeviceSynchronize();
  MPI_Alltoall(da, ngrid / npuz, MPI_DOUBLE_COMPLEX, work, ngrid / npuz,
	       MPI_DOUBLE_COMPLEX, ICOMMZ);
#else
  cudaMemcpy(tmpr, da, ngrid * sizeof(double2), cudaMemcpyDefault);
  MPI_Alltoall(tmpr, ngrid / npuz, MPI_DOUBLE_COMPLEX, tmps, ngrid / npuz,
	       MPI_DOUBLE_COMPLEX, ICOMMZ);
  cudaMemcpyAsync(work, tmps, ngrid * sizeof(double2), cudaMemcpyDefault);
#endif

  ztransb <<< gry, bry, bry.x * sizeof(double2) >>> (da, work);    
  cufftExecZ2Z(plany, da, da, CUFFT_INVERSE);
  mztransb <<< gry, bry >>> (work, da, npuy);

#ifdef GDR
  cudaDeviceSynchronize();
  MPI_Alltoall(work, ngrid / npuy, MPI_DOUBLE_COMPLEX, da, ngrid / npuy,
	       MPI_DOUBLE_COMPLEX, ICOMMY);
#else
  cudaMemcpy(tmpr, work, ngrid * sizeof(double2), cudaMemcpyDefault);
  MPI_Alltoall(tmpr, ngrid / npuy, MPI_DOUBLE_COMPLEX, tmps, ngrid / npuy,
	       MPI_DOUBLE_COMPLEX, ICOMMY);
  cudaMemcpyAsync(da, tmps, ngrid * sizeof(double2), cudaMemcpyDefault);
#endif

  ztransb <<< grx, brx, brx.x * sizeof(double2) >>> (work, da);    
  cufftExecZ2Z(planx, work, work, CUFFT_INVERSE);
  timekb <<< gr, br >>> (da, work, dkf, dir, volb);
}
