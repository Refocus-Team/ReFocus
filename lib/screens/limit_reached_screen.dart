import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';

class LimitReachedScreen extends StatefulWidget {
  const LimitReachedScreen({super.key});

  @override
  State<LimitReachedScreen> createState() => _LimitReachedScreenState();
}

class _LimitReachedScreenState extends State<LimitReachedScreen> with SingleTickerProviderStateMixin {
  int _timeLeft = 900; // 15 minutes in seconds (15 * 60)
  Timer? _timer;
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _startTimer();

    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2500),
    )..repeat(reverse: true);

    _pulseAnimation = Tween<double>(begin: 0.98, end: 1.02).animate(
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
    return "${mins.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}";
  }

  @override
  Widget build(BuildContext context) {
    // We start with a slice of white representing 15 minutes countdown (e.g. 0.25 to 0.0)
    // Or we can let it show a nice sweep. Let's make it start at 0.25 and count down.
    final progressFraction = _timeLeft / 3600.0; // 15 mins out of 60 mins = 0.25 max progress

    return PopScope(
      canPop: false, // Disables back button lock-out
      child: Scaffold(
        backgroundColor: const Color(0xFF131E3D), // Deep dark navy blue matching the mock
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
            child: Column(
              children: [
                const Spacer(flex: 3),

                // Beautiful Mascot Circle with progress ring
                ScaleTransition(
                  scale: _pulseAnimation,
                  child: SizedBox(
                    width: 250,
                    height: 250,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        // Progress ring
                        Positioned.fill(
                          child: CustomPaint(
                            painter: _OuterRingPainter(progress: progressFraction),
                          ),
                        ),
                        // Mascot display
                        Container(
                          width: 218,
                          height: 218,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Color(0xFF1B2755),
                          ),
                          child: ClipOval(
                            child: Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: Image.asset(
                                'assets/mascot-limit.png',
                                fit: BoxFit.contain,
                                errorBuilder: (context, error, stackTrace) => const Icon(
                                  Icons.lock_outline,
                                  size: 110,
                                  color: Color(0xFFA5C0DD),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const Spacer(flex: 2),

                // Title: Time Limit Reached!
                const Text(
                  'Time Limit Reached!',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    letterSpacing: -0.5,
                  ),
                ),
                const SizedBox(height: 12),

                // Description
                const Text(
                  "You’ve reached your daily limit\nfor TikTok",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 18,
                    color: Color(0xFFBACAE6),
                    height: 1.3,
                  ),
                ),

                const Spacer(flex: 4),

                // Start Challenge Button
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pushReplacementNamed(context, '/challenge');
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF1C3F95),
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    child: const Text(
                      'Start Challenge',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Remind Me Later Button
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: OutlinedButton(
                    onPressed: () {
                      Navigator.pushReplacementNamed(context, '/home');
                    },
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.white,
                      side: const BorderSide(color: Color(0xFF2E3B5E), width: 1.5),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    child: const Text(
                      'Remind Me Later',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // Countdown Text
                Text(
                  'or wait ${_formatTime(_timeLeft)}',
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF7D8FA9),
                  ),
                ),
                const Spacer(flex: 1),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _OuterRingPainter extends CustomPainter {
  final double progress;
  _OuterRingPainter({required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = min(size.width / 2, size.height / 2) - 8;

    // Background circle (light blue progress track)
    final bgPaint = Paint()
      ..color = const Color(0xFF38BDF8)
      ..strokeWidth = 10
      ..style = PaintingStyle.stroke;

    // Active progress arc (white)
    final activePaint = Paint()
      ..color = Colors.white
      ..strokeWidth = 10
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    canvas.drawCircle(center, radius, bgPaint);

    // Draw active progress arc (white) from -pi/2
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -pi / 2,
      2 * pi * progress,
      false,
      activePaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
