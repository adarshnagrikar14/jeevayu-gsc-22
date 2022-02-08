import 'dart:async';

import 'package:flutter/services.dart';

class OpenSettings {
  // Static constant variable to initialize MethodChannel of 'app_settings'.
  static const MethodChannel _channel = MethodChannel('app_settings');

  /// Future async method call to open WIFI settings.
  static Future<void> openWIFISettings({
    bool asAnotherTask = false,
  }) async {
    _channel.invokeMethod('wifi', {
      'asAnotherTask': asAnotherTask,
    });
  }
}
