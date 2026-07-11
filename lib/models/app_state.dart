import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../services/database_service.dart';

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

  Map<String, dynamic> toJson() => {
    'name': name,
    'logo': logo,
    'timeLimit': timeLimit,
    'progress': progress,
    'checked': checked,
  };

  factory SocialApp.fromJson(Map<String, dynamic> json) => SocialApp(
    name: json['name'] as String,
    logo: json['logo'] as String,
    timeLimit: json['timeLimit'] as String? ?? '0m',
    progress: json['progress'] as int? ?? 0,
    checked: json['checked'] as bool? ?? false,
  );
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

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'description': description,
    'time': time,
    'isRead': isRead,
  };

  factory FocusNotification.fromJson(Map<String, dynamic> json) => FocusNotification(
    id: json['id'] as String,
    title: json['title'] as String,
    description: json['description'] as String,
    time: json['time'] as String,
    isRead: json['isRead'] as bool? ?? false,
  );
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

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'description': detail,
    'time': time,
  };

  factory FocusHistoryLog.fromJson(Map<String, dynamic> json) => FocusHistoryLog(
    id: json['id'] as String,
    title: json['title'] as String,
    time: json['time'] as String,
    detail: json['description'] as String? ?? json['detail'] as String? ?? '',
  );
}

class AppState extends ChangeNotifier {
  List<SocialApp> _selectedApps = [
    SocialApp(name: "Instagram", logo: "instagram.png", timeLimit: "30m", progress: 0, checked: true),
    SocialApp(name: "TikTok", logo: "tiktok.png", timeLimit: "1h", progress: 0, checked: true),
    SocialApp(name: "YouTube", logo: "youtube.png", timeLimit: "1h 30min", progress: 0, checked: true),
    SocialApp(name: "Facebook", logo: "facebook.png", timeLimit: "30m", progress: 0, checked: true),
    SocialApp(name: "WhatsApp", logo: "whatsapp.png", timeLimit: "0m", progress: 0, checked: false),
    SocialApp(name: "Shopee", logo: "shopee.png", timeLimit: "0m", progress: 0, checked: false),
  ];

  String _userName = "Dio";
  int _points = 0;
  int _focusScore = 0;
  int _totalScreenTimeMinutes = 0;
  int _streakDays = 0;
  bool _deepWorkMode = false;

  List<FocusNotification> _notifications = [];
  List<FocusHistoryLog> _focusHistory = [];
  String _lastActiveDate = '';

  List<SocialApp> get selectedApps => _selectedApps;
  List<SocialApp> get activeApps => _selectedApps.where((app) => app.checked).toList();
  String get userName => _userName;
  int get points => _points;
  int get focusScore => _focusScore;
  int get totalScreenTimeMinutes => _totalScreenTimeMinutes;
  int get streakDays => _streakDays;
  bool get deepWorkMode => _deepWorkMode;
  List<FocusNotification> get notifications => _notifications;
  int get unreadNotificationsCount => _notifications.where((n) => !n.isRead).length;
  List<FocusHistoryLog> get focusHistory => _focusHistory;

  String get totalScreenTimeFormatted {
    final hours = _totalScreenTimeMinutes ~/ 60;
    final mins = _totalScreenTimeMinutes % 60;
    if (hours > 0) return '${hours}h ${mins}m';
    return '${mins}m';
  }

  Future<void> loadFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    _userName = prefs.getString('userName') ?? 'Dio';
    _points = prefs.getInt('points') ?? 0;
    _streakDays = prefs.getInt('streakDays') ?? 0;
    _lastActiveDate = prefs.getString('lastActiveDate') ?? '';

    final appsJson = prefs.getString('selectedApps');
    if (appsJson != null) {
      final list = jsonDecode(appsJson) as List;
      _selectedApps = list.map((e) => SocialApp.fromJson(e as Map<String, dynamic>)).toList();
    }

    final notifJson = prefs.getString('notifications');
    if (notifJson != null) {
      final list = jsonDecode(notifJson) as List;
      _notifications = list.map((e) => FocusNotification.fromJson(e as Map<String, dynamic>)).toList();
    }

    final historyJson = prefs.getString('focusHistory');
    if (historyJson != null) {
      final list = jsonDecode(historyJson) as List;
      _focusHistory = list.map((e) => FocusHistoryLog.fromJson(e as Map<String, dynamic>)).toList();
    }

    _updateStreak();
    notifyListeners();
  }

  void _updateStreak() {
    final today = DateTime.now();
    final todayStr = '${today.year}-${today.month.toString().padLeft(2, '0')}-${today.day.toString().padLeft(2, '0')}';
    if (_lastActiveDate.isEmpty) {
      _streakDays = 1;
    } else if (_lastActiveDate == todayStr) {
      return;
    } else {
      final yesterday = today.subtract(const Duration(days: 1));
      final yesterdayStr = '${yesterday.year}-${yesterday.month.toString().padLeft(2, '0')}-${yesterday.day.toString().padLeft(2, '0')}';
      if (_lastActiveDate == yesterdayStr) {
        _streakDays++;
      } else {
        _streakDays = 1;
      }
    }
    _lastActiveDate = todayStr;
    _saveToPrefs();
  }

  Future<void> _saveToPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('userName', _userName);
    await prefs.setInt('points', _points);
    await prefs.setInt('streakDays', _streakDays);
    await prefs.setString('lastActiveDate', _lastActiveDate);
    await prefs.setString('selectedApps', jsonEncode(_selectedApps.map((a) => a.toJson()).toList()));
    await prefs.setString('notifications', jsonEncode(_notifications.map((n) => n.toJson()).toList()));
    await prefs.setString('focusHistory', jsonEncode(_focusHistory.map((h) => h.toJson()).toList()));
  }

  void updateFromUsageStats(Map<String, int> usageStats) {
    int totalMinutes = 0;
    for (final app in _selectedApps) {
      final usedMinutes = usageStats[app.name] ?? 0;
      totalMinutes += usedMinutes;

      final limitMinutes = parseLimitToMinutes(app.timeLimit);
      if (limitMinutes > 0) {
        app.progress = ((usedMinutes / limitMinutes) * 100).clamp(0, 100).toInt();
      } else {
        app.progress = 0;
      }
    }
    _totalScreenTimeMinutes = totalMinutes;

    _focusScore = _calculateFocusScore();
    notifyListeners();
  }

  Future<void> saveDailyData() async {
    final today = DateTime.now();
    final dateStr = '${today.year}-${today.month.toString().padLeft(2, '0')}-${today.day.toString().padLeft(2, '0')}';
    await DatabaseService.instance.saveFocusScore(dateStr, _focusScore, _totalScreenTimeMinutes);
  }

  int _calculateFocusScore() {
    if (_selectedApps.isEmpty) return 100;
    double totalRatio = 0;
    int count = 0;
    for (final app in _selectedApps) {
      if (!app.checked) continue;
      final limitMinutes = parseLimitToMinutes(app.timeLimit);
      if (limitMinutes <= 0) continue;
      final usedMinutes = (app.progress / 100 * limitMinutes).round();
      final ratio = usedMinutes / limitMinutes;
      totalRatio += ratio;
      count++;
    }
    if (count == 0) return 100;
    final avgRatio = totalRatio / count;
    return (100 - (avgRatio * 100)).clamp(0, 100).round();
  }

  int parseLimitToMinutes(String limit) {
    if (limit.contains('h')) {
      if (limit.contains('1 h 30') || limit.contains('1h 30')) return 90;
      return 60;
    }
    final parts = limit.split(' ');
    final num = int.tryParse(parts[0]) ?? 0;
    if (limit.contains('min')) return num;
    return num;
  }

  void toggleAppSelection(int index) {
    _selectedApps[index].checked = !_selectedApps[index].checked;
    _saveToPrefs();
    notifyListeners();
  }

  void updateAppLimit(String name, String newLimit) {
    final idx = _selectedApps.indexWhere((app) => app.name == name);
    if (idx != -1) {
      _selectedApps[idx].timeLimit = newLimit;
      _saveToPrefs();
      notifyListeners();
    }
  }

  void addPoints(int amount) {
    _points += amount;
    _saveToPrefs();
    notifyListeners();
  }

  void setFocusScore(int score) {
    _focusScore = score;
    notifyListeners();
  }

  void setTotalScreenTime(int minutes) {
    _totalScreenTimeMinutes = minutes;
    notifyListeners();
  }

  void updateUserName(String name) {
    _userName = name;
    _saveToPrefs();
    notifyListeners();
  }

  bool withdrawPoints(int amount) {
    if (_points >= amount) {
      _points -= amount;
      _saveToPrefs();
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
    _saveToPrefs();
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
    _saveToPrefs();
    notifyListeners();
  }

  void clearNotifications() {
    _notifications.clear();
    _saveToPrefs();
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
    _saveToPrefs();
    notifyListeners();
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
