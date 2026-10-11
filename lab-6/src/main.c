#include "main.h"

// Application entry point
int main(void) {
  enable_MSI_freq_compensation();
  configure_system_clock();
  configure_timers();
  configure_GPIO();
  configure_USART();
}