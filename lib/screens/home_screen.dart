import 'dart:math';
import 'package:flutter/material.dart';
import '../models/app_state.dart';
import '../widgets/bottom_navigation.dart';
import '../services/usage_repository.dart';
import '../services/screen_time_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin {
  late final AnimationController _mascotController;
  late final Animation<double> _mascotFloat;

  @override
  void initState() {
    super.initState();
    _mascotController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat(reverse: true);
    
    _mascotFloat = Tween<double>(begin: 0, end: -8).animate(
      CurvedAnimation(parent: _mascotController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _mascotController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = AppStateProvider.of(context);
    final apps = state.activeApps.isEmpty ? state.selectedApps.take(4).toList() : state.activeApps;
    final userName = state.userName;
    final unreadNotifications = state.unreadNotificationsCount;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.only(left: 18.0, right: 18.0, bottom: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 12),
              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Image.asset(
                    'assets/logo-refocus.png',
                    height: 30,
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) => const Text(
                      'ReFocus',
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.w900,
                        color: Color(0xFF1B2755),
                      ),
                    ),
                  ),
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          if (ScreenTimeService.isMonitoring) {
                            ScreenTimeService.stopMonitoring().then((_) {
                              if (!context.mounted) return;
                              setState(() {});
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Monitoring dimatikan'),
                                  duration: Duration(seconds: 2),
                                ),
                              );
                            });
                          } else {
                            Navigator.pushNamed(context, '/select-apps');
                          }
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                          decoration: BoxDecoration(
                            color: ScreenTimeService.isMonitoring
                                ? const Color(0xFF204A94)
                                : Colors.grey[300],
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                ScreenTimeService.isMonitoring
                                    ? Icons.shield
                                    : Icons.shield_outlined,
                                color: ScreenTimeService.isMonitoring
                                    ? Colors.white
                                    : const Color(0xFF1B2755),
                                size: 16,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                ScreenTimeService.isMonitoring ? 'ON' : 'OFF',
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                  color: ScreenTimeService.isMonitoring
                                      ? Colors.white
                                      : const Color(0xFF1B2755),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      GestureDetector(
                        onTap: () => Navigator.pushNamed(context, '/notifications'),
                        child: Stack(
                          clipBehavior: Clip.none,
                          children: [
                            const Icon(
                              Icons.notifications_none_outlined,
                              color: Color(0xFF1B2755),
                              size: 28,
                            ),
                            if (unreadNotifications > 0)
                              Positioned(
                                top: 2,
                                right: 2,
                                child: Container(
                                  width: 9,
                                  height: 9,
                                  decoration: const BoxDecoration(
                                    color: Colors.red,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // Good Morning & Mascot
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Good Morning, $userName! 👋',
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF1B2755),
                          ),
                        ),
                        const SizedBox(height: 4),
                        const Text(
                          "Let's stay focused and achieve your goals today",
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  AnimatedBuilder(
                    animation: _mascotFloat,
                    builder: (context, child) {
                      return Transform.translate(
                        offset: Offset(0, _mascotFloat.value),
                        child: child,
                      );
                    },
                    child: Image.asset(
                      'assets/mascot-home.png',
                      width: 80,
                      height: 80,
                      fit: BoxFit.contain,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),

              // Focus Score Circular Card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: const Color(0xFF1B2755),
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Focus Score',
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.white70,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          RichText(
                            text: TextSpan(
                              text: '${state.focusScore}',
                              style: const TextStyle(
                                fontSize: 56,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                              children: const [
                                TextSpan(
                                  text: ' / 100',
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.normal,
                                    color: Colors.white60,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 12),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.15),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: const Text(
                              'Excellent!',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 12),
                    // Circular Progress Indicator
                    SizedBox(
                      width: 100,
                      height: 100,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          TweenAnimationBuilder<double>(
                            tween: Tween<double>(begin: 0.0, end: state.focusScore / 100.0),
                            duration: const Duration(milliseconds: 1500),
                            curve: Curves.easeOutCubic,
                            builder: (context, value, child) {
                              return CustomPaint(
                                size: const Size(90, 90),
                                painter: _CircularProgressPainter(progress: value),
                              );
                            },
                          ),
                          const Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "You're doing",
                                style: TextStyle(color: Colors.white, fontSize: 8, fontWeight: FontWeight.bold),
                              ),
                              Text(
                                "great today!",
                                style: TextStyle(color: Colors.white, fontSize: 8, fontWeight: FontWeight.bold),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),

              // Grid Metrics (Menggunakan Row + Expanded agar dinamis & anti-overflow)
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Today's Screen Time Card
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: Colors.grey.withValues(alpha: 0.08)),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            "Today's Screen Time",
                            style: TextStyle(fontSize: 13, color: Color(0xFF204A94), fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            state.totalScreenTimeFormatted,
                            style: const TextStyle(fontSize: 30, fontWeight: FontWeight.bold, color: Colors.black),
                          ),
                          const SizedBox(height: 6),
                          Row(
                            children: [
                              const Icon(Icons.arrow_downward, color: Color(0xFF10B981), size: 14),
                              const SizedBox(width: 2),
                              Text(
                                '${state.focusScore}%',
                                style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF10B981)),
                              ),
                              const SizedBox(width: 4),
                              Expanded(
                                child: Text(
                                  'focus score today',
                                  style: const TextStyle(fontSize: 11, color: Color(0xFF38BDF8), fontWeight: FontWeight.bold),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  // Current Streak Card
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: Colors.grey.withValues(alpha: 0.08)),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            'Current Streak',
                            style: TextStyle(fontSize: 13, color: Color(0xFF204A94), fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 4),
                          Row(
                            textBaseline: TextBaseline.alphabetic,
                            crossAxisAlignment: CrossAxisAlignment.baseline,
                            children: [
                              Text(
                                '${state.streakDays}',
                                style: const TextStyle(fontSize: 36, fontWeight: FontWeight.bold, color: Colors.black),
                              ),
                              const SizedBox(width: 4),
                              const Text(
                                'Days',
                                style: TextStyle(fontSize: 18, color: Colors.black, fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                          const SizedBox(height: 6),
                          const Text(
                            'Keep your streak alive',
                            style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF38BDF8)),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Limits Section Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Your Social Media Limits',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1B2755),
                    ),
                  ),
                  GestureDetector(
                    onTap: () => Navigator.pushNamed(context, '/select-apps'),
                    child: const Text(
                      'Edit Limits',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF204A94),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),

              // Social Limits App Cards
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: min(3, apps.length),
                itemBuilder: (context, index) {
                  final app = apps[index];
                  final usedMinutes = UsageRepository.instance.getUsageMinutes(app.name);
                  final limitMinutes = state.parseLimitToMinutes(app.timeLimit);
                  final timeLabel = limitMinutes > 0
                      ? '${UsageRepository.instance.formatMinutes(usedMinutes)}/${app.timeLimit}'
                      : UsageRepository.instance.formatMinutes(usedMinutes);
                  final percentLabel = '${app.progress}%';
                  final progressValue = limitMinutes > 0
                      ? (usedMinutes / limitMinutes).clamp(0.0, 1.0)
                      : 0.0;

                  return Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.grey.withValues(alpha: 0.08)),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Image.asset(
                          'assets/${app.logo}',
                          width: 40,
                          height: 40,
                          fit: BoxFit.contain,
                          errorBuilder: (context, error, stackTrace) => const Icon(Icons.android, size: 36),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    app.name,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFF204A94),
                                      fontSize: 15,
                                    ),
                                  ),
                                  const Spacer(),
                                  Text(
                                    timeLabel,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFF204A94),
                                      fontSize: 14,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFE0F2FE),
                                      borderRadius: BorderRadius.circular(6),
                                      border: Border.all(color: const Color(0xFF38BDF8).withValues(alpha: 0.5)),
                                    ),
                                    child: Text(
                                      percentLabel,
                                      style: const TextStyle(
                                        color: Color(0xFF204A94),
                                        fontWeight: FontWeight.bold,
                                        fontSize: 10,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              SizedBox(
                                width: double.infinity,
                                height: 8,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(4),
                                  child: LinearProgressIndicator(
                                    value: progressValue,
                                    backgroundColor: Colors.grey[200],
                                    color: const Color(0xFF38BDF8),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
              const SizedBox(height: 12),

              // Bottom Challenge & Insights Grid
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Challenge card
                  Expanded(
                    child: Container(
                      height: 180,
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: const Color(0xFFE0F2FE),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Stack(
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Row(
                                children: [
                                  Icon(Icons.sports_esports_outlined, size: 16, color: Color(0xFF204A94)),
                                  SizedBox(width: 4),
                                  Text(
                                    "Today's Challenge",
                                    style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF204A94), fontSize: 13),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              const Text(
                                'Memory Match',
                                style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Color(0xFF1B2755)),
                              ),
                              const SizedBox(height: 4),
                              const SizedBox(
                                width: 100,
                                child: Text(
                                  'Train your memory and improve focus in just 2 minutes!',
                                  style: TextStyle(fontSize: 10, color: Color(0xFF204A94), height: 1.3),
                                ),
                              ),
                              const Spacer(),
                              ElevatedButton(
                                onPressed: () => Navigator.pushNamed(context, '/challenge'),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF204A94),
                                  foregroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                                  elevation: 0,
                                ),
                                child: const Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text('Start Challenge', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold)),
                                    SizedBox(width: 2),
                                    Icon(Icons.chevron_right, size: 12),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          Positioned(
                            bottom: -4,
                            right: -4,
                            child: Image.asset(
                              'assets/mascot-home-todays.png',
                              width: 50,
                              height: 50,
                              fit: BoxFit.contain,
                              errorBuilder: (context, error, stackTrace) => const SizedBox(),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  // Insight card
                  Expanded(
                    child: Container(
                      height: 180,
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: const Color(0xFFE0F2FE),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Stack(
                        children: [
                          const Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Icon(Icons.lightbulb_outline, size: 16, color: Color(0xFF204A94)),
                                  SizedBox(width: 4),
                                  Text(
                                    "Daily Insight",
                                    style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF204A94), fontSize: 13),
                                  ),
                                ],
                              ),
                              SizedBox(height: 8),
                              Text(
                                'You spend the most time on social media between',
                                style: TextStyle(fontSize: 10, color: Color(0xFF204A94), height: 1.3),
                                  ),
                              SizedBox(height: 6),
                              Text(
                                '8 PM – 10 PM',
                                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF1B2755)),
                              ),
                              SizedBox(height: 6),
                              Text(
                                'Try to take a break during that time tomorrow!',
                                style: TextStyle(fontSize: 10, color: Color(0xFF204A94), height: 1.3),
                              ),
                            ],
                          ),
                          Positioned(
                            bottom: -4,
                            right: -4,
                            child: Image.asset(
                              'assets/mascot-home-daily.png',
                              width: 55,
                              height: 55,
                              fit: BoxFit.contain,
                              errorBuilder: (context, error, stackTrace) => const SizedBox(),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: const BottomNavigation(activePage: 'home'),
    );
  }
}

class _CircularProgressPainter extends CustomPainter {
  final double progress;

  _CircularProgressPainter({required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = min(size.width / 2, size.height / 2) - 8;

    final backgroundPaint = Paint()
      ..color = const Color(0xFF25407A)
      ..strokeWidth = 10
      ..style = PaintingStyle.stroke;

    final foregroundPaint = Paint()
      ..color = const Color(0xFF38BDF8)
      ..strokeWidth = 10
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    canvas.drawCircle(center, radius, backgroundPaint);
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -pi / 2,
      2 * pi * progress,
      false,
      foregroundPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
