#pragma once
#include <stdint.h>
#include <stdbool.h>

#include "reg.h"
#include "song.h"


void configure_clocks(void);
void configure_timers(void);
void configure_GPIO(void);

uint16_t freq_to_max_count(uint16_t);
uint16_t duration_to_max_count(uint16_t);
void set_speaker_freq(uint16_t);
void drive_speaker(void);
void silence_speaker(void);
void set_duration_timer(uint16_t);
bool is_duration_timer_done(void);
void clear_duration_timer_done(void);

void play_note(uint32_t);
bool is_note_rest(uint32_t);
bool is_song_done(uint32_t);