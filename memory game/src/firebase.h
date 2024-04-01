#ifndef FIREBASE_H
#define FIREBASE_H
#include <Arduino.h>

void firebaseSetup();
void firebaseWrite(String user, int level);
void firebaseWriteSpeed(String user, int update);
String firebaseReadUser();
#endif