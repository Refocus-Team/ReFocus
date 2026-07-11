import 'dart:async';
import 'package:flutter/foundation.dart';
import '../models/app_state.dart';
import 'usage_repository.dart';
import 'screen_time_service.dart';

class RealtimeService {
  Timer? _timer;
  final AppState _state;
  bool _isRunning = false;

  RealtimeService(this._state);

  void start() {
    if (_isRunning) return;
    _isRunning = true;

    _fetchAndUpdate();

    _timer = Timer.periodic(const Duration(seconds: 5), (_) {
      _fetchAndUpdate();
    });

    ScreenTimeService.listenUsageStats((stats) {
      final converted = <String, int>{};
      for (final entry in stats.entries) {
        final appName = UsageRepository.packageToAppName(entry.key);
        converted[appName] = entry.value;
      }
      _state.updateFromUsageStats(converted);
    });
  }

  void stop() {
    _isRunning = false;
    _timer?.cancel();
    _timer = null;
  }

  Future<void> _fetchAndUpdate() async {
    try {
      final stats = await UsageRepository.instance.fetchUsageStats();
      _state.updateFromUsageStats(stats);
    } catch (e) {
      debugPrint("RealtimeService fetch error: $e");
    }
  }

  void dispose() {
    stop();
  }
}
