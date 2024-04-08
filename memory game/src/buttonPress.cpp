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
extern int game;

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

}
int buttonPress::loop()
{
  // read the state of the pushbutton value:
  buttonState = digitalRead(buttonPin);
  //dont remove!! needed for delay.
  //Serial.printf("buttom %d state = %d, prev = %d\n", id,buttonState,prevButtonState);
  if (!one_pressed && buttonState == LOW && prevButtonState == HIGH) {
    if(id != sequences[user_index])
    {
      prevButtonState = buttonState;
      i_lost = true;
    }
    if(!i_lost){
      one_pressed = true;
      play_filename(3, filename);
      // turn LED on:
      digitalWrite(ledPin, HIGH);
      prevButtonState = buttonState;
    }
  }
  if(buttonState == HIGH && prevButtonState == LOW){
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
  play_filename(3, filename);
  digitalWrite(ledPin, HIGH);
  if(game == 0)
  {
    delay(500);
  }
  else
  {
    delay(250);
  }
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
  {
    play_filename(2, 7);
    // turn LED on:
    digitalWrite(ledPin, HIGH);
    delay(4500);
    // turn LED off:
    digitalWrite(ledPin, LOW);
    //one_pressed = true;
    prevButtonState = buttonState;
    if(game == 1)
      return true;
  }
  if(buttonState == HIGH && prevButtonState == LOW){
    one_pressed = false;
    prevButtonState = buttonState;
    if(game == 0)
      return true;
  }
  return false;
}

int buttonPress::game2Loop()
{
  // read the state of the pushbutton value:
  buttonState = digitalRead(buttonPin);
  //dont remove!! needed for delay.
  //Serial.printf("buttom %d state = %d, prev = %d\n", id,buttonState,prevButtonState);
  if (!one_pressed && buttonState == LOW && prevButtonState == HIGH) {
    if(id != sequences[0])
    {
      prevButtonState = buttonState;
      delay(100);
      digitalWrite(ledPin, LOW);
      return -1;
    }
      one_pressed = true;
      play_filename(3, filename);
      // turn LED on:
      digitalWrite(ledPin, HIGH);
      prevButtonState = buttonState;
      delay(500);
      digitalWrite(ledPin, LOW);
    return 5;
  }
  if(buttonState == HIGH && prevButtonState == LOW){
    // turn LED off:
    one_pressed = false;
    digitalWrite(ledPin, LOW);
    prevButtonState = buttonState;
  }
  return 0;
}