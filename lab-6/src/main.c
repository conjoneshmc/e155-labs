#include "main.h"

// Provided webpage from starter code
char* webpage_template = "<!DOCTYPE html><html>\
  <head>\
    <title>E155 Web Server Demo Webpage</title>\
	  <meta name=\"viewport\" content=\"width=device-width, initial-scale=1.0\">\
	</head>\
	<body>\
    <h1>E155 Web Server Demo Webpage</h1>\
    <form action=\"/\"><input type=\"submit\" value=\"Refresh\"></form>\
    <h2>LED Control</h2>\
    <form action=\"ledon\"><input type=\"submit\" value=\"Turn the LED on!\"></form>\
    <form action=\"ledoff\"><input type=\"submit\" value=\"Turn the LED off!\"></form>\
    \
    <h2>Temperature Resolution</h2>\
    <form action=\"res8bit\"><input type=\"submit\" value=\"8-bit\"></form>\
    <form action=\"res9bit\"><input type=\"submit\" value=\"9-bit\"></form>\
    <form action=\"res10bit\"><input type=\"submit\" value=\"10-bit\"></form>\
    <form action=\"res11bit\"><input type=\"submit\" value=\"11-bit\"></form>\
    <form action=\"res12bit\"><input type=\"submit\" value=\"12-bit\"></form>\
    \
    <h2>LED Status</h2>\
    <p>The LED is: <b>%s</b></p>\
    \
    <h2>Temperature Status</h2>\
    <p>The current resolution is: <b>%d-bit</b></p>\
    <p>The current temperature is: <b>%.3f C</b></p>\
  </body>\
</html>";

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

void configure_temperature_sensor(TemperatureResolution_TypeDef resolution) {
  uint8_t resolution_field = 0;
  switch (resolution) {
    case RES_8_BIT: resolution_field = 0b000; break;
    case RES_9_BIT: resolution_field = 0b001; break;
    case RES_10_BIT: resolution_field = 0b010; break;
    case RES_11_BIT: resolution_field = 0b011; break;
    case RES_12_BIT: resolution_field = 0b111; break;
    default: break;
  }

  uint8_t config_data = 0b11100000 | (resolution_field << 1);
  spi_begin();
  spi_send_recv(0x80);        // Write to configuration register
  spi_send_recv(config_data); // Enable continuous conversion mode
  spi_end();
}

int16_t read_temperature_sensor(void) {
  spi_begin();
  spi_send_recv(0x01);
  uint8_t temperature_lsb = spi_send_recv(0x00);
  uint8_t temperature_msb = spi_send_recv(0x00);
  spi_end();
  return (int16_t) ((temperature_msb << 8) | temperature_lsb);
}

// Application entry point
static TemperatureResolution_TypeDef temperature_resolution = RES_8_BIT;
int main(void) {
  configure_flash();
  enable_MSI_freq_compensation();
  configure_system_clock();
  configure_timers();
  configure_GPIO();
  configure_USART();
  configure_SPI();
  configure_temperature_sensor(temperature_resolution);

  while (true) {
    char request[64] = "";
    int char_index = 0;

    while (!str_contains(request, "\n")) {
      while (! _FLD2VAL(USART_ISR_RXNE, USART1->ISR));
      request[char_index] = read_char();
      char_index++;
    }

    // Update LED status based on request
    if      (str_contains(request, "ledon"))  set_led_state(1);
    else if (str_contains(request, "ledoff")) set_led_state(0);

    // Configure temperature sensor resolution based on request
    if (str_contains(request, "res8bit")) {
      temperature_resolution = RES_8_BIT;
      configure_temperature_sensor(temperature_resolution);
    } else if (str_contains(request, "res9bit")) {
      temperature_resolution = RES_9_BIT;
      configure_temperature_sensor(temperature_resolution);
    } else if (str_contains(request, "res10bit")) {
      temperature_resolution = RES_10_BIT;
      configure_temperature_sensor(temperature_resolution);
    } else if (str_contains(request, "res11bit")) {
      temperature_resolution = RES_11_BIT;
      configure_temperature_sensor(temperature_resolution);
    } else if (str_contains(request, "res12bit")) {
      temperature_resolution = RES_12_BIT;
      configure_temperature_sensor(temperature_resolution);
    }

    // Get LED status
    char led_state_str[4] = "";
    if (get_led_state()) strcpy(led_state_str, "ON");
    else                 strcpy(led_state_str, "OFF");
    
    // Calculate temperature from sensor data
    int16_t temperature_raw = read_temperature_sensor();
    double temperature_celsius = 0.00390625 * temperature_raw;
    
    // Send webpage over USART
    char webpage_data[2048] = "";
    snprintf(webpage_data, sizeof(webpage_data), webpage_template,
      led_state_str,
      (int) temperature_resolution,
      temperature_celsius
    );
    send_str(webpage_data);
  }
}