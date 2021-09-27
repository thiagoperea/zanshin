import 'dart:io';

import 'package:flutter/foundation.dart';

class PlatformHelper {
  static bool isWeb() => kIsWeb;

  static bool isDesktop() => Platform.isWindows || Platform.isLinux;
}
