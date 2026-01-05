#include <Servo.h>

// Encoder Pins and Config
#define CLK_PIN 2    // Encoder Clock (Yellow)
#define DATA_PIN 3   // Encoder Data (White)
#define SSI_BITS 18
#define RESOLUTION 262144

// Servo Pin
#define SERVO_PIN 5

Servo DHS110;

void setup() {
  pinMode(4, OUTPUT);
  digitalWrite(4, LOW);

  pinMode(CLK_PIN, OUTPUT);
  pinMode(DATA_PIN, INPUT);
  digitalWrite(CLK_PIN, HIGH);  // Clock Initialization

  Serial.begin(19200);

  DHS110.attach(SERVO_PIN);
}

void loop() {
  if (Serial.available()) {
    String command = Serial.readStringUntil('\n');
    command.trim();

    // Servo command: starts with 'S', followed by microseconds, e.g. "S1500"
    if (command.startsWith("S")) {
      int servoValue = command.substring(1).toInt();
      DHS110.writeMicroseconds(servoValue);
      Serial.print("Servo command accepted: ");
      Serial.println(servoValue);
    }
    // Encoder command: "E1" or "E0"
    else if (command == "E1") {
      Serial.println("Encoder is ready!");
      digitalWrite(4, HIGH);
      delay(300);
      digitalWrite(4, LOW);
    }
    else if (command == "E0") {
      unsigned long grayCode = readSSI();
      unsigned long position = grayToBinary(grayCode);
      float angle = (float(position) / RESOLUTION) * 360.0;
      Serial.println(angle, 3);
    }
    else {
      Serial.println("Unknown command.");
    }
  }
}

// Encoder SSI read function
unsigned long readSSI() {
  unsigned long value = 0;
  for (int i = 0; i < SSI_BITS; i++) {
    digitalWrite(CLK_PIN, LOW);
    delayMicroseconds(1);
    digitalWrite(CLK_PIN, HIGH);
    delayMicroseconds(1);
    value <<= 1;
    if (digitalRead(DATA_PIN) == HIGH) {
      value |= 1;
    }
  }
  return value;
}

// Gray to binary conversion
unsigned long grayToBinary(unsigned long gray) {
  unsigned long binary = gray;
  while (gray >>= 1) {
    binary ^= gray;
  }
  return binary;
}
