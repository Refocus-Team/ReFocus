import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/app_state.dart';
import '../widgets/bottom_navigation.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _focusReminderOn = true;
  bool _notificationOn = true;
  String _dailyGoal = "2h 30m";

  @override
  Widget build(BuildContext context) {
    final state = AppStateProvider.of(context);
    final isDark = state.themeMode == ThemeMode.dark;

    final scaffoldBg = isDark ? const Color(0xFF121212) : Colors.white;
    final cardBg = isDark ? const Color(0xFF1E1E1E) : Colors.white;
    final primaryTextColor = isDark ? const Color(0xFF9FA8DA) : const Color(0xFF1C3F95);
    final secondaryTextColor = isDark ? Colors.white : const Color(0xFF1B2755);
    final textStyleColor = isDark ? Colors.white70 : Colors.black87;
    final dividerColor = isDark ? Colors.white12 : Colors.grey.withOpacity(0.15);
    final shadowColor = isDark ? Colors.black.withOpacity(0.3) : Colors.black.withOpacity(0.02);

    return Scaffold(
      backgroundColor: scaffoldBg,
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.only(left: 24, right: 24, bottom: 40),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),
              // Centered Header Title
              Center(
                child: Text(
                  'Settings',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: primaryTextColor,
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // General Group
              Text(
                'General',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: secondaryTextColor,
                ),
              ),
              const SizedBox(height: 10),
              Container(
                decoration: BoxDecoration(
                  color: cardBg,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: dividerColor, width: 1.5),
                  boxShadow: [
                    BoxShadow(
                      color: shadowColor,
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
                      color: primaryTextColor,
                      onTap: () {
                        Navigator.pop(context);
                      },
                    ),
                    _buildDivider(dividerColor),
                    _buildSettingTile(
                      icon: Icons.timer,
                      title: 'Daily Goal',
                      trailingText: _dailyGoal,
                      color: primaryTextColor,
                      onTap: () {
                        _showDailyGoalDialog(cardBg, secondaryTextColor, primaryTextColor, dividerColor);
                      },
                    ),
                    _buildDivider(dividerColor),
                    _buildSettingTile(
                      icon: Icons.notifications_active,
                      title: 'Focus Reminder',
                      trailingText: _focusReminderOn ? 'On' : 'Off',
                      color: primaryTextColor,
                      onTap: () {
                        setState(() {
                          _focusReminderOn = !_focusReminderOn;
                        });
                        _showSnackBar('Focus Reminder turned ${_focusReminderOn ? 'On' : 'Off'}', primaryTextColor);
                      },
                    ),
                    _buildDivider(dividerColor),
                    _buildSettingTile(
                      icon: Icons.notifications,
                      title: 'Notification',
                      trailingText: _notificationOn ? 'On' : 'Off',
                      color: primaryTextColor,
                      onTap: () {
                        setState(() {
                          _notificationOn = !_notificationOn;
                        });
                        _showSnackBar('Notification turned ${_notificationOn ? 'On' : 'Off'}', primaryTextColor);
                      },
                    ),
                    _buildDivider(dividerColor),
                    _buildSettingTile(
                      icon: Icons.palette,
                      title: 'Theme',
                      trailingText: isDark ? 'Dark' : 'Light',
                      color: primaryTextColor,
                      onTap: () {
                        state.toggleThemeMode();
                        _showSnackBar('Theme set to ${!isDark ? 'Dark' : 'Light'}', primaryTextColor);
                      },
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Support Group
              Text(
                'Support',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: secondaryTextColor,
                ),
              ),
              const SizedBox(height: 10),
              Container(
                decoration: BoxDecoration(
                  color: cardBg,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: dividerColor, width: 1.5),
                  boxShadow: [
                    BoxShadow(
                      color: shadowColor,
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
                      color: primaryTextColor,
                      onTap: () {
                        _showInfoDialog(
                          'Help Center',
                          'Butuh bantuan? Silakan hubungi tim dukungan kami di support@refocus.com atau kunjungi dokumentasi online.',
                          cardBg,
                          secondaryTextColor,
                          textStyleColor,
                          primaryTextColor,
                        );
                      },
                    ),
                    _buildDivider(dividerColor),
                    _buildSettingTile(
                      icon: Icons.verified_user,
                      title: 'Privacy Policy',
                      color: primaryTextColor,
                      onTap: () {
                        _showInfoDialog(
                          'Privacy Policy',
                          'Privasi Anda sangat penting bagi kami. Kami berkomitmen untuk melindungi data pribadi dan privasi penggunaan waktu layar Anda.',
                          cardBg,
                          secondaryTextColor,
                          textStyleColor,
                          primaryTextColor,
                        );
                      },
                    ),
                    _buildDivider(dividerColor),
                    _buildSettingTile(
                      icon: Icons.assignment,
                      title: 'Terms of Use',
                      color: primaryTextColor,
                      onTap: () {
                        _showInfoDialog(
                          'Terms of Use',
                          'Dengan menggunakan ReFocus, Anda menyetujui persyaratan penggunaan dan batasan waktu layar yang Anda buat sendiri untuk kebaikan fokus Anda.',
                          cardBg,
                          secondaryTextColor,
                          textStyleColor,
                          primaryTextColor,
                        );
                      },
                    ),
                    _buildDivider(dividerColor),
                    _buildSettingTile(
                      icon: Icons.info,
                      title: 'About ReFocus',
                      trailingText: 'v1.0.0',
                      color: primaryTextColor,
                      onTap: () {
                        _showInfoDialog(
                          'About ReFocus',
                          'ReFocus App v1.0.0\n\nAplikasi asisten fokus digital dan pelacakan limit penggunaan sosial media untuk produktivitas optimal.',
                          cardBg,
                          secondaryTextColor,
                          textStyleColor,
                          primaryTextColor,
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
    required Color color,
  }) {
    return ListTile(
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      leading: Icon(icon, color: color, size: 24),
      title: Text(
        title,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: color,
          fontSize: 14,
        ),
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (trailingText != null) ...[
            Text(
              trailingText,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: color,
                fontSize: 13,
              ),
            ),
            const SizedBox(width: 8),
          ],
          Icon(Icons.chevron_right, color: color, size: 20),
        ],
      ),
    );
  }

  Widget _buildDivider(Color color) {
    return Divider(
      height: 1,
      thickness: 1,
      color: color,
    );
  }

  void _showSnackBar(String message, Color bgColor) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 2),
        backgroundColor: bgColor,
      ),
    );
  }

  void _showInfoDialog(
    String title,
    String content,
    Color cardBg,
    Color secondaryTextColor,
    Color textStyleColor,
    Color buttonColor,
  ) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: cardBg,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(title, style: TextStyle(color: secondaryTextColor, fontWeight: FontWeight.bold)),
        content: Text(content, style: TextStyle(color: textStyleColor)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Tutup', style: TextStyle(color: buttonColor, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  void _showDailyGoalDialog(
    Color cardBg,
    Color secondaryTextColor,
    Color buttonColor,
    Color borderColor,
  ) {
    final controller = TextEditingController(text: _dailyGoal);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: cardBg,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text('Set Daily Goal', style: TextStyle(color: secondaryTextColor, fontWeight: FontWeight.bold)),
        content: TextField(
          controller: controller,
          style: TextStyle(color: secondaryTextColor),
          decoration: InputDecoration(
            hintText: 'e.g., 2h 30m',
            hintStyle: const TextStyle(color: Colors.grey),
            enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: borderColor)),
            focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: buttonColor)),
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
              _showSnackBar('Daily Goal updated to $_dailyGoal', buttonColor);
            },
            child: Text('Simpan', style: TextStyle(color: buttonColor, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }
}
