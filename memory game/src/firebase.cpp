#include "firebase.h"
#include <ESP32Firebase.h>
#include <Arduino.h>
#define _SSID "shaza"          // Your WiFi SSID
#define _PASSWORD "12345678"      // Your WiFi Password
#define REFERENCE_URL "https://simon-game-4d363-default-rtdb.firebaseio.com/"  // Your Firebase project reference url

Firebase firebase(REFERENCE_URL);


void firebaseSetup()
{
    Serial.begin(9600);
  // pinMode(LED_BUILTIN, OUTPUT);
  // digitalWrite(LED_BUILTIN, LOW);
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
    String user_path = user + "/level_" + String(level);
    int gameNum = firebase.getInt(user_path);
    firebase.setInt(user_path, ++gameNum);
}

String firebaseReadUser()
{
    return firebase.getString("currentUser");
}

// //================================================================//
// //================================================================//

//   // Examples of setting String, integer and float values.
//   firebase.setString("Example/setString", "It's Working");
//   firebase.setInt("Example/setInt", 123);
//   firebase.setFloat("Example/setFloat", 45.32);

//   // Examples of pushing String, integer and float values.
//   firebase.pushString("push", "Hello");
//   firebase.pushInt("push", 789);
//   firebase.pushFloat("push", 89.54);

//   // Example of getting a String.
//   String data1 = firebase.getString("Example/setString");
//   Serial.print("Received String:\t");
//   Serial.println(data1);

//   // Example of getting an int.
//   int data2 = firebase.getInt("Example/setInt");
//   Serial.print("Received Int:\t\t");
//   Serial.println(data2);

//   // Example of getting a float.
//   float data3 = firebase.getFloat("Example/setFloat");
//   Serial.print("Received Float:\t\t");
//   Serial.println(data3);

//   // Example of data deletion.
//   firebase.deleteData("Example");
