import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';

class LimitReachedScreen extends StatefulWidget {
  const LimitReachedScreen({super.key});

  @override
  State<LimitReachedScreen> createState() => _LimitReachedScreenState();
}

class _LimitReachedScreenState extends State<LimitReachedScreen> with SingleTickerProviderStateMixin {
  int _timeLeft = 900; // 15 minutes in seconds
  Timer? _timer;
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _startTimer();

    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);

    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.05).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_timeLeft > 0) {
        setState(() {
          _timeLeft--;
        });
      } else {
        _timer?.cancel();
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pulseController.dispose();
    super.dispose();
  }

  String _formatTime(int seconds) {
    final mins = seconds ~/ 60;
    final secs = seconds % 60;
    return "$mins:${secs.toString().padLeft(2, '0')}";
  }

  @override
  Widget build(BuildContext context) {
    final progressFraction = _timeLeft / 900.0;

    return Scaffold(
      backgroundColor: const Color(0xFF1B2755),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Spacer(flex: 1),
              // Circular countdown & locked mascot
              SizedBox(
                width: 240,
                height: 240,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    // Outer static circle
                    Container(
                      width: 220,
                      height: 220,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.grey.withOpacity(0.2), width: 4),
                      ),
                    ),
                    // Progress arc (countdown timer)
                    TweenAnimationBuilder<double>(
                      tween: Tween<double>(begin: 1.0, end: progressFraction),
                      duration: const Duration(milliseconds: 500),
                      builder: (context, value, child) {
                        return CustomPaint(
                          size: const Size(220, 220),
                          painter: _TimerProgressPainter(progress: value),
                        );
                      },
                    ),
                    // Locked mascot with pulse breathing effect
                    ScaleTransition(
                      scale: _pulseAnimation,
                      child: Image.asset(
                        'assets/mascot-locked.png',
                        width: 170,
                        height: 170,
                        fit: BoxFit.contain,
                        errorBuilder: (context, error, stackTrace) => const Icon(
                          Icons.lock_outline,
                          size: 100,
                          color: Color(0xFFA5C0DD),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 36),

              const Text(
                'Time Limit Reached!',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 6),
              const Text(
                "You've reached your daily limit for TikTok",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.white70,
                ),
              ),
              const SizedBox(height: 36),

              // Start Challenge Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/challenge');
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF204A94),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 3,
                  ),
                  child: const Text(
                    'Start Challenge',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 12),

              // Remind Me Later (Back or Close)
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  style: OutlinedButton.styleFrom(
                    foregroundColor: const Color(0xFFA5C0DD),
                    side: const BorderSide(color: Color(0xFFA5C0DD)),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: const Text(
                    'Remind Me Later',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Cooldown countdown text
              Text(
                'or wait ${_formatTime(_timeLeft)}',
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: Colors.white54,
                ),
              ),
              const Spacer(flex: 1),
            ],
          ),
        ),
      ),
    );
  }
}

class _TimerProgressPainter extends CustomPainter {
  final double progress;

  _TimerProgressPainter({required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = min(size.width / 2, size.height / 2) - 4;

    final paint = Paint()
      ..color = const Color(0xFFA5C0DD)
      ..strokeWidth = 4
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -pi / 2,
      2 * pi * progress,
      false,
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
