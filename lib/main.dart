import 'package:flutter/material.dart';
import 'models/app_state.dart';
import 'screens/splash_screen.dart';
import 'screens/intro_screen.dart';
import 'screens/login_screen.dart';
import 'screens/signup_screen.dart';
import 'screens/permission_screen.dart';
import 'screens/select_apps_screen.dart';
import 'screens/set_limit_screen.dart';
import 'screens/home_screen.dart';
import 'screens/statistics_screen.dart';
import 'screens/limit_reached_screen.dart';
import 'screens/challenge_menu_screen.dart';
import 'screens/challenge_play_screen.dart';
import 'screens/profile_screen.dart';
import 'screens/points_screen.dart';
import 'screens/deep_focus_screen.dart';
import 'screens/notifications_screen.dart';
import 'screens/focus_history_screen.dart';
import 'screens/math_sprint_screen.dart';
import 'screens/pattern_recall_screen.dart';
import 'screens/settings_screen.dart';
import 'services/auth_service.dart';
import 'services/screen_time_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AuthService.seedDefaultUser();
  ScreenTimeService.initialize();
  runApp(
    AppStateProvider(
      notifier: AppState(),
      child: const ReFocusApp(),
    ),
  );
}

class ReFocusApp extends StatelessWidget {
  const ReFocusApp({super.key});

  @override
  Widget build(BuildContext context) {
    final state = AppStateProvider.of(context);
    return MaterialApp(
      navigatorKey: ScreenTimeService.navigatorKey,
      title: 'ReFocus',
      debugShowCheckedModeBanner: false,
      themeMode: state.themeMode,
      theme: ThemeData(
        brightness: Brightness.light,
        fontFamily: 'Inter',
        primaryColor: const Color(0xFF204A94),
        scaffoldBackgroundColor: Colors.white,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF204A94),
          primary: const Color(0xFF204A94),
          secondary: const Color(0xFF1B2755),
          brightness: Brightness.light,
        ),
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            foregroundColor: const Color(0xFF204A94),
          ),
        ),
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        fontFamily: 'Inter',
        primaryColor: const Color(0xFF204A94),
        scaffoldBackgroundColor: const Color(0xFF121212),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF204A94),
          primary: const Color(0xFF204A94),
          secondary: const Color(0xFF9FA8DA),
          brightness: Brightness.dark,
        ),
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            foregroundColor: const Color(0xFF9FA8DA),
          ),
        ),
      ),
      // Define named routes to navigate identically to the React pages
      initialRoute: '/',
      onGenerateRoute: (settings) {
        Widget builder;
        switch (settings.name) {
          case '/':
            builder = const SplashScreen();
            break;
          case '/intro':
            builder = const IntroScreen();
            break;
          case '/login':
            builder = const LoginScreen();
            break;
          case '/signup':
            builder = const SignupScreen();
            break;
          case '/permission':
            builder = const PermissionScreen();
            break;
          case '/select-apps':
            builder = const SelectAppsScreen();
            break;
          case '/set-limit':
            builder = const SetLimitScreen();
            break;
          case '/home':
            builder = const HomeScreen();
            break;
          case '/statistics':
            builder = const StatisticsScreen();
            break;
          case '/limit-reached':
            builder = const LimitReachedScreen();
            break;
          case '/challenge':
            builder = const ChallengeMenuScreen();
            break;
          case '/challenge/play':
            builder = const ChallengePlayScreen();
            break;
          case '/challenge/math-sprint':
            builder = const MathSprintScreen();
            break;
          case '/challenge/pattern-recall':
            builder = const PatternRecallScreen();
            break;
          case '/profile':
            builder = const ProfileScreen();
            break;
          case '/points':
            builder = const PointsScreen();
            break;
          case '/deep-focus':
            builder = const DeepFocusScreen();
            break;
          case '/notifications':
            builder = const NotificationsScreen();
            break;
          case '/focus-history':
            builder = const FocusHistoryScreen();
            break;
          case '/settings':
            builder = const SettingsScreen();
            break;
          default:
            builder = const SplashScreen();
        }

        // Custom PageRouteBuilder for instant or quick transitions between main tabs
        // to match React single page app behavior
        if (['/home', '/statistics', '/challenge', '/profile', '/settings'].contains(settings.name)) {
          return PageRouteBuilder(
            settings: settings,
            pageBuilder: (context, animation, secondaryAnimation) => builder,
            transitionsBuilder: (context, animation, secondaryAnimation, child) {
              return FadeTransition(
                opacity: animation,
                child: child,
              );
            },
            transitionDuration: const Duration(milliseconds: 150),
          );
        }

        // Default route transition for onboarding and sub-drawers
        return MaterialPageRoute(
          settings: settings,
          builder: (context) => builder,
        );
      },
    );
  }
}
