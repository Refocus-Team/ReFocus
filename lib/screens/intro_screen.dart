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
      "title": "Stay Focused,\nAchieve More",
      "description": "ReFocus membantu Anda melacak waktu layar, mengurangi gangguan, dan membangun kebiasaan yang lebih baik",
      "image": "assets/images/intro-1.png"
    },
    {
      "title": "Beat Distraction\nwith Challenges",
      "description": "Selesaikan tantangan seru dan edukatif, raih kembali fokusmu, dan dapatkan hadiahnya!",
      "image": "assets/images/intro-2.png"
    },
    {
      "title": "Track Progress,\nSee Results",
      "description": "Pantau progresmu, bangun konsistensi, dan jadilah versi terbaikmu.",
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
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        const SizedBox(height: 40),
                        // Slide Title
                        Text(
                          slide["title"]!,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.w900,
                            color: Color(0xFF1B2755),
                            height: 1.25,
                            letterSpacing: -0.5,
                          ),
                        ),
                        const Spacer(),
                        // Slide Image
                        Image.asset(
                          slide["image"]!,
                          width: MediaQuery.of(context).size.width * 0.75,
                          height: MediaQuery.of(context).size.height * 0.35,
                          fit: BoxFit.contain,
                          errorBuilder: (context, error, stackTrace) {
                            return const Icon(
                              Icons.image,
                              size: 150,
                              color: Color(0xFFA5C0DD),
                            );
                          },
                        ),
                        const Spacer(),
                        // Slide Description
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: Text(
                            slide["description"]!,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF204A94),
                              height: 1.4,
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
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
                    // Dynamic indicators (equal-sized circles)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(
                        _slides.length,
                        (index) => AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          margin: const EdgeInsets.symmetric(horizontal: 6.0),
                          width: 12.0,
                          height: 12.0,
                          decoration: BoxDecoration(
                            color: index == _currentStep
                                ? const Color(0xFF1B2755)
                                : Colors.transparent,
                            border: Border.all(
                              color: const Color(0xFF1B2755),
                              width: 1.5,
                            ),
                            shape: BoxShape.circle,
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
                        child: const Text(
                          'Next',
                          style: TextStyle(
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
