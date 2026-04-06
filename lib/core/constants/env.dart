import 'package:flutter_dotenv/flutter_dotenv.dart';
class Env {
  static String _get(String key) {
    final value = dotenv.env[key];
    if (value == null || value.isEmpty) {
      throw Exception("Missing env variable: $key");
    }
    return value;
  }

  static String get firebaseWebApiKey => _get('FIREBASE_WEB_API_KEY');
  static String get firebaseAndroidApiKey => _get('FIREBASE_ANDROID_API_KEY');
  static String get firebaseIosApiKey => _get('FIREBASE_IOS_API_KEY');
  static String get firebaseMacosApiKey => _get('FIREBASE_MACOS_API_KEY');
  static String get firebaseWindowsApiKey => _get('FIREBASE_WINDOWS_API_KEY');
  static String get openRouterApiKey => _get('OPENROUTER_API_KEY');

}