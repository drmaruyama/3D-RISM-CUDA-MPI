void factor(int n, int * ip) {
  ip[0] = 0;
  ip[1] = 0;
  ip[2] = 0;
  int n2 = n;
  if (n%2 != 0 && n%3 != 0 && n%5 != 0) return;
  while (n2 > 1) {
    if (n2%2 ==0) {
      ++ip[0];
      n2 /= 2;
    } else if (n2%3 ==0) {
      ++ip[1];
      n2 /= 3;
    } else if (n2%5 ==0) {
      ++ip[2];
      n2 /= 5;
    }
  }
}
