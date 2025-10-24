import 'package:flutter/foundation.dart';

abstract class PlatformUtils {
  static bool get isWeb => kIsWasm || kIsWeb;
}
