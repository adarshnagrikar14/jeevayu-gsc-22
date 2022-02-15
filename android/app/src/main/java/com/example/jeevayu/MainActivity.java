package com.example.jeevayu;

import android.content.SharedPreferences;

import androidx.annotation.NonNull;

import io.flutter.embedding.android.FlutterActivity;
import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.plugin.common.BinaryMessenger;
import io.flutter.plugin.common.MethodChannel;

public class MainActivity extends FlutterActivity {

    static final String CHANNEL1 = "com.project/deviceState";

    @Override
    public void configureFlutterEngine(@NonNull FlutterEngine flutterEngine) {
        super.configureFlutterEngine(flutterEngine);

        BinaryMessenger messenger = flutterEngine.getDartExecutor().getBinaryMessenger();
        MethodChannel channel = new MethodChannel(messenger, CHANNEL1);

        channel.setMethodCallHandler(((call, result) -> {
            switch (call.method) {
                case "setPreferenceYes": {

                    SharedPreferences sharedPreferences = getSharedPreferences("DeviceState", MODE_PRIVATE);
                    SharedPreferences.Editor myEdit = sharedPreferences.edit();
                    myEdit.putString("connected", "yes");
                    myEdit.apply();
                    result.success("Done");

                    break;
                }
                case "setPreferenceNo": {

                    SharedPreferences sharedPreferences = getSharedPreferences("DeviceState", MODE_PRIVATE);
                    SharedPreferences.Editor myEdit = sharedPreferences.edit();
                    myEdit.putString("connected", "no");
                    myEdit.apply();
                    result.success("Done");

                    break;
                }
                case "getPreference":

                    SharedPreferences sharedPreferences = getSharedPreferences("DeviceState", MODE_PRIVATE);
                    String state = sharedPreferences.getString("connected", "");
                    result.success(state);

                    break;
                default:
                    result.notImplemented();
                    break;
            }
        }));

    }

}
