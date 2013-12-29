#include "FastSPI_LED2.h"

#define INITIAL_BRIGHTNESS 10
#define NUM_LEDS 168

#define CMD_SHOW    0x01
#define CMD_CLEAR   0x02
#define CMD_SET     0x03
#define CMD_FILL    0x04

CRGB leds[NUM_LEDS];
CRGB rgb;
byte cmd;
byte ledIndex; 

void setup() {
  delay(200);
   
  LEDS.setBrightness(INITIAL_BRIGHTNESS);
  LEDS.addLeds<WS2811, 13, GRB>(leds, NUM_LEDS);
  LEDS.show();
  
  Serial.begin(115200);
  
  establishContact();
  
  Serial.println("hai");
}

void loop() {
  cmd = readByte();  
  switch(cmd) {
    case CMD_SHOW:
      Serial.println("received CMD_SHOW");
      LEDS.show();
      break;
    case CMD_CLEAR:
      Serial.println("received CMD_CLEAR");
      memset(leds, 0,  NUM_LEDS * sizeof(struct CRGB));
      break;
    case CMD_FILL:
      Serial.println("received CMD_FILL");
      readRgb(&rgb);
      for(int i = 0; i < NUM_LEDS; i++) {
        leds[i].r = rgb.r;
        leds[i].g = rgb.g;
        leds[i].b = rgb.b;
      }
      break;
    case CMD_SET:
      Serial.println("received CMD_SET");
      ledIndex = readByte();
      Serial.print("idx: ");
      Serial.println(ledIndex);
      
      if(ledIndex < 0 && ledIndex >= NUM_LEDS) {
        Serial.println("WARNING: led index out of range. Canceling CMD_SET.");
        break;
      }
      
      readRgb(&rgb);
      leds[ledIndex].r = rgb.r;
      leds[ledIndex].g = rgb.g;
      leds[ledIndex].b = rgb.b;
      break;  
    default:
      Serial.print("WARNING: received unkown command ");
      Serial.println(cmd);
      break;
  }
}

void readRgb(CRGB* rgb) {
  rgb->r = readByte();
  Serial.print("R: ");
  Serial.println(rgb->r, HEX);
  
  rgb->g = readByte();
  Serial.print("G: ");
  Serial.println(rgb->g, HEX);     
  
  rgb->b = readByte();
  Serial.print("B: ");
  Serial.println(rgb->b, HEX);
}

byte readByte() {
  byte byteRead;
//  Serial.write("waiting for input\n");
  while(!Serial.available()) {  }
  byteRead = Serial.read();
  return byteRead;
}

void establishContact() {
  while (Serial.available() <= 0) {
    Serial.print('A');
    delay(300);
  }
}
