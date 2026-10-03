#include "periph.h"

// Enable the PLL part of the MSI clock, allowing it to compensation for any errors in frequency
// This helps achieve greater accuracy in the system clock
void enable_MSI_freq_compensation(void) {
  RCC->APB1ENR1 |= _VAL2FLD(RCC_APB1ENR1_PWREN, 1);  // Set PWREN
  PWR->CR1 |= _VAL2FLD(PWR_CR1_DBP, 1);              // Set DBP, enabling write access to RCC_BDCR
  RCC->BDCR |= _VAL2FLD(RCC_BDCR_LSEON, 1);          // Set LSEON, enabling low-frequency oscillator
  while (_FLD2VAL(RCC_BDCR_LSERDY, RCC->BDCR) != 1); // Wait for LSERDY to go high
  RCC->CR |= _VAL2FLD(RCC_CR_MSIPLLEN, 1);           // Set MSIPLLEN, enabling clock frquency compensation
  PWR->CR1 &= ~PWR_CR1_DBP_Msk;                      // Clear DBP, protecting write access to RCC_BDCR
}

// Enable and configure the MSI clock to run at 4 MHz
void configure_system_clock(void) {
  RCC->CR &= ~RCC_CR_MSIRANGE_Msk;              // :
  RCC->CR |= _VAL2FLD(RCC_CR_MSIRANGE, 0b0110); // Set MSIRANGE = 0110, setting clock frequency to 4 MHz
  RCC->CR |= _VAL2FLD(RCC_CR_MSIRGSEL, 1);      // Set MSIRGSEL, using our provided clock frequency
  RCC->CR |= _VAL2FLD(RCC_CR_MSION, 1);         // Set MSION, enabling the MSI clock
  RCC->CFGR &= ~RCC_CFGR_SW_Msk;                // Set SW = 00, using MSI as the system clock
}

// Configure necessary GPIO ports as inputs
// We will be using PA6 for quad encoder A signal and PB0 for quad encoder B signal
// Both pins are 5V tolerant I/O and exposed to the breadboard connector
void configure_GPIO(void) {
  RCC->AHB2ENR |= _VAL2FLD(RCC_AHB2ENR_GPIOAEN, 1) | _VAL2FLD(RCC_AHB2ENR_GPIOBEN, 1); // Enable GPIOA & GPIOB
  GPIOA->MODER &= ~GPIO_MODER_MODE6_Msk; // Set MODE6 = 00, making PA6 an input pin
  GPIOA->PUPDR &= ~GPIO_PUPDR_PUPD6_Msk; // Set PUPD6 = 00, making PA6 floating
  GPIOB->MODER &= ~GPIO_MODER_MODE0_Msk; // Set MODE0 = 00, making PB0 and input pin
  GPIOB->PUPDR &= ~GPIO_PUPDR_PUPD0_Msk; // Set PUPD0 = 00, making PB0 floating
}

// Configure interrupts
void configure_interrupts(void) {
  __enable_irq();                                    // Enable interrupts globally
  RCC->APB2ENR |= _VAL2FLD(RCC_APB2ENR_SYSCFGEN, 1); // Set SYSCFGEN, enabling system configuration clock domain
  // Configure EXTI6 interrupt
  SYSCFG->EXTICR[1] &= ~SYSCFG_EXTICR2_EXTI6_Msk; // Set EXTI6 = 000, making PA6 connected to EXTI6
  EXTI->IMR1 |= _VAL2FLD(EXTI_IMR1_IM6, 1);       // Set IM6, unmasking external interrupt line 6
  EXTI->RTSR1 |= _VAL2FLD(EXTI_RTSR1_RT6, 1);     // Set RT6, making EXTI6 listen for rising edges
  EXTI->FTSR1 |= _VAL2FLD(EXTI_FTSR1_FT6, 1);     // Set FT6, making EXTI6 listen for falling edges
  NVIC_EnableIRQ(EXTI9_5_IRQn);                   // Enable EXTI9_5 in the NVIC
  // Configure EXTI0 interrupt
  SYSCFG->EXTICR[0] &= ~SYSCFG_EXTICR1_EXTI0_Msk;             // :
  SYSCFG->EXTICR[0] |= _VAL2FLD(SYSCFG_EXTICR1_EXTI0, 0b001); // Set EXTI0 = 001, making PB0 connected to EXTI0
  EXTI->IMR1 |= _VAL2FLD(EXTI_IMR1_IM0, 1);                   // Set IM0, unmasking external interrupt line 0
  EXTI->RTSR1 |= _VAL2FLD(EXTI_RTSR1_RT0, 1);                 // Set RT0, making EXTI0 listen for rising edges
  EXTI->FTSR1 |= _VAL2FLD(EXTI_FTSR1_FT0, 1);                 // Set FT0, making EXTI0 listen for falling edges
  NVIC_EnableIRQ(EXTI0_IRQn);
}