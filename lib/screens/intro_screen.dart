import 'package:flutter/material.dart';

class IntroScreen extends StatefulWidget {
  const IntroScreen({super.key});

  @override
  State<IntroScreen> createState() => _IntroScreenState();
}

class _IntroScreenState extends State<IntroScreen> {
  final PageController _pageController = PageController();
  int _currentStep = 0;

  final List<Map<String, String>> _slides = [
    {
      "title": "Stay Focused, Achieve More",
      "description": "ReFocus helps you track screen time and build healthy digital habits.",
      "image": "assets/images/intro-1.png"
    },
    {
      "title": "Beat Distraction with Challenges",
      "description": "Complete engaging challenges to strengthen your focus and reduce screen-related distractions.",
      "image": "assets/images/intro-2.png"
    },
    {
      "title": "Track Progress, See Results",
      "description": "Monitor your progress, set goals, and celebrate your achievements in building better focus habits.",
      "image": "assets/images/intro-3.png"
    }
  ];

  void _handleNext() {
    if (_currentStep < _slides.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      Navigator.pushReplacementNamed(context, '/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
          child: Column(
            children: [
              Expanded(
                child: PageView.builder(
                  controller: _pageController,
                  onPageChanged: (index) {
                    setState(() {
                      _currentStep = index;
                    });
                  },
                  itemCount: _slides.length,
                  itemBuilder: (context, index) {
                    final slide = _slides[index];
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Slide Image
                        Expanded(
                          flex: 5,
                          child: Center(
                            child: Image.asset(
                              slide["image"]!,
                              width: MediaQuery.of(context).size.width * 0.7,
                              fit: BoxFit.contain,
                              errorBuilder: (context, error, stackTrace) {
                                return const Icon(
                                  Icons.image,
                                  size: 150,
                                  color: Color(0xFFA5C0DD),
                                );
                              },
                            ),
                          ),
                        ),
                        const SizedBox(height: 24),
                        // Slide Title
                        Text(
                          slide["title"]!,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF1B2755),
                            height: 1.2,
                          ),
                        ),
                        const SizedBox(height: 12),
                        // Slide Description
                        Text(
                          slide["description"]!,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 15,
                            color: Color(0xFF204A94),
                            height: 1.4,
                          ),
                        ),
                        const Spacer(flex: 1),
                      ],
                    );
                  },
                ),
              ),
              // Dots and Button Row
              Padding(
                padding: const EdgeInsets.only(bottom: 24.0),
                child: Column(
                  children: [
                    // Dynamic indicators
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(
                        _slides.length,
                        (index) => AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          margin: const EdgeInsets.symmetric(horizontal: 4.0),
                          width: index == _currentStep ? 24.0 : 8.0,
                          height: 8.0,
                          decoration: BoxDecoration(
                            color: index == _currentStep
                                ? const Color(0xFF1B2755)
                                : Colors.transparent,
                            border: Border.all(color: const Color(0xFF1B2755)),
                            borderRadius: BorderRadius.circular(4.0),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 32),
                    // Action button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _handleNext,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF1B2755),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          elevation: 2,
                        ),
                        child: Text(
                          _currentStep < _slides.length - 1 ? 'Next' : 'Start',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
