__global__ void mztransf(double2 * v, double2 * da, int np) {
  unsigned int ip = threadIdx.x + blockIdx.x * blockDim.x
    + blockIdx.y * blockDim.x * gridDim.x;
  int nn = gridDim.x * gridDim.y / np;  
  int yz = blockIdx.x + blockIdx.y * gridDim.x;
  int y = yz / nn;
  int z = yz % nn;
  unsigned int jp = threadIdx.x + y * blockDim.x
    + z * blockDim.x * np;
  v[jp].x = da[ip].x;
  v[jp].y = da[ip].y;
}


__global__ void mztransb(double2 * v, double2 * da, int np) {
  unsigned int ip = threadIdx.x + blockIdx.x * blockDim.x
    + blockIdx.y * blockDim.x * gridDim.x;
  int nx = blockDim.x / np;
  int x = threadIdx.x % nx;
  int z = threadIdx.x / nx;
  unsigned int jp = x + blockIdx.x * nx + blockIdx.y * nx * gridDim.x
    + z * nx * gridDim.x * gridDim.y;
  v[jp].x = da[ip].x;
  v[jp].y = da[ip].y;
}


__global__ void ztransf(double2 * v, const double2 * __restrict__ da) {
  extern __shared__ double2 sdata[];

  unsigned int ip = threadIdx.x + blockIdx.x * blockDim.x
    + blockIdx.y * blockDim.x * gridDim.x;
  unsigned int jp = blockIdx.x + blockIdx.y * gridDim.x
    + threadIdx.x * gridDim.x * gridDim.y;
  sdata[threadIdx.x].x = da[ip].x;
  sdata[threadIdx.x].y = da[ip].y;
  v[jp].x = sdata[threadIdx.x].x; 
  v[jp].y = sdata[threadIdx.x].y;
}


__global__ void ztransb(double2 * v, const double2 * __restrict__ da) {
  extern __shared__ double2 sdata[];

  unsigned int ip = blockIdx.x + blockIdx.y * gridDim.x
    + threadIdx.x * gridDim.x * gridDim.y;
  unsigned int jp = threadIdx.x + blockIdx.x * blockDim.x
    + blockIdx.y * blockDim.x * gridDim.x;
  sdata[threadIdx.x].x = da[ip].x;
  sdata[threadIdx.x].y = da[ip].y;
  v[jp].x = sdata[threadIdx.x].x; 
  v[jp].y = sdata[threadIdx.x].y;
}


__global__ void timekf(double2 * da, double2 * dkf, int * dir) {
  unsigned int ip = threadIdx.x + blockIdx.x * blockDim.x
    + blockIdx.y * blockDim.x * gridDim.x;
  double tmpr = da[ip].x * dir[ip];
  double tmpi = da[ip].y * dir[ip];
  da[ip].x = tmpr * dkf[ip].x - tmpi * dkf[ip].y;
  da[ip].y = tmpi * dkf[ip].x + tmpr * dkf[ip].y;
}


__global__ void timekb(double2 * da, double2 * v, double2 * dkf,
		       int * dir, double vol) {
  unsigned int ip = threadIdx.x + blockIdx.x * blockDim.x
    + blockIdx.y * blockDim.x * gridDim.x;
  double tmpr = v[ip].x * dir[ip] * vol;
  double tmpi = v[ip].y * dir[ip] * vol;
  da[ip].x = tmpr * dkf[ip].x + tmpi * dkf[ip].y;
  da[ip].y = tmpi * dkf[ip].x - tmpr * dkf[ip].y;
}


__global__ void timeirvolf(double2 * da, double2 * v,
			   int * dik, double vol) {
  unsigned int ip = threadIdx.x + blockIdx.x * blockDim.x
    + blockIdx.y * blockDim.x * gridDim.x;
  da[ip].x = v[ip].x * dik[ip] * vol;
  da[ip].y = v[ip].y * dik[ip] * vol;
}


__global__ void timeirvolb(double2 * da, int * dik) {
  unsigned int ip = threadIdx.x + blockIdx.x * blockDim.x
    + blockIdx.y * blockDim.x * gridDim.x;
  da[ip].x = da[ip].x * dik[ip];
  da[ip].y = da[ip].y * dik[ip];
}


__global__ void setkf(double2 * dkf, int nx, int ny, int nz, int yy, int zz) {
  unsigned int ip = threadIdx.x + blockIdx.x * blockDim.x
    + blockIdx.y * blockDim.x * gridDim.x;
  int x = threadIdx.x - nx / 2.0;
  int y = blockIdx.x + yy - ny / 2.0;
  int z = blockIdx.y + zz - nz / 2.0;
  double dkx = M_PI / nx;
  double dky = M_PI / ny;
  double dkz = M_PI / nz;
  double dkr = dkx * x + dky * y + dkz * z;
  dkf[ip].x = cos(dkr);
  dkf[ip].y = - sin(dkr);
}


__global__ void setir(int * dir, int yy, int zz) {
  unsigned int ip = threadIdx.x + blockIdx.x * blockDim.x
    + blockIdx.y * blockDim.x * gridDim.x;
  if ((threadIdx.x + blockIdx.x + blockIdx.y + yy + zz) % 2 == 0) {
    dir[ip] = 1;
  } else {
    dir[ip] = -1;
  }
}


__global__ void setik(int * dik, int xx, int yy) {
  unsigned int ip = threadIdx.x + blockIdx.x * blockDim.x
    + blockIdx.y * blockDim.x * gridDim.x;
  if ((threadIdx.x + blockIdx.x + blockIdx.y + xx + yy) % 2 == 0) {
    dik[ip] = 1;
  } else {
    dik[ip] = -1;
  }
}
