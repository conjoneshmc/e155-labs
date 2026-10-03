#pragma once
#include <stdint.h>
#include <stdbool.h>

void wait_for_bit(volatile const uint32_t* const reg, uint8_t bit, uint8_t value);
void set_bit(volatile uint32_t* const reg, uint8_t bit);
void clear_bit(volatile uint32_t* const reg, uint8_t bit);
void overwrite_bits(volatile uint32_t* const reg, uint8_t lsb, uint8_t len, uint32_t value);
uint8_t read_bit(volatile const uint32_t* const reg, uint8_t bit);