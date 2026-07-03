import 'dart:math';
import 'package:flutter/material.dart';
import '../models/app_state.dart';
import '../widgets/bottom_navigation.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin {
  late AnimationController _mascotController;
  late Animation<double> _mascotFloat;

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
    final points = state.points;
    final userName = state.userName;
    final unreadNotifications = state.unreadNotificationsCount;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      body: Stack(
        children: [
          SafeArea(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.only(left: 18.0, right: 18.0, bottom: 120.0),
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
                        height: 80,
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
                      GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(context, '/notifications');
                        },
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
                              'Good Morning,\n$userName!',
                              style: const TextStyle(
                                fontSize: 30,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF1B2755),
                                height: 1.15,
                              ),
                            ),
                            const SizedBox(height: 4),
                            const Text(
                              "Let's stay focused and achieve your goals today",
                              style: TextStyle(
                                fontSize: 15,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 12),
                      AnimatedBuilder(
                        animation: _mascotFloat,
                        builder: (context, child) {
                          return Transform.translate(
                            offset: Offset(0, _mascotFloat.value),
                            child: child,
                          );
                        },
                        child: Image.asset(
                          'assets/mascot-cool.png',
                          width: 80,
                          height: 80,
                          fit: BoxFit.contain,
                          errorBuilder: (context, error, stackTrace) => const Icon(
                            Icons.face_retouching_natural,
                            size: 60,
                            color: Color(0xFF1B2755),
                          ),
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
                                ),
                              ),
                              const SizedBox(height: 4),
                              RichText(
                                text: const TextSpan(
                                  text: '82',
                                  style: TextStyle(
                                    fontSize: 56,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                  children: [
                                    TextSpan(
                                      text: '/100',
                                      style: TextStyle(
                                        fontSize: 24,
                                        fontWeight: FontWeight.normal,
                                        color: Colors.white60,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 12),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.15),
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
                          width: 90,
                          height: 90,
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              TweenAnimationBuilder<double>(
                                tween: Tween<double>(begin: 0.0, end: 0.82),
                                duration: const Duration(milliseconds: 1500),
                                curve: Curves.easeOutCubic,
                                builder: (context, value, child) {
                                  return CustomPaint(
                                    size: const Size(80, 80),
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
                  const SizedBox(height: 10),

                  // Grid Metrics
                  GridView.count(
                    crossAxisCount: 2,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                    childAspectRatio: 1.4,
                    children: [
                      // Today's Screen Time
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: Colors.grey.withOpacity(0.1)),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              "Today's Screen Time",
                              style: TextStyle(fontSize: 13, color: Colors.grey),
                            ),
                            const SizedBox(height: 4),
                            const Text(
                              '1h 42m',
                              style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold, color: Color(0xFF2C3E50)),
                            ),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                const Icon(Icons.arrow_upward, color: Colors.green, size: 14),
                                const SizedBox(width: 2),
                                Text(
                                  '10% from yesterday',
                                  style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: Colors.green[600]),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      // Current Streak
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: Colors.grey.withOpacity(0.1)),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              'Current Streak',
                              style: TextStyle(fontSize: 13, color: Colors.grey),
                            ),
                            const SizedBox(height: 4),
                            const Row(
                              textBaseline: TextBaseline.alphabetic,
                              crossAxisAlignment: CrossAxisAlignment.baseline,
                              children: [
                                Text(
                                  '7',
                                  style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Color(0xFF204A94)),
                                ),
                                SizedBox(width: 2),
                                Text(
                                  'Days',
                                  style: TextStyle(fontSize: 16, color: Colors.grey),
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '$points pts · Keep it up!',
                              style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF204A94)),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

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
                        onTap: () {
                          Navigator.pushNamed(context, '/select-apps');
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: const Color(0xFFE0F2FE),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Text(
                            'Edit Limits',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF204A94),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),

                  // Social Limits App Cards
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: apps.length,
                    itemBuilder: (context, index) {
                      final app = apps[index];
                      return Container(
                        margin: const EdgeInsets.only(bottom: 8),
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: Colors.grey.withOpacity(0.08)),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Row(
                                children: [
                                  Image.asset(
                                    'assets/${app.logo}',
                                    width: 38,
                                    height: 38,
                                    fit: BoxFit.contain,
                                    errorBuilder: (context, error, stackTrace) => const Icon(Icons.android),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          app.name,
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 1,
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Color(0xFF1B2755),
                                            fontSize: 16,
                                          ),
                                        ),
                                        Text(
                                          app.timeLimit,
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 1,
                                          style: const TextStyle(
                                            fontSize: 13,
                                            color: Colors.grey,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 16),
                            Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFE0F2FE),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Text(
                                    '${app.progress}%',
                                    style: const TextStyle(
                                      color: Color(0xFF204A94),
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                // Progress bar
                                SizedBox(
                                  width: 60,
                                  height: 6,
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(3),
                                    child: TweenAnimationBuilder<double>(
                                      tween: Tween<double>(begin: 0, end: app.progress / 100.0),
                                      duration: const Duration(seconds: 1),
                                      builder: (context, val, child) {
                                        return LinearProgressIndicator(
                                          value: val,
                                          backgroundColor: Colors.grey[200],
                                          color: const Color(0xFF38BDF8),
                                        );
                                      },
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 8),

                  // Bottom Challenge & Insights Grid
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Challenge card
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: const Color(0xFFE0F2FE),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                "Today's Challenge",
                                style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF1B2755), fontSize: 15),
                              ),
                              const SizedBox(height: 4),
                              const Text(
                                'Train your memory and improve focus in just 2 minutes!',
                                style: TextStyle(fontSize: 12, color: Color(0xFF555555), height: 1.3),
                              ),
                              const SizedBox(height: 12),
                              SizedBox(
                                width: double.infinity,
                                child: ElevatedButton(
                                  onPressed: () {
                                    Navigator.pushNamed(context, '/challenge');
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFF1B2755),
                                    foregroundColor: Colors.white,
                                    padding: const EdgeInsets.symmetric(vertical: 10),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    elevation: 0,
                                  ),
                                  child: const Text(
                                    'Start Challenge',
                                    style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      // Insight card
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: const Color(0xFFE0F2FE),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: const Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text('💡', style: TextStyle(fontSize: 14)),
                                  SizedBox(width: 4),
                                  Text(
                                    "Daily Insight",
                                    style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF1B2755), fontSize: 15),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 6),
                              Text(
                                'You spend the most time on social media between 8-10 PM. Try to take a break during that time tomorrow!',
                                style: TextStyle(fontSize: 12, color: Color(0xFF555555), height: 1.3),
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
          // Fixed Glassmorphic Navigation
          const BottomNavigation(activePage: 'home'),
        ],
      ),
    );
  }
}

class _CircularProgressPainter extends CustomPainter {
  final double progress;

  _CircularProgressPainter({required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = min(size.width / 2, size.height / 2) - 4;

    final backgroundPaint = Paint()
      ..color = const Color(0xFF25407A)
      ..strokeWidth = 6
      ..style = PaintingStyle.stroke;

    final foregroundPaint = Paint()
      ..color = const Color(0xFF38BDF8)
      ..strokeWidth = 6
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
