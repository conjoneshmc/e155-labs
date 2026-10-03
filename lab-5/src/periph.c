#include "periph.h"

// Enable the PLL part of the MSI clock, allowing it to compensation for any errors in frequency
// This helps achieve greater accuracy in the system clock
void enable_MSI_freq_compensation(void) {
  set_bit(&RCC->APB1ENR1, 28);                // Set PWREN
  set_bit((uint32_t*) PWR_CR1, 8);   // Set DBP, enabling write access to RCC_BDCR
  set_bit(&RCC->BDCR, 0);                     // Set LSEON, enabling low-frequency oscillator
  wait_for_bit(&RCC->BDCR, 1, 1);             // Wait for LSERDY to go high
  set_bit(&RCC->CR, 2);                       // Set MSIPLLEN, enabling clock frquency compensation
  clear_bit((uint32_t*) PWR_CR1, 8); // Clear DBP, protecting write access to RCC_BDCR
}

// Enable and configure the MSI clock to run at 4 MHz
void configure_MSI_clock(void) {
  overwrite_bits(&RCC->CR, 4, 4, 0b0110); // Set MSIRANGE = 0110, setting clock frequency to 4 MHz
  set_bit(&RCC->CR, 3);                   // Set MSIRGSEL, using our provided clock frequency
  set_bit(&RCC->CR, 0);                   // Set MSION, enabling the MSI clock
  overwrite_bits(&RCC->CFGR, 0, 2, 0b00); // Set SW = 00, using MSI as the system clock
}

// Configure necessary GPIO ports as inputs
// We will be using PA6 for quad encoder A signal and PB0 for quad encoder B signal
// Both pins are 5V tolerant I/O and exposed to the breadboard connector
void configure_GPIO(void) {
  set_bit(&RCC->AHB2ENR, 0);                  // Enable GPIOA clock domain
  set_bit(&RCC->AHB2ENR, 1);                  // Enable GPIOB clock domain
  overwrite_bits(&GPIOA->MODER, 12, 2, 0b00); // Set MODE6 = 00, making PA6 an input pin
  overwrite_bits(&GPIOA->PUPDR, 12, 2, 0b00); // Set PUPD6 = 00, making PA6 floating
  overwrite_bits(&GPIOB->MODER, 0, 2, 0b00);  // Set MODE0 = 00, making PB0 an input pin
  overwrite_bits(&GPIOB->PUPDR, 0, 2, 0b00);  // Set PUPD0 = 00, making PB0 floating
}

// Configure interrupts
void configure_interrupts(void) {
  set_bit(&RCC->APB2ENR, 0);                     // Set SYSCFGEN, enabling system configuration clock domain
  // Configure EXTI6 interrupt
  overwrite_bits(&SYSCFG->EXTICR2, 8, 3, 0b000); // Set EXTI6 = 000, making PA6 connected to EXTI6
  set_bit(&EXTI->IMR1, 6);                       // Set IM6, unmasking external interrupt line 6
  set_bit(&EXTI->RTSR1, 6);                      // Set RT6, making EXTI6 listen for rising edges
  set_bit(&EXTI->FTSR1, 6);                      // Set FT6, making EXTI6 listen for falling edges
  set_bit((uint32_t*) NVIC_ISER0, 23);  // Enable IRQ 23 in the NVIC, which corresponds to EXT9_5
}