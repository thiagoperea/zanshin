import 'package:hive_flutter/hive_flutter.dart';

class AppPreferences {
  AppPreferences._instance();

  static Future<void> saveNightMode(bool isNightMode) async {
    final db = await Hive.openBox("settings"); //TODO: DI

    db.put(AppPreferencesKeys.isNightMode, isNightMode);
  }

  static Future<bool> isNightMode() async {
    final db = await Hive.openBox("settings"); //TODO: DI

    return db.get(AppPreferencesKeys.isNightMode, defaultValue: false);
  }

  static Future<void> saveSelectedAlarm(int selectedAlarm) async {
    final db = await Hive.openBox("settings"); //TODO: DI

    await db.put(AppPreferencesKeys.selectedAlarm, selectedAlarm);
  }

  static Future<int> getSelectedAlarm() async {
    final db = await Hive.openBox("settings"); //TODO: DI

    return db.get(AppPreferencesKeys.selectedAlarm, defaultValue: 0);
  }
}

class AppPreferencesKeys {
  AppPreferencesKeys._intance();

  static String isNightMode = "is_night_mode";
  static String selectedAlarm = "selected_alarm";
}
