#include "HX711.h"
#include <ESP8266WiFi.h>
#include <FirebaseESP8266.h>
#include <addons/TokenHelper.h>
#include <addons/RTDBHelper.h>

#define WIFI_SSID "Wifi-SSID"
#define WIFI_PASSWORD "Wifi-Password"

#define DOUT  D5
#define CLK  D6

#define API_KEY "Web-Api-key"
#define DATABASE_URL "https://link.firebaseio.com/"

#define USER_EMAIL "auth@gmail.com"
#define USER_PASSWORD "password"

//Define Firebase Data object
FirebaseData fbdo;
FirebaseAuth auth;
FirebaseConfig config;

unsigned long prevMillis = 0;

HX711 scale(DOUT, CLK);

float calibration_factor = 127679;

void setup() {
  Serial.begin(9600);
  scale.set_scale();
  scale.tare(); //Reset the scale to 0

  WiFi.begin(WIFI_SSID, WIFI_PASSWORD);
  while (WiFi.status() != WL_CONNECTED)
  {
    delay(300);
  }

  config.api_key = API_KEY;
  auth.user.email = USER_EMAIL;
  auth.user.password = USER_PASSWORD;

  config.database_url = DATABASE_URL;
  config.token_status_callback = tokenStatusCallback;

  Firebase.begin(&config, &auth);
  Firebase.reconnectWiFi(true);
  Firebase.setDoubleDigits(5);
}

void loop() {
  scale.set_scale(calibration_factor);
  Serial.println(scale.get_units() * 5, 2);
  delay(20000);

  if (Firebase.ready() && (millis() - prevMillis > 10000 || prevMillis == 0))
  {
    prevMillis = millis();
    double jVal = scale.get_units(2) * 5;
    if (jVal >= 15.30 && jVal <= 18.80) {
      Serial.printf("Set- %s\n", Firebase.setInt(fbdo, F("/jJUkyxRN6yEce35v/Weight/"), jVal) ? "Done" : fbdo.errorReason().c_str());
    } else {
      Serial.printf("Set- %s\n", Firebase.setInt(fbdo, F("/jJUkyxRN6yEce35v/Weight/"), 15.3) ? "Done" : fbdo.errorReason().c_str());
    }
  }

}
