#pragma once
#include <stdint.h>
#include <stdbool.h>

#include <stm32l432xx.h>

void send_char(char data);
void send_str(char* data);
char read_char(void);
void read_str(char* out);