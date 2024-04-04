#include "firebase.h"
#include <ESP32Firebase.h>
#include <Arduino.h>
#include <Adafruit_NeoPixel.h>
#define _SSID "Mariam"          // Your WiFi SSID
#define _PASSWORD "12345678"      // Your WiFi Password
#define REFERENCE_URL "https://simon-game-4d363-default-rtdb.firebaseio.com/"  // Your Firebase project reference url

Firebase firebase(REFERENCE_URL);
extern int mode;
extern Adafruit_NeoPixel pixels;
extern int game;

void firebaseSetup()
{
  for(int i =0; i < 16; i++)
  {
    pixels.setPixelColor(i, pixels.Color(255, 103, 0));
  }
  pixels.show();
  WiFi.mode(WIFI_STA);
  WiFi.disconnect();
  delay(1000);

  // Connect to WiFi
  WiFi.begin(_SSID, _PASSWORD);

  while (WiFi.status() != WL_CONNECTED) {
    delay(500);
    Serial.print("-");
  }

  pixels.show();
}

void firebaseWrite(String user, int level)
{
  bool flag = 1;
  while(WiFi.status() != WL_CONNECTED) {
    if(flag)
    {
      for(int i =0; i < 16; i++)
      {
        pixels.setPixelColor(i, pixels.Color(255, 103, 0));
      }
      pixels.show();
    }
    flag = 0;
    delay(500);
  }
  if(user != "None")
  {
    String game_name = (game == 0) ? "/memory_game" : "/speed_game";
    String user_path = user + game_name + "/level_" + String(level);
    int gameNum = firebase.getInt(user_path);
    firebase.setInt(user_path, ++gameNum);
  }
}

void firebaseWriteSpeed(String user, int update)
{
  bool flag = 1;
  while(WiFi.status() != WL_CONNECTED) {
    if(flag)
    {
      for(int i =0; i < 16; i++)
      {
        pixels.setPixelColor(i, pixels.Color(255, 103, 0));
      }
      pixels.show();
    }
    flag = 0;
    delay(500);
    Serial.print("-");
  }
  Serial.print("wifi");
  Serial.println(WiFi.status());
  pixels.clear();
  pixels.show();
  Serial.print("user:");
  Serial.println(user);
  Serial.print("49,firebase:");
  Serial.println(update);
  if(user != "None")
  {
    String user_path = user + "/speed_game" + "/last";
    firebase.setInt(user_path, update);
    if(update)
    {
      String user_path = user + "/speed_game" + "/fast";
      int gameNum = firebase.getInt(user_path);
      firebase.setInt(user_path, ++gameNum);
    }
    else
    {
      String user_path = user + "/speed_game" + "/slow";
      int gameNum = firebase.getInt(user_path);
      firebase.setInt(user_path, ++gameNum);
    }
  }
}

String firebaseReadUser()
{
  String user =  firebase.getString("currentUser");
  Serial.print("Currentuser:");
  Serial.println(user);
  return user;
}