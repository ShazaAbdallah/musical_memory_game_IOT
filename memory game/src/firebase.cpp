#include "firebase.h"

#include <Arduino.h>
#include <Adafruit_NeoPixel.h>
#define _SSID "Mariam"          // Your WiFi SSID
#define _PASSWORD "12345678"      // Your WiFi Password
#define REFERENCE_URL "https://simon-game-4d363-default-rtdb.firebaseio.com/"  // Your Firebase project reference url

#include <Arduino.h>
#include <ArduinoJson.h>
/**
 * Based on code created by K. Suwatchai (Mobizt)
 * https://github.com/mobizt/Firebase-ESP-Client/blob/main/examples/RTDB/DataChangesListener/Callback/Callback.ino
 */

#if defined(ESP32)
#include <WiFi.h>
#elif defined(ESP8266)
#include <ESP8266WiFi.h>
#endif
//#include <nlohmann/json.hpp>


#include "secrets.h"

#include <Firebase_ESP_Client.h>

// Provide the token generation process info.
#include <addons/TokenHelper.h>

// Provide the RTDB payload printing info and other helper functions.
#include <addons/RTDBHelper.h>

// Define Firebase Data object
FirebaseData stream;
FirebaseData fbdo;
//using json = nlohmann::json;
FirebaseAuth auth;
FirebaseConfig config;


extern int mode;
extern Adafruit_NeoPixel pixels;
extern int game;

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

  Serial.printf("Firebase Client v%s\n\n", FIREBASE_CLIENT_VERSION);

  /* Assign the api key (required) */
  config.api_key = API_KEY;

  /* Assign the user sign in credentials */
  auth.user.email = USER_EMAIL;
  auth.user.password = USER_PASSWORD;

  /* Assign the RTDB URL (required) */
  config.database_url = DATABASE_URL;

  // Or use legacy authenticate method
  // config.database_url = DATABASE_URL;
  // config.signer.tokens.legacy_token = "<database secret>";

  // To connect without auth in Test Mode, see Authentications/TestMode/TestMode.ino

  Firebase.begin(&config, &auth);

  Firebase.reconnectWiFi(true);

// Recommend for ESP8266 stream, adjust the buffer size to match your stream data size
#if defined(ESP8266)
  stream.setBSSLBufferSize(2048 /* Rx in bytes, 512 - 16384 */, 512 /* Tx in bytes, 512 - 16384 */);
#endif

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
  String game_name = (game == 0) ? "/memory_game" : "/speed_game";
  String user_path = user + game_name + "/level_" + String(level);

  Firebase.ready(); // should be called repeatedly to handle authentication tasks.
  FirebaseJsonData result;
  FirebaseJson json_2;
  Serial.print(user_path);
  if(Firebase.RTDB.getJSON(&fbdo, user_path, &json_2))
  {
    Serial.print("enterd get\n");
    String data = json_2.raw();
    JsonDocument doc;
    deserializeJson(doc,data);
    String key = "/level_" + String(level);
    int prev_level = doc[key].as<int>();
    FirebaseJson json;
    json.add(key, ++prev_level);
    Firebase.RTDB.setJSON(&fbdo, user_path, &json);
  }
}

String firebaseReadUser()
{
  Firebase.ready(); // should be called repeatedly to handle authentication tasks.
  FirebaseJsonData result;
  FirebaseJson json_2;
  if(Firebase.RTDB.getJSON(&fbdo, "/current_user", &json_2))
  {
    String data = json_2.raw();
    JsonDocument doc;
    deserializeJson(doc,data);
    String user = doc["currentUser"].as<String>();
    return user;
  }
  return "fake";
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

  Firebase.ready(); // should be called repeatedly to handle authentication tasks.

  String user_path = user + "/speed_game";
  FirebaseJson json;
  json.add("/last", update);
  Firebase.RTDB.setJSON(&fbdo, user_path, &json);
  if(update)
  {
    String user_path = user + "/speed_game";

    FirebaseJsonData result;
    FirebaseJson json_2;
    if(Firebase.RTDB.getJSON(&fbdo, user_path, &json_2))
    {
      String data = json_2.raw();
      JsonDocument doc;
      deserializeJson(doc,data);
      int prev_level = doc["fast"].as<int>();
      FirebaseJson json;
      json.add("fast", ++prev_level);
      Firebase.RTDB.setJSON(&fbdo, user_path, &json);
    }
  }
  else
  {
    String user_path = user + "/speed_game";
    FirebaseJsonData result;
    FirebaseJson json_2;
    if(Firebase.RTDB.getJSON(&fbdo, user_path, &json_2))
    {
      String data = json_2.raw();
      JsonDocument doc;
      deserializeJson(doc,data);
      int prev_level = doc["slow"].as<int>();
      FirebaseJson json;
      json.add("slow", ++prev_level);
      Firebase.RTDB.setJSON(&fbdo, user_path, &json);
    }

  }
}