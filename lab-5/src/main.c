#include "main.h"

int main(void) {
  enable_MSI_freq_compensation();
  configure_MSI_clock();
  configure_GPIO();
  return 0;
}