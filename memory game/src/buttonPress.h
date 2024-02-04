#ifndef BUTTONPRESS_H
#define BUTTONPRESS_H
#include <Arduino.h>
#include <Adafruit_NeoPixel.h>
#ifdef __AVR__
 #include <avr/power.h> // Required for 16 MHz Adafruit Trinket
#endif
/* Button
    turns on neopixel led and play sound
*/
class buttonPress
{
public:
    const int buttonPin;
    const int pixelPin;
    const int pixelCount;
    int filename;
    int buttonState;
    Adafruit_NeoPixel strip;
    buttonPress(const int buttonPin,const int pixelPin, const int pixelCount, int filename);
    void setup();
    void loop();
    ~buttonPress() = default;
};

#endif 