import 'package:flutter/material.dart';
import '../models/app_state.dart';
import '../widgets/bottom_navigation.dart';

class PointsScreen extends StatefulWidget {
  const PointsScreen({super.key});

  @override
  State<PointsScreen> createState() => _PointsScreenState();
}

class _PointsScreenState extends State<PointsScreen> {
  final List<Map<String, dynamic>> _withdrawalOptions = [
    {"name": "Voucher", "min": 100, "icon": "icon-points.png"},
    {"name": "PayPal", "min": 500, "icon": "icon-points.png"},
    {"name": "Bank Transfer", "min": 1000, "icon": "icon-points.png"},
  ];

  void _handleWithdrawal(AppState state, int minAmount, String name) {
    final success = state.withdrawPoints(minAmount);
    if (success) {
      state.addFocusHistory("Penarikan $name Berhasil", "-$minAmount Poin");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Penarikan $name sebesar $minAmount poin berhasil dilakukan!'),
          backgroundColor: Colors.green,
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Poin Anda tidak mencukupi untuk melakukan penarikan ini.'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = AppStateProvider.of(context);
    final points = state.points;
    final history = state.focusHistory;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.only(left: 24, right: 24, bottom: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 12),
                  // Header
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: const Icon(Icons.arrow_back, color: Color(0xFF1B2755), size: 26),
                      ),
                      const Text(
                        'My Points',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1B2755),
                        ),
                      ),
                      const SizedBox(width: 48), // spacer balance
                    ],
                  ),
                  const SizedBox(height: 20),

                  // Points Balance Gradient Card (Mesh Gradient representation)
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 28, horizontal: 24),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(24),
                      gradient: const LinearGradient(
                        colors: [
                          Color(0xFF1B2755),
                          Color(0xFF1E3A8A),
                          Color(0xFF204A94),
                        ],
                        stops: [0.0, 0.5, 1.0],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF1B2755).withValues(alpha: 0.35),
                          blurRadius: 15,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        const Text(
                          'Your Points Balance',
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.white70,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          '$points',
                          style: const TextStyle(
                            fontSize: 54,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 6),
                        const Text(
                          'Total Points Earned',
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.white70,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Stats Row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildMiniMetricCard("240", "This Week"),
                      _buildMiniMetricCard("850", "This Month"),
                      _buildMiniMetricCard("2400", "All Time"),
                    ],
                  ),
                  const SizedBox(height: 28),

                  // Withdrawal options
                  const Text(
                    'Withdrawal Options',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF1B2755)),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: _withdrawalOptions.map((opt) {
                      final name = opt["name"] as String;
                      final min = opt["min"] as int;
                      final icon = opt["icon"] as String;
                      final isEligible = points >= min;

                      return Expanded(
                        child: Container(
                          margin: const EdgeInsets.symmetric(horizontal: 4),
                          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 8),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: isEligible ? Colors.green : Colors.grey.withValues(alpha: 0.2),
                              width: isEligible ? 2.0 : 1.0,
                            ),
                          ),
                          child: Opacity(
                            opacity: isEligible ? 1.0 : 0.6,
                            child: Column(
                              children: [
                                Image.asset(
                                  'assets/$icon',
                                  width: 32,
                                  height: 32,
                                  errorBuilder: (context, error, stackTrace) => const Icon(Icons.toll, color: Colors.orange),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  name,
                                  style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF1B2755), fontSize: 13),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  'Min: $min pts',
                                  style: const TextStyle(fontSize: 10, color: Colors.grey),
                                ),
                                const SizedBox(height: 10),
                                ElevatedButton(
                                  onPressed: isEligible ? () => _handleWithdrawal(state, min, name) : null,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFF204A94),
                                    foregroundColor: Colors.white,
                                    disabledBackgroundColor: Colors.grey[200],
                                    disabledForegroundColor: Colors.grey[400],
                                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    elevation: 0,
                                  ),
                                  child: const Text('Withdraw', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold)),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 28),

                  // Transaction History
                  const Text(
                    'Transaction History',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF1B2755)),
                  ),
                  const SizedBox(height: 12),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: history.length,
                    itemBuilder: (context, index) {
                      final item = history[index];
                      final isAddition = item.detail.startsWith('+');

                      return Container(
                        margin: const EdgeInsets.only(bottom: 12),
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: Colors.grey.withValues(alpha: 0.08)),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  item.title,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF1B2755),
                                    fontSize: 14,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  item.time,
                                  style: const TextStyle(
                                    fontSize: 11,
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                            Text(
                              item.detail,
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
          ),
      bottomNavigationBar: const BottomNavigation(activePage: 'profile'),
    );
  }

  Widget _buildMiniMetricCard(String value, String label) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 4),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.01),
              blurRadius: 6,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          children: [
            Text(
              value,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF204A94)),
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: const TextStyle(fontSize: 10, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}
