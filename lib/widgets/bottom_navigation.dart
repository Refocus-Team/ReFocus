import 'dart:ui';
import 'package:flutter/material.dart';

class BottomNavigation extends StatelessWidget {
  final String activePage;

  const BottomNavigation({super.key, required this.activePage});

  @override
  Widget build(BuildContext context) {
    final items = [
      {'label': 'Home', 'icon': 'nav-home.png', 'route': '/home'},
      {'label': 'Statistics', 'icon': 'nav-stats.png', 'route': '/statistics'},
      {'label': 'Challenge', 'icon': 'nav-challenge.png', 'route': '/challenge'},
      {'label': 'Profile', 'icon': 'nav-profile.png', 'route': '/profile'},
    ];

    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 25,
              spreadRadius: 2,
              offset: const Offset(0, -6), // upward shadow projection
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
            child: Container(
              padding: const EdgeInsets.only(top: 14, bottom: 20, left: 16, right: 16),
              color: Colors.white.withOpacity(0.85),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: items.map((item) {
                  final label = item['label'] as String;
                  final iconName = item['icon'] as String;
                  final routeName = item['route'] as String;
                  final isActive = activePage.toLowerCase() == label.toLowerCase();

                  return GestureDetector(
                    onTap: () {
                      if (!isActive) {
                        Navigator.pushNamedAndRemoveUntil(
                          context,
                          routeName,
                          (route) => false,
                        );
                      }
                    },
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeOutBack,
                      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                      decoration: BoxDecoration(
                        color: isActive
                            ? const Color(0xFFE0F2FE)
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          AnimatedScale(
                            scale: isActive ? 1.15 : 1.0,
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeOutBack,
                            child: Image.asset(
                              'assets/$iconName',
                              width: 32,
                              height: 32,
                              color: isActive ? const Color(0xFF1B2755) : const Color(0xFF1B2755).withOpacity(0.4),
                              fit: BoxFit.contain,
                              errorBuilder: (context, error, stackTrace) {
                                return Icon(
                                  isActive ? Icons.star : Icons.star_border,
                                  color: isActive ? const Color(0xFF1B2755) : Colors.grey,
                                  size: 32,
                                );
                              },
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            label,
                            style: TextStyle(
                              fontSize: isActive ? 12 : 11,
                              fontWeight: isActive ? FontWeight.w800 : FontWeight.w600,
                              color: isActive ? const Color(0xFF1B2755) : Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
