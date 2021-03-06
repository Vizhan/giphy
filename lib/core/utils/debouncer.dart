import 'dart:async';

import 'package:flutter/foundation.dart';

class Debouncer {
  Debouncer({
    Duration delay = const Duration(milliseconds: 1000),
  }) : _delay = delay;

  final Duration _delay;
  Timer _timer;

  void call(VoidCallback action) {
    _timer?.cancel();
    _timer = Timer(_delay, action);
  }

  void cancel() {
    _timer?.cancel();
  }
}
