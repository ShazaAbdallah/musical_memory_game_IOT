#include "mp3.h"
#include <HardwareSerial.h>
#include <Arduino.h>

HardwareSerial MP3(2);  // Use UART2 for MP3 player communication
void mp3_setup()
{
    // Initiate the serial monitor.
    Serial.begin(9600);
    // Initiate the Serial MP3 Player Module.
    MP3.begin(9600, SERIAL_8N1, 17, 16);
    delay(100);  //delay for stability
    if (reset_mp3() == true) 
    {
        Serial.println("reset MP3 success");
    } 
    else 
    {
        Serial.println("reset MP3 fail");
        delay(10000);
    }
    select_SD_card();  //ALWAYS select SD card at beginning
    delay(1200);  
}
bool reset_mp3() {
  Serial.println("MP3 RESET");
  MP3.flush();  //delete all data in serial2 buffer for MP3
  int len = 5;
  for (int i = 0; i < len; i++) {
    MP3.write(reset_CMD[i]);
  }
  delay(50);              //give the mp3 player time to reset and return message
  if (MP3.available()) {  //check if there is a response from the board (not reading the response itself)
    return true;
  } else {
    return false;
  }
}

void select_SD_card() {
  Serial.println("MP3_select_SD_card");
  int len = 4;
  for (int i = 0; i <= len; i++) {
    MP3.write(select_SD_CMD[i]);
  }
}

void set_volume(byte volume) {
  Serial.print("set volume= ");
  Serial.print(volume);
  Serial.println(" of 30");
  MP3.write(start_byte);
  byte msg_len = 0x03;
  MP3.write(msg_len);
  MP3.write(set_volume_CMD);
  MP3.write(volume);
  MP3.write(end_byte);
  delay(20);  //required for stability
}

void play_filename(int8_t directory, int8_t file) {
  Serial.print("playing directory ");
  Serial.print(directory);
  Serial.print(" file number ");
  Serial.println(file);
  MP3.write(start_byte);
  byte msg_len = 0x04;
  MP3.write(msg_len);
  MP3.write(play_filename_CMD);
  byte dir_ind = directory;
  MP3.write(dir_ind);
  byte file_ind = file;
  MP3.write(file_ind);
  MP3.write(end_byte);
  mp3_read();
  delay(20);  //required for stability
}

void mp3_read()
{
    if (MP3.available()) {
    Serial.println("Received data from MP3 player:");
    
    while (MP3.available()) {
      char receivedByte = MP3.read();

      // Print each byte in hexadecimal format
      Serial.print("0x");
      if (receivedByte < 0x10) {
        Serial.print("0"); // Print leading zero for single digit
      }
      Serial.print(receivedByte, HEX);
      Serial.print(" ");
    }
    Serial.println(); // Print a newline after printing the buffer
  }

  // Other loop tasks

}