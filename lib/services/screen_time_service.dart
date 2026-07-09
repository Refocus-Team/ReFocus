import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

class ScreenTimeService {
  static final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
  
  static const MethodChannel _methodChannel = MethodChannel('com.example.refocus/method');
  static const EventChannel _eventChannel = EventChannel('com.example.refocus/event');

  /// Memeriksa apakah akses izin penggunaan statistik (Usage Access) sudah diberikan.
  /// Jika belum, Android native akan otomatis membukakan halaman Settings terkait.
  static Future<bool> checkUsagePermission() async {
    try {
      final bool granted = await _methodChannel.invokeMethod('checkUsagePermission');
      return granted;
    } on PlatformException catch (e) {
      print("ScreenTimeService checkUsagePermission error: ${e.message}");
      return false;
    }
  }

  /// Memeriksa apakah akses izin Overlay (Display over other apps) sudah diberikan.
  /// Jika belum, Android native akan otomatis membukakan halaman Settings terkait.
  static Future<bool> checkOverlayPermission() async {
    try {
      final bool granted = await _methodChannel.invokeMethod('checkOverlayPermission');
      return granted;
    } on PlatformException catch (e) {
      print("ScreenTimeService checkOverlayPermission error: ${e.message}");
      return false;
    }
  }

  /// Memulai pemantauan background monitor untuk daftar package media sosial tertentu.
  static Future<bool> startMonitoring(List<String> packages, int timeLimitInMinutes) async {
    try {
      final bool success = await _methodChannel.invokeMethod('startMonitoring', {
        'packages': packages,
        'timeLimitInMinutes': timeLimitInMinutes,
      });
      return success;
    } on PlatformException catch (e) {
      print("ScreenTimeService startMonitoring error: ${e.message}");
      return false;
    }
  }

  /// Mulai mendengarkan EventChannel untuk mendeteksi kapan batas waktu limit tercapai.
  /// Jika diterima event, aplikasi akan langsung dialihkan secara paksa ke LimitReachedScreen.
  static void initialize() {
    _eventChannel.receiveBroadcastStream().listen((dynamic event) {
      if (event != null) {
        print("ScreenTimeService: limit reached event received for package: $event");
        navigatorKey.currentState?.pushNamedAndRemoveUntil(
          '/limit-reached',
          (route) => false,
        );
      }
    }, onError: (dynamic error) {
      print("ScreenTimeService EventChannel error: $error");
    });
  }
}
