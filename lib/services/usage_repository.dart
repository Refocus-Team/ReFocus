import 'dart:async';
import 'screen_time_service.dart';

class UsageRepository {
  static final UsageRepository _instance = UsageRepository._();
  static UsageRepository get instance => _instance;
  UsageRepository._();

  static const Map<String, String> packageToApp = {
    'com.instagram.android': 'Instagram',
    'com.zhiliaoapp.musically': 'TikTok',
    'com.google.android.youtube': 'YouTube',
    'com.facebook.katana': 'Facebook',
    'com.whatsapp': 'WhatsApp',
    'com.shopee.id': 'Shopee',
    'com.twitter.android': 'X',
    'com.linkedin.android': 'LinkedIn',
    'com.spotify.music': 'Spotify',
    'com.snapchat.android': 'Snapchat',
    'com.roblox.client': 'Roblox',
    'com.mobile.legends': 'Mobile Legends',
    'com.tencent.ig': 'PUBG Mobile',
  };

  static const Map<String, String> appToPackage = {
    'Instagram': 'com.instagram.android',
    'TikTok': 'com.zhiliaoapp.musically',
    'YouTube': 'com.google.android.youtube',
    'Facebook': 'com.facebook.katana',
    'WhatsApp': 'com.whatsapp',
    'Shopee': 'com.shopee.id',
    'X': 'com.twitter.android',
    'LinkedIn': 'com.linkedin.android',
    'Spotify': 'com.spotify.music',
    'Snapchat': 'com.snapchat.android',
    'Roblox': 'com.roblox.client',
    'Mobile Legends': 'com.mobile.legends',
    'PUBG Mobile': 'com.tencent.ig',
  };

  Map<String, int>? _cachedStats;

  Map<String, int>? get cachedStats => _cachedStats;

  static String packageToAppName(String packageName) {
    return packageToApp[packageName] ?? packageName;
  }

  static String? appNameToPackage(String appName) {
    return appToPackage[appName];
  }

  Future<Map<String, int>> fetchUsageStats() async {
    final raw = await ScreenTimeService.getUsageStats();
    if (raw == null) return {};

    final result = <String, int>{};
    for (final entry in raw.entries) {
      final appName = packageToAppName(entry.key);
      final minutes = (entry.value as num).toInt();
      result[appName] = minutes;
    }

    _cachedStats = result;
    return result;
  }

  int getUsageMinutes(String appName) {
    if (_cachedStats == null) return 0;
    return _cachedStats![appName] ?? 0;
  }

  int getTotalUsageMinutes() {
    if (_cachedStats == null) return 0;
    return _cachedStats!.values.fold(0, (sum, v) => sum + v);
  }

  String formatMinutes(int minutes) {
    if (minutes < 1) return '0m';
    final hours = minutes ~/ 60;
    final mins = minutes % 60;
    if (hours > 0) {
      return '${hours}h ${mins}m';
    }
    return '${mins}m';
  }
}
