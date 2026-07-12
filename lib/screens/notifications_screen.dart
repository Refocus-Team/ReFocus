import 'package:flutter/material.dart';
import '../models/app_state.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  @override
  void initState() {
    super.initState();
    // Mark all notifications as read when the screen is viewed
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        AppStateProvider.of(context).markNotificationsAsRead();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = AppStateProvider.of(context);
    final notifications = state.notifications;
    final isDark = state.themeMode == ThemeMode.dark;

    final scaffoldBg = isDark ? const Color(0xFF121212) : const Color(0xFFF5F7FA);
    final cardBg = isDark ? const Color(0xFF1E1E1E) : Colors.white;
    final appBarBg = isDark ? const Color(0xFF1E1E1E) : Colors.white;
    final primaryTextColor = isDark ? const Color(0xFF9FA8DA) : const Color(0xFF204A94);
    final secondaryTextColor = isDark ? Colors.white : const Color(0xFF1B2755);
    final dividerColor = isDark ? Colors.white12 : Colors.grey.withOpacity(0.08);
    final shadowColor = isDark ? Colors.black.withOpacity(0.3) : Colors.black.withOpacity(0.01);

    return Scaffold(
      backgroundColor: scaffoldBg,
      appBar: AppBar(
        backgroundColor: appBarBg,
        elevation: 0.5,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(Icons.arrow_back, color: secondaryTextColor),
        ),
        title: Text(
          'Notifikasi',
          style: TextStyle(
            color: secondaryTextColor,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        actions: [
          if (notifications.isNotEmpty)
            TextButton(
              onPressed: () {
                state.clearNotifications();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Semua notifikasi dibersihkan.')),
                );
              },
              child: Text(
                'Clear All',
                style: TextStyle(
                  color: primaryTextColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
        ],
      ),
      body: notifications.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: isDark ? const Color(0xFF1E293B) : const Color(0xFFE3F0FB),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.notifications_off_outlined,
                      size: 64,
                      color: isDark ? const Color(0xFF38BDF8) : const Color(0xFF204A94),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Tidak Ada Notifikasi',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: secondaryTextColor,
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'Semua bersih! Anda tidak memiliki peringatan baru.',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            )
          : ListView.builder(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              itemCount: notifications.length,
              itemBuilder: (context, index) {
                final notif = notifications[index];
                IconData iconData = Icons.info_outline;
                Color iconColor = isDark ? const Color(0xFF38BDF8) : const Color(0xFF204A94);
                Color iconBgColor = isDark ? const Color(0xFF25407A) : const Color(0xFFE3F0FB);

                if (notif.title.toLowerCase().contains('limit')) {
                  iconData = Icons.warning_amber_outlined;
                  iconColor = Colors.orange;
                  iconBgColor = isDark ? Colors.orange.withOpacity(0.2) : Colors.orange.withOpacity(0.12);
                } else if (notif.title.toLowerCase().contains('selesai') || notif.title.toLowerCase().contains('streak')) {
                  iconData = Icons.emoji_events_outlined;
                  iconColor = Colors.green;
                  iconBgColor = isDark ? Colors.green.withOpacity(0.2) : Colors.green.withOpacity(0.12);
                }

                return Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: cardBg,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: dividerColor,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: shadowColor,
                        blurRadius: 6,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: iconBgColor,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(iconData, color: iconColor, size: 20),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Text(
                                    notif.title,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: secondaryTextColor,
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                                if (!notif.isRead)
                                  Container(
                                    width: 6,
                                    height: 6,
                                    decoration: const BoxDecoration(
                                      color: Colors.blue,
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Text(
                              notif.description,
                              style: const TextStyle(
                                color: Colors.grey,
                                fontSize: 12,
                                height: 1.3,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              notif.time,
                              style: TextStyle(
                                color: isDark ? Colors.white38 : Colors.black38,
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
    );
  }
}
