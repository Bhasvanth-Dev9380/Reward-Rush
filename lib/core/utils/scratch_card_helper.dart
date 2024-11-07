// lib/core/utils/scratch_card_helper.dart

import 'package:shared_preferences/shared_preferences.dart';

class ScratchCardHelper {
  static const String _lastScratchTimeKey = 'last_scratch_time';
  static const String _isScratchAvailableKey = 'is_scratch_available';

  static Future<void> saveLastScratchTime(DateTime time) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_lastScratchTimeKey, time.millisecondsSinceEpoch);
  }

  static Future<DateTime?> getLastScratchTime() async {
    final prefs = await SharedPreferences.getInstance();
    final timestamp = prefs.getInt(_lastScratchTimeKey);
    if (timestamp != null) {
      return DateTime.fromMillisecondsSinceEpoch(timestamp);
    }
    return null;
  }

  static Future<void> setScratchAvailable(bool isAvailable) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_isScratchAvailableKey, isAvailable);
  }

  static Future<bool> isScratchAvailable() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_isScratchAvailableKey) ?? false;
  }
}
