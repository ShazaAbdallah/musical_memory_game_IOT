#define RED_PIN   14  // GPIO pin for the red color
#define GREEN_PIN 27  // GPIO pin for the green color
#define BLUE_PIN  26  // GPIO pin for the blue color

void setup() {
  pinMode(RED_PIN, OUTPUT);
  pinMode(GREEN_PIN, OUTPUT);
  pinMode(BLUE_PIN, OUTPUT);

  Serial.begin(115200);
  Serial.println("RGB LED Control");
}

void loop() {
  // Set the RGB LED to different colors
  setColor(255, 0, 0);  // Red
  delay(1000);

  setColor(0, 255, 0);  // Green
  delay(1000);

  setColor(0, 0, 255);  // Blue
  delay(1000);

  setColor(255, 255, 0);  // Yellow
  delay(1000);

  setColor(255, 0, 255);  // Magenta
  delay(1000);

  setColor(0, 255, 255);  // Cyan
  delay(1000);

  setColor(255, 255, 255);  // White
  delay(1000);
}

void setColor(int red, int green, int blue) {
  analogWrite(RED_PIN, red);
  analogWrite(GREEN_PIN, green);
  analogWrite(BLUE_PIN, blue);
}
