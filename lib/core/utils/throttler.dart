import 'dart:async';

class Throttler {
  static final Map<String, bool> _isThrottlingMap = {};

  static void run(
    String key, {
    required Duration duration,
    required void Function() action,
  }) {
    if (_isThrottlingMap[key] == true) return;

    action();
    _isThrottlingMap[key] = true;

    Timer(duration, () => _isThrottlingMap[key] = false);
  }
}
