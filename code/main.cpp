#include <Arduino.h>
#include "buttonPress.h"
#include "mp3.h"

buttonPress button_1(5, 26, 3, 1);
void setup() 
{
  button_1.setup();
  mp3_setup();
}

void loop() {
  button_1.loop();
}

