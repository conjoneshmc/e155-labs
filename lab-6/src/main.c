#include "main.h"

// Provided webpage from starter code
char* webpage_start_str = "<!DOCTYPE html><html><head><title>E155 Web Server Demo Webpage</title>\
	<meta name=\"viewport\" content=\"width=device-width, initial-scale=1.0\">\
	</head>\
	<body><h1>E155 Web Server Demo Webpage</h1>";
char* webpage_led_str = "<p>LED Control:</p><form action=\"ledon\"><input type=\"submit\" value=\"Turn the LED on!\"></form>\
	<form action=\"ledoff\"><input type=\"submit\" value=\"Turn the LED off!\"></form>";
char* webpage_end_str = "</body></html>";

int str_contains(char* str, char* sequence) {
  if (strstr(str, sequence) != NULL) {
    return 1;
  } else {
    return 0;
  }
}

// Functions to get and set the output LED state
void set_led_state(int on) {
  if (on) {
    GPIOB->ODR |= GPIO_ODR_OD0;
  } else {
    GPIOB->ODR &= ~GPIO_ODR_OD0;
  }
}

int get_led_state(void) {
  if (_FLD2VAL(GPIO_ODR_OD0, GPIOB->ODR)) {
    return 1;
  } else {
    return 0;
  }
} 

// Application entry point
int main(void) {
  configure_flash();
  enable_MSI_freq_compensation();
  configure_system_clock();
  configure_timers();
  configure_GPIO();
  configure_USART();
  configure_SPI();

  while (true) {
    char request[64] = "";
    int char_index = 0;

    while (!str_contains(request, "\n")) {
      while (! _FLD2VAL(USART_ISR_RXNE, USART1->ISR));
      request[char_index] = read_char();
      char_index++;
    }

    // TODO: ADD SPI CODE FOR READING TEMPERATURE

    // Update LED status based on request
    if (str_contains(request, "ledon")) {
      set_led_state(1);
    } else if (str_contains(request, "ledoff")) {
      set_led_state(0);
    }

    // Send the webpage over UART
    send_str(webpage_start_str);
    send_str(webpage_led_str);

    send_str("<h2>LED Status</h2>");
    if (get_led_state()) {
      send_str("<p>The LED is <b>ON</b></p>");
    } else {
      send_str("<p>The LED is <b>OFF</b></p>");
    }

    send_str(webpage_end_str);
  }
}