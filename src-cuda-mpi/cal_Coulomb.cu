#include <iostream>
#include "rism3d.h"

void RISM3D :: cal_Coulomb () {
  __global__ void coulomb(double * de, double * dfr,
			  double3 * dru, double * dqu,
			  double dx, double dy, double dz,
			  int nx, int ny, int nz, int natu, int ystart, int zstart);
  __global__ void fk(double2 *, double3 *, double3 *, double *, int);
  __global__ void betar(double * de, double * dfr, double ubeta);
  __global__ void betak(double2 * dfk, double ubeta);

  if (myrank == 0) {
    cout << "synthesizing solute Coulomb potential ..." << endl;
  }
  cudaMalloc(&de, ce -> mgrid * sizeof(double));
  cudaMalloc(&dfr, ce -> mgrid * sizeof(double));
  cudaMalloc(&dfk, ce -> mgrid * sizeof(double2));
  cudaMemsetAsync(de, 0.0, ce -> mgrid * sizeof(double));
  cudaMemsetAsync(dfr, 0.0, ce -> mgrid * sizeof(double));
  cudaMemsetAsync(dfk, 0.0, ce -> mgrid * sizeof(double2));

  if (adswitch != 1) {
    coulomb <<< gr, br >>> (de, dfr, su -> dr, su -> dq,
      			    ce -> dr[0], ce -> dr[1], ce -> dr[2], 
      			    ce -> grid[0], ce -> grid[1], ce -> grid[2],
      			    su -> num, ce -> ystart, ce -> zstart);

    fk <<< gk, bk >>> (dfk, dgv, su -> dr, su -> dq, su -> num);

    double lambda2 = 1.0;
    if (adswitch == 2) lambda2 = lambda;
    double ubeta = hartree * bohr / (boltzmann * sv -> temper) * lambda2;
    betar <<< gr, br >>> (de, dfr, ubeta);
    betak <<< gk, bk >>> (dfk, ubeta);
  }
} 


__global__ void coulomb(double * de, double * dfr,
                        double3 * dru, double * dqu,
                        double bx, double by, double bz,
                        int nx, int ny, int nz, int natu, int yy, int zz) {
  unsigned int ip = threadIdx.x + blockIdx.x * blockDim.x
    + blockIdx.y * blockDim.x * gridDim.x;
  double rx = ((int)threadIdx.x - nx / 2) * bx;
  double ry = ((int)blockIdx.x + yy - ny / 2) * by;
  double rz = ((int)blockIdx.y + zz - nz / 2) * bz;
  for (int iu = 0; iu < natu; ++iu) {
    double delx = rx - dru[iu].x;
    double dely = ry - dru[iu].y;
    double delz = rz - dru[iu].z;
    double ra = sqrt(delx * delx + dely * dely + delz * delz) ;
    if (ra >= 1.0e-5) {
      double qr = dqu[iu] / ra ;
      de[ip] += qr ;
      dfr[ip] += qr * (1 - exp(- ra)) ;
    } else {
      dfr[ip] += dqu[iu] ;
    }
  }
}


__global__ void fk(double2 * dfk, double3 * dgv, double3 * dru, double * dqu,
		   int natu) {
  unsigned int ip = threadIdx.x + blockIdx.x * blockDim.x
    + blockIdx.y * blockDim.x * gridDim.x;
  double rk2 = dgv[ip].x * dgv[ip].x
    + dgv[ip].y * dgv[ip].y + dgv[ip].z * dgv[ip].z;
  double rk4i = 1.0 / (rk2 * (rk2 + 1.0));
  for (int iu = 0; iu < natu; ++iu) {
    double ruk = dgv[ip].x * dru[iu].x 
      + dgv[ip].y * dru[iu].y + dgv[ip].z * dru[iu].z;
    double tmp = 4.0 * M_PI * dqu[iu] * rk4i;
    dfk[ip].x += tmp * cos(ruk);
    dfk[ip].y -= tmp * sin(ruk);
  }
}


__global__ void betar(double * de, double * dfr, double ubeta) {
  unsigned int ip = threadIdx.x + blockIdx.x * blockDim.x
    + blockIdx.y * blockDim.x * gridDim.x;
  de[ip] *= ubeta;
  dfr[ip] *= ubeta;
}


__global__ void betak(double2 * dfk, double ubeta) {
  unsigned int ip = threadIdx.x + blockIdx.x * blockDim.x
    + blockIdx.y * blockDim.x * gridDim.x;
  dfk[ip].x *= ubeta;
  dfk[ip].y *= ubeta;
}
