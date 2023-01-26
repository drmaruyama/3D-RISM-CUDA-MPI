#include <iostream>
#include <fstream>
#include "rism3d.h"
#include "extension.h"

void RISM3D :: iterate() {
  void alloc2D (vector <double *> &, int, int);
  void calloc2D (vector <complex <double> *> &, int, int);
#ifdef TEST
  double t[5];
  double ft = 0.0;
  double mt = 0.0;
  t[0] = MPI_Wtime();
#endif

  calloc2D (guv, sv -> natv, ce -> mgrid);
  calloc2D (huv, sv -> natv, ce -> mgrid);
  alloc2D (tuv, sv -> natv, ce -> mgrid);

  cudaMalloc(&dguv, ce -> mgrid * sv -> natv * sizeof(double2));
  cudaMalloc(&dhuv, ce -> mgrid * sv -> natv * sizeof(double2));
  cudaMalloc(&dt, ce -> mgrid * sv -> natv * sizeof(double));
  cudaMalloc(&dtr, ce -> mgrid * sv -> natv * sizeof(double));
  cudaMalloc(&ds, ce -> grid[1] * ce -> zrsize * sizeof(double));

  ifstream in_file ;
  in_file.open((fname + exttuv).c_str());
  bool saved = in_file.is_open();
  in_file.close();

  if (saved) {
    read_tuv();
  } else {
    initialize_tuv();
  }
#ifdef TEST
  t[1] = MPI_Wtime();
#endif
  ma -> initialize (ce, sv);
  fft -> initialize (ce, procs, yprocs, zprocs, myrank, ICOMMY, ICOMMZ, devid);
#ifdef TEST
  t[2] = MPI_Wtime();
#endif

  if (myrank == 0) cout << "relaxing 3D UV RISM:" << endl;
  bool conver = false;
  bool diverge = false;
  for (int istep = 1; istep <= co -> maxstep; ++istep) {
    calculate(ft);
    double rms = cal_rms ();
    diverge = !isfinite(rms);
    if (diverge) {
      break;
    }
    if (rms <= co -> convergence) {
      conver = true;
    } else {
      ma -> calculate (dt, dtr, mt);
    }
    if (myrank == 0) {
      cout << " Step = " << istep << " Reside = " << rms << endl;
    }
    if (co -> ksave > 0 && istep % co -> ksave == 0) {
      write_tuv();
    }
    if (conver) {
      if (co -> ksave != 0) {
	write_tuv();
      }
      break;
    }
  }
  if (diverge) {
    if (myrank == 0) {
      cout << "Calculation diverged." << endl;
    }
  } else if (!conver) {
    if (myrank == 0) {
      cout << "3D UV RISM: reached limit # of relaxation steps: "
	   << co -> maxstep << endl;
    }
  }
#ifdef TEST
  t[3] = MPI_Wtime();
#endif
  for (int iv = 0; iv < sv -> natv; ++iv) {
    cudaMemcpyAsync(huv[iv], dhuv + (iv * ce -> mgrid), 
	       ce -> mgrid * sizeof(double2), cudaMemcpyDefault);
    cudaMemcpyAsync(guv[iv], dguv + (iv * ce -> mgrid), 
	       ce -> mgrid * sizeof(double2), cudaMemcpyDefault);
  }
  delete ma;
  delete fft;
#ifdef TEST
  t[4] = MPI_Wtime();
  if (myrank == 0) {
    printf("Init Tuv    :\t%lf sec.\n", t[1] - t[0]);
    printf("Init Class  :\t%lf sec.\n", t[2] - t[1]);
    printf("Iteration   :\t%lf sec.\n", t[3] - t[2]);
    printf("cudaMemcpy  :\t%lf sec.\n", t[4] - t[3]);
    printf("----\n");
    printf("FFT         :\t%lf sec.\n", ft);
    printf("MA          :\t%lf sec.\n", mt);
    printf("Others      :\t%lf sec.\n", t[3] - t[2] - ft - mt);
  }
#endif
} 
