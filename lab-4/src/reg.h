#pragma once
#include <stdint.h>

// Peripheral clocks
#define RCC_BASE 0x40021000UL
#define RCC_AHB2ENR ((uint32_t*) (RCC_BASE + 0x4C))

// GPIO ports
typedef struct {
  volatile uint32_t MODER;   // 0x00
  volatile uint32_t OTYPER;  // 0x04
  volatile uint32_t OSPEEDR; // 0x08
  volatile uint32_t PUPDR;   // 0x0C
  volatile uint32_t IDR;     // 0x10
  volatile uint32_t ODR;     // 0x14
  volatile uint32_t BSRR;    // 0x18
  volatile uint32_t LCKR;    // 0x1C
  volatile uint32_t AFRL;    // 0x20
  volatile uint32_t AFRH;    // 0x24
  volatile uint32_t BRR;     // 0x28
} GPIOPort;

#define GPIOH_BASE 0x48001C00UL
#define GPIOC_BASE 0x48000800UL
#define GPIOB_BASE 0x48000400UL
#define GPIOA_BASE 0x48000000UL

#define GPIOH ((GPIOPort*) GPIOH_BASE)
#define GPIOC ((GPIOPort*) GPIOC_BASE)
#define GPIOB ((GPIOPort*) GPIOB_BASE)
#define GPIOA ((GPIOPort*) GPIOA_BASE)