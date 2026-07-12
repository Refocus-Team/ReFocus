import 'dart:io';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import '../models/app_state.dart';
import '../widgets/bottom_navigation.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {

  Future<void> _pickProfileImage(AppState state) async {
    PermissionStatus status;

    if (Platform.isAndroid) {
      int sdkInt = 0;
      try {
        final sdkMatch = RegExp(r'SDK\s+(\d+)').firstMatch(Platform.operatingSystemVersion);
        if (sdkMatch != null) {
          sdkInt = int.parse(sdkMatch.group(1)!);
        }
      } catch (_) {}

      if (sdkInt >= 33) {
        status = await Permission.photos.request();
      } else {
        status = await Permission.storage.request();
      }
    } else {
      status = await Permission.photos.request();
    }

    if (status.isGranted || status.isLimited) {
      final ImagePicker picker = ImagePicker();
      try {
        final XFile? pickedFile = await picker.pickImage(
          source: ImageSource.gallery,
          maxWidth: 500,
          maxHeight: 500,
          imageQuality: 85,
        );

        if (pickedFile != null) {
          state.updateProfileImagePath(pickedFile.path);
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Foto profil berhasil diperbarui!'),
                backgroundColor: Colors.green,
              ),
            );
          }
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Gagal memilih gambar: $e'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    } else if (status.isPermanentlyDenied) {
      if (mounted) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Izin Galeri Ditolak'),
              content: const Text(
                'Anda telah menolak izin akses galeri secara permanen. '
                'Silakan aktifkan izin galeri secara manual di Pengaturan sistem untuk melanjutkan.',
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Batal'),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                    openAppSettings();
                  },
                  child: const Text('Buka Pengaturan'),
                ),
              ],
            );
          },
        );
      }
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Izin akses galeri ditolak.'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

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
    final isDark = state.themeMode == ThemeMode.dark;

    final scaffoldBg = isDark ? const Color(0xFF121212) : Colors.white;
    final cardBg = isDark ? const Color(0xFF1E1E1E) : Colors.white;
    final primaryTextColor = isDark ? const Color(0xFF9FA8DA) : const Color(0xFF1C3F95);
    final dividerColor = isDark ? Colors.white12 : Colors.grey.withOpacity(0.12);
    final shadowColor = isDark ? Colors.black.withOpacity(0.3) : Colors.black.withOpacity(0.04);
    final xpBgColor = isDark ? const Color(0xFF2D2D2D) : const Color(0xFFE2E8F5);

    return Scaffold(
      backgroundColor: scaffoldBg,
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.only(left: 24, right: 24, bottom: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 16),
              // Header settings icon row
              Align(
                alignment: Alignment.centerRight,
                child: GestureDetector(
                  onTap: () => Navigator.pushNamed(context, '/settings'),
                  child: Image.asset(
                    'assets/icon-settings.png',
                    width: 28,
                    height: 28,
                    color: primaryTextColor,
                    errorBuilder: (context, error, stackTrace) => Icon(Icons.settings, color: primaryTextColor),
                  ),
                ),
              ),

              // Profile Avatar
              const SizedBox(height: 12),
              Stack(
                clipBehavior: Clip.none,
                alignment: Alignment.center,
                children: [
                  Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.08),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(60),
                      child: state.profileImagePath != null && state.profileImagePath!.isNotEmpty
                          ? (kIsWeb
                              ? Image.network(
                                  state.profileImagePath!,
                                  width: 120,
                                  height: 120,
                                  fit: BoxFit.cover,
                                )
                              : Image.file(
                                  File(state.profileImagePath!),
                                  width: 120,
                                  height: 120,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) => Container(
                                    color: const Color(0xFFA5C0DD),
                                    child: const Icon(Icons.person, size: 60, color: Colors.white),
                                  ),
                                ))
                          : Image.asset(
                              'assets/profile-avatar.png',
                              width: 120,
                              height: 120,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) => Container(
                                color: const Color(0xFFA5C0DD),
                                child: const Icon(Icons.person, size: 60, color: Colors.white),
                              ),
                            ),
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: GestureDetector(
                      onTap: () => _pickProfileImage(state),
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: cardBg,
                          shape: BoxShape.circle,
                          border: Border.all(color: primaryTextColor, width: 1.5),
                          boxShadow: [
                            BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 4, offset: const Offset(0, 2)),
                          ],
                        ),
                        child: Icon(
                          Icons.camera_alt,
                          size: 18,
                          color: primaryTextColor,
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              // Name & Level
              const SizedBox(height: 16),
              Text(
                userName,
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: primaryTextColor,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                'Level 5 | Focus Master',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: primaryTextColor,
                ),
              ),

              // XP level slider progress bar
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    SizedBox(
                      width: double.infinity,
                      height: 10,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(5),
                        child: LinearProgressIndicator(
                          value: 520 / 800,
                          backgroundColor: xpBgColor,
                          valueColor: AlwaysStoppedAnimation<Color>(primaryTextColor),
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '520/800 XP',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: primaryTextColor,
                      ),
                    ),
                  ],
                ),
              ),

              // Stats row card
              const SizedBox(height: 24),
              Container(
                padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
                decoration: BoxDecoration(
                  color: cardBg,
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: dividerColor, width: 1.5),
                  boxShadow: [
                    BoxShadow(
                      color: shadowColor,
                      blurRadius: 15,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Column(
                      children: [
                        Text(
                          'Focus Score',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            color: primaryTextColor,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          '82',
                          style: TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            color: primaryTextColor,
                          ),
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        Text(
                          'Streak',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            color: primaryTextColor,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          '7 Days',
                          style: TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            color: primaryTextColor,
                          ),
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        Text(
                          'Challenge',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            color: primaryTextColor,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          '12',
                          style: TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            color: primaryTextColor,
                          ),
                        ),
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
                  Text(
                    'Achievements',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: primaryTextColor,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {},
                    child: Text(
                      'See all',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: primaryTextColor,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // Achievements horizontal list (distribute evenly)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  {'name': 'First step', 'img': 'ach-1.png'},
                  {'name': 'Time tracker', 'img': 'ach-2.png'},
                  {'name': 'Limit setter', 'img': 'ach-3.png'},
                  {'name': 'Locked in', 'img': 'ach-4.png'},
                ].map((ach) {
                  return Expanded(
                    child: Column(
                      children: [
                        Image.asset(
                          'assets/${ach["img"]}',
                          width: 64,
                          height: 64,
                          fit: BoxFit.contain,
                          errorBuilder: (context, error, stackTrace) => const Icon(
                            Icons.stars,
                            color: Colors.orange,
                            size: 48,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          ach["name"]!,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: primaryTextColor,
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),

              // History & Points navigation buttons
              const SizedBox(height: 24),
              Container(
                decoration: BoxDecoration(
                  color: cardBg,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: dividerColor, width: 1.5),
                  boxShadow: [
                    BoxShadow(
                      color: shadowColor,
                      blurRadius: 15,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    // Focus History
                    ListTile(
                      onTap: () => Navigator.pushNamed(context, '/focus-history'),
                      leading: Image.asset(
                        'assets/icon-history.png',
                        width: 28,
                        height: 28,
                        color: primaryTextColor,
                        errorBuilder: (context, error, stackTrace) => Icon(Icons.history, color: primaryTextColor),
                      ),
                      title: Text(
                        'Focus History',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: primaryTextColor,
                          fontSize: 14,
                        ),
                      ),
                      trailing: Icon(Icons.chevron_right, color: primaryTextColor, size: 22),
                    ),
                    Divider(height: 1, color: dividerColor),
                    // My Points
                    ListTile(
                      onTap: () => Navigator.pushNamed(context, '/points'),
                      leading: Image.asset(
                        'assets/icon-points.png',
                        width: 28,
                        height: 28,
                        color: primaryTextColor,
                        errorBuilder: (context, error, stackTrace) => Icon(Icons.toll, color: primaryTextColor),
                      ),
                      title: Text(
                        'My Points',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: primaryTextColor,
                          fontSize: 14,
                        ),
                      ),
                      trailing: Icon(Icons.chevron_right, color: primaryTextColor, size: 22),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: const BottomNavigation(activePage: 'profile'),
    );
  }
}
