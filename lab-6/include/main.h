#pragma once
#include <stdint.h>
#include <stdbool.h>
#include <string.h>
#include <stdlib.h>
#include <stdio.h>

#include <stm32l432xx.h>
#include "periph.h"
#include "usart.h"
#include "spi.h"

typedef enum {
  RES_8_BIT = 8,
  RES_9_BIT = 9,
  RES_10_BIT = 10,
  RES_11_BIT = 11,
  RES_12_BIT = 12
} TemperatureResolution_TypeDef;

int str_contains(char* str, char* sequence);
void set_led_state(int on);
int get_led_state(void);
void configure_temperature_sensor(TemperatureResolution_TypeDef resolution);
int16_t read_temperature_sensor(void);
int main(void);