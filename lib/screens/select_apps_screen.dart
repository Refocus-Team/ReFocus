import 'package:flutter/material.dart';
import '../models/app_state.dart';

class SelectAppsScreen extends StatefulWidget {
  const SelectAppsScreen({super.key});

  @override
  State<SelectAppsScreen> createState() => _SelectAppsScreenState();
}

class _SelectAppsScreenState extends State<SelectAppsScreen> with SingleTickerProviderStateMixin {
  late AnimationController _mascotController;
  late Animation<double> _mascotFloat;

  @override
  void initState() {
    super.initState();
    _mascotController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat(reverse: true);
    _mascotFloat = Tween<double>(begin: 0, end: -10).animate(
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
    final apps = state.selectedApps;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            children: [
              const SizedBox(height: 16),
              // Floating mascot
              AnimatedBuilder(
                animation: _mascotFloat,
                builder: (context, child) {
                  return Transform.translate(
                    offset: Offset(0, _mascotFloat.value),
                    child: child,
                  );
                },
                child: Image.asset(
                  'assets/mascot-select.png',
                  height: 120,
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) => const Icon(
                    Icons.apps_outlined,
                    size: 80,
                    color: Color(0xFF204A94),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              const Text(
                'Select Apps',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1B2755),
                ),
              ),
              const SizedBox(height: 4),
              const Text(
                'Pilih sosial media atau aplikasi yang anda ingin kelola',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF204A94),
                ),
              ),
              const SizedBox(height: 16),

              // Apps checklist scrollview
              Expanded(
                child: ListView.builder(
                  physics: const BouncingScrollPhysics(),
                  itemCount: apps.length,
                  itemBuilder: (context, index) {
                    final app = apps[index];
                    return GestureDetector(
                      onTap: () {
                        state.toggleAppSelection(index);
                      },
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        margin: const EdgeInsets.only(bottom: 12),
                        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: app.checked ? const Color(0xFF204A94) : const Color(0xFF1B2755).withOpacity(0.15),
                            width: app.checked ? 2.0 : 1.0,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.02),
                              blurRadius: 8,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Image.asset(
                                  'assets/${app.logo}',
                                  width: 32,
                                  height: 32,
                                  fit: BoxFit.contain,
                                  errorBuilder: (context, error, stackTrace) => Container(
                                    width: 32,
                                    height: 32,
                                    decoration: const BoxDecoration(
                                      color: Color(0xFFE3F0FB),
                                      shape: BoxShape.circle,
                                    ),
                                    child: const Icon(Icons.android, size: 20, color: Color(0xFF204A94)),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Text(
                                  app.name,
                                  style: const TextStyle(
                                    color: Color(0xFF204A94),
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              width: 22,
                              height: 22,
                              decoration: BoxDecoration(
                                color: app.checked ? const Color(0xFF204A94) : Colors.white,
                                border: Border.all(
                                  color: const Color(0xFF204A94),
                                  width: 2.0,
                                ),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: app.checked
                                  ? const Icon(
                                      Icons.check,
                                      size: 14,
                                      color: Colors.white,
                                    )
                                  : null,
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),

              // Bottom buttons
              Padding(
                padding: const EdgeInsets.only(bottom: 16.0, top: 12.0),
                child: Column(
                  children: [
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pushReplacementNamed(context, '/set-limit');
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF204A94),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          elevation: 3,
                          shadowColor: const Color(0xFF204A94).withOpacity(0.3),
                        ),
                        child: const Text(
                          'Continue',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    GestureDetector(
                      onTap: () {
                        Navigator.pushReplacementNamed(context, '/set-limit');
                      },
                      child: const Text(
                        'You can change this later',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: Colors.grey,
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
