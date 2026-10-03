#include "util.h"

// Wait for a bit at a certain register to change to the specified value
void wait_for_bit(volatile const uint32_t* const reg, uint8_t bit, uint8_t value) {
  while (((*reg & (1 << bit)) >> bit) != value);
}

// Set the specified bit at a certain register
void set_bit(volatile uint32_t* const reg, uint8_t bit) {
  *reg |= (1 << bit);
}

// Clear the specified bit at a certain register
void clear_bit(volatile uint32_t* const reg, uint8_t bit) {
  *reg &= ~(1 << bit);
}

// Overwrite a range of bits at a certain register
void overwrite_bits(volatile uint32_t* const reg, uint8_t lsb, uint8_t len, uint32_t value) {
  uint32_t mask = (1 << len) - 1;
  *reg &= ~(mask << lsb);          // Clear all the desired bits first
  *reg |= ((value & mask) << lsb); // ...then set them to the given value
}

// Read the specified bit at a certain register
uint8_t read_bit(volatile const uint32_t* const reg, uint8_t bit) {
  return (uint8_t) (*reg & (1 << bit)) >> bit;
}