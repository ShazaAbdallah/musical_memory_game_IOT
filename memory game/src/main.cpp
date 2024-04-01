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
#define BRIGHTNESS    50  // Set initial brightness (0-255)
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
int game2_level;
buttonPress button_1(5, 4, 1, 1);
buttonPress button_2(27, 26, 2, 2);
buttonPress button_3(21, 18, 3, 3);
buttonPress button_4(22, 23, 4, 4);
int sequences[MAX_SEQUENCE];
int user_index;
String current_user = "";
bool one_pressed = false;
unsigned long startTime;
unsigned long elapsedTime;
unsigned long speed_time = 0;

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
  pixels.setBrightness(BRIGHTNESS); // Set initial brightness
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
  pixels.show();

  set_volume(5);
}

void setup1()
{
  for(int i =0; i < 16; i++)
  {
    pixels.setPixelColor(i, pixels.Color(125, 249, 255));
  }
  pixels.show();
  delay(500);
  current_user = firebaseReadUser();
  pixels.clear();
  pixels.show();
  current_sequence = 0;
  mode = PENDING_MODE;
  user_index = 0;
}

void setup2()
{
  for(int i =0; i < 16; i++)
  {
    pixels.setPixelColor(i, pixels.Color(159, 43, 104));
  }
  pixels.show();
  delay(500);
  current_user = firebaseReadUser();
  pixels.clear();
  pixels.show();
  mode = PENDING_MODE;
  game2_level = 0;
  elapsedTime = 0;
  startTime = 0;
}

void loop()
{
  // int sequences_1 [] = {1,2,3,2,1,4,2, 0, 0,0,0,0,0,0,0,0};
  // delay(1000);
  // for(int i = 0; i < 7; i++)
  // {
  //   switch (sequences_1[i])
  //   {
  //     case 1:
  //     button_1.show();
  //       //play_filename(3, 1);
  //       delay(1000-60*current_sequence);
  //       break;
  //     case 2:
  //     button_2.show();
  //       //play_filename(3, 2);
  //       delay(1000-60*current_sequence);
  //       break;
  //     case 3:
  //     button_3.show();
  //       //play_filename(3, 3);
  //       delay(1000-60*current_sequence);
  //       break;
  //     case 4:
  //     button_4.show();
  //       //play_filename(3, 4);
  //       delay(1000-60*current_sequence);
  //       break;
  //     default:
  //       break;
  //   }
  // }
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
    Serial.println("in pending");
    if( button_1.isPressed() || button_2.isPressed() || button_3.isPressed() || button_4.isPressed() )
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
      for(int i = 0 ; i <current_sequence; i++)
      {
        pixels.setPixelColor(i, pixels.Color(0, 150, 0));
        pixels.show();
      }
      for(int i = 0; i<3; i++)
      {
        pixels.setPixelColor(current_sequence, pixels.Color(0, 150, 0));
        delay(100);
        pixels.show();
        pixels.setPixelColor(current_sequence, pixels.Color(0, 0, 0));
        delay(100);
        pixels.show(); 
      }
      pixels.setPixelColor(current_sequence, pixels.Color(0, 150, 0));
      pixels.show();
      current_sequence++;
      
      Serial.print("steps: ");
      Serial.println(current_sequence);
      delay(1000);
      int delay_ = (current_sequence >= 4) ? 100 : 500;
      for(int i = 0; i < current_sequence; i++)
      {
        switch (sequences[i])
        {
        case 1:
          button_1.show();
          delay(delay_);
          break;
        case 2:
          button_2.show();
          delay(delay_);
          break;
        case 3:
          button_3.show();
          delay(delay_);
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
    pixels.clear();
    pixels.show();
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
      // Serial.print("user_index = ");
      // Serial.println(user_index);
      if(result < 0)
      {
        loser();
      }
    }
  }
}

void loop2()
{
  if(mode == PENDING_MODE)
  {
    Serial.println("in pending");
    if( button_1.isPressed() || button_2.isPressed() || button_3.isPressed() || button_4.isPressed() )
    {
      mode = GAME_MODE;
    }
  }
  else if(mode == GAME_MODE)
  {
    if(game2_level < MAX_SEQUENCE)
    {
      pixels.setPixelColor(game2_level, pixels.Color(0, 150, 0));
      pixels.show(); 
      int random_number = std::rand() % 4 + 1;
      sequences[0] = random_number;
      delay(500);
      switch (random_number)
      {
        case 1:
          button_1.show();
          //delay(1000);
          break;
        case 2:
          button_2.show();
          //delay(1000);
          break;
        case 3:
          button_3.show();
          //delay(1000);
          break;
        case 4:
          button_4.show();
          //delay(1000);
          break;
        default:
          break;
      }
      mode = USER_MODE;
      startTime = millis();
      elapsedTime = 0;
    }else{
      winner();
    }
  }else if(mode == USER_MODE)
  {
    elapsedTime = millis() - startTime;
    int runtime =  (game2_level <= 3)? 1500 : 500;
    if (elapsedTime < runtime) 
    {
      int result = button_1.game2Loop() + button_2.game2Loop() + button_3.game2Loop() + button_4.game2Loop();
      Serial.printf("result = %d\n", result);
      if(result == 5){
        mode = GAME_MODE;
        game2_level++;
        speed_time += elapsedTime;
        Serial.print("***************8speed_time = ");
        Serial.println(speed_time);
      }
      else if(result != 0)
      {
        loser();
        Serial.println("lost beuasue result != 0");
      }
    }
    if(elapsedTime > runtime && mode == USER_MODE){
      loser();
      Serial.println("lost beuasue elapsed time");
    }
  }

}

void loser()
{
  button_1.on();
  button_2.on();
  button_3.on();
  button_4.on();
  play_filename(2, 6);
  for(int i =0; i < 16; i++)
  {
    pixels.setPixelColor(i, pixels.Color(255, 0, 0));
  }
  pixels.show();
  delay(1500);

  mode = PENDING_MODE;

  if(game == SIMON_GAME)
  {
    int final_level = current_sequence;
    current_sequence = 0;
    user_index = 0;
    // write to firebase
    if(final_level - 1 != 0)
    {
      firebaseWrite(current_user, final_level-1);
    }
  }else if(game == SPEED_GAME)
  {
    if(game2_level != 0)
    {
      firebaseWrite(current_user, game2_level);
    }
    if (speed_time < 0.5*500*game2_level)
    {
      firebaseWriteSpeed(current_user, 1);
    }
    else{
      firebaseWriteSpeed(current_user, 0);
    }
    game2_level = 0;
    speed_time =0 ;
  }

  button_1.off();
  button_2.off();
  button_3.off();
  button_4.off();
  pixels.clear();
  pixels.show();
}

void winner()
{
  int final_level = (game == SIMON_GAME) ? current_sequence : game2_level;
  button_1.on();
  button_2.on();
  button_3.on();
  button_4.on();
  play_filename(2, 5);
    for(int i =0; i < 16; i++)
  {
    pixels.setPixelColor(i, pixels.Color(0, 255, 0));
  }
  pixels.show();
  delay(1500);
  delay(1500);

  // write to firebase
  firebaseWrite(current_user,final_level);
  if(game == SPEED_GAME)
  {
    if (speed_time < 0.5*500*game2_level)
    {
      firebaseWriteSpeed(current_user, 1);
    }
    else{
      firebaseWriteSpeed(current_user, 0);
    }
  }
  button_1.off();
  button_2.off();
  button_3.off();
  button_4.off();
  current_sequence = 0;
  game2_level = 0;
  speed_time =0;
  mode = PENDING_MODE;
  user_index = 0;
  pixels.clear();
  pixels.show();
}
