import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

class ScreenTimeService {
  static final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
  
  static const MethodChannel _methodChannel = MethodChannel('com.example.refocus/method');
  static const EventChannel _eventChannel = EventChannel('com.example.refocus/event');
  static const EventChannel _usageStatsChannel = EventChannel('com.example.refocus/usage_stats');

  static Future<bool> checkUsagePermission() async {
    try {
      final bool granted = await _methodChannel.invokeMethod('checkUsagePermission');
      return granted;
    } on PlatformException catch (e) {
      debugPrint("ScreenTimeService checkUsagePermission error: ${e.message}");
      return false;
    }
  }

  static Future<bool> checkOverlayPermission() async {
    try {
      final bool granted = await _methodChannel.invokeMethod('checkOverlayPermission');
      return granted;
    } on PlatformException catch (e) {
      debugPrint("ScreenTimeService checkOverlayPermission error: ${e.message}");
      return false;
    }
  }

  static bool _isMonitoring = false;

  static bool get isMonitoring => _isMonitoring;

  static Future<bool> startMonitoring(List<String> packages, Map<String, int> timeLimits) async {
    try {
      final bool success = await _methodChannel.invokeMethod('startMonitoring', {
        'packages': packages,
        'timeLimits': timeLimits,
      });
      if (success) _isMonitoring = true;
      return success;
    } on PlatformException catch (e) {
      debugPrint("ScreenTimeService startMonitoring error: ${e.message}");
      return false;
    }
  }

  static Future<void> stopMonitoring() async {
    try {
      await _methodChannel.invokeMethod('stopMonitoring');
      _isMonitoring = false;
    } on PlatformException catch (e) {
      debugPrint("ScreenTimeService stopMonitoring error: ${e.message}");
    }
  }

  static Future<Map<String, dynamic>?> getUsageStats() async {
    try {
      final result = await _methodChannel.invokeMethod('getUsageStats');
      if (result is Map) {
        return result.cast<String, dynamic>();
      }
      return null;
    } on PlatformException catch (e) {
      debugPrint("ScreenTimeService getUsageStats error: ${e.message}");
      return null;
    }
  }

  static void initialize() {
    _eventChannel.receiveBroadcastStream().listen((dynamic event) {
      if (event != null) {
        debugPrint("ScreenTimeService: limit reached event received for package: $event");
        navigatorKey.currentState?.pushNamedAndRemoveUntil(
          '/limit-reached',
          (route) => false,
          arguments: event,
        );
      }
    }, onError: (dynamic error) {
      debugPrint("ScreenTimeService EventChannel error: $error");
    });
  }

  static void listenUsageStats(void Function(Map<String, int> stats) callback) {
    _usageStatsChannel.receiveBroadcastStream().listen((dynamic event) {
      if (event is Map) {
        final stats = event.cast<String, int>();
        callback(stats);
      }
    }, onError: (dynamic error) {
      debugPrint("ScreenTimeService UsageStats channel error: $error");
    });
  }
}
