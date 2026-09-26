#include "main.h"


//
// Peripheral configuration
//
void configure_clocks(void) {
  // Set MSIRANGE[3:0] = 0110 (set MSI clock frequency to 4MHz)
  RCC->CR &= ~(0b1111 << 4);
  RCC->CR |=  (0b0110 << 4);
  // Set MSIRGSEL = 1 (use the provided clock frequency in the CR register)
  RCC->CR |= (1 << 3);
  // Set MSION = 1 (enable MSI clock)
  RCC->CR |= (1 << 0);
  // Set SW[1:0] = 00 (use MSI as system clock)
  RCC->CFGR &= ~(0b11 << 0);

  // Set HPRE[3:0] = 0000 (AHB prescaler not dividing SYSCLK)
  RCC->CFGR &= ~(0b1111 << 4);
  // Set PPRE1[2:0] = 111 (APB1 prescaler dividing SYSCLK by 16, for 250kHz)
  // !! IMPORTANT !! The frequency that the timers will be running at is actually 500kHz because
  // timers multiply their clock frequency by 2 if the APB prescaler is set to a value other than 1
  RCC->CFGR |= (0b111 << 8);

  // Enable TIM6 clock
  RCC->APB1ENR1 |= (1 << 4);
  // Enable TIM7 clock
  RCC->APB1ENR1 |= (1 << 5);
  // Enable GPIOA clock
  RCC->AHB2ENR |= (1 << 0);
}

void configure_timers(void) {
  // Set ARPE = 0 (don't buffer auto-reload register)
  TIM6->CR1 &= ~(1 << 7);
  // Set PSC = 1
  // This divides the clock frequency by 2 to get 250kHz
  TIM6->PSC = 1;
  // Set CEN = 1 (enable counter)
  TIM6->CR1 |= (1 << 0);

  // Set ARPE = 0 (don't buffer auto-reload register)
  TIM7->CR1 &= ~(1 << 7);
  // Set OPM = 1 (making it a one-shot timer)
  TIM7->CR1 |= (1 << 3);
  // Set PSC = 7
  // This divides the clock frequency by 8 to get 62.5kHz
  TIM7->PSC = 7;
}

void configure_GPIO(void) {
  // Set MODE5[1:0] = 10 (general-purpose output mode)
  GPIOA->MODER &= ~(0b11 << 10);
  GPIOA->MODER |=  (0b01 << 10);
  // Set OSPEED3[1:0] = 01 (medium speed)
  GPIOA->OSPEEDR &= ~(0b11 << 10);
  GPIOA->OSPEEDR |=  (0b01 << 10);
}


//
// Utils for playing music
//
const uint32_t PITCH_TIMER_BASE_FREQ = 250000;
const uint32_t DURATION_TIMER_BASE_FREQ = 62500;

uint16_t freq_to_max_count(uint16_t freq) {
  return (uint16_t) (PITCH_TIMER_BASE_FREQ / freq);
}

uint16_t duration_to_max_count(uint16_t duration) {
  return (uint16_t) ((DURATION_TIMER_BASE_FREQ * duration) / 1000);
}

void set_speaker_freq(uint16_t freq) {
  // Set the max count for the timer
  TIM6->ARR = freq_to_max_count(freq);
  // Set UG = 1, resetting the timer
  TIM6->EGR |= (1 << 0);
}

void drive_speaker(void) {
  volatile uint16_t freq_count = TIM6->CNT;
  volatile uint16_t max_freq_count = TIM6->ARR;

  if (freq_count >= max_freq_count / 2) {
    // Drive speaker pin high
    GPIOA->ODR |=  (1 << 5);
  } else {
    // Drive speaker pin low
    GPIOA->ODR &= ~(1 << 5);
  }
}

void silence_speaker(void) {
  // Drive speaker pin low
  GPIOA->ODR &= ~(1 << 5);
}

void set_duration_timer(uint16_t duration) {
  // Set UG = 1, resetting the timer
  TIM7->EGR |= (1 << 0);
  // Set the max count for the timer
  TIM7->ARR = duration_to_max_count(duration);
  // Set UIF = 0, clearing the update flag
  // This must be done AFTER setting UG = 1
  TIM7->SR &= ~(1 << 0);
  // Set CEN = 1 (enable counter)
  TIM7->CR1 |= (1 << 0);
}

bool is_duration_timer_done(void) {
  // Check if UIF (update flag) is set
  return (TIM7->SR) & (1 << 0);
}

void clear_duration_timer_done(void) {
  // Set UIF = 0, clearing the update flag
  TIM7->SR &= ~(1 << 0);
}


//
// Application loop
//
void play_note(uint32_t note_index) {
  uint16_t pitch = SONG_NOTES[note_index][0];
  uint16_t duration = SONG_NOTES[note_index][1];

  if (pitch != 0) {
    // This note isn't a rest, so play it on the speaker
    set_speaker_freq(pitch);
  }

  if (duration != 0) {
    // This isn't the end of the song, so wait for the next note
    set_duration_timer(duration);
  }
}

bool is_note_rest(uint32_t note_index) {
  uint16_t pitch = SONG_NOTES[note_index][0];
  return pitch == 0;
}

bool is_song_done(uint32_t note_index) {
  uint16_t duration = SONG_NOTES[note_index][1];
  return duration == 0;
}

int main(void) {
  configure_clocks();
  configure_timers();
  configure_GPIO();

  uint32_t note_index = 0;
  play_note(note_index);

  while (true) {
    if (is_duration_timer_done()) {
      clear_duration_timer_done();

      note_index++;
      if (is_song_done(note_index)) {
        note_index = 0;
      }
      play_note(note_index);
    }

    if (is_note_rest(note_index)) {
      silence_speaker();
    } else {
      drive_speaker();
    }
  }
}