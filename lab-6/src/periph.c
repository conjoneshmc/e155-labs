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

// Configure the MSI as the system clock
void configure_system_clock(void) {
  RCC->CR &= ~RCC_CR_MSIRANGE;  // :
  RCC->CR |= RCC_CR_MSIRANGE_10; // Set MSIRANGE = 1010, setting clock frequency to 32 MHz
  RCC->CR |= RCC_CR_MSIRGSEL;   // Set MSIRGSEL, using our provided clock frequency
  RCC->CR |= RCC_CR_MSION;      // Set MSION, enabling the MSI clock
  RCC->CFGR &= ~RCC_CFGR_SW;    // Set SW = 00, using MSI as the system clock
}

// Configure TIM2 to run in upcounting mode
void configure_timers(void) {
  RCC->APB1ENR1 |= RCC_APB1ENR1_TIM2EN; // Enable TIM2 clock domain
  TIM2->CR1 |= TIM_CR1_ARPE;            // Set ARPE, making the auto-reload register preloaded
  TIM2->CR1 &= ~TIM_CR1_CMS;            // Set CMS = 00, making the timer count in one direction
  TIM2->CR1 &= ~TIM_CR1_DIR;            // Set DIR = 0, making the timer count up
  TIM2->CR1 |= TIM_CR1_CEN;             // Set CEN = 1, starting the counter
}

// Configure necessary GPIO ports as inputs
void configure_GPIO(void) {
  RCC->AHB2ENR |= RCC_AHB2ENR_GPIOAEN;                      // Enable GPIOA clock domain
  GPIOA->MODER &= ~(GPIO_MODER_MODE9 | GPIO_MODER_MODE10);  // :
  GPIOA->MODER |= _VAL2FLD(GPIO_MODER_MODE9, 0b10);         // Configure PA9 in alternate function mode
  GPIOA->MODER |= _VAL2FLD(GPIO_MODER_MODE10, 0b10);        // Configure PA10 in alternate function mode
  GPIOA->AFR[1] &= ~(GPIO_AFRH_AFSEL9 | GPIO_AFRH_AFSEL10); // :
  GPIOA->AFR[1] |= _VAL2FLD(GPIO_AFRH_AFSEL9, 0b0111);      // Configure PA9 as AF7 (USART1_TX)
  GPIOA->AFR[1] |= _VAL2FLD(GPIO_AFRH_AFSEL10, 0b0111);     // Configure PA10 as AF7 (USART1_RX)
}

// Configure USART1 peripheral
void configure_USART(void) {
  RCC->APB2ENR |= RCC_APB2ENR_USART1EN;              // Enable USART1 clock domain
  RCC->CCIPR &= ~RCC_CCIPR_USART1SEL;                // :
  RCC->CCIPR |= _VAL2FLD(RCC_CCIPR_USART1SEL, 0b01); // Set USART1 clock source to system clock
  USART1->CR1 &= ~(USART_CR1_M1 | USART_CR1_M0);     // Set M = 00, which is 1 start bit, 8 data bits, n stop bits
  USART1->CR1 &= ~USART_CR1_OVER8;                   // Set OVER8 = 0, so we oversample by 16 instead
  USART1->CR2 &= ~USART_CR2_STOP;                    // Set STOP = 00, which is 1 stop bit
  USART1->BRR = (uint16_t) 256;                      // Set BRR = 256, which divides the 32 MHz system clock to 125 kHz
  USART1->CR1 |= USART_CR1_UE;                       // :
  USART1->CR1 |= USART_CR1_TE | USART_CR1_RE;        // Enable transmission and reception on the USART peripheral
}