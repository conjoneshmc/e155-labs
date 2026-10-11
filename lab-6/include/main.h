#pragma once
#include <stdint.h>
#include <stdbool.h>
#include <string.h>
#include <stdlib.h>
#include <stdio.h>

#include <stm32l432xx.h>
#include "periph.h"
#include "usart.h"

int str_contains(char* str, char* sequence);
void set_led_state(int on);
int get_led_state(void);
int main(void);