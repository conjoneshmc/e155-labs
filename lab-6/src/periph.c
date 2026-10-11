#include "periph.h"

// No idea what this is for, but it was in the starter code
void configure_flash(void) {
  FLASH->ACR |= FLASH_ACR_LATENCY_4WS;
  FLASH->ACR |= FLASH_ACR_PRFTEN;
}

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

  RCC->AHB2ENR |= RCC_AHB2ENR_GPIOBEN;                      // Enable GPIOB clock domain
  GPIOB->MODER &= ~(GPIO_MODER_MODE3 | GPIO_MODER_MODE4
    | GPIO_MODER_MODE5 | GPIO_MODER_MODE6);                 // :
  GPIOB->MODER |= _VAL2FLD(GPIO_MODER_MODE3, 0b10);         // Configure PB3 in alternate function mode
  GPIOB->MODER |= _VAL2FLD(GPIO_MODER_MODE4, 0b10);         // Configure PB4 in alternate function mode
  GPIOB->MODER |= _VAL2FLD(GPIO_MODER_MODE5, 0b10);         // Configure PB5 in alternate function mode
  GPIOB->MODER |= _VAL2FLD(GPIO_MODER_MODE6, 0b01);         // Configure PB5 in output mode
  GPIOB->AFR[0] &= ~(GPIO_AFRL_AFSEL3 | GPIO_AFRL_AFSEL4
    | GPIO_AFRL_AFSEL5);                                    // :
  GPIOB->AFR[0] |= _VAL2FLD(GPIO_AFRL_AFSEL3, 0b0101);      // Configure PB3 as AF5 (SPI1_SCK)
  GPIOB->AFR[0] |= _VAL2FLD(GPIO_AFRL_AFSEL4, 0b0101);      // Configure PB4 as AF5 (SPI1_MISO)
  GPIOB->AFR[0] |= _VAL2FLD(GPIO_AFRL_AFSEL5, 0b0101);      // Configure PB5 as AF5 (SPI1_MOSI)
  GPIOB->MODER &= ~GPIO_MODER_MODE0;                        // :
  GPIOB->MODER |= _VAL2FLD(GPIO_MODER_MODE0, 0b01);         // Configure PB0 in output mode
  GPIOB->MODER &= ~GPIO_MODER_MODE6;                        // :
  GPIOB->MODER |= _VAL2FLD(GPIO_MODER_MODE6, 0b01);         // Configure PB6 in output mode
  
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
  USART1->CR1 |= USART_CR1_UE;                       // Enable the peripheral
  USART1->CR1 |= USART_CR1_TE | USART_CR1_RE;        // Enable transmission and reception on the USART peripheral
}

// Configure SPI peripheral
void configure_SPI(void) {
  RCC->APB2ENR |= RCC_APB2ENR_SPI1EN;                // Enable SPI1 clock domain
  SPI1->CR1 &= ~SPI_CR1_BR;                          // :
  SPI1->CR1 |= _VAL2FLD(SPI_CR1_BR, 0b101);          // Set BR = 101, dividing input clock by 64
  SPI1->CR1 |= SPI_CR1_CPHA;                         // Set CPHA = 1
  SPI1->CR1 |= SPI_CR1_CPOL;                         // Set CPOL = 1
  SPI1->CR1 |= SPI_CR1_SSM;                          // Set SSM = 1, disabling hardware management of NSS
  SPI1->CR1 |= SPI_CR1_SSI;                          // Set SSI = 1, so SPI doesn't go into a master mode fault state
  SPI1->CR1 |= SPI_CR1_MSTR;                         // Select master mode
  SPI1->CR2 &= ~SPI_CR2_SSOE;                        // Set SSOE = 0, disabling the NSS pin
  SPI1->CR2 |= SPI_CR2_FRXTH;                        // Lecture slides told me to enable this
  SPI1->CR1 |= SPI_CR1_SPE;                          // Enable the peripheral
}