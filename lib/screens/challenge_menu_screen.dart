import 'package:flutter/material.dart';
import '../models/app_state.dart';
import '../widgets/bottom_navigation.dart';

class ChallengeMenuScreen extends StatefulWidget {
  const ChallengeMenuScreen({super.key});

  @override
  State<ChallengeMenuScreen> createState() => _ChallengeMenuScreenState();
}

class _ChallengeMenuScreenState extends State<ChallengeMenuScreen> {
  int _activeTabIdx = 1; // Default to 'Daily' like original

  final List<Map<String, dynamic>> _challenges = [
    {
      "title": "Memory Match",
      "description": "Train your memory and attention.",
      "points": 10,
      "route": "/challenge/play"
    },
    {
      "title": "Deep Focus Pomodoro",
      "description": "Maintain your focus for 25 minutes.",
      "points": 30,
      "route": "/deep-focus"
    },
    {
      "title": "Math Sprint",
      "description": "Solve math problems in time.",
      "points": 20,
      "route": "/challenge/math-sprint"
    },
    {
      "title": "Pattern Recall",
      "description": "Remember and repeat patterns.",
      "points": 25,
      "route": "/challenge/pattern-recall"
    }
  ];

  @override
  Widget build(BuildContext context) {
    final state = AppStateProvider.of(context);
    final points = state.points;

    return Scaffold(
      backgroundColor: const Color(0xFF1B2755),
      body: Stack(
        children: [
          SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Banner header
                Container(
                  padding: const EdgeInsets.only(left: 24, right: 24, top: 16, bottom: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Challenge',
                            style: TextStyle(
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 12),
                          const Text(
                            'POINTS',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: Colors.white60,
                            ),
                          ),
                          Text(
                            '$points',
                            style: const TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                      Image.asset(
                        'assets/mascot-cool.png',
                        width: 90,
                        height: 90,
                        fit: BoxFit.contain,
                        errorBuilder: (context, error, stackTrace) => const Icon(Icons.star, color: Colors.amber, size: 60),
                      ),
                    ],
                  ),
                ),

                // White rounded container
                Expanded(
                  child: Container(
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(40),
                        topRight: Radius.circular(40),
                      ),
                    ),
                    child: ClipRRect(
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(40),
                        topRight: Radius.circular(40),
                      ),
                      child: Column(
                        children: [
                          // Tab Bar
                          Padding(
                            padding: const EdgeInsets.only(left: 24.0, right: 24.0, top: 24.0),
                            child: Row(
                              children: ['All', 'Daily', 'Completed'].map((tab) {
                                final idx = ['All', 'Daily', 'Completed'].indexOf(tab);
                                final isActive = _activeTabIdx == idx;
                                return Expanded(
                                  child: GestureDetector(
                                    onTap: () => setState(() => _activeTabIdx = idx),
                                    child: Container(
                                      margin: const EdgeInsets.symmetric(horizontal: 4),
                                      padding: const EdgeInsets.symmetric(vertical: 10),
                                      decoration: BoxDecoration(
                                        color: isActive ? const Color(0xFF1B2755) : Colors.white,
                                        borderRadius: BorderRadius.circular(10),
                                        border: Border.all(color: const Color(0xFF1B2755)),
                                      ),
                                      child: Text(
                                        tab,
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          color: isActive ? Colors.white : const Color(0xFF1B2755),
                                          fontWeight: FontWeight.bold,
                                          fontSize: 13,
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              }).toList(),
                            ),
                          ),

                          // Challenges list
                          Expanded(
                            child: ListView.builder(
                              physics: const BouncingScrollPhysics(),
                              padding: const EdgeInsets.only(left: 24, right: 24, top: 20, bottom: 100),
                              itemCount: _challenges.length,
                              itemBuilder: (context, index) {
                                final challenge = _challenges[index];
                                return Container(
                                  margin: const EdgeInsets.only(bottom: 16),
                                  padding: const EdgeInsets.all(16),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFE3F0FB),
                                    borderRadius: BorderRadius.circular(20),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.02),
                                        blurRadius: 10,
                                        offset: const Offset(0, 4),
                                      ),
                                    ],
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              challenge["title"],
                                              style: const TextStyle(
                                                color: Color(0xFF1B2755),
                                                fontWeight: FontWeight.bold,
                                                fontSize: 16,
                                              ),
                                            ),
                                            const SizedBox(height: 4),
                                            Text(
                                              challenge["description"],
                                              style: const TextStyle(
                                                color: Color(0xFF204A94),
                                                fontSize: 12,
                                              ),
                                            ),
                                            const SizedBox(height: 8),
                                            RichText(
                                              text: TextSpan(
                                                text: '+${challenge["points"]}',
                                                style: const TextStyle(
                                                  color: Colors.orange,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 14,
                                                ),
                                                children: const [
                                                  TextSpan(
                                                    text: ' pts',
                                                    style: TextStyle(
                                                      color: Color(0xFF1B2755),
                                                      fontWeight: FontWeight.bold,
                                                      fontSize: 14,
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      // Start Button
                                      ElevatedButton(
                                        onPressed: () {
                                          Navigator.pushNamed(context, challenge["route"]);
                                        },
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: const Color(0xFF204A94),
                                          foregroundColor: Colors.white,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(10),
                                          ),
                                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                                          elevation: 0,
                                        ),
                                        child: const Text(
                                          'Start',
                                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const BottomNavigation(activePage: 'challenge'),
        ],
      ),
    );
  }
}
