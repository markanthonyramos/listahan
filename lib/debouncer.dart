import 'dart:async';

import 'package:flutter/foundation.dart';

class Debouncer {
  Duration? duration;
  VoidCallback? action;
  Timer? _timer;

  Debouncer({this.duration});

  run(VoidCallback action) {
    if (_timer != null) {
      _timer!.cancel();
    }
    _timer = Timer(duration ?? const Duration(milliseconds: 300), action);
  }
}
