import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import '../models/app_state.dart';

class MathSprintScreen extends StatefulWidget {
  const MathSprintScreen({super.key});

  @override
  State<MathSprintScreen> createState() => _MathSprintScreenState();
}

class _MathSprintScreenState extends State<MathSprintScreen> {
  int _score = 0;
  int _timeLeft = 30;
  Timer? _timer;
  bool _isGameActive = false;
  bool _gameCompleted = false;
  bool _failed = false;

  late String _question;
  late int _correctAnswer;
  late List<int> _options;

  final Random _random = Random();

  @override
  void initState() {
    super.initState();
    _startNewGame();
  }

  void _startNewGame() {
    _score = 0;
    _timeLeft = 30;
    _gameCompleted = false;
    _failed = false;
    _isGameActive = true;
    _generateQuestion();
    _startTimer();
  }

  void _generateQuestion() {
    final type = _random.nextInt(3); // 0: add, 1: sub, 2: mult
    int a, b;
    if (type == 0) {
      a = _random.nextInt(80) + 10;
      b = _random.nextInt(80) + 10;
      _question = "$a + $b";
      _correctAnswer = a + b;
    } else if (type == 1) {
      a = _random.nextInt(80) + 20;
      b = _random.nextInt(a - 10) + 5;
      _question = "$a - $b";
      _correctAnswer = a - b;
    } else {
      a = _random.nextInt(10) + 3;
      b = _random.nextInt(10) + 3;
      _question = "$a × $b";
      _correctAnswer = a * b;
    }

    // Generate options
    final Set<int> optionsSet = {_correctAnswer};
    while (optionsSet.length < 4) {
      final offset = _random.nextInt(10) - 5;
      final dummy = _correctAnswer + offset;
      if (dummy > 0 && dummy != _correctAnswer) {
        optionsSet.add(dummy);
      }
    }
    _options = optionsSet.toList()..shuffle();
  }

  void _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!_isGameActive || _gameCompleted || _failed) return;
      if (_timeLeft > 0) {
        setState(() {
          _timeLeft--;
        });
      } else {
        _handleTimeUp();
      }
    });
  }

  void _handleTimeUp() {
    _timer?.cancel();
    setState(() {
      _isGameActive = false;
    });

    if (_score >= 8) {
      _handleGameCompletion();
    } else {
      setState(() {
        _failed = true;
      });
    }
  }

  void _handleGameCompletion() {
    setState(() {
      _gameCompleted = true;
      _isGameActive = false;
    });

    // Update global points
    final state = AppStateProvider.of(context);
    state.addPoints(20);
    state.addFocusHistory("Menyelesaikan Math Sprint", "+20 Poin");
  }

  void _handleOptionClick(int selectedOption) {
    if (!_isGameActive || _gameCompleted || _failed) return;

    if (selectedOption == _correctAnswer) {
      setState(() {
        _score++;
      });
    }

    setState(() {
      _generateQuestion();
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = AppStateProvider.of(context);
    final points = state.points;

    return Scaffold(
      backgroundColor: const Color(0xFF1B2755),
      body: SafeArea(
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                children: [
                  // Header Row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: const Icon(Icons.arrow_back, color: Colors.white, size: 28),
                      ),
                      const Text(
                        'Math Sprint',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      Row(
                        children: [
                          Image.asset('assets/coin-icon.png', width: 20, height: 20),
                          const SizedBox(width: 4),
                          Text(
                            '$points',
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Timer & Target Badge
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(
                          border: Border.all(color: const Color(0xFFA5C0DD)),
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.access_time, color: Color(0xFFA5C0DD), size: 18),
                            const SizedBox(width: 8),
                            Text(
                              '00:$_timeLeft',
                              style: const TextStyle(
                                color: Color(0xFFA5C0DD),
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 12),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(
                          color: const Color(0xFF204A94),
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: Text(
                          'Score: $_score/8 to Win',
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 40),

                  // Question Card
                  Expanded(
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(32),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.08),
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(color: Colors.white.withValues(alpha: 0.15)),
                      ),
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              'Berapa hasil dari:',
                              style: TextStyle(
                                color: Colors.white60,
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 20),
                            Text(
                              _question,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 64,
                                fontWeight: FontWeight.w900,
                                letterSpacing: 2,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),

                  // Options Grid
                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                      childAspectRatio: 1.6,
                    ),
                    itemCount: 4,
                    itemBuilder: (context, index) {
                      final option = _options[index];
                      return ElevatedButton(
                        onPressed: () => _handleOptionClick(option),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF204A94),
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          elevation: 2,
                        ),
                        child: Text(
                          '$option',
                          style: const TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),

            // Game Completed overlay
            if (_gameCompleted)
              Container(
                color: Colors.black.withValues(alpha: 0.75),
                child: Center(
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 32),
                    padding: const EdgeInsets.all(28),
                    decoration: BoxDecoration(
                      color: const Color(0xFF1B2755),
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(color: const Color(0xFFA5C0DD), width: 1.5),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text(
                          'Challenge Completed!',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 20),
                        Image.asset(
                          'assets/mascot-cool.png',
                          width: 100,
                          height: 100,
                          fit: BoxFit.contain,
                          errorBuilder: (context, error, stackTrace) => const Icon(Icons.stars, color: Colors.amber, size: 80),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Great job! You answered $_score questions correctly and earned +20 points!',
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.white70,
                          ),
                        ),
                        const SizedBox(height: 24),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF204A94),
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: const Text(
                              'Back to Challenge Menu',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

            // Failed overlay
            if (_failed)
              Container(
                color: Colors.black.withValues(alpha: 0.75),
                child: Center(
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 32),
                    padding: const EdgeInsets.all(28),
                    decoration: BoxDecoration(
                      color: const Color(0xFF1B2755),
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(color: Colors.red.withValues(alpha: 0.5), width: 1.5),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text(
                          'Waktu Habis!',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 20),
                        const Icon(Icons.sentiment_dissatisfied, color: Colors.redAccent, size: 80),
                        const SizedBox(height: 16),
                        Text(
                          'Skor Anda $_score. Target minimal adalah 8 jawaban benar.',
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.white70,
                          ),
                        ),
                        const SizedBox(height: 24),
                        Row(
                          children: [
                            Expanded(
                              child: OutlinedButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                style: OutlinedButton.styleFrom(
                                  foregroundColor: Colors.white,
                                  side: const BorderSide(color: Color(0xFFA5C0DD)),
                                  padding: const EdgeInsets.symmetric(vertical: 14),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                                child: const Text('Keluar'),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: ElevatedButton(
                                onPressed: () {
                                  setState(() {
                                    _startNewGame();
                                  });
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF204A94),
                                  foregroundColor: Colors.white,
                                  padding: const EdgeInsets.symmetric(vertical: 14),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                                child: const Text(
                                  'Coba Lagi',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
