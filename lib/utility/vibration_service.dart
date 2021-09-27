import 'package:flutter_vibrate/flutter_vibrate.dart';

class VibrationService {
  VibrationService._internal();

  static Future<void> simpleVibration() async {
    bool canVibrate = await Vibrate.canVibrate;

    if (!canVibrate) {
      return;
    }

    Vibrate.vibrateWithPauses([
      const Duration(milliseconds: 200),
      const Duration(milliseconds: 200),
    ]);
  }
}
