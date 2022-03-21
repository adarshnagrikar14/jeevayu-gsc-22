package com.example.jeevayu;

import android.content.Intent;
import android.content.SharedPreferences;
import android.net.Uri;
import android.provider.Settings;

import androidx.annotation.NonNull;

import java.util.Map;

import io.flutter.embedding.android.FlutterActivity;
import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.plugin.common.BinaryMessenger;
import io.flutter.plugin.common.MethodChannel;

public class MainActivity extends FlutterActivity {

    static final String CHANNEL1 = "com.project/deviceState";
    static final String CHANNEL2 = "com.project/notificationControl";
    static final String CHANNEL3 = "com.project/DeviceID";
    static final String CHANNEL4 = "com.project/ConnectionDate";
    static final String CHANNEL5 = "com.project/CylinderQuantity";

    @Override
    public void configureFlutterEngine(@NonNull FlutterEngine flutterEngine) {
        super.configureFlutterEngine(flutterEngine);

        BinaryMessenger messenger = flutterEngine.getDartExecutor().getBinaryMessenger();
        MethodChannel channel1 = new MethodChannel(messenger, CHANNEL1);
        MethodChannel channel2 = new MethodChannel(messenger, CHANNEL2);
        MethodChannel channel3 = new MethodChannel(messenger, CHANNEL3);
        MethodChannel channel4 = new MethodChannel(messenger, CHANNEL4);
        MethodChannel channel5 = new MethodChannel(messenger, CHANNEL5);

        // pref method
        channel1.setMethodCallHandler(((call, result) -> {
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

        // notification setting method
        channel2.setMethodCallHandler((call, result) -> {
            if (call.method.equals("openNotification")) {
                Intent intent;
                if (android.os.Build.VERSION.SDK_INT >= android.os.Build.VERSION_CODES.O) {
                    intent = new Intent(Settings.ACTION_APP_NOTIFICATION_SETTINGS)
                            .addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
                            .putExtra(Settings.EXTRA_APP_PACKAGE, getPackageName());

                } else {
                    intent = new Intent(Settings.ACTION_APPLICATION_DETAILS_SETTINGS);
                    intent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK);

                    Uri uri = Uri.fromParts("package", getPackageName(), null);
                    intent.setData(uri);
                }
                startActivity(intent);

            }
        });

        // Device ID method (read ,update)
        channel3.setMethodCallHandler((call, result) -> {
            if (call.method.equals("setDeviceID")) {

                final Map<String, Object> arguments = call.arguments();

                String devID = (String) arguments.get("data");

                SharedPreferences sharedPreferences = getSharedPreferences("DeviceID", MODE_PRIVATE);
                SharedPreferences.Editor myEdit = sharedPreferences.edit();
                myEdit.putString("ID", devID);
                myEdit.apply();
                result.success("Done");

            } else if (call.method.equals("getDeviceID")) {
                SharedPreferences sharedPreferences = getSharedPreferences("DeviceID", MODE_PRIVATE);
                String ID = sharedPreferences.getString("ID", "");
                result.success(ID);
            }
        });

        // Connection Date method (read ,update)
        channel4.setMethodCallHandler((call, result) -> {
            if (call.method.equals("setConnectionDate")) {

                final Map<String, Object> arguments = call.arguments();

                String conDate = (String) arguments.get("date");

                SharedPreferences sharedPreferences = getSharedPreferences("ConnectionDate", MODE_PRIVATE);
                SharedPreferences.Editor myEdit = sharedPreferences.edit();
                myEdit.putString("Date", conDate);
                myEdit.apply();
                result.success("Done");

            } else if (call.method.equals("getConnectionDate")) {
                SharedPreferences sharedPreferences = getSharedPreferences("ConnectionDate", MODE_PRIVATE);
                String Date = sharedPreferences.getString("Date", "");
                result.success(Date);
            }
        });

        // Connection Date method (read ,update)
        channel5.setMethodCallHandler((call, result) -> {
            if (call.method.equals("setQuantity")) {

                final Map<String, Object> arguments = call.arguments();

                String conDate = (String) arguments.get("quantity");

                SharedPreferences sharedPreferences = getSharedPreferences("CylinderQ", MODE_PRIVATE);
                SharedPreferences.Editor myEdit = sharedPreferences.edit();
                myEdit.putString("Quantity", conDate);
                myEdit.apply();
                result.success("Done");

            } else if (call.method.equals("getQuantity")) {
                SharedPreferences sharedPreferences = getSharedPreferences("CylinderQ", MODE_PRIVATE);
                String quantity = sharedPreferences.getString("Quantity", "");
                result.success(quantity);
            }
        });

    }

}
