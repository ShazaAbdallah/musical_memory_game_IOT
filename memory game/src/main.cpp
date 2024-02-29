#include <Arduino.h>
#include "buttonPress.h"
#include "mp3.h"
#include <cstdlib> // For std::rand and std::srand
#include <ctime>   // For std::time
#include <iostream>
#include <Adafruit_NeoPixel.h>
#include <string>
#ifdef __AVR__
 #include <avr/power.h> // Required for 16 MHz Adafruit Trinket
#endif
#include "firebase.h"

#define NEO_PIN 19
#define NEO_NUMPIXELS 16


Adafruit_NeoPixel pixels(NEO_NUMPIXELS, NEO_PIN, NEO_GRB + NEO_KHZ800);


#define MAX_SEQUENCE 5
#define USER_MODE 1
#define GAME_MODE 2
#define PENDING_MODE 3
#define DELAYVAL 500

int mode;
int current_sequence;
buttonPress button_1(5, 26, 1, 1);
buttonPress button_2(27, 18, 2, 2);
int sequences[MAX_SEQUENCE];
int user_index;
String current_user = "";

void loser();

void setup() 
{
  Serial.begin(9600); // Initialize serial communication at 9600 baud rate
  firebaseSetup();
  std::srand(static_cast<unsigned int>(std::time(nullptr)));
  #if defined(__AVR_ATtiny85__) && (F_CPU == 16000000)
    clock_prescale_set(clock_div_1);
  #endif
  pixels.begin();
  pixels.clear();
  pixels.show();
  button_1.setup();
  button_2.setup();
  mp3_setup();
  current_sequence = 0;
  mode = PENDING_MODE;
  user_index = 0;
}

void loop() {
  if(mode == PENDING_MODE)
  {
    current_user = firebaseReadUser();
    if( button_1.isPressed() || button_2.isPressed())
    {
      mode = GAME_MODE;
    }
  }
  else if(mode == GAME_MODE)
  {

    user_index = 0;
    if(current_sequence < MAX_SEQUENCE)
    {
      int random_number = std::rand() % 2 + 1;
      sequences[current_sequence] = random_number;
      pixels.setPixelColor(current_sequence, pixels.Color(0, 150, 0));
      current_sequence++;
      pixels.show(); 
      Serial.print("steps: ");
      Serial.println(current_sequence);
      for(int i = 0; i < current_sequence; i++)
      {
        switch (sequences[i])
        {
        case 1:
          button_1.show();
          delay(500);
          break;
        case 2:
          button_2.show();
          delay(500);
          break;
        default:
          break;
        }
      }
      mode = USER_MODE;
    }
    else
    {
      firebaseWrite(current_user,current_sequence);
    }
  }
  else if( mode == USER_MODE)
  {
    if(user_index >= current_sequence)
    {
      mode = GAME_MODE;
      button_1.off();
      button_2.off();
      // giving some time before playing the next sequence 
      delay(200);
    }
    else if (mode = USER_MODE)
    {
      int result = button_1.loop() + button_2.loop();
      if(result < 0)
      {
        if(current_sequence - 1 != 0)
        {
          firebaseWrite(current_user, current_sequence-1);
        }
        loser();
      }
     // Serial.print("My Variable: ");
      //Serial.println(user_index);
    }
  }
}


void loser()
{
  button_1.on();
  button_2.on();
  play_filename(2, 6);
  delay(1500);
  button_1.off();
  button_2.off();
  current_sequence = 0;
  mode = PENDING_MODE;
  user_index = 0;
  pixels.clear();
  pixels.show();
}
