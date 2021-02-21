#include "rism3d.h"

void RISM3D :: set_cuda () {
  br.x = ce -> grid[0];
  gr.x = ce -> yrsize;
  gr.y = ce -> zrsize;
  bk.x = ce -> xksize;
  gk.x = ce -> yksize;
  gk.y = ce -> grid[2];
}
