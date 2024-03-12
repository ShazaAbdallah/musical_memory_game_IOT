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

void firebaseSetup()
{
  Serial.begin(9600);
  // pinMode(LED_BUILTIN, OUTPUT);
  // digitalWrite(LED_BUILTIN, LOW);
  for(int i =0; i < 16; i++)
  {
    pixels.setPixelColor(i, pixels.Color(255, 103, 0));
  }
  pixels.show();
  WiFi.mode(WIFI_STA);
  WiFi.disconnect();
  delay(1000);

  // Connect to WiFi
  Serial.println();
  Serial.println();
  Serial.print("Connecting to: ");
  Serial.println(_SSID);
  WiFi.begin(_SSID, _PASSWORD);

  while (WiFi.status() != WL_CONNECTED) {
    delay(500);
    Serial.print("-");
  }
  pixels.clear();
  pixels.show();

  Serial.println("");
  Serial.println("WiFi Connected");

  // Print the IP address
  Serial.print("IP Address: ");
  Serial.print("http://");
  Serial.print(WiFi.localIP());
  Serial.println("/");
  // digitalWrite(LED_BUILTIN, HIGH);
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
    Serial.print("-");
  }
  pixels.clear();
  pixels.show();
  Serial.print("user:");
  Serial.println(user);
  Serial.print("49,firebase:");
  Serial.println(level);
  String user_path = user + "/level_" + String(level);
  int gameNum = firebase.getInt(user_path);
  firebase.setInt(user_path, ++gameNum);
}

String firebaseReadUser()
{
  String user =  firebase.getString("currentUser");
  Serial.print("Currentuser:");
  Serial.println(user);
  return user;
}