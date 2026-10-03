#pragma once
#include <stdint.h>

//
// Reset and clock control
//
typedef struct {
  volatile uint32_t CR;          // 0x00
  volatile uint32_t ICSCR;       // 0x04
  volatile uint32_t CFGR;        // 0x08
  volatile uint32_t PLLCFGR;     // 0x0C
  volatile uint32_t PLLSAI1CFGR; // 0x10
  volatile uint32_t RESERVED1;   //
  volatile uint32_t CIER;        // 0x18
  volatile uint32_t CIFR;        // 0x1C
  volatile uint32_t CICR;        // 0x20
  volatile uint32_t RESERVED2;   //
  volatile uint32_t AHB1RSTR;    // 0x28
  volatile uint32_t AHB2RSTR;    // 0x2C
  volatile uint32_t AHB3RSTR;    // 0x30
  volatile uint32_t RESERVED3;   //
  volatile uint32_t APB1RSTR1;   // 0x38
  volatile uint32_t APB1RSTR2;   // 0x3C
  volatile uint32_t APB2RSTR;    // 0x40
  volatile uint32_t RESERVED4;   //
  volatile uint32_t AHB1ENR;     // 0x48
  volatile uint32_t AHB2ENR;     // 0x4C
  volatile uint32_t AHB3ENR;     // 0x50
  volatile uint32_t RESERVED5;   //
  volatile uint32_t APB1ENR1;    // 0x58
  volatile uint32_t APB1ENR2;    // 0x5C
  volatile uint32_t APB2ENR;     // 0x60
  volatile uint32_t RESERVED6;   //
  volatile uint32_t AHB1SMENR;   // 0x68
  volatile uint32_t AHB2SMENR;   // 0x6C
  volatile uint32_t AHB3SMENR;   // 0x70
  volatile uint32_t RESERVED7;   //
  volatile uint32_t APB1SMENR1;  // 0x78
  volatile uint32_t APB1SMENR2;  // 0x7C
  volatile uint32_t APB2SMENR;   // 0x80
  volatile uint32_t RESERVED8;   //
  volatile uint32_t CCIPR;       // 0x88
  volatile uint32_t RESERVED9;   //
  volatile uint32_t BDCR;        // 0x90
  volatile uint32_t CSR;         // 0x94
  volatile uint32_t CRRCR;       // 0x98
  volatile uint32_t CCIPR2;      // 0x9C
} RCCReg;

#define PWR_CR1 0x40007000UL

#define RCC_BASE 0x40021000UL
#define RCC ((RCCReg*) RCC_BASE)

//
// Timers
//
typedef struct {
  volatile uint32_t CR1;       // 0x00
  volatile uint32_t CR2;       // 0x04
  volatile uint32_t RESERVED1; //
  volatile uint32_t DIER;      // 0x0C
  volatile uint32_t SR;        // 0x10
  volatile uint32_t EGR;       // 0x14
  volatile uint32_t RESERVED2; //
  volatile uint32_t RESERVED3; //
  volatile uint32_t RESERVED4; //
  volatile uint32_t CNT;       // 0x24
  volatile uint32_t PSC;       // 0x28
  volatile uint32_t ARR;       // 0x2C
} BasicTimerReg;

#define TIM7_BASE 0x40001400UL
#define TIM6_BASE 0x40001000UL
#define TIM7 ((BasicTimerReg*) TIM7_BASE)
#define TIM6 ((BasicTimerReg*) TIM6_BASE)

//
// GPIO ports
//
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
} GPIOPortReg;

#define GPIOH_BASE 0x48001C00UL
#define GPIOC_BASE 0x48000800UL
#define GPIOB_BASE 0x48000400UL
#define GPIOA_BASE 0x48000000UL
#define GPIOH ((GPIOPortReg*) GPIOH_BASE)
#define GPIOC ((GPIOPortReg*) GPIOC_BASE)
#define GPIOB ((GPIOPortReg*) GPIOB_BASE)
#define GPIOA ((GPIOPortReg*) GPIOA_BASE)

//
// System configuration controller
//
typedef struct {
  volatile uint32_t MEMRMP;  // 0x00
  volatile uint32_t CFGR1;   // 0x04
  volatile uint32_t EXTICR1; // 0x08
  volatile uint32_t EXTICR2; // 0x0C
  volatile uint32_t EXTICR3; // 0x10
  volatile uint32_t EXTICR4; // 0x14
  volatile uint32_t SCSR;    // 0x18
  volatile uint32_t CFGR2;   // 0x1C
  volatile uint32_t SWPR;    // 0x20
  volatile uint32_t SKR;     // 0x24
} SYSCFGReg;

#define SYSCFG_BASE 0x40010000UL
#define SYSCFG ((SYSCFGReg*) SYSCFG_BASE)

//
// External interrupts
//
typedef struct {
  volatile uint32_t IMR1;      // 0x00
  volatile uint32_t EMR1;      // 0x04
  volatile uint32_t RTSR1;     // 0x08
  volatile uint32_t FTSR1;     // 0x0C
  volatile uint32_t SWIER1;    // 0x10
  volatile uint32_t PR1;       // 0x14
  volatile uint32_t RESERVED1; //
  volatile uint32_t RESERVED2; //
  volatile uint32_t IMR2;      // 0x20
  volatile uint32_t EMR2;      // 0x24
  volatile uint32_t RTSR2;     // 0x28
  volatile uint32_t FTSR2;     // 0x2C
  volatile uint32_t SWIER2;    // 0x30
  volatile uint32_t PR2;       // 0x34
} EXTIReg;

#define EXTI_BASE 0x40010400UL
#define EXTI ((EXTIReg*) EXTI_BASE)

//
// Nested vector interrupt controller
//
#define NVIC_ISER0 0xE000E200UL
#define NVIC_ISER1 0xE000E204UL
#define NVIC_ISER2 0xE000E208UL
#define NVIC_ISER3 0xE000E20CUL
#define NVIC_ISER4 0xE000E210UL
#define NVIC_ISER5 0xE000E214UL
#define NVIC_ISER6 0xE000E218UL
#define NVIC_ISER7 0xE000E21CUL

#define NVIC_ICER0 0xE000E280UL
#define NVIC_ICER1 0xE000E284UL
#define NVIC_ICER2 0xE000E288UL
#define NVIC_ICER3 0xE000E28CUL
#define NVIC_ICER4 0xE000E290UL
#define NVIC_ICER5 0xE000E294UL
#define NVIC_ICER6 0xE000E298UL
#define NVIC_ICER7 0xE000E29CUL