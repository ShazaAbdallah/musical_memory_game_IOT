#include "buttonPress.h"
#include "mp3.h"
#include <Arduino.h>
#include <Adafruit_NeoPixel.h>
#ifdef __AVR__
 #include <avr/power.h> // Required for 16 MHz Adafruit Trinket
#endif
#include <HardwareSerial.h>

void colorWipe(uint32_t color, int wait, Adafruit_NeoPixel* strip);

buttonPress::buttonPress(const int buttonPin,const int pixelPin, const int pixelCount, int filename):
buttonPin(buttonPin),pixelPin(pixelPin),pixelCount(pixelCount),filename(filename),strip(pixelCount, pixelPin, NEO_GRB + NEO_KHZ800)
{
    buttonState = HIGH;
}
void buttonPress::setup()
{
// initialize the pushbutton pin as an input:
  pinMode(buttonPin, INPUT_PULLUP);
  strip.begin(); // Initialize NeoPixel strip object (REQUIRED)
  strip.show();  // Initial#include <HardwareSerial.h>ize all pixels to 'off'
}
void buttonPress::loop()
{
    // read the state of the pushbutton value:
  buttonState = digitalRead(buttonPin);

  if (buttonState == LOW) {
    set_volume(25);
    play_filename(1, 2);
    // turn LED on:
    colorWipe(strip.Color(255,   0,   0), 70, &strip);
  } else {
    // turn LED off:
    colorWipe(strip.Color(  0,   0,   0), 70, &strip);
  }
}

void colorWipe(uint32_t color, int wait, Adafruit_NeoPixel* strip) {
  for(int i=0; i<strip->numPixels(); i++) { // For each pixel in strip...
    strip->setPixelColor(i, color);         //  Set pixel's color (in RAM)
    strip->show();                          //  Update strip to match
    delay(wait);                           //  Pause for a moment
  }
}