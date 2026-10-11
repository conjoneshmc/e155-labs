#include "spi.h"

char spi_send_recv(char data) {
  while (! _FLD2VAL(SPI_SR_TXE, SPI1->SR));
  *((volatile char*) (&SPI1->DR)) = data;
  while (! _FLD2VAL(SPI_SR_RXNE, SPI1->SR));
  return *((volatile char*) (&SPI1->DR));
}