#include "FastSPI_LED2.h"

#define INITIAL_BRIGHTNESS 10
#define NUM_LEDS 168

#define CMD_SHOW    0x01
#define CMD_CLEAR   0x02
#define CMD_SET     0x03
#define CMD_FILL    0x04
#define CMD_FRAME   0x05
#define CMD_DUMP    0x06

CRGB leds[NUM_LEDS];
CRGB rgb;
byte cmd;
byte ledIndex; 

void setup() {
  delay(200);
   
  LEDS.setBrightness(INITIAL_BRIGHTNESS);
  LEDS.addLeds<WS2811, 13, GRB>(leds, NUM_LEDS);
  LEDS.show();
  
  Serial.begin(19200);
  
  establishContact();
  
  Serial.println("hai");
}

void loop() {
  //Serial.println("new loop");
  cmd = readByte();  
  switch(cmd) {
    case CMD_SHOW:
      //Serial.println("received CMD_SHOW");
      LEDS.show();
      break;
    case CMD_CLEAR:
      //Serial.println("received CMD_CLEAR");
      memset(leds, 0, NUM_LEDS * sizeof(struct CRGB));
      
      LEDS.show();
      break;
    case CMD_FILL:
      //Serial.println("received CMD_FILL");
      readRgb(&rgb);
      for(int i = 0; i < NUM_LEDS; i++) {
        leds[i].r = rgb.r;
        leds[i].g = rgb.g;
        leds[i].b = rgb.b;
      }
      
      LEDS.show();
      break;
    case CMD_SET:
      //Serial.println("received CMD_SET");
      ledIndex = readByte();
      ledIndex--; // because the first LED is broken
      //Serial.print("idx: ");
      //Serial.println(ledIndex);
      
      if(ledIndex < 0 && ledIndex >= NUM_LEDS) {
        Serial.println("WARNING: led index out of range. Canceling CMD_SET.");
        break;
      }
      
      readRgb(&rgb);
      leds[ledIndex].r = rgb.r;
      leds[ledIndex].g = rgb.g;
      leds[ledIndex].b = rgb.b;
      
      LEDS.show();
      break;  
    case CMD_FRAME:
      //Serial.println("received CMD_FRAME");

      // ignorethe first LED because its broken
      readRgb(&rgb);
      
      for(int i = 0; i < NUM_LEDS; i++)
      {
        readRgb(&rgb);
        leds[i].r = rgb.r;
        leds[i].g = rgb.g;
        leds[i].b = rgb.b;
      }
      
      LEDS.show();
      break;
    case CMD_DUMP:
      Serial.write(sizeof(struct CRGB) * NUM_LEDS);
      for(int i = 0; i < NUM_LEDS; i++)
      {
        Serial.write(leds[i].r);
        Serial.write(leds[i].g);
        Serial.write(leds[i].b);
      }
      break;
    default:
      Serial.print("WARNING: received unkown command ");
      Serial.println(cmd);
      break;
  }
}

void readRgb(CRGB* rgb) {
  rgb->r = readByte();
  rgb->g = readByte();
  rgb->b = readByte();
}

byte readByte() {
  byte byteRead;
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
