#include "FastSPI_LED2.h"

#define INITIAL_BRIGHTNESS 10
#define NUM_LEDS 168
#define GRID_HEIGHT 13
#define GRID_WIDTH 13

#define CMD_SHOW  0x01
#define CMD_CLEAR  0x02
#define CMD_COLOR  0x03
#define CMD_SELECT 0x04

byte cmdRead;

CRGB leds[NUM_LEDS];

CRGB* currLed = NULL;

void setup() {
  delay(200);
   
  LEDS.setBrightness(INITIAL_BRIGHTNESS);
  LEDS.addLeds<WS2811, 13, GRB>(leds, NUM_LEDS);
  
  Serial.begin(9600);
  
  establishContact();
  
  Serial.println("hai");
}

void loop() {
  Serial.println("begin new loop");
  
  byte cmd;
  byte ledIndex;
  
  CRGB rgb;
  
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
    case CMD_COLOR:
      Serial.println("received CMD_COLOR");
      rgb.r = readByte();
      rgb.g = readByte();
      rgb.b = readByte();
      
      if(currLed == NULL) {
        for(int i = 0; i < NUM_LEDS; i++) {
          leds[i].r = rgb.r;
          leds[i].g = rgb.g;
          leds[i].b = rgb.b;
        }
      }
      else {
        currLed->r = rgb.r;
        currLed->g = rgb.g;
        currLed->b = rgb.b;
      }
      break;
    case CMD_SELECT:
      Serial.println("received CMD_SELECT");
      ledIndex = readByte();
      if(ledIndex >= 0 && ledIndex < NUM_LEDS) {
        currLed = &leds[ledIndex];
      }
      else {
        currLed = NULL;
      }
      break;
    default:
      Serial.print("received unkown command ");
      Serial.println(cmd);
      break;
  }
}

byte readByte() {
  byte byteRead;
  Serial.write("waiting for input\n");
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
