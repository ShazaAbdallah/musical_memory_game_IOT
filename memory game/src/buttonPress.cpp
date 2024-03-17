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
extern bool one_pressed;

void colorWipe(uint32_t color, int wait, Adafruit_NeoPixel* strip);

buttonPress::buttonPress(const int buttonPin,const int ledPin, int filename, int id):
buttonPin(buttonPin),ledPin(ledPin),filename(filename),id(id)
{
    buttonState = HIGH;
    prevButtonState = HIGH;
    i_lost = false;
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
  if (!one_pressed && buttonState == LOW && prevButtonState == HIGH) {
    Serial.print("is pressed...");
    Serial.println(id);
    if(id != sequences[user_index])
    {
      Serial.print("user index = ");
      Serial.println(user_index);
      Serial.print(id);
      Serial.println(" is lost-----");
      prevButtonState = buttonState;
      i_lost = true;
    }
    if(!i_lost){
      one_pressed = true;
      set_volume(25);
      play_filename(3, filename);
      // turn LED on:
      digitalWrite(ledPin, HIGH);
      prevButtonState = buttonState;
    }
  }
  if(buttonState == HIGH && prevButtonState == LOW){
    Serial.print(id);
    Serial.println(" is incide----------------------");
    // turn LED off:
    if(i_lost){
      prevButtonState = buttonState;
      i_lost = false;
      return -1;
    }
    one_pressed = false;
    user_index++;
    digitalWrite(ledPin, LOW);
    prevButtonState = buttonState;
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
  play_filename(3, filename);
  digitalWrite(ledPin, HIGH);
  delay(500);
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
  buttonState = digitalRead(buttonPin);
  if(!one_pressed && buttonState == LOW && prevButtonState == HIGH)
  //if(buttonState == LOW)
  {
    Serial.print("ispressed_____");
    Serial.println(id);
    set_volume(25);
    play_filename(2, 7);
    // turn LED on:
    digitalWrite(ledPin, HIGH);
    delay(4500);
    // turn LED off:
    digitalWrite(ledPin, LOW);
    //one_pressed = true;
    prevButtonState = buttonState;
  }
  if(buttonState == HIGH && prevButtonState == LOW){
    one_pressed = false;
    prevButtonState = buttonState;
    return true;
  }
  return false;
}