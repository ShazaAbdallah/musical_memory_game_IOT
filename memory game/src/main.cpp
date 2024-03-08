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
#define SWITCH_PIN 33


Adafruit_NeoPixel pixels(NEO_NUMPIXELS, NEO_PIN, NEO_GRB + NEO_KHZ800);


#define MAX_SEQUENCE 16
#define USER_MODE 1
#define GAME_MODE 2
#define PENDING_MODE 3

#define SIMON_GAME 0
#define SPEED_GAME 1

int mode;
int game;
int current_sequence;
buttonPress button_1(5, 26, 1, 1);
buttonPress button_2(27, 18, 2, 2);
buttonPress button_3(5, 26, 3, 3);
buttonPress button_4(27, 18, 4, 4);
int sequences[MAX_SEQUENCE];
int user_index;
String current_user = "";

void loser();
void winner();
void loop1();
void loop2();
void setup1();
void setup2();

void setup() 
{
  Serial.begin(9600); // Initialize serial communication at 9600 baud rate
  firebaseSetup();
  current_user = firebaseReadUser();
  std::srand(static_cast<unsigned int>(std::time(nullptr)));
  #if defined(__AVR_ATtiny85__) && (F_CPU == 16000000)
    clock_prescale_set(clock_div_1);
  #endif
  pixels.begin();
  pixels.clear();
  pixels.show();
  button_1.setup();
  button_2.setup();
  button_3.setup();
  button_4.setup();
  mp3_setup();
  pinMode(SWITCH_PIN, INPUT_PULLUP);
  game = digitalRead(SWITCH_PIN);
  if(game == SIMON_GAME){
    setup1();
  }else{
    setup2();
  }
}

void setup1()
{
  current_sequence = 0;
  mode = PENDING_MODE;
  user_index = 0;
}

void setup2()
{
  for(int i =0; i < 16; i++)
  {
    pixels.setPixelColor(i, pixels.Color(255, 0, 255));
  }
  pixels.show();
}

void loop()
{
  int current_game = digitalRead(SWITCH_PIN);

  if(current_game != game)
  {
    game = current_game;
    if(game == SIMON_GAME)
    {
      setup1();
    }
    else
    {
      setup2();
    }
  }

  if(game == SIMON_GAME)
  {
    loop1();
  }
  else
  {
    loop2();
  }
}

void loop1()
{
  if(mode == PENDING_MODE)
  {
    //Serial.println("in pending");
    if( button_1.isPressed() || button_2.isPressed() || button_3.isPressed() || button_4.isPressed())
    {
      mode = GAME_MODE;
    }
  }
  else if(mode == GAME_MODE)
  {
    user_index = 0;
    if(current_sequence < MAX_SEQUENCE)
    {
      int random_number = std::rand() % 4 + 1;
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
        case 3:
          button_3.show();
          delay(500);
          break;
        case 4:
          button_4.show();
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
      winner();
    }
  }
  else if( mode == USER_MODE)
  {
    if(user_index >= current_sequence)
    {
      mode = GAME_MODE;
      button_1.off();
      button_2.off();
      button_3.off();
      button_4.off();
      // giving some time before playing the next sequence 
      delay(200);
    }
    else if (mode = USER_MODE)
    {
      int result = button_1.loop() + button_2.loop() + button_3.loop() + button_4.loop();
      if(result < 0)
      {
        loser();
      }
    }
  }
}

void loop2()
{

}

void loser()
{
  int final_level = current_sequence;
  button_1.on();
  button_2.on();
  button_3.on();
  button_4.on();
  play_filename(2, 6);
  delay(1500);
  button_1.off();
  button_2.off();
  button_3.off();
  button_4.off();
  current_sequence = 0;
  mode = PENDING_MODE;
  user_index = 0;
  pixels.clear();
  pixels.show();

  // write to firebase
  if(final_level - 1 != 0)
  {
    firebaseWrite(current_user, final_level-1);
  }
}

void winner()
{
  int final_level = current_sequence;
  button_1.on();
  button_2.on();
  button_3.on();
  button_4.on();
  play_filename(2, 5);
  delay(1500);
  button_1.off();
  button_2.off();
  button_3.off();
  button_4.off();
  current_sequence = 0;
  mode = PENDING_MODE;
  user_index = 0;
  pixels.clear();
  pixels.show();

  // write to firebase
  firebaseWrite(current_user,final_level);
}
