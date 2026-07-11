import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../widgets/bottom_navigation.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _focusReminderOn = true;
  bool _notificationOn = true;
  String _theme = "Light";
  String _dailyGoal = "2h 30m";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.only(left: 24, right: 24, bottom: 40),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),
              // Centered Header Title
              const Center(
                child: Text(
                  'Settings',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1C3F95),
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // General Group
              const Text(
                'General',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1B2755),
                ),
              ),
              const SizedBox(height: 10),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.grey.withValues(alpha: 0.15), width: 1.5),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.02),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    _buildSettingTile(
                      icon: Icons.person,
                      title: 'Profile',
                      onTap: () {
                        Navigator.pop(context);
                      },
                    ),
                    _buildDivider(),
                    _buildSettingTile(
                      icon: Icons.timer,
                      title: 'Daily Goal',
                      trailingText: _dailyGoal,
                      onTap: () {
                        _showDailyGoalDialog();
                      },
                    ),
                    _buildDivider(),
                    _buildSettingTile(
                      icon: Icons.notifications_active,
                      title: 'Focus Reminder',
                      trailingText: _focusReminderOn ? 'On' : 'Off',
                      onTap: () {
                        setState(() {
                          _focusReminderOn = !_focusReminderOn;
                        });
                        _showSnackBar('Focus Reminder turned ${_focusReminderOn ? 'On' : 'Off'}');
                      },
                    ),
                    _buildDivider(),
                    _buildSettingTile(
                      icon: Icons.notifications,
                      title: 'Notification',
                      trailingText: _notificationOn ? 'On' : 'Off',
                      onTap: () {
                        setState(() {
                          _notificationOn = !_notificationOn;
                        });
                        _showSnackBar('Notification turned ${_notificationOn ? 'On' : 'Off'}');
                      },
                    ),
                    _buildDivider(),
                    _buildSettingTile(
                      icon: Icons.palette,
                      title: 'Theme',
                      trailingText: _theme,
                      onTap: () {
                        setState(() {
                          _theme = _theme == 'Light' ? 'Dark' : 'Light';
                        });
                        _showSnackBar('Theme set to $_theme');
                      },
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Support Group
              const Text(
                'Support',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1B2755),
                ),
              ),
              const SizedBox(height: 10),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.grey.withValues(alpha: 0.15), width: 1.5),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.02),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    _buildSettingTile(
                      icon: Icons.help_outline,
                      title: 'Help Center',
                      onTap: () {
                        _showInfoDialog(
                          'Help Center',
                          'Butuh bantuan? Silakan hubungi tim dukungan kami di support@refocus.com atau kunjungi dokumentasi online.',
                        );
                      },
                    ),
                    _buildDivider(),
                    _buildSettingTile(
                      icon: Icons.verified_user,
                      title: 'Privacy Policy',
                      onTap: () {
                        _showInfoDialog(
                          'Privacy Policy',
                          'Privasi Anda sangat penting bagi kami. Kami berkomitmen untuk melindungi data pribadi dan privasi penggunaan waktu layar Anda.',
                        );
                      },
                    ),
                    _buildDivider(),
                    _buildSettingTile(
                      icon: Icons.assignment,
                      title: 'Terms of Use',
                      onTap: () {
                        _showInfoDialog(
                          'Terms of Use',
                          'Dengan menggunakan ReFocus, Anda menyetujui persyaratan penggunaan dan batasan waktu layar yang Anda buat sendiri untuk kebaikan fokus Anda.',
                        );
                      },
                    ),
                    _buildDivider(),
                    _buildSettingTile(
                      icon: Icons.info,
                      title: 'About ReFocus',
                      trailingText: 'v1.0.0',
                      onTap: () {
                        _showInfoDialog(
                          'About ReFocus',
                          'ReFocus App v1.0.0\n\nAplikasi asisten fokus digital dan pelacakan limit penggunaan sosial media untuk produktivitas optimal.',
                        );
                      },
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),
              // Logout Button
              Center(
                child: TextButton(
                  onPressed: () async {
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
                  child: const Text(
                    'Logout / Keluar',
                    style: TextStyle(
                      color: Colors.red,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: const BottomNavigation(activePage: 'profile'),
    );
  }

  Widget _buildSettingTile({
    required IconData icon,
    required String title,
    String? trailingText,
    required VoidCallback onTap,
  }) {
    return ListTile(
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      leading: Icon(icon, color: const Color(0xFF1C3F95), size: 24),
      title: Text(
        title,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          color: Color(0xFF1C3F95),
          fontSize: 14,
        ),
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (trailingText != null) ...[
            Text(
              trailingText,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Color(0xFF1C3F95),
                fontSize: 13,
              ),
            ),
            const SizedBox(width: 8),
          ],
          const Icon(Icons.chevron_right, color: Color(0xFF1C3F95), size: 20),
        ],
      ),
    );
  }

  Widget _buildDivider() {
    return Divider(
      height: 1,
      thickness: 1,
      color: Colors.grey.withValues(alpha: 0.15),
    );
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 2),
        backgroundColor: const Color(0xFF1C3F95),
      ),
    );
  }

  void _showInfoDialog(String title, String content) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(title, style: const TextStyle(color: Color(0xFF1B2755), fontWeight: FontWeight.bold)),
        content: Text(content, style: const TextStyle(color: Colors.black87)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Tutup', style: TextStyle(color: Color(0xFF1C3F95), fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  void _showDailyGoalDialog() {
    final controller = TextEditingController(text: _dailyGoal);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Set Daily Goal', style: TextStyle(color: Color(0xFF1B2755), fontWeight: FontWeight.bold)),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(
            hintText: 'e.g., 2h 30m',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal', style: TextStyle(color: Colors.grey)),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                _dailyGoal = controller.text.trim();
              });
              Navigator.pop(context);
              _showSnackBar('Daily Goal updated to $_dailyGoal');
            },
            child: const Text('Simpan', style: TextStyle(color: Color(0xFF1C3F95), fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }
}
