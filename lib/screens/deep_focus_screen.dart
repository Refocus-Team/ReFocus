import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import '../models/app_state.dart';

class DeepFocusScreen extends StatefulWidget {
  const DeepFocusScreen({super.key});

  @override
  State<DeepFocusScreen> createState() => _DeepFocusScreenState();
}

class _DeepFocusScreenState extends State<DeepFocusScreen> with SingleTickerProviderStateMixin {
  int _secondsRemaining = 1500; // 25 minutes in seconds
  Timer? _timer;
  bool _isRunning = false;
  String _selectedSound = 'Silence';

  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  final List<Map<String, dynamic>> _sounds = [
    {"name": "Rain", "icon": Icons.umbrella_outlined},
    {"name": "Waves", "icon": Icons.water_outlined},
    {"name": "White Noise", "icon": Icons.settings_input_antenna_outlined},
    {"name": "Library", "icon": Icons.local_library_outlined},
    {"name": "Silence", "icon": Icons.volume_off_outlined},
  ];

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );
    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.06).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
  }

  void _toggleTimer() {
    if (_isRunning) {
      _timer?.cancel();
      _pulseController.stop();
      setState(() {
        _isRunning = false;
      });
    } else {
      setState(() {
        _isRunning = true;
      });
      _pulseController.repeat(reverse: true);
      _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
        if (_secondsRemaining > 0) {
          setState(() {
            _secondsRemaining--;
          });
        } else {
          _handleFocusSuccess();
        }
      });
    }
  }

  void _resetTimer() {
    _timer?.cancel();
    _pulseController.stop();
    setState(() {
      _secondsRemaining = 1500;
      _isRunning = false;
    });
  }

  void _handleFocusSuccess() {
    _timer?.cancel();
    _pulseController.stop();
    setState(() {
      _isRunning = false;
      _secondsRemaining = 1500;
    });

    final state = AppStateProvider.of(context);
    state.addPoints(5);
    state.addFocusHistory("Sesi Deep Focus Berhasil", "+5 Poin");

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          backgroundColor: const Color(0xFF1B2755),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: const Text(
            'Sesi Fokus Selesai!',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.check_circle_outline, color: Colors.green, size: 64),
              const SizedBox(height: 16),
              const Text(
                'Kerja bagus! Anda telah fokus selama 25 menit penuh dan mendapatkan +5 poin.',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white70, fontSize: 13),
              ),
            ],
          ),
          actions: [
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF204A94),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                child: const Text('Klaim Poin', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              ),
            )
          ],
        );
      },
    );
  }

  String _formatTime(int totalSeconds) {
    final minutes = totalSeconds ~/ 60;
    final seconds = totalSeconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double fractionRemaining = _secondsRemaining / 1500.0;

    return Scaffold(
      backgroundColor: const Color(0xFF1B2755),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
          child: Column(
            children: [
              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.arrow_back, color: Colors.white, size: 26),
                  ),
                  const Text(
                    'Deep Focus Session',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(width: 48), // spacer
                ],
              ),
              const Spacer(flex: 1),

              // Pomodoro Countdown Circle
              ScaleTransition(
                scale: _isRunning ? _pulseAnimation : const AlwaysStoppedAnimation(1.0),
                child: SizedBox(
                  width: 220,
                  height: 220,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      // Inner static circle
                      Container(
                        width: 200,
                        height: 200,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white.withValues(alpha: 0.08), width: 6),
                        ),
                      ),
                      // Progress Arc
                      CustomPaint(
                        size: const Size(200, 200),
                        painter: _TimerProgressPainter(progress: fractionRemaining),
                      ),
                      // Timer Text
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            _formatTime(_secondsRemaining),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 38,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            _isRunning ? 'FOCUSING' : 'READY',
                            style: TextStyle(
                              color: _isRunning ? const Color(0xFF38BDF8) : Colors.white60,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 2,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Control Buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Play / Pause
                  GestureDetector(
                    onTap: _toggleTimer,
                    child: Container(
                      width: 60,
                      height: 60,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        _isRunning ? Icons.pause : Icons.play_arrow,
                        color: const Color(0xFF1B2755),
                        size: 32,
                      ),
                    ),
                  ),
                  const SizedBox(width: 24),
                  // Reset
                  GestureDetector(
                    onTap: _resetTimer,
                    child: Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        color: Colors.transparent,
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white.withValues(alpha: 0.3), width: 1.5),
                      ),
                      child: const Icon(
                        Icons.refresh,
                        color: Colors.white,
                        size: 24,
                      ),
                    ),
                  ),
                ],
              ),
              const Spacer(flex: 1),

              // Ambient Sound selector
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Ambient Sound',
                  style: TextStyle(
                    color: Colors.white70,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                height: 75,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  physics: const BouncingScrollPhysics(),
                  itemCount: _sounds.length,
                  itemBuilder: (context, index) {
                    final snd = _sounds[index];
                    final name = snd["name"] as String;
                    final icon = snd["icon"] as IconData;
                    final isSelected = _selectedSound == name;

                    return GestureDetector(
                      onTap: () => setState(() => _selectedSound = name),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        margin: const EdgeInsets.only(right: 12),
                        width: 80,
                        decoration: BoxDecoration(
                          color: isSelected ? const Color(0xFF204A94) : Colors.white.withValues(alpha: 0.05),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: isSelected ? const Color(0xFF38BDF8) : Colors.transparent,
                            width: 1.5,
                          ),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(icon, color: isSelected ? Colors.white : Colors.white70, size: 24),
                            const SizedBox(height: 6),
                            Text(
                              name,
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                                color: isSelected ? Colors.white : Colors.white70,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),

              const SizedBox(height: 24),
              // Tips Banner
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.06),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.lightbulb_outline, color: Color(0xFF38BDF8), size: 22),
                    SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Poin bonus (+5) akan ditambahkan secara instan setelah target 25 menit tercapai.',
                        style: TextStyle(color: Colors.white60, fontSize: 11, height: 1.3),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
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

    final Paint paint = Paint()
      ..shader = const SweepGradient(
        colors: [Color(0xFF38BDF8), Color(0xFF4AA5F9), Color(0xFF38BDF8)],
        stops: [0.0, 0.5, 1.0],
      ).createShader(Rect.fromCircle(center: center, radius: radius))
      ..strokeWidth = 6
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
