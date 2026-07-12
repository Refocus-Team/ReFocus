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

    return SafeArea(
      bottom: false,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
          border: Border.all(color: const Color(0xFF1C3F95), width: 1.0),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 15,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
          child: Container(
            color: Colors.white,
            padding: const EdgeInsets.only(top: 8, bottom: 8, left: 12, right: 12),
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
                  child: Container(
                    width: 68,
                    height: 68, 
                    decoration: BoxDecoration(
                      color: isActive ? const Color(0xFFB3D4FF) : Colors.transparent,
                      shape: BoxShape.circle,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center, // Memusatkan konten agar tidak melar ke ujung
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Image.asset(
                          'assets/$iconName',
                          width: 28,
                          height: 28,
                          color: const Color(0xFF1C3F95),
                          fit: BoxFit.contain,
                          errorBuilder: (context, error, stackTrace) {
                            return Icon(
                              isActive ? Icons.star : Icons.star_border,
                              color: const Color(0xFF1C3F95),
                              size: 28,
                            );
                          },
                        ),
                        Text(
                          label,
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF1C3F95),
                            height: 1.0, // Memaksa ruang teks merapat ke atas tanpa jarak bawaan font
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(), // Tanda penutup toList yang sempat hilang sudah diperbaiki
            ),
          ),
        ),
      ),
    );
  }
}