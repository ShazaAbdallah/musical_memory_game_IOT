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
    const int ledPin;
    int filename;
    int buttonState;
    int prevButtonState;
    int id;
    bool i_lost;
    //Adafruit_NeoPixel strip;
    buttonPress(const int buttonPin,const int ledPin, int filename, int id);
    void setup();
    int loop();
    void show();
    void off();
    void on();
    bool isPressed();
    int game2Loop();
    ~buttonPress() = default;
};

#endif 