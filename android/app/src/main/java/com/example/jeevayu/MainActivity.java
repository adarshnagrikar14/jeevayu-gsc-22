package com.example.jeevayu;

import android.content.Context;
import android.content.Intent;
import android.net.Uri;
import android.net.wifi.WifiConfiguration;
import android.net.wifi.WifiManager;
import android.os.Build;
import android.provider.Settings;
import android.util.Log;

import androidx.annotation.NonNull;

import java.lang.reflect.Method;

import io.flutter.embedding.android.FlutterActivity;
import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.plugin.common.BinaryMessenger;
import io.flutter.plugin.common.MethodChannel;

public class MainActivity extends FlutterActivity {

    static final String CHANNEL = "com.project/battery";

    @Override
    public void configureFlutterEngine(@NonNull FlutterEngine flutterEngine) {
        super.configureFlutterEngine(flutterEngine);

        BinaryMessenger messenger = flutterEngine.getDartExecutor().getBinaryMessenger();
        MethodChannel channel = new MethodChannel(messenger, CHANNEL);

        channel.setMethodCallHandler(((call, result) -> {
            if (call.method.equals("getBatteryLevel")) {
                if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
                    if (!Settings.System.canWrite(getApplicationContext())) {
                        Intent intent = new Intent(Settings.ACTION_MANAGE_WRITE_SETTINGS, Uri.parse("package:" + getPackageName()));
                        startActivityForResult(intent, 200);

                    } else {
                        // setPass(getContext());
                        String pass = getPass(getContext());
                        result.success(pass);
                    }
                }

            } else {
                result.notImplemented();
            }
        }));

    }

    private String getPass(Context context) {

        String level;
        try {

            assert context != null;
            WifiManager wifiManager = (WifiManager) context.getApplicationContext().getSystemService(Context.WIFI_SERVICE);
            Method getConfigMethod = wifiManager.getClass().getMethod("getWifiApConfiguration");
            WifiConfiguration wifiConfiguration = (WifiConfiguration) getConfigMethod.invoke(wifiManager);
            assert wifiConfiguration != null;

            // level = wifiConfiguration.SSID;
            level = wifiConfiguration.preSharedKey;
            return level;

        } catch (Exception e) {
            Log.e("TAG", "onCreate: ", e);
            return null;

        }

    }
}
