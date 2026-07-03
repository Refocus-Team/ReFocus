import 'dart:async';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/app_state.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _floatAnimation;
  late Animation<double> _fadeAnimation;
  Timer? _navigationTimer;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);

    _floatAnimation = Tween<double>(begin: 0, end: -15).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    _fadeAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0, 0.5, curve: Curves.easeIn),
      ),
    );

    // Auto-navigate to intro or home after 3 seconds checking SharedPreferences
    _navigationTimer = Timer(const Duration(seconds: 3), () async {
      if (mounted) {
        final prefs = await SharedPreferences.getInstance();
        final isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
        final name = prefs.getString('loggedInUserName') ?? '';

        if (isLoggedIn && name.isNotEmpty) {
          if (mounted) {
            final state = AppStateProvider.of(context);
            state.updateUserName(name);
            Navigator.pushReplacementNamed(context, '/home');
          }
        } else {
          if (mounted) {
            Navigator.pushReplacementNamed(context, '/intro');
          }
        }
      }
    });
  }

  @override
  void dispose() {
    _navigationTimer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE3F0FB),
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Title fade in
              TweenAnimationBuilder<double>(
                tween: Tween<double>(begin: 0, end: 1),
                duration: const Duration(milliseconds: 1000),
                builder: (context, value, child) {
                  return Opacity(
                    opacity: value,
                    child: Transform.translate(
                      offset: Offset(0, (1 - value) * 15),
                      child: child,
                    ),
                  );
                },
                child: Column(
                  children: [
                    const Text(
                      'ReFocus',
                      style: TextStyle(
                        fontSize: 56,
                        fontWeight: FontWeight.w900, // ExtraBold
                        color: Color(0xFF1B2755),
                        letterSpacing: -1,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Reclaim Your Focus, Live Better',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF1B2755),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 48),
              // Floating mascot image
              AnimatedBuilder(
                animation: _floatAnimation,
                builder: (context, child) {
                  return Transform.translate(
                    offset: Offset(0, _floatAnimation.value),
                    child: child,
                  );
                },
                child: Image.asset(
                  'assets/splash.png',
                  width: MediaQuery.of(context).size.width * 0.65,
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      padding: const EdgeInsets.all(20),
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.track_changes,
                        size: 100,
                        color: Color(0xFF1B2755),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
