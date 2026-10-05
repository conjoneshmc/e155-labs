#include "main.h"

// Function used by printf to send characters to the laptop
int _write(int file, char *ptr, int len) {
  for (int i = 0; i < len; i++) {
    ITM_SendChar((*ptr++));
  }
  return len;
}

int __io_putchar(int ch) {
  ITM_SendChar(ch);
  return ch;
}

// Interrupt handler logic
// For both interrupt handlers, record the time at which the pin changed, and the values of
// both encoder outputs (A & B) at that instant
// The interrupt handler needs to be short, so we will do all logic related to motor speed
// calculation in the main while loop
// The interrupt handlers also set a flag to let the main loop know an interrupt has occurred
uint32_t enc_A_timer_capture = 0;
uint8_t enc_A_pin_capture = 0; // Bit 1 = A, bit 0 = B
uint8_t enc_A_changed = 0;
uint32_t enc_B_timer_capture = 0;
uint8_t enc_B_pin_capture = 0; // Bit 1 = A, bit 0 = B
uint8_t enc_B_changed = 0;

void EXTI9_5_IRQHandler(void) { // PB5 interrupt handler (encoder A)
  if (_FLD2VAL(EXTI_PR1_PIF5, EXTI->PR1)) EXTI->PR1 |= EXTI_PR1_PIF5; // Clear pending interrupt
  enc_A_timer_capture = TIM2->CNT;
  enc_A_pin_capture = (_FLD2VAL(GPIO_IDR_ID5, GPIOB->IDR) << 1) | _FLD2VAL(GPIO_IDR_ID0, GPIOB->IDR);
  enc_A_changed = 1;
}

void EXTI0_IRQHandler(void) { // PB0 interrupt handler (encoder B)
  if (_FLD2VAL(EXTI_PR1_PIF0, EXTI->PR1)) EXTI->PR1 |= EXTI_PR1_PIF0; // Clear pending interrupt
  enc_B_timer_capture = TIM2->CNT;
  enc_B_pin_capture = (_FLD2VAL(GPIO_IDR_ID5, GPIOB->IDR) << 1) | _FLD2VAL(GPIO_IDR_ID0, GPIOB->IDR);
  enc_B_changed = 1;
}

// Timing constants
#define TIMER_FREQ_HZ 32000000
#define ZERO_VELOCITY_PULSE_TIMEOUT (TIMER_FREQ_HZ * 10) / 1000
#define REFRESH_VELOCITY_TIMEOUT (TIMER_FREQ_HZ * 50) / 1000
#define PULSES_PER_ROTATION 120
#define PULSE_TO_DELAY_RATIO 4.366

// Application entry point
int main(void) {
  enable_MSI_freq_compensation();
  configure_system_clock();
  configure_timers();
  configure_GPIO();
  configure_interrupts();
  __enable_irq();

  // Depending on the direction the motor is spinning, the edges on A and B may be used to start or
  // stop the timer. The state variable will keep track of whether we're waiting for any edge to occur (IDLE)
  // or whether we're waiting for a specific edge to occur to time pulses between the encoders
  typedef enum {
    WAITING_FOR_A,
    WAITING_FOR_B,
    IDLE
  } State_TypeDef;
  State_TypeDef state = IDLE;

  uint32_t waiting_timestamp = 0;
  uint32_t refresh_velocity_timestamp = 0;
  int32_t running_pulse_delay = 0;
  uint32_t running_pulse_count = 0;

  while (true) {
    uint32_t now_timestamp = TIM2->CNT;

    if (enc_A_changed) {
      enc_A_changed = 0;

      if ((enc_A_pin_capture == 0b00 || enc_A_pin_capture == 0b11) && state == WAITING_FOR_A) {
        // We are rotating COUNTERCLOCKWISE
        // DO calculations to measure motor speed
        state = IDLE;
        uint32_t start = enc_B_timer_capture;
        uint32_t end = enc_A_timer_capture;
        running_pulse_delay += (end - start);
        running_pulse_count++;
      }
      else if ((enc_A_pin_capture == 0b10 || enc_A_pin_capture == 0b01) && state == IDLE) {
        // We are rotating CLOCKWISE
        // Rising edge from A while B is low OR falling edge from A while B is high
        // Wait for a corresponding edge from B
        state = WAITING_FOR_B;
        waiting_timestamp = now_timestamp;
      }
      else {
        // INVALID STATE, SHOULD NOT HAPPEN DURING NORMAL OPERATION
        // If A and B are the same, then we should be in a WAITING_FOR_A state
        // Otherwise, we should be in an IDLE state
        // This may occur if the motor starts switching direction, so just reset everything
        state = IDLE;
      }
    }

    if (enc_B_changed) {
      enc_B_changed = 0;

      if ((enc_B_pin_capture == 0b00 || enc_B_pin_capture == 0b11) && state == WAITING_FOR_B) {
        // We are rotating CLOCKWISE
        // DO calculations to measure motor speed
        state = IDLE;
        uint32_t start = enc_A_timer_capture;
        uint32_t end = enc_B_timer_capture;
        running_pulse_delay -= (end - start);
        running_pulse_count++;
      }
      else if ((enc_B_pin_capture == 0b10 || enc_B_pin_capture == 0b01) && state == IDLE) {
        // We are rotating COUNTERCLOCKWISE
        // Rising edge from B while A is low OR falling edge from B while A is high
        // Wait for a corresponding edge from A
        state = WAITING_FOR_A;
        waiting_timestamp = now_timestamp;
      }
      else {
        // INVALID STATE, SHOULD NOT HAPPEN DURING NORMAL OPERATION
        // If A and B are the same, then we should be in a WAITING_FOR_B state
        // Otherwise, we should be in an IDLE state
        // This may occur if the motor starts switching direction, so just reset everything
        state = IDLE;
      }
    }

    if (
      (state == WAITING_FOR_A || state == WAITING_FOR_B)
      && (now_timestamp - waiting_timestamp) >= ZERO_VELOCITY_PULSE_TIMEOUT
    ) {
      // Timed out waiting for a pulse, assume the motor is at rest
      state = IDLE;
      running_pulse_delay = 0;
      running_pulse_count = 0;
    }

    if ((now_timestamp - refresh_velocity_timestamp) >= REFRESH_VELOCITY_TIMEOUT) {
      state = IDLE;
      refresh_velocity_timestamp = now_timestamp;

      if (running_pulse_count == 0) {
        printf("Motor speed: 0.000 rev/s\n");
      } else {
        double delay_per_count = running_pulse_delay / (double) running_pulse_count;
        double motor_rev_s = TIMER_FREQ_HZ / (PULSES_PER_ROTATION * PULSE_TO_DELAY_RATIO * delay_per_count);
        printf("Motor speed: %.3f rev/s\n", motor_rev_s);
      }

      running_pulse_delay = 0;
      running_pulse_count = 0;
    }
  }
}