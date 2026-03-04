import 'package:hive_flutter/hive_flutter.dart';

class HiveService {
  static const String guestBoxName = 'guest_data';
  static const String settingsBoxName = 'settings';
  static const String askAiBoxName = 'ask_ai';

  static Future<void> init() async {
    await Hive.initFlutter();
    // Register Adapters here
    await Hive.openBox(guestBoxName);
    await Hive.openBox(settingsBoxName);
    await Hive.openBox(askAiBoxName);
  }

  static Future<void> put(String boxName, String key, dynamic value) async {
    final box = Hive.box(boxName);
    await box.put(key, value);
  }

  static dynamic get(String boxName, String key, {dynamic defaultValue}) {
    final box = Hive.box(boxName);
    return box.get(key, defaultValue: defaultValue);
  }

  static Future<void> delete(String boxName, String key) async {
    final box = Hive.box(boxName);
    await box.delete(key);
  }

  static Future<void> clearBox(String boxName) async {
    final box = Hive.box(boxName);
    await box.clear();
  }
}
