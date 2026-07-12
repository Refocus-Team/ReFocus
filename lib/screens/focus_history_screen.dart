import 'package:flutter/material.dart';
import '../models/app_state.dart';

class FocusHistoryScreen extends StatelessWidget {
  const FocusHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final state = AppStateProvider.of(context);
    final history = state.focusHistory;
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
          'Focus History',
          style: TextStyle(
            color: secondaryTextColor,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Stats summary card
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: cardBg,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: dividerColor),
                boxShadow: [
                  BoxShadow(
                    color: shadowColor,
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Column(
                    children: [
                      const Text('Total Focus', style: TextStyle(color: Colors.grey, fontSize: 11)),
                      const SizedBox(height: 4),
                      Text('${state.focusHistory.length} Kali', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: secondaryTextColor)),
                    ],
                  ),
                  Container(width: 1, height: 36, color: isDark ? Colors.white12 : Colors.grey[200]),
                  Column(
                    children: [
                      const Text('Tantangan', style: TextStyle(color: Colors.grey, fontSize: 11)),
                      const SizedBox(height: 4),
                      Text('12 Kali', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: secondaryTextColor)),
                    ],
                  ),
                  Container(width: 1, height: 36, color: isDark ? Colors.white12 : Colors.grey[200]),
                  Column(
                    children: [
                      const Text('Bonus Poin', style: TextStyle(color: Colors.grey, fontSize: 11)),
                      const SizedBox(height: 4),
                      Text('+${state.points} Pts', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: primaryTextColor)),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 28),

            // History Log List
            Text(
              'Aktivitas Fokus Terbaru',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: secondaryTextColor,
              ),
            ),
            const SizedBox(height: 12),

            if (history.isEmpty)
              const Center(
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 40.0),
                  child: Text('Belum ada log aktivitas fokus.'),
                ),
              )
            else
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: history.length,
                itemBuilder: (context, index) {
                  final log = history[index];
                  final isAddition = log.detail.startsWith('+');

                  return Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: cardBg,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: dividerColor),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: isAddition ? Colors.green.withOpacity(0.1) : Colors.red.withOpacity(0.1),
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                isAddition ? Icons.add_task : Icons.history_toggle_off,
                                color: isAddition ? Colors.green : Colors.red,
                                size: 20,
                              ),
                            ),
                            const SizedBox(width: 14),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  log.title,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: secondaryTextColor,
                                    fontSize: 14,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  log.time,
                                  style: const TextStyle(
                                    fontSize: 11,
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        Text(
                          log.detail,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: isAddition ? Colors.green : Colors.red,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
          ],
        ),
      ),
    );
  }
}
