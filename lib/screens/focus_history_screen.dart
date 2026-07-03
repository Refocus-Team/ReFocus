import 'package:flutter/material.dart';
import '../models/app_state.dart';

class FocusHistoryScreen extends StatelessWidget {
  const FocusHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final state = AppStateProvider.of(context);
    final history = state.focusHistory;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back, color: Color(0xFF1B2755)),
        ),
        title: const Text(
          'Focus History',
          style: TextStyle(
            color: Color(0xFF1B2755),
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
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.grey.withOpacity(0.08)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.01),
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
                      Text('${state.focusHistory.length} Kali', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Color(0xFF1B2755))),
                    ],
                  ),
                  Container(width: 1, height: 36, color: Colors.grey[200]),
                  Column(
                    children: [
                      const Text('Tantangan', style: TextStyle(color: Colors.grey, fontSize: 11)),
                      const SizedBox(height: 4),
                      const Text('12 Kali', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Color(0xFF1B2755))),
                    ],
                  ),
                  Container(width: 1, height: 36, color: Colors.grey[200]),
                  Column(
                    children: [
                      const Text('Bonus Poin', style: TextStyle(color: Colors.grey, fontSize: 11)),
                      const SizedBox(height: 4),
                      Text('+${state.points} Pts', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Color(0xFF204A94))),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 28),

            // History Log List
            const Text(
              'Aktivitas Fokus Terbaru',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1B2755),
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
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.grey.withOpacity(0.06)),
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
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF1B2755),
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
