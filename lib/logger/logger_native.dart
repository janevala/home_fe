import 'dart:io';

import 'package:logger/logger.dart';

final prettyPrinter = PrettyPrinter(
  methodCount: 0,
  lineLength: stdout.hasTerminal ? stdout.terminalColumns : 120,
  colors: stdout.supportsAnsiEscapes,
);
