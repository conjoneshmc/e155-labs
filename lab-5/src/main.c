#include "main.h"

int main(void) {
  enable_MSI_freq_compensation();
  configure_system_clock();
  configure_GPIO();
  configure_interrupts();
  return 0;
}