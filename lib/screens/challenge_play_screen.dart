import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import '../models/app_state.dart';

class ChallengePlayScreen extends StatefulWidget {
  const ChallengePlayScreen({super.key});

  @override
  State<ChallengePlayScreen> createState() => _ChallengePlayScreenState();
}

class _ChallengePlayScreenState extends State<ChallengePlayScreen> {
  late List<String> _cards;
  late List<bool> _cardFlipped;
  late List<bool> _cardMatched;
  final List<int> _selectedIndices = [];

  int _timeLeft = 90;
  Timer? _timer;
  bool _isGameActive = true;
  bool _gameCompleted = false;

  final List<String> _iconsList = [
    'coin-icon.png',
    'coin-icon.png',  
    'icon-usage.png',
    'icon-usage.png',
    'apple-icon.png',
    'apple-icon.png',
    'google-icon.png',
    'google-icon.png',
    'apple-icon.png',
    'apple-icon.png',
    'google-icon.png',
    'google-icon.png'
  ];

  @override
  void initState() {
    super.initState();
    _initializeGame();
    _startTimer();
  }

  void _initializeGame() {
    _cards = List.from(_iconsList)..shuffle();
    _cardFlipped = List.generate(12, (_) => false);
    _cardMatched = List.generate(12, (_) => false);
    _selectedIndices.clear();
    _timeLeft = 90;
    _gameCompleted = false;
    _isGameActive = true;
  }

  void _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!_isGameActive || _gameCompleted) return;
      if (_timeLeft > 0) {
        setState(() {
          _timeLeft--;
        });
      } else {
        _handleGameOver();
      }
    });
  }

  void _handleGameOver() {
    _timer?.cancel();
    setState(() {
      _isGameActive = false;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Waktu habis! Coba lagi.'),
        backgroundColor: Colors.red,
      ),
    );
  }

  void _handleCardClick(int index) {
    if (!_isGameActive || _cardMatched[index] || _cardFlipped[index] || _selectedIndices.length >= 2) {
      return;
    }

    setState(() {
      _cardFlipped[index] = true;
      _selectedIndices.add(index);
    });

    if (_selectedIndices.length == 2) {
      final firstIdx = _selectedIndices[0];
      final secondIdx = _selectedIndices[1];

      if (_cards[firstIdx] == _cards[secondIdx]) {
        // Match found!
        setState(() {
          _cardMatched[firstIdx] = true;
          _cardMatched[secondIdx] = true;
          _selectedIndices.clear();
        });

        // Check win condition
        if (_cardMatched.every((matched) => matched)) {
          _handleGameCompletion();
        }
      } else {
        // No match, flip back after a delay
        Future.delayed(const Duration(milliseconds: 800), () {
          if (mounted) {
            setState(() {
              _cardFlipped[firstIdx] = false;
              _cardFlipped[secondIdx] = false;
              _selectedIndices.clear();
            });
          }
        });
      }
    }
  }

  void _handleGameCompletion() {
    _timer?.cancel();
    setState(() {
      _gameCompleted = true;
      _isGameActive = false;
    });

    // Update global points
    final state = AppStateProvider.of(context);
    state.addPoints(10);
    state.addFocusHistory("Menyelesaikan Memory Match", "+10 Poin");
  }

  String _formatTime(int seconds) {
    final mins = seconds ~/ 60;
    final secs = seconds % 60;
    return "$mins:${secs.toString().padLeft(2, '0')}";
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
                  // Header row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: const Icon(Icons.arrow_back, color: Colors.white, size: 28),
                      ),
                      const Text(
                        'Memory Match',
                        style: TextStyle(
                          fontSize: 20,
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

                  // Timer Badge
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
                          '01:${_formatTime(_timeLeft).substring(2)}',
                          style: const TextStyle(
                            color: Color(0xFFA5C0DD),
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 32),

                  // Cards Grid
                  Expanded(
                    child: GridView.builder(
                      // MODIFIKASI: Mengubah dari NeverScrollableScrollPhysics agar bisa di-scroll
                      physics: const BouncingScrollPhysics(), 
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        crossAxisSpacing: 12,
                        mainAxisSpacing: 12,
                        childAspectRatio: 0.75,
                      ),
                      itemCount: 12,
                      itemBuilder: (context, index) {
                        return MemoryCard(
                          isFlipped: _cardFlipped[index] || _cardMatched[index],
                          iconPath: _cards[index],
                          onTap: () => _handleCardClick(index),
                        );
                      },
                    ),
                  ),

                  // Pause Button
                  Padding(
                    padding: const EdgeInsets.only(top: 16.0),
                    child: SizedBox(
                      width: double.infinity,
                      child: OutlinedButton.icon(
                        onPressed: () {
                          setState(() {
                            _isGameActive = !_isGameActive;
                          });
                          if (_isGameActive) {
                            _startTimer();
                          } else {
                            _timer?.cancel();
                          }
                        },
                        icon: Icon(
                          _isGameActive ? Icons.pause : Icons.play_arrow,
                          color: Colors.white,
                        ),
                        label: Text(
                          _isGameActive ? 'Pause' : 'Resume',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.white,
                          side: const BorderSide(color: Color(0xFFA5C0DD)),
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Game Completed Victory Modal overlay
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
                        const Text(
                          'Great job! You earned +10 points!',
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
          ],
        ),
      ),
    );
  }
}

// 3D Flippable MemoryCard widget using Transform
class MemoryCard extends StatefulWidget {
  final bool isFlipped;
  final String iconPath;
  final VoidCallback onTap;

  const MemoryCard({
    super.key,
    required this.isFlipped,
    required this.iconPath,
    required this.onTap,
  });

  @override
  State<MemoryCard> createState() => _MemoryCardState();
}

class _MemoryCardState extends State<MemoryCard> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 350),
    );
    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(_controller);
    if (widget.isFlipped) {
      _controller.value = 1.0;
    }
  }

  @override
  void didUpdateWidget(covariant MemoryCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isFlipped != oldWidget.isFlipped) {
      if (widget.isFlipped) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: AnimatedBuilder(
        animation: _animation,
        builder: (context, child) {
          final double angle = _animation.value * pi;
          final bool showFront = angle >= pi / 2;

          return Transform(
            transform: Matrix4.identity()
              ..setEntry(3, 2, 0.002) // Perspective factor
              ..rotateY(angle),
            alignment: Alignment.center,
            child: showFront
                ? Transform(
                    transform: Matrix4.identity()..rotateY(pi),
                    alignment: Alignment.center,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.1),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      padding: const EdgeInsets.all(12),
                      child: Image.asset(
                        'assets/${widget.iconPath}',
                        fit: BoxFit.contain,
                        errorBuilder: (context, error, stackTrace) => const Icon(Icons.image, color: Colors.grey),
                      ),
                    ),
                  )
                : Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFF204A94),
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.15),
                          blurRadius: 6,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: const Center(
                      child: Icon(
                        Icons.question_mark,
                        color: Colors.white38,
                        size: 28,
                      ),
                    ),
                  ),
          );
        },
      ),
    );
  }
}
