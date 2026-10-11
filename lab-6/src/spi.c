#include "spi.h"

void spi_begin(void) {
  GPIOB->ODR |= GPIO_ODR_OD6;
}

void spi_end(void) {
  GPIOB->ODR &= ~GPIO_ODR_OD6;
}

uint8_t spi_send_recv(uint8_t data) {
  while (! _FLD2VAL(SPI_SR_TXE, SPI1->SR));  // Wait for TX shift register to be empty
  *((volatile uint8_t*) (&SPI1->DR)) = data; // Write data into the TX shift register
  while (! _FLD2VAL(SPI_SR_RXNE, SPI1->SR)); // Wait for RX shift register to fill up
  return *((volatile uint8_t*) (&SPI1->DR)); // Read received data
}