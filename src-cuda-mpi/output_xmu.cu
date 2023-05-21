#include <iostream>
#include <fstream>
#include <iomanip>
#include "rism3d.h"
#include "extension.h"

void RISM3D :: output_xmu(double * & xmu, double pmv) {
    
  ofstream out_file;
  out_file.open((fname + extxmu).c_str());

  double ibeta = avogadoro * boltzmann * sv -> temper / kcal2J;

  double xmua = 0.0;
  for (int iv = 0; iv < sv -> natv; ++iv) {
    xmua += xmu[iv];
  }

  out_file << "Solvation_Free_Energy(SC): " << fixed << setprecision(5)
           << ibeta * xmua << " (kcal/mol)" << endl;
  for (int iv = 0; iv < sv -> natv; ++iv) {
    out_file << "  " << iv << " -----> " << fixed << setprecision(5)
             << ibeta * xmu[iv] << endl;
  }
  out_file << endl;

  out_file << "PMV: " << fixed << setprecision(5)
           << pmv << " (cc/mol)" << endl;

  out_file.close();
} 
