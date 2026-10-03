#include "main.h"

static uint8_t pa6_changed = 0;
static uint8_t pb0_changed = 0;

// PA6 interrupt handler
void EXTI9_5_IRQHandler(void) {
  if (_FLD2VAL(EXTI_PR1_PIF6, EXTI->PR1)) EXTI->PR1 |= EXTI_PR1_PIF6;
  pa6_changed = 1;
}

// PB0 interrupt handler
void EXTI0_IRQHandler(void) {
  if (_FLD2VAL(EXTI_PR1_PIF0, EXTI->PR1)) EXTI->PR1 |= EXTI_PR1_PIF0;
  pb0_changed = 1;
}

// Application entry point
int main(void) {
  enable_MSI_freq_compensation();
  configure_system_clock();
  configure_GPIO();
  configure_interrupts();
  __enable_irq();

  // printf("Done configuring!\n");
  // while (true) {
  //   if (pa6_changed) {
  //     pa6_changed = 0;
  //     printf("PA6 changed\n");
  //   }

  //   if (pb0_changed) {
  //     pb0_changed = 0;
  //     printf("PB0 changed\n");
  //   }
  // }
}