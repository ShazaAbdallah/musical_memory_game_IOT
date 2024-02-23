#include "buttonPress.h"
#include "mp3.h"
#include <Arduino.h>
#include <Adafruit_NeoPixel.h>
#ifdef __AVR__
 #include <avr/power.h> // Required for 16 MHz Adafruit Trinket
#endif
#include <HardwareSerial.h>


extern int user_index;
extern int sequences[];

void colorWipe(uint32_t color, int wait, Adafruit_NeoPixel* strip);

buttonPress::buttonPress(const int buttonPin,const int ledPin, int filename, int id):
buttonPin(buttonPin),ledPin(ledPin),filename(filename),id(id)
{
    buttonState = HIGH;
}
void buttonPress::setup()
{
// initialize the pushbutton pin as an input:
  pinMode(buttonPin, INPUT_PULLUP);
  pinMode(ledPin, OUTPUT);
  //strip.begin(); // Initialize NeoPixel strip object (REQUIRED)
  //strip.show();  // Initial#include <HardwareSerial.h>ize all pixels to 'off'
}
int buttonPress::loop()
{
    // read the state of the pushbutton value:
  buttonState = digitalRead(buttonPin);

  if (buttonState == LOW) {
    if(id != sequences[user_index])
    {
      return -1;
    }
    set_volume(25);
    play_filename(2, filename);
    user_index++;
    // turn LED on:
    digitalWrite(ledPin, HIGH);
    delay(1500);
  } else {
    // turn LED off:
    digitalWrite(ledPin, LOW);
  }
  return 0;
}

void colorWipe(uint32_t color, int wait, Adafruit_NeoPixel* strip) {
  for(int i=0; i<strip->numPixels(); i++) { // For each pixel in strip...
    strip->setPixelColor(i, color);         //  Set pixel's color (in RAM)
    strip->show();                          //  Update strip to match
    delay(wait);                           //  Pause for a moment
  }
}

void buttonPress::show()
{
  set_volume(25);
  Serial.print("pressed...");
  Serial.println(id);
  play_filename(2, filename);
  digitalWrite(ledPin, HIGH);
  delay(1000);
  digitalWrite(ledPin, LOW);
}

void buttonPress::off()
{
  digitalWrite(ledPin, LOW);
}

void buttonPress::on()
{
   digitalWrite(ledPin, HIGH);
}

bool buttonPress::isPressed()
{
  bool isPressed = false;
  buttonState = digitalRead(buttonPin);
  if(buttonState == LOW)
  {
    set_volume(25);
    play_filename(2, 7);
    // turn LED on:
    digitalWrite(ledPin, HIGH);
    delay(4500);
    // turn LED off:
    digitalWrite(ledPin, LOW);
    isPressed = true;
  }
  return isPressed;
}