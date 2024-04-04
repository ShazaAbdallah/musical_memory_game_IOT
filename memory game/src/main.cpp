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
bool shoud_read_user = 1;

void looser();
void winner();
void loop1();
void loop2();
void setup1();
void setup2();

void setup() 
{
  Serial.begin(9600); // Initialize serial communication at 9600 baud rate
  
  //Initiate pixels
  pixels.begin();
  pixels.setBrightness(BRIGHTNESS);

  firebaseSetup();

  //Set pixels color purple - game setup mode
  for(int i =0; i < 16; i++)
  {
    pixels.setPixelColor(i, pixels.Color(119, 7, 55));
  }
  pixels.show();

  //Read currint connected user
  current_user = firebaseReadUser();

  //Initiate srand
  std::srand(static_cast<unsigned int>(std::time(nullptr)));
  #if defined(__AVR_ATtiny85__) && (F_CPU == 16000000)
    clock_prescale_set(clock_div_1);
  #endif

  //Initiate buttons 
  button_1.setup();
  button_2.setup();
  button_3.setup();
  button_4.setup();

  //mp3 Setup
  mp3_setup();
  set_volume(25);

  //Set game mode
  pinMode(SWITCH_PIN, INPUT_PULLUP);
  game = digitalRead(SWITCH_PIN);
  if(game == SIMON_GAME){
    setup1();
  }else{
    setup2();
  }
}

void setup1() //SIMON_GAME
{
  //Set pixels color blue - SIMON_GAME setup mode
  for(int i =0; i < 16; i++)
  {
    pixels.setPixelColor(i, pixels.Color(125, 249, 255));
  }
  pixels.show();
  delay(500);

  current_user = firebaseReadUser();
  shoud_read_user = 0;

  //Finish game setup
  pixels.clear();
  pixels.show();

  current_sequence = 0;
  mode = PENDING_MODE;
  user_index = 0;
}

void setup2() //SPEED_GAME
{
  //Set pixels color pink - SPEED_GAME setup mode
  for(int i =0; i < 16; i++)
  {
    pixels.setPixelColor(i, pixels.Color(159, 43, 104));
  }
  pixels.show();
  delay(500);

  current_user = firebaseReadUser();
  shoud_read_user = 0;

  //Finish game setup
  pixels.clear();
  pixels.show();

  mode = PENDING_MODE;
  game2_level = 0;
  elapsedTime = 0;
  startTime = 0;
}

void loop()
{
  //Need to switch game
  int current_game = digitalRead(SWITCH_PIN);
  if(current_game != game)
  {
    game = current_game;
    if(game == SIMON_GAME)
    {
      setup1(); //SIMON_GAME
    }
    else
    {
      setup2(); //SPEED_GAME
    }
  }

  //Play game
  if(game == SIMON_GAME)
  {
    loop1(); //SIMON_GAME
  }
  else
  {
    loop2(); //SPEED_GAME
  }
}

void loop1()
{
  //SIMON_GAME
  if(mode == PENDING_MODE) //press any button to start
  {
    if(shoud_read_user)
    {
      shoud_read_user =0;
      int led_status = digitalRead(button_1.ledPin);
      if(led_status == LOW)
      {
        button_1.on();
        button_2.on();
        button_3.on();
        button_4.on();
      }
      current_user = firebaseReadUser();
      button_1.off();
      button_2.off();
      button_3.off();
      button_4.off();
    }

    if( button_1.isPressed() || button_2.isPressed() || button_3.isPressed() || button_4.isPressed() )
    {
      shoud_read_user = 1;
      mode = GAME_MODE;
    }
  }
  else if(mode == GAME_MODE) //Game showes sequence
  {
    srand(time(0));
    user_index = 0;

    if(current_sequence < MAX_SEQUENCE)
    {
      //Pick random button.
      int random_number = std::rand() % 4 + 1;
      sequences[current_sequence] = random_number;

      //pixel show level
      for(int i = 0 ; i <current_sequence; i++)
      {
        pixels.setPixelColor(i, pixels.Color(0, 150, 0));
        pixels.show();
      }

      // Level up sound
      delay(300);
      if(current_sequence > 0)
        play_filename(3,5);

      //Level up led blink
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

      //update level
      current_sequence++;
      delay(1000);

      //show sequence faster for advanced levels
      int delay_ = (current_sequence >= 4) ? 100 : 500;

      //show sequence
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
  else if( mode == USER_MODE) // Handle user input
  {
    //Set pixels color clear - firebase reading user mode
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

      if(result < 0)
      {
        looser();
      }
    }
  }
}

void loop2() //SPEED_GAME
{
  if(mode == PENDING_MODE) //press any button to start
  {
    if(shoud_read_user)
    {
      Serial.println(" shoud_read_user  loop2");
      shoud_read_user =0;
      int led_status = digitalRead(button_1.ledPin);
      if(led_status == LOW)
      {
        Serial.println("button light on  loop2");
        button_1.on();
        button_2.on();
        button_3.on();
        button_4.on();
      }
      current_user = firebaseReadUser();
      button_1.off();
      button_2.off();
      button_3.off();
      button_4.off();

    }

    if( button_1.isPressed() || button_2.isPressed() || button_3.isPressed() || button_4.isPressed() )
    {
      shoud_read_user = 1;
      mode = GAME_MODE;
    }
  }
  else if(mode == GAME_MODE) //Game showes button
  {
    srand(time(0));

    if(game2_level < MAX_SEQUENCE)
    {
      //pixel show level
      pixels.setPixelColor(game2_level, pixels.Color(0, 150, 0));
      pixels.show(); 

      //pick random button
      int random_number = std::rand() % 4 + 1;
      sequences[0] = random_number;
      delay(500);

      switch (random_number)
      {
        case 1:
          button_1.show();
          break;
        case 2:
          button_2.show();
          break;
        case 3:
          button_3.show();
          break;
        case 4:
          button_4.show();
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

      if(result == 5){
        mode = GAME_MODE;
        game2_level++;
        speed_time += elapsedTime;
      }
      else if(result != 0)
      {
        looser();
      }
    }
    if(elapsedTime > runtime && mode == USER_MODE){
      looser();
    }
  }

}

void looser() //Handle loosing 
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
  current_user = firebaseReadUser();
  if(game == SIMON_GAME)
  {
    int final_level = current_sequence;
    current_sequence = 0;
    user_index = 0;
    Serial.print("user is in looser(): ");
    Serial.println(current_user);
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

  pixels.clear();
  pixels.show();
}

void winner()  //Handle winning
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

  current_user = firebaseReadUser();
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

  current_sequence = 0;
  game2_level = 0;
  speed_time =0;
  mode = PENDING_MODE;
  user_index = 0;

  pixels.clear();
  pixels.show();
}
