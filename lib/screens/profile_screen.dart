import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/app_state.dart';
import '../widgets/bottom_navigation.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {

  void _showSettingsBottomSheet(BuildContext context, AppState state) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Container(
              padding: const EdgeInsets.all(24),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Settings',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1B2755),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Deep Work Mode Toggle (New Feature!)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Deep Work Mode',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF1B2755),
                            ),
                          ),
                          SizedBox(height: 2),
                          Text(
                            'Blokir semua notifikasi sosial media secara paksa',
                            style: TextStyle(fontSize: 11, color: Colors.grey),
                          ),
                        ],
                      ),
                      Switch(
                        value: state.deepWorkMode,
                        activeColor: const Color(0xFF204A94),
                        onChanged: (val) {
                          setModalState(() {
                            state.toggleDeepWorkMode(val);
                          });
                          setState(() {}); // Rebuild parent screen too
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  const Divider(),
                  const SizedBox(height: 12),

                  // Profile Info mockup
                  const Row(
                    children: [
                      Icon(Icons.person_outline, color: Color(0xFF204A94)),
                      SizedBox(width: 12),
                      Text(
                        'Edit Account Info',
                        style: TextStyle(fontWeight: FontWeight.w600, color: Color(0xFF1B2755)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  const Row(
                    children: [
                      Icon(Icons.shield_outlined, color: Color(0xFF204A94)),
                      SizedBox(width: 12),
                      Text(
                        'Privacy & Security',
                        style: TextStyle(fontWeight: FontWeight.w600, color: Color(0xFF1B2755)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  const Divider(),
                  const SizedBox(height: 12),
                  GestureDetector(
                    onTap: () async {
                      Navigator.pop(context); // Close bottom sheet
                      final prefs = await SharedPreferences.getInstance();
                      await prefs.setBool('isLoggedIn', false);
                      await prefs.setString('loggedInUserName', '');
                      if (context.mounted) {
                        Navigator.pushNamedAndRemoveUntil(
                          context,
                          '/login',
                          (route) => false,
                        );
                      }
                    },
                    child: const Row(
                      children: [
                        Icon(Icons.logout, color: Colors.red),
                        SizedBox(width: 12),
                        Text(
                          'Logout / Keluar',
                          style: TextStyle(fontWeight: FontWeight.w600, color: Colors.red),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                ],
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = AppStateProvider.of(context);
    final userName = state.userName;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      body: Stack(
        children: [
          SafeArea(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.only(left: 24, right: 24, bottom: 140),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 16),
                  // Header settings icon row
                  Align(
                    alignment: Alignment.centerRight,
                    child: GestureDetector(
                      onTap: () => _showSettingsBottomSheet(context, state),
                      child: Image.asset(
                        'assets/icon-settings.png',
                        width: 24,
                        height: 24,
                        errorBuilder: (context, error, stackTrace) => const Icon(Icons.settings, color: Color(0xFF1B2755)),
                      ),
                    ),
                  ),

                  // Profile Avatar
                  const SizedBox(height: 12),
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      // Avatar outer ring animation/glow
                      Container(
                        width: 118,
                        height: 118,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: state.deepWorkMode ? Colors.green : const Color(0xFF204A94).withOpacity(0.3),
                            width: 3,
                          ),
                        ),
                      ),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(55),
                        child: Image.asset(
                          'assets/profile-avatar.png',
                          width: 106,
                          height: 106,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) => Container(
                            width: 106,
                            height: 106,
                            color: const Color(0xFFA5C0DD),
                            child: const Icon(Icons.person, size: 50, color: Colors.white),
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 0,
                        right: 4,
                        child: Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.grey.withOpacity(0.1)),
                            boxShadow: [
                              BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 4, offset: const Offset(0, 2)),
                            ],
                          ),
                          child: Image.asset(
                            'assets/icon-camera.png',
                            width: 18,
                            height: 18,
                            errorBuilder: (context, error, stackTrace) => const Icon(Icons.camera_alt, size: 16),
                          ),
                        ),
                      ),
                    ],
                  ),

                  // Name & Level
                  const SizedBox(height: 16),
                  Text(
                    userName,
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1B2755),
                    ),
                  ),
                  const SizedBox(height: 2),
                  const Text(
                    'Level 5 | Focus Master',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF204A94),
                    ),
                  ),

                  // XP level slider progress bar
                  const SizedBox(height: 16),
                  SizedBox(
                    width: 260,
                    child: Column(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Container(
                            height: 10,
                            color: Colors.grey[200],
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Container(
                                width: 260 * 0.65, // 65% width representation
                                color: const Color(0xFF204A94),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 6),
                        const Text(
                          '520/800 XP',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF1B2755),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Stats row card
                  const SizedBox(height: 24),
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.grey.withOpacity(0.08)),
                      boxShadow: [
                        BoxShadow(color: Colors.black.withOpacity(0.01), blurRadius: 10, offset: const Offset(0, 4)),
                      ],
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Column(
                          children: [
                            Text('Focus Score', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF1B2755))),
                            SizedBox(height: 4),
                            Text('82', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Color(0xFF204A94))),
                          ],
                        ),
                        Column(
                          children: [
                            Text('Streak', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF1B2755))),
                            SizedBox(height: 4),
                            Text('7 Days', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Color(0xFF204A94))),
                          ],
                        ),
                        Column(
                          children: [
                            Text('Challenge', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF1B2755))),
                            SizedBox(height: 4),
                            Text('12', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Color(0xFF204A94))),
                          ],
                        ),
                      ],
                    ),
                  ),

                  // Achievements header
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Achievements',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF1B2755)),
                      ),
                      GestureDetector(
                        onTap: () {},
                        child: const Text(
                          'See all',
                          style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF204A94)),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  // Achievements horizontal list
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    physics: const BouncingScrollPhysics(),
                    child: Row(
                      children: [
                        {'name': 'First step', 'img': 'ach-1.png'},
                        {'name': 'Time tracker', 'img': 'ach-2.png'},
                        {'name': 'Limit setter', 'img': 'ach-3.png'},
                        {'name': 'Locked in', 'img': 'ach-4.png'},
                      ].map((ach) {
                        return Container(
                          margin: const EdgeInsets.only(right: 14),
                          width: 80,
                          child: Column(
                            children: [
                              Image.asset(
                                'assets/${ach["img"]}',
                                width: 56,
                                height: 56,
                                fit: BoxFit.contain,
                                errorBuilder: (context, error, stackTrace) => const Icon(Icons.stars, color: Colors.orange, size: 40),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                ach["name"]!,
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF204A94),
                                ),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                    ),
                  ),

                  // History & Points navigation buttons
                  const SizedBox(height: 28),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.grey.withOpacity(0.08)),
                    ),
                    child: Column(
                      children: [
                        // Focus History (New Target Screen!)
                        ListTile(
                          onTap: () => Navigator.pushNamed(context, '/focus-history'),
                          leading: Image.asset(
                            'assets/icon-history.png',
                            width: 24,
                            height: 24,
                            errorBuilder: (context, error, stackTrace) => const Icon(Icons.history, color: Color(0xFF1B2755)),
                          ),
                          title: const Text(
                            'Focus History',
                            style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF1B2755), fontSize: 14),
                          ),
                          trailing: const Icon(Icons.chevron_right, color: Colors.grey, size: 20),
                        ),
                        Divider(height: 1, color: const Color(0xFFA5C0DD).withOpacity(0.2)),
                        // My Points
                        ListTile(
                          onTap: () => Navigator.pushNamed(context, '/points'),
                          leading: Image.asset(
                            'assets/icon-points.png',
                            width: 24,
                            height: 24,
                            errorBuilder: (context, error, stackTrace) => const Icon(Icons.toll, color: Color(0xFF1B2755)),
                          ),
                          title: const Text(
                            'My Points',
                            style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF1B2755), fontSize: 14),
                          ),
                          trailing: const Icon(Icons.chevron_right, color: Colors.grey, size: 20),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          const BottomNavigation(activePage: 'profile'),
        ],
      ),
    );
  }
}
