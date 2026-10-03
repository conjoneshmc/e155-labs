#include "periph.h"

// Enable the PLL part of the MSI clock, allowing it to compensation for any errors in frequency
// This helps achieve greater accuracy in the system clock
void enable_MSI_freq_compensation(void) {
  RCC->APB1ENR1 |= RCC_APB1ENR1_PWREN;               // Set PWREN
  PWR->CR1 |= PWR_CR1_DBP;                           // Set DBP, enabling write access to RCC_BDCR
  RCC->BDCR |= RCC_BDCR_LSEON;                       // Set LSEON, enabling low-frequency oscillator
  while (_FLD2VAL(RCC_BDCR_LSERDY, RCC->BDCR) != 1); // Wait for LSERDY to go high
  RCC->CR |= RCC_CR_MSIPLLEN;                        // Set MSIPLLEN, enabling clock frquency compensation
  PWR->CR1 &= ~PWR_CR1_DBP;                          // Clear DBP, protecting write access to RCC_BDCR
}

// Enable and configure the MSI clock to run at 4 MHz
void configure_system_clock(void) {
  RCC->CR &= ~RCC_CR_MSIRANGE;  // :
  RCC->CR |= RCC_CR_MSIRANGE_6; // Set MSIRANGE = 0110, setting clock frequency to 4 MHz
  RCC->CR |= RCC_CR_MSIRGSEL;   // Set MSIRGSEL, using our provided clock frequency
  RCC->CR |= RCC_CR_MSION;      // Set MSION, enabling the MSI clock
  RCC->CFGR &= ~RCC_CFGR_SW;    // Set SW = 00, using MSI as the system clock
}

// Configure necessary GPIO ports as inputs
// We will be using PA6 for quad encoder A signal and PB0 for quad encoder B signal
// Both pins are 5V tolerant I/O and exposed to the breadboard connector
void configure_GPIO(void) {
  RCC->AHB2ENR |= RCC_AHB2ENR_GPIOAEN | RCC_AHB2ENR_GPIOBEN; // Enable GPIOA & GPIOB
  GPIOA->MODER &= ~GPIO_MODER_MODE6; // Set MODE6 = 00, making PA6 an input pin
  GPIOA->PUPDR &= ~GPIO_PUPDR_PUPD6; // Set PUPD6 = 00, making PA6 floating
  GPIOB->MODER &= ~GPIO_MODER_MODE0; // Set MODE0 = 00, making PB0 and input pin
  GPIOB->PUPDR &= ~GPIO_PUPDR_PUPD0; // Set PUPD0 = 00, making PB0 floating
}

// Configure interrupts
void configure_interrupts(void) {
  RCC->APB2ENR |= _VAL2FLD(RCC_APB2ENR_SYSCFGEN, 1); // Set SYSCFGEN, enabling system configuration clock domain

  // Configure EXTI6 interrupt
  SYSCFG->EXTICR[1] &= ~SYSCFG_EXTICR2_EXTI6;     // :
  SYSCFG->EXTICR[1] |= SYSCFG_EXTICR2_EXTI6_PA;   // Set EXTI6 = 000, making PA6 connected to EXTI6
  EXTI->IMR1 |= EXTI_IMR1_IM6;                    // Set IM6, unmasking external interrupt line 6
  EXTI->RTSR1 |= EXTI_RTSR1_RT6;                  // Set RT6, making EXTI6 listen for rising edges
  EXTI->FTSR1 |= EXTI_FTSR1_FT6;                  // Set FT6, making EXTI6 listen for falling edges
  NVIC_EnableIRQ(EXTI9_5_IRQn);                   // Enable EXTI9_5 in the NVIC

  // Configure EXTI0 interrupt
  SYSCFG->EXTICR[0] &= ~SYSCFG_EXTICR1_EXTI0;     // :
  SYSCFG->EXTICR[0] |= SYSCFG_EXTICR1_EXTI0_PB;   // Set EXTI0 = 001, making PB0 connected to EXTI0
  EXTI->IMR1 |= EXTI_IMR1_IM0;                    // Set IM0, unmasking external interrupt line 0
  EXTI->RTSR1 |= EXTI_RTSR1_RT0;                  // Set RT0, making EXTI0 listen for rising edges
  EXTI->FTSR1 |= EXTI_FTSR1_FT0;                  // Set FT0, making EXTI0 listen for falling edges
  NVIC_EnableIRQ(EXTI0_IRQn);                     // Enable EXTI0 in the NVIC
}