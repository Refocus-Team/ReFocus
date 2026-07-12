import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SocialApp {
  final String name;
  final String logo;
  String timeLimit;
  int progress;
  bool checked;

  SocialApp({
    required this.name,
    required this.logo,
    required this.timeLimit,
    required this.progress,
    this.checked = false,
  });

  SocialApp copyWith({
    String? name,
    String? logo,
    String? timeLimit,
    int? progress,
    bool? checked,
  }) {
    return SocialApp(
      name: name ?? this.name,
      logo: logo ?? this.logo,
      timeLimit: timeLimit ?? this.timeLimit,
      progress: progress ?? this.progress,
      checked: checked ?? this.checked,
    );
  }
}

class FocusNotification {
  final String id;
  final String title;
  final String description;
  final String time;
  bool isRead;

  FocusNotification({
    required this.id,
    required this.title,
    required this.description,
    required this.time,
    this.isRead = false,
  });
}

class FocusHistoryLog {
  final String id;
  final String title;
  final String time;
  final String detail;

  FocusHistoryLog({
    required this.id,
    required this.title,
    required this.time,
    required this.detail,
  });
}

class AppState extends ChangeNotifier {
  List<SocialApp> _selectedApps = [
    SocialApp(name: "Instagram", logo: "instagram.png", timeLimit: "1h 42m", progress: 90, checked: true),
    SocialApp(name: "TikTok", logo: "tiktok.png", timeLimit: "30m", progress: 70, checked: true),
    SocialApp(name: "YouTube", logo: "youtube.png", timeLimit: "45m", progress: 85, checked: true),
    SocialApp(name: "Facebook", logo: "facebook.png", timeLimit: "20m", progress: 95, checked: true),
    SocialApp(name: "WhatsApp", logo: "whatsapp.png", timeLimit: "0m", progress: 0, checked: false),
    SocialApp(name: "Shopee", logo: "shopee.png", timeLimit: "0m", progress: 0, checked: false),
  ];

  String _userName = "Dio";
  int _points = 240;
  bool _deepWorkMode = false;
  String? _profileImagePath;
  ThemeMode _themeMode = ThemeMode.light;

  AppState() {
    _loadThemeMode();
    _loadSavedAppData();
  }

  void _loadThemeMode() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final themeStr = prefs.getString('theme_mode') ?? 'light';
      _themeMode = themeStr == 'dark' ? ThemeMode.dark : ThemeMode.light;
      notifyListeners();
    } catch (_) {}
  }

  void _loadSavedAppData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      for (int i = 0; i < _selectedApps.length; i++) {
        final appName = _selectedApps[i].name;
        final isChecked = prefs.getBool('app_checked_$appName');
        if (isChecked != null) {
          _selectedApps[i].checked = isChecked;
        }
        final limit = prefs.getString('app_limit_$appName');
        if (limit != null) {
          _selectedApps[i].timeLimit = limit;
        }
      }
      notifyListeners();
    } catch (_) {}
  }

  final List<FocusNotification> _notifications = [
    FocusNotification(
      id: "1",
      title: "TikTok Limit Warning",
      description: "Anda mendekati batas waktu TikTok harian Anda. Tinggal 5 menit lagi!",
      time: "10 menit yang lalu",
    ),
    FocusNotification(
      id: "2",
      title: "Tantangan Harian Selesai",
      description: "Selamat! Anda menyelesaikan Memory Match dan mendapatkan 10 poin.",
      time: "2 jam yang lalu",
    ),
    FocusNotification(
      id: "3",
      title: "Focus Streak Dipertahankan",
      description: "Kerja bagus! Anda telah mencapai 7 hari beruntun tetap fokus.",
      time: "Kemarin",
    ),
  ];

  final List<FocusHistoryLog> _focusHistory = [
    FocusHistoryLog(
      id: "1",
      title: "Menyelesaikan Memory Match",
      time: "Hari ini",
      detail: "+10 Poin",
    ),
    FocusHistoryLog(
      id: "2",
      title: "Bonus Login Harian",
      time: "Kemarin",
      detail: "+5 Poin",
    ),
    FocusHistoryLog(
      id: "3",
      title: "Streak Fokus Dipertahankan",
      time: "2 hari lalu",
      detail: "+15 Poin",
    ),
    FocusHistoryLog(
      id: "4",
      title: "Tantangan Selesai",
      time: "3 hari lalu",
      detail: "+20 Poin",
    ),
    FocusHistoryLog(
      id: "5",
      title: "Bonus Mingguan",
      time: "4 hari lalu",
      detail: "+25 Poin",
    ),
  ];

  List<SocialApp> get selectedApps => _selectedApps;
  List<SocialApp> get activeApps => _selectedApps.where((app) => app.checked).toList();
  String get userName => _userName;
  int get points => _points;
  bool get deepWorkMode => _deepWorkMode;
  List<FocusNotification> get notifications => _notifications;
  int get unreadNotificationsCount => _notifications.where((n) => !n.isRead).length;
  List<FocusHistoryLog> get focusHistory => _focusHistory;
  String? get profileImagePath => _profileImagePath;
  ThemeMode get themeMode => _themeMode;

  void toggleAppSelection(int index) async {
    _selectedApps[index].checked = !_selectedApps[index].checked;
    notifyListeners();
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('app_checked_${_selectedApps[index].name}', _selectedApps[index].checked);
    } catch (_) {}
  }

  void updateAppLimit(String name, String newLimit) async {
    final idx = _selectedApps.indexWhere((app) => app.name == name);
    if (idx != -1) {
      _selectedApps[idx].timeLimit = newLimit;
      notifyListeners();
      try {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('app_limit_$name', newLimit);
      } catch (_) {}
    }
  }

  void addPoints(int amount) {
    _points += amount;
    notifyListeners();
  }

  void updateUserName(String name) async {
    _userName = name;
    notifyListeners();
    try {
      final prefs = await SharedPreferences.getInstance();
      _profileImagePath = prefs.getString('profile_image_$name');
      notifyListeners();
    } catch (_) {}
  }

  void updateProfileImagePath(String? path) async {
    _profileImagePath = path;
    notifyListeners();
    try {
      final prefs = await SharedPreferences.getInstance();
      if (path != null) {
        await prefs.setString('profile_image_$_userName', path);
      } else {
        await prefs.remove('profile_image_$_userName');
      }
    } catch (_) {}
  }

  bool withdrawPoints(int amount) {
    if (_points >= amount) {
      _points -= amount;
      notifyListeners();
      return true;
    }
    return false;
  }

  void toggleDeepWorkMode(bool value) {
    _deepWorkMode = value;
    notifyListeners();
  }

  void markNotificationsAsRead() {
    for (var n in _notifications) {
      n.isRead = true;
    }
    notifyListeners();
  }

  void addNotification(String title, String description) {
    _notifications.insert(
      0,
      FocusNotification(
        id: DateTime.now().toString(),
        title: title,
        description: description,
        time: "Baru saja",
      ),
    );
    notifyListeners();
  }

  void clearNotifications() {
    _notifications.clear();
    notifyListeners();
  }

  void addFocusHistory(String title, String detail) {
    _focusHistory.insert(
      0,
      FocusHistoryLog(
        id: DateTime.now().toString(),
        title: title,
        time: "Hari ini",
        detail: detail,
      ),
    );
    notifyListeners();
  }

  void toggleThemeMode() async {
    _themeMode = _themeMode == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    notifyListeners();
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('theme_mode', _themeMode == ThemeMode.dark ? 'dark' : 'light');
    } catch (_) {}
  }
}

class AppStateProvider extends InheritedNotifier<AppState> {
  const AppStateProvider({
    super.key,
    required super.notifier,
    required super.child,
  });

  static AppState of(BuildContext context) {
    final provider = context.dependOnInheritedWidgetOfExactType<AppStateProvider>();
    assert(provider != null, "No AppStateProvider found in context");
    return provider!.notifier!;
  }
}
