#include <Arduino.h>
#include "buttonPress.h"
#include "mp3.h"
#include <cstdlib> // For std::rand and std::srand
#include <ctime>   // For std::time
#include <iostream>

#define MAX_SEQUENCE 5
#define USER_MODE 1
#define GAME_MODE 2
#define PENDDING_MODE 3

int mode;
int current_sequence;
buttonPress button_1(5, 26, 1, 1);
buttonPress button_2(27, 18, 2, 2);
int sequences[MAX_SEQUENCE];
int user_index;

void loser();

void setup() 
{
  Serial.begin(9600); // Initialize serial communication at 9600 baud rate
  std::srand(static_cast<unsigned int>(std::time(nullptr)));
  button_1.setup();
  button_2.setup();
  mp3_setup();
  current_sequence = 0;
  mode = GAME_MODE;
  user_index = 0;
}

void loop() {
  if(mode == GAME_MODE)
  {
    user_index = 0;
    if(current_sequence < MAX_SEQUENCE)
    {
      int random_number = std::rand() % 2 + 1;
      sequences[current_sequence] = random_number;
      current_sequence++;
      Serial.print("steps: ");
      Serial.println(current_sequence);
      for(int i = 0; i <= current_sequence; i++)
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
  }
  else if( mode == USER_MODE)
  {
    if(user_index >= current_sequence)
    {
      mode = GAME_MODE;
      button_1.off();
      button_2.off();
    }
    else if (mode = USER_MODE)
    {
      int result = button_1.loop() + button_2.loop();
      if(result < 0)
      {
        loser();
        mode = PENDDING_MODE;
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
  play_filename(1, 3);
}
