import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import '../models/app_state.dart';

class PatternRecallScreen extends StatefulWidget {
  const PatternRecallScreen({super.key});

  @override
  State<PatternRecallScreen> createState() => _PatternRecallScreenState();
}

class _PatternRecallScreenState extends State<PatternRecallScreen> {
  int _level = 1;
  final int _maxLevels = 4; // Length 3, 4, 5, 6
  List<int> _sequence = [];
  List<int> _userSequence = [];
  bool _isDisplayingSequence = false;
  bool _isGameActive = false;
  bool _gameCompleted = false;
  bool _failed = false;

  int? _flashingIndex;

  final Random _random = Random();

  @override
  void initState() {
    super.initState();
    _startNewGame();
  }

  void _startNewGame() {
    _level = 1;
    _sequence.clear();
    _userSequence.clear();
    _gameCompleted = false;
    _failed = false;
    _isGameActive = true;
    _generateNextRound();
  }

  void _generateNextRound() {
    _userSequence.clear();
    // Add one random index (0-8) to the sequence
    _sequence.add(_random.nextInt(9));
    _playSequence();
  }

  Future<void> _playSequence() async {
    setState(() {
      _isDisplayingSequence = true;
      _flashingIndex = null;
    });

    await Future.delayed(const Duration(milliseconds: 500));

    for (int index in _sequence) {
      if (!mounted || !_isGameActive) return;
      setState(() {
        _flashingIndex = index;
      });
      await Future.delayed(const Duration(milliseconds: 600));
      if (!mounted || !_isGameActive) return;
      setState(() {
        _flashingIndex = null;
      });
      await Future.delayed(const Duration(milliseconds: 250));
    }

    if (mounted) {
      setState(() {
        _isDisplayingSequence = false;
      });
    }
  }

  void _handleCellClick(int index) {
    if (!_isGameActive || _isDisplayingSequence || _gameCompleted || _failed) return;

    setState(() {
      _userSequence.add(index);
    });

    // Check if the input is correct so far
    final checkIndex = _userSequence.length - 1;
    if (_userSequence[checkIndex] != _sequence[checkIndex]) {
      // Incorrect sequence!
      setState(() {
        _failed = true;
        _isGameActive = false;
      });
      return;
    }

    // Check if user completed the round
    if (_userSequence.length == _sequence.length) {
      if (_level == _maxLevels) {
        _handleGameCompletion();
      } else {
        setState(() {
          _level++;
        });
        Future.delayed(const Duration(milliseconds: 800), () {
          if (mounted) {
            _generateNextRound();
          }
        });
      }
    }
  }

  void _handleGameCompletion() {
    setState(() {
      _gameCompleted = true;
      _isGameActive = false;
    });

    // Update global points
    final state = AppStateProvider.of(context);
    state.addPoints(25);
    state.addFocusHistory("Menyelesaikan Pattern Recall", "+25 Poin");
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
                        'Pattern Recall',
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

                  // Level Indicator
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      border: Border.all(color: const Color(0xFFA5C0DD)),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Text(
                      'Level $_level of $_maxLevels',
                      style: const TextStyle(
                        color: Color(0xFFA5C0DD),
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Prompt Text
                  Text(
                    _isDisplayingSequence
                        ? 'Perhatikan Pola di Bawah...'
                        : 'Ulangi Pola Sesuai Urutan!',
                    style: TextStyle(
                      color: _isDisplayingSequence ? const Color(0xFF38BDF8) : Colors.greenAccent,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 32),

                  // 3x3 Grid
                  Expanded(
                    child: Center(
                      child: AspectRatio(
                        aspectRatio: 1.0,
                        child: GridView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
                            crossAxisSpacing: 16,
                            mainAxisSpacing: 16,
                          ),
                          itemCount: 9,
                          itemBuilder: (context, index) {
                            final isFlashing = _flashingIndex == index;
                            return GestureDetector(
                              onTapDown: (_) => _handleCellClick(index),
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 150),
                                decoration: BoxDecoration(
                                  color: isFlashing
                                      ? const Color(0xFF38BDF8)
                                      : Colors.white.withOpacity(0.08),
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(
                                    color: isFlashing
                                        ? const Color(0xFF38BDF8)
                                        : Colors.white.withOpacity(0.15),
                                    width: 2,
                                  ),
                                  boxShadow: isFlashing
                                      ? [
                                          BoxShadow(
                                            color: const Color(0xFF38BDF8).withOpacity(0.6),
                                            blurRadius: 20,
                                            spreadRadius: 2,
                                          )
                                        ]
                                      : [],
                                ),
                                child: Center(
                                  child: Icon(
                                    Icons.lens,
                                    size: 16,
                                    color: isFlashing ? Colors.white : Colors.white24,
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),
                ],
              ),
            ),

            // Game Completed overlay
            if (_gameCompleted)
              Container(
                color: Colors.black.withOpacity(0.75),
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
                        const Text(
                          'Great job! You recalled all patterns correctly and earned +25 points!',
                          textAlign: TextAlign.center,
                          style: TextStyle(
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
                color: Colors.black.withOpacity(0.75),
                child: Center(
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 32),
                    padding: const EdgeInsets.all(28),
                    decoration: BoxDecoration(
                      color: const Color(0xFF1B2755),
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(color: Colors.red.withOpacity(0.5), width: 1.5),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text(
                          'Salah Urutan!',
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
                          'Anda gagal mengingat pola pada Level $_level.',
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
