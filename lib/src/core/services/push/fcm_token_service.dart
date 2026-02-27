import 'package:firebase_messaging/firebase_messaging.dart';

class FcmTokenService {
  Future<String?> getToken() async {
    await FirebaseMessaging.instance.requestPermission();
    final token = await FirebaseMessaging.instance.getToken();
    return token;
  }

  void onTokenRefresh(void Function(String token) callback) {
    FirebaseMessaging.instance.onTokenRefresh.listen(callback);
  }
}
