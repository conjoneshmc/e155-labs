#include "usart.h"

void send_char(char data) {
  while(! _FLD2VAL(USART_ISR_TXE, USART1->ISR));
  USART1->TDR = data;
  while(! _FLD2VAL(USART_ISR_TC, USART1->ISR));
}

void send_str(char* data) {
  for (uint32_t i = 0; data[i] != 0; i++) {
    send_char(data[i]);
  }
}

char read_char(void) {
  return (char) (USART1->RDR);
}

void read_str(char* out, uint32_t max_len) {
  for (uint32_t i = 0; i < max_len; i++) {
    if (! _FLD2VAL(USART_ISR_RXNE, USART1->ISR)) break;
    out[i] = read_char();
  }
}