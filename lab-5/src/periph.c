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
  RCC->CR |= RCC_CR_MSIRANGE_10; // Set MSIRANGE = 1010, setting clock frequency to 32 MHz
  RCC->CR |= RCC_CR_MSIRGSEL;   // Set MSIRGSEL, using our provided clock frequency
  RCC->CR |= RCC_CR_MSION;      // Set MSION, enabling the MSI clock
  RCC->CFGR &= ~RCC_CFGR_SW;    // Set SW = 00, using MSI as the system clock
}

void configure_timers(void) {
  RCC->APB1ENR1 |= RCC_APB1ENR1_TIM2EN; // Enable TIM2 clock domain
  TIM2->CR1 |= TIM_CR1_ARPE;            // Set ARPE, making the auto-reload register preloaded
  TIM2->CR1 &= ~TIM_CR1_CMS;            // Set CMS = 00, making the timer count in one direction
  TIM2->CR1 &= ~TIM_CR1_DIR;            // Set DIR = 0, making the timer count up
  TIM2->CR1 |= TIM_CR1_CEN;             // Set CEN = 1, starting the counter
}

// Configure necessary GPIO ports as inputs
// We will be using PB5 for quad encoder A signal and PB0 for quad encoder B signal
// Both pins are 5V tolerant I/O and exposed to the breadboard connector
void configure_GPIO(void) {
  RCC->AHB2ENR |= RCC_AHB2ENR_GPIOBEN; // Enable GPIOB clock domain
  GPIOB->MODER &= ~GPIO_MODER_MODE5; // Set MODE5 = 00, making PB5 an input pin
  GPIOB->PUPDR &= ~GPIO_PUPDR_PUPD5; // Set PUPD5 = 00, making PB5 floating
  GPIOB->MODER &= ~GPIO_MODER_MODE0; // Set MODE0 = 00, making PB0 an input pin
  GPIOB->PUPDR &= ~GPIO_PUPDR_PUPD0; // Set PUPD0 = 00, making PB0 floating
}

// Configure interrupts
void configure_interrupts(void) {
  RCC->APB2ENR |= _VAL2FLD(RCC_APB2ENR_SYSCFGEN, 1); // Set SYSCFGEN, enabling system configuration clock domain

  // Configure EXTI5 interrupt
  SYSCFG->EXTICR[1] &= ~SYSCFG_EXTICR2_EXTI5;     // :
  SYSCFG->EXTICR[1] |= SYSCFG_EXTICR2_EXTI5_PB;   // Set EXTI5 = 001, making PB5 connected to EXTI5
  EXTI->IMR1 |= EXTI_IMR1_IM5;                    // Set IM5, unmasking external interrupt line 6
  EXTI->RTSR1 |= EXTI_RTSR1_RT5;                  // Set RT5, making EXTI5 listen for rising edges
  EXTI->FTSR1 |= EXTI_FTSR1_FT5;                  // Set FT5, making EXTI5 listen for falling edges
  NVIC_EnableIRQ(EXTI9_5_IRQn);                   // Enable EXTI9_5 in the NVIC

  // Configure EXTI0 interrupt
  SYSCFG->EXTICR[0] &= ~SYSCFG_EXTICR1_EXTI0;     // :
  SYSCFG->EXTICR[0] |= SYSCFG_EXTICR1_EXTI0_PB;   // Set EXTI0 = 001, making PB0 connected to EXTI0
  EXTI->IMR1 |= EXTI_IMR1_IM0;                    // Set IM0, unmasking external interrupt line 0
  EXTI->RTSR1 |= EXTI_RTSR1_RT0;                  // Set RT0, making EXTI0 listen for rising edges
  EXTI->FTSR1 |= EXTI_FTSR1_FT0;                  // Set FT0, making EXTI0 listen for falling edges
  NVIC_EnableIRQ(EXTI0_IRQn);                     // Enable EXTI0 in the NVIC
}