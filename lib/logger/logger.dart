import 'dart:async';
import 'package:homefe/logger/list_utils.dart';
import 'package:homefe/logger/logger_native.dart'
    if (dart.library.js_interop) 'package:homefe/logger/logger_html.dart';
import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';

final loggerBuffer = _BufferOutput();

final loggerFilter = _NonProductionFilter();

final logger = Logger(
  printer: prettyPrinter,
  output: loggerBuffer,
  filter: loggerFilter,
);

class _BufferOutput extends ConsoleOutput {
  final _buffer = CircularBuffer<OutputEvent>(200);

  String get bufferString {
    return _buffer.dump().map((e) => e.lines).flattened.join('\n');
  }

  @override
  Future<void> output(OutputEvent event) async {
    if (kDebugMode) {
      super.output(event);
    }

    _buffer.add(event);
  }
}

class _NonProductionFilter extends LogFilter {
  bool? isProd;

  @override
  bool shouldLog(LogEvent event) {
    if (event.level.value < level!.value) {
      return false;
    }

    return kDebugMode || isProd == false;
  }
}
