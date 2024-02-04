#ifndef MP3_H_OUR
#define MP3_H_OUR
#include <HardwareSerial.h>
#include <Arduino.h>

// GPIO17 ------------------------ MP3 TX
// GPIO16 ------------------------ MP3 RX
static byte start_byte = 0x7E;  // Start byte
static byte end_byte = 0xEF;    // End byte

static byte set_volume_CMD = 0x31;
static byte play_index_CMD = 0x41;
static byte play_filename_CMD = 0x42;
static char select_SD_CMD[] = { 0x7e, 0x03, 0X35, 0x01, 0xef };
static char reset_CMD[] = { 0x7e, 0x03, 0X35, 0x05, 0xef };

void mp3_setup();
bool reset_mp3();
void select_SD_card();
void set_volume(byte volume);
void play_filename(int8_t directory, int8_t file);


#endif