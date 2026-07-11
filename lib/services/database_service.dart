import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/app_state.dart';

class DatabaseService {
  static final DatabaseService _instance = DatabaseService._();
  static DatabaseService get instance => _instance;
  DatabaseService._();

  Database? _db;

  Future<Database> get database async {
    if (_db != null) return _db!;
    _db = await _initDb();
    return _db!;
  }

  Future<Database> _initDb() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'refocus.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE user_profile (
        id INTEGER PRIMARY KEY DEFAULT 1,
        name TEXT NOT NULL DEFAULT 'User',
        email TEXT,
        points INTEGER NOT NULL DEFAULT 0,
        streak_days INTEGER NOT NULL DEFAULT 0,
        deep_work_mode INTEGER NOT NULL DEFAULT 0
      )
    ''');

    await db.execute('''
      CREATE TABLE selected_apps (
        name TEXT PRIMARY KEY,
        logo TEXT NOT NULL,
        time_limit TEXT NOT NULL DEFAULT '30m',
        checked INTEGER NOT NULL DEFAULT 0
      )
    ''');

    await db.execute('''
      CREATE TABLE focus_history (
        id TEXT PRIMARY KEY,
        title TEXT NOT NULL,
        time TEXT NOT NULL,
        detail TEXT NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE notifications (
        id TEXT PRIMARY KEY,
        title TEXT NOT NULL,
        description TEXT NOT NULL,
        time TEXT NOT NULL,
        is_read INTEGER NOT NULL DEFAULT 0
      )
    ''');

    await db.execute('''
      CREATE TABLE daily_usage (
        date TEXT NOT NULL,
        package_name TEXT NOT NULL,
        minutes_used INTEGER NOT NULL DEFAULT 0,
        PRIMARY KEY (date, package_name)
      )
    ''');

    await db.execute('''
      CREATE TABLE focus_scores (
        date TEXT PRIMARY KEY,
        score INTEGER NOT NULL DEFAULT 0,
        screen_time_minutes INTEGER NOT NULL DEFAULT 0
      )
    ''');

    await db.insert('user_profile', {
      'name': 'Dio',
      'points': 0,
      'streak_days': 0,
      'deep_work_mode': 0,
    });
  }

  Future<Map<String, dynamic>?> getUserProfile() async {
    final db = await database;
    final result = await db.query('user_profile', where: 'id = 1');
    return result.isNotEmpty ? result.first : null;
  }

  Future<void> saveUserProfile({
    required String name,
    required int points,
    required int streakDays,
    required bool deepWorkMode,
  }) async {
    final db = await database;
    await db.update(
      'user_profile',
      {
        'name': name,
        'points': points,
        'streak_days': streakDays,
        'deep_work_mode': deepWorkMode ? 1 : 0,
      },
      where: 'id = 1',
    );
  }

  Future<void> addPoints(int amount) async {
    final db = await database;
    await db.rawUpdate(
      'UPDATE user_profile SET points = points + ? WHERE id = 1',
      [amount],
    );
  }

  Future<List<Map<String, dynamic>>> getSelectedApps() async {
    final db = await database;
    return await db.query('selected_apps');
  }

  Future<void> saveSelectedApps(List<SocialApp> apps) async {
    final db = await database;
    await db.delete('selected_apps');
    for (final app in apps) {
      await db.insert('selected_apps', {
        'name': app.name,
        'logo': app.logo,
        'time_limit': app.timeLimit,
        'checked': app.checked ? 1 : 0,
      });
    }
  }

  Future<void> upsertAppLimit(String name, String timeLimit) async {
    final db = await database;
    await db.update(
      'selected_apps',
      {'time_limit': timeLimit},
      where: 'name = ?',
      whereArgs: [name],
    );
  }

  Future<void> toggleAppChecked(String name, bool checked) async {
    final db = await database;
    await db.update(
      'selected_apps',
      {'checked': checked ? 1 : 0},
      where: 'name = ?',
      whereArgs: [name],
    );
  }

  Future<List<Map<String, dynamic>>> getFocusHistory() async {
    final db = await database;
    return await db.query('focus_history', orderBy: 'time DESC');
  }

  Future<void> addFocusHistory(String id, String title, String time, String detail) async {
    final db = await database;
    await db.insert('focus_history', {
      'id': id,
      'title': title,
      'time': time,
      'detail': detail,
    });
  }

  Future<List<Map<String, dynamic>>> getNotifications() async {
    final db = await database;
    return await db.query('notifications', orderBy: 'time DESC');
  }

  Future<void> addNotification(String id, String title, String description, String time) async {
    final db = await database;
    await db.insert('notifications', {
      'id': id,
      'title': title,
      'description': description,
      'time': time,
      'is_read': 0,
    });
  }

  Future<void> markAllNotificationsRead() async {
    final db = await database;
    await db.update('notifications', {'is_read': 1});
  }

  Future<void> clearNotifications() async {
    final db = await database;
    await db.delete('notifications');
  }

  Future<void> saveDailyUsage(String date, String packageName, int minutesUsed) async {
    final db = await database;
    await db.insert(
      'daily_usage',
      {'date': date, 'package_name': packageName, 'minutes_used': minutesUsed},
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<int> getTotalScreenTime(String date) async {
    final db = await database;
    final result = await db.rawQuery(
      'SELECT COALESCE(SUM(minutes_used), 0) as total FROM daily_usage WHERE date = ?',
      [date],
    );
    return (result.first['total'] as int?) ?? 0;
  }

  Future<List<Map<String, dynamic>>> getDailyUsage(String date) async {
    final db = await database;
    return await db.query('daily_usage', where: 'date = ?', whereArgs: [date]);
  }

  Future<void> saveFocusScore(String date, int score, int screenTimeMinutes) async {
    final db = await database;
    await db.insert(
      'focus_scores',
      {'date': date, 'score': score, 'screen_time_minutes': screenTimeMinutes},
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<Map<String, dynamic>?> getFocusScore(String date) async {
    final db = await database;
    final result = await db.query('focus_scores', where: 'date = ?', whereArgs: [date]);
    return result.isNotEmpty ? result.first : null;
  }

  Future<List<Map<String, dynamic>>> getWeeklyScores() async {
    final db = await database;
    return await db.query('focus_scores', orderBy: 'date DESC', limit: 7);
  }
}
