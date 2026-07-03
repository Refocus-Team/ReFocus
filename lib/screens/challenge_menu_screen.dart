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
      "route": "/challenge/play",
      "isLocked": false,
      "difficulty": "Mudah",
      "isCompleted": true,
      "completedDate": "Selesai: Hari Ini",
      "bestScore": "Best Time: 01:15",
      "isDaily": true
    },
    {
      "title": "Deep Focus Pomodoro",
      "description": "Maintain your focus for 25 minutes.",
      "points": 30,
      "route": "/deep-focus",
      "isLocked": true,
      "difficulty": "Sukar",
      "isCompleted": false,
      "completedDate": null,
      "bestScore": null,
      "isDaily": false
    },
    {
      "title": "Math Sprint",
      "description": "Solve math problems in time.",
      "points": 20,
      "route": "/challenge/math-sprint",
      "isLocked": false,
      "difficulty": "Sedang",
      "isCompleted": false,
      "completedDate": null,
      "bestScore": null,
      "isDaily": true
    },
    {
      "title": "Pattern Recall",
      "description": "Remember and repeat patterns.",
      "points": 25,
      "route": "/challenge/pattern-recall",
      "isLocked": false,
      "difficulty": "Sedang",
      "isCompleted": true,
      "completedDate": "Selesai: 2 hari lalu",
      "bestScore": "Best Level: 6",
      "isDaily": true
    }
  ];

  Color _getDifficultyColor(String difficulty) {
    switch (difficulty) {
      case 'Mudah':
        return const Color(0xFF10B981); // Emerald Green
      case 'Sedang':
        return const Color(0xFFF59E0B); // Amber Yellow
      case 'Sukar':
      default:
        return const Color(0xFFEF4444); // Red
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = AppStateProvider.of(context);
    final points = state.points;

    // Filter challenges based on selected tab
    final List<Map<String, dynamic>> filteredChallenges = _activeTabIdx == 0
        ? _challenges
        : _activeTabIdx == 1
            ? _challenges.where((c) => c['isDaily'] == true).toList()
            : _challenges.where((c) => c['isCompleted'] == true).toList();

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
                  width: double.infinity,
                  padding: const EdgeInsets.only(left: 24, right: 24, top: 16, bottom: 20),
                  child: Stack(
                    clipBehavior: Clip.none,
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
                      Positioned(
                        bottom: -20,
                        right: -12,
                        child: Image.asset(
                          'assets/mascot-cool.png',
                          width: 100,
                          fit: BoxFit.contain,
                          errorBuilder: (context, error, stackTrace) => const Icon(
                            Icons.star,
                            color: Colors.white24,
                            size: 70,
                          ),
                        ),
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

                          // Challenges list or Empty State
                          Expanded(
                            child: filteredChallenges.isEmpty
                                ? Center(
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 48.0),
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Image.asset(
                                            'assets/mascot-cool.png',
                                            height: 180,
                                            fit: BoxFit.contain,
                                            errorBuilder: (context, error, stackTrace) => const Icon(
                                              Icons.emoji_events_outlined,
                                              size: 100,
                                              color: Color(0xFF204A94),
                                            ),
                                          ),
                                          const SizedBox(height: 24),
                                          Text(
                                            _activeTabIdx == 2
                                                ? 'Belum Ada Tantangan Selesai'
                                                : 'Belum Ada Tantangan',
                                            style: const TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold,
                                              color: Color(0xFF1B2755),
                                            ),
                                          ),
                                          const SizedBox(height: 8),
                                          Text(
                                            _activeTabIdx == 2
                                                ? 'Kamu belum menyelesaikan tantangan apa pun. Yuk kumpulkan poin pertamamu!'
                                                : 'Tidak ada tantangan yang tersedia di kategori ini.',
                                            textAlign: TextAlign.center,
                                            style: const TextStyle(
                                              fontSize: 14,
                                              color: Color(0xFF204A94),
                                              height: 1.4,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  )
                                : ListView.builder(
                                    physics: const BouncingScrollPhysics(),
                                    padding: const EdgeInsets.only(left: 24, right: 24, top: 20, bottom: 100),
                                    itemCount: filteredChallenges.length,
                                    itemBuilder: (context, index) {
                                      final challenge = filteredChallenges[index];
                                      final bool isLocked = challenge["isLocked"] == true;
                                      final bool isCompleted = challenge["isCompleted"] == true;

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
                                        child: Opacity(
                                          opacity: isLocked ? 0.6 : 1.0,
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Expanded(
                                                child: Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    // Difficulty badge & lock icon row
                                                    Row(
                                                      children: [
                                                        Container(
                                                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                                          decoration: BoxDecoration(
                                                            color: _getDifficultyColor(challenge["difficulty"]),
                                                            borderRadius: BorderRadius.circular(6),
                                                          ),
                                                          child: Text(
                                                            challenge["difficulty"],
                                                            style: const TextStyle(
                                                              color: Colors.white,
                                                              fontSize: 10,
                                                              fontWeight: FontWeight.bold,
                                                            ),
                                                          ),
                                                        ),
                                                        if (isLocked) ...[
                                                          const SizedBox(width: 8),
                                                          const Icon(
                                                            Icons.lock_outline,
                                                            size: 14,
                                                            color: Color(0xFF1B2755),
                                                          ),
                                                        ],
                                                      ],
                                                    ),
                                                    const SizedBox(height: 8),
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

                                                    // Completed date and score details
                                                    if (isCompleted) ...[
                                                      const SizedBox(height: 8),
                                                      Row(
                                                        children: [
                                                          if (challenge["completedDate"] != null) ...[
                                                            const Icon(Icons.check_circle_outline, size: 12, color: Color(0xFF10B981)),
                                                            const SizedBox(width: 4),
                                                            Text(
                                                              challenge["completedDate"],
                                                              style: const TextStyle(
                                                                color: Color(0xFF10B981),
                                                                fontSize: 11,
                                                                fontWeight: FontWeight.bold,
                                                              ),
                                                            ),
                                                          ],
                                                          if (challenge["completedDate"] != null && challenge["bestScore"] != null)
                                                            const SizedBox(width: 12),
                                                          if (challenge["bestScore"] != null) ...[
                                                            const Icon(Icons.emoji_events_outlined, size: 12, color: Color(0xFF204A94)),
                                                            const SizedBox(width: 4),
                                                            Text(
                                                              challenge["bestScore"],
                                                              style: const TextStyle(
                                                                color: Color(0xFF204A94),
                                                                fontSize: 11,
                                                                fontWeight: FontWeight.bold,
                                                              ),
                                                            ),
                                                          ],
                                                        ],
                                                      ),
                                                    ],
                                                    const SizedBox(height: 8),

                                                    // Reward points with coin icon
                                                    Row(
                                                      children: [
                                                        Image.asset(
                                                          'assets/coin-icon.png',
                                                          width: 16,
                                                          height: 16,
                                                          errorBuilder: (context, error, stackTrace) => const Icon(
                                                            Icons.monetization_on,
                                                            size: 16,
                                                            color: Colors.orange,
                                                          ),
                                                        ),
                                                        const SizedBox(width: 6),
                                                        Text(
                                                          '+${challenge["points"]} pts',
                                                          style: const TextStyle(
                                                            color: Colors.orange,
                                                            fontWeight: FontWeight.bold,
                                                            fontSize: 14,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              const SizedBox(width: 8),

                                              // Action button
                                              if (isLocked)
                                                ElevatedButton(
                                                  onPressed: null,
                                                  style: ElevatedButton.styleFrom(
                                                    backgroundColor: Colors.grey[300],
                                                    disabledBackgroundColor: Colors.grey[300],
                                                    foregroundColor: Colors.grey[600],
                                                    disabledForegroundColor: Colors.grey[600],
                                                    shape: RoundedRectangleBorder(
                                                      borderRadius: BorderRadius.circular(10),
                                                    ),
                                                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                                                    elevation: 0,
                                                  ),
                                                  child: const Row(
                                                    mainAxisSize: MainAxisSize.min,
                                                    children: [
                                                      Icon(Icons.lock, size: 14),
                                                      SizedBox(width: 4),
                                                      Text(
                                                        'Locked',
                                                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                                                      ),
                                                    ],
                                                  ),
                                                )
                                              else if (isCompleted)
                                                OutlinedButton(
                                                  onPressed: () {
                                                    Navigator.pushNamed(context, challenge["route"]);
                                                  },
                                                  style: OutlinedButton.styleFrom(
                                                    side: const BorderSide(color: Color(0xFF204A94), width: 1.5),
                                                    foregroundColor: const Color(0xFF204A94),
                                                    shape: RoundedRectangleBorder(
                                                      borderRadius: BorderRadius.circular(10),
                                                    ),
                                                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                                                  ),
                                                  child: const Text(
                                                    'Play Again',
                                                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                                                  ),
                                                )
                                              else
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
