import 'package:flutter/material.dart';
import '../models/app_state.dart';
import '../widgets/bottom_navigation.dart';
import '../widgets/custom_line_chart.dart';

class StatisticsScreen extends StatefulWidget {
  const StatisticsScreen({super.key});

  @override
  State<StatisticsScreen> createState() => _StatisticsScreenState();
}

class _StatisticsScreenState extends State<StatisticsScreen> {
  String _activeTab = 'Ikhtisar';
  final List<String> _tabs = ['Ikhtisar', 'Harian', 'Mingguan', 'Bulanan'];
  final List<String> _days = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];

  final List<ChartPoint> _ikhtisarData = [
    ChartPoint('Sen', 60), ChartPoint('Sel', 72), ChartPoint('Rab', 65),
    ChartPoint('Kam', 78), ChartPoint('Jum', 82), ChartPoint('Sab', 75), ChartPoint('Min', 80)
  ];
  final List<ChartPoint> _harianData = [
    ChartPoint('08:00', 30), ChartPoint('12:00', 65), ChartPoint('16:00', 80),
    ChartPoint('20:00', 55), ChartPoint('23:00', 20)
  ];
  final List<ChartPoint> _mingguanData = [
    ChartPoint('Sen', 65), ChartPoint('Sel', 70), ChartPoint('Rab', 58),
    ChartPoint('Kam', 75), ChartPoint('Jum', 85), ChartPoint('Sab', 72), ChartPoint('Min', 68)
  ];
  final List<ChartPoint> _bulananData = [
    ChartPoint('M1', 55), ChartPoint('M2', 65), ChartPoint('M3', 72), ChartPoint('M4', 68)
  ];

  Widget _buildMetricCard({
    required String label,
    required String value,
    required String subtitle,
    bool isGradient = false,
  }) {
    final cardDecoration = isGradient
        ? const BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(20)),
            gradient: LinearGradient(
              colors: [Color(0xFF4AA5F9), Color(0xFF1B2755)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          )
        : BoxDecoration(
            color: Colors.white,
            borderRadius: const BorderRadius.all(Radius.circular(20)),
            border: Border.all(color: Colors.grey.withOpacity(0.08)),
          );

    final textLabelColor = isGradient ? Colors.white.withOpacity(0.8) : Colors.grey;
    final textValueColor = isGradient ? Colors.white : const Color(0xFF1B2755);
    final textSubColor = isGradient ? Colors.white.withOpacity(0.85) : const Color(0xFF204A94);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: cardDecoration,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            label,
            style: TextStyle(fontSize: 11, color: textLabelColor),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: textValueColor),
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: textSubColor),
          ),
        ],
      ),
    );
  }

  Widget _buildMiniBarChart() {
    final heights = [40, 55, 70, 45, 60, 80, 65, 50, 75, 90, 85, 60];
    return Container(
      height: 32,
      margin: const EdgeInsets.only(top: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: heights.map((h) {
          return Expanded(
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 1.0),
              height: h * 0.35,
              decoration: BoxDecoration(
                color: const Color(0xFFE0F2FE),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildStreakCircles() {
    return Container(
      margin: const EdgeInsets.only(top: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: _days.map((day) {
          return Container(
            width: 24,
            height: 24,
            decoration: const BoxDecoration(
              color: Color(0xFF204A94),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                day,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 9,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = AppStateProvider.of(context);
    final apps = state.activeApps.isEmpty ? state.selectedApps.take(4).toList() : state.activeApps;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      body: Stack(
        children: [
          SafeArea(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.only(bottom: 120.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Top Banner
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.only(left: 24, right: 24, top: 24, bottom: 28),
                    decoration: const BoxDecoration(
                      color: Color(0xFF1B2755),
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(40),
                        bottomRight: Radius.circular(40),
                      ),
                    ),
                    child: Stack(
                      clipBehavior: Clip.none,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Statistik',
                              style: TextStyle(
                                fontSize: 32,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 6),
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.55,
                              child: const Text(
                                'Lacak kemajuan Anda dan bangun kebiasaan digital yang lebih baik.',
                                style: TextStyle(
                                  fontSize: 13,
                                  color: Colors.white70,
                                  height: 1.3,
                                ),
                              ),
                            ),
                          ],
                        ),
                        // Stats mascot absolute
                        Positioned(
                          bottom: -28,
                          right: -12,
                          child: Image.asset(
                            'assets/mascot-stats.png',
                            width: 100,
                            fit: BoxFit.contain,
                            errorBuilder: (context, error, stackTrace) => const Icon(
                              Icons.bar_chart,
                              size: 70,
                              color: Colors.white24,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Tab Buttons
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
                    padding: const EdgeInsets.all(4.0),
                    decoration: BoxDecoration(
                      color: const Color(0xFFE3F0FB),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Row(
                      children: _tabs.map((tab) {
                        final isActive = _activeTab == tab;
                        return Expanded(
                          child: GestureDetector(
                            onTap: () => setState(() => _activeTab = tab),
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 250),
                              padding: const EdgeInsets.symmetric(vertical: 8),
                              decoration: BoxDecoration(
                                color: isActive ? const Color(0xFF1B2755) : Colors.transparent,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                tab,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: isActive ? Colors.white : const Color(0xFF1B2755),
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),

                  // Tab content
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (_activeTab == 'Ikhtisar') ...[
                          GridView.count(
                            crossAxisCount: 2,
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            crossAxisSpacing: 16,
                            mainAxisSpacing: 16,
                            childAspectRatio: 1.3,
                            children: [
                              _buildMetricCard(label: "Focus Score", value: "82%", subtitle: "↗ +12% vs last week"),
                              _buildMetricCard(label: "Daily Average", value: "3h 42m", subtitle: "Down by 45m", isGradient: true),
                              // Card with MiniBarChart
                              Container(
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(color: Colors.grey.withOpacity(0.08)),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text("Today's Screen Time", style: TextStyle(fontSize: 10, color: Colors.grey)),
                                    const SizedBox(height: 2),
                                    const Text("1h 42m", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF1B2755))),
                                    const Text("↓ 10% from yesterday", style: TextStyle(fontSize: 9, color: Colors.green, fontWeight: FontWeight.bold)),
                                    _buildMiniBarChart(),
                                  ],
                                ),
                              ),
                              // Card with StreakCircles
                              Container(
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(color: Colors.grey.withOpacity(0.08)),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text("Current Streak", style: TextStyle(fontSize: 10, color: Colors.grey)),
                                    const SizedBox(height: 2),
                                    const Text("7 Days", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF1B2755))),
                                    const Text("🔥 Keep it up!", style: TextStyle(fontSize: 9, color: Color(0xFF204A94), fontWeight: FontWeight.bold)),
                                    _buildStreakCircles(),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          // Line Chart Card
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(color: Colors.grey.withOpacity(0.08)),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text('Tren Fokus', style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF1B2755), fontSize: 15)),
                                        Text('Konsistensi meningkat sebesar 15%', style: TextStyle(color: Colors.grey, fontSize: 11)),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Container(width: 8, height: 8, decoration: const BoxDecoration(color: Color(0xFF38BDF8), shape: BoxShape.circle)),
                                        const SizedBox(width: 4),
                                        const Text('Focus', style: TextStyle(color: Colors.grey, fontSize: 10)),
                                      ],
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 12),
                                CustomLineChart(data: _ikhtisarData),
                              ],
                            ),
                          ),
                        ] else if (_activeTab == 'Harian') ...[
                          GridView.count(
                            crossAxisCount: 2,
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            crossAxisSpacing: 16,
                            mainAxisSpacing: 16,
                            childAspectRatio: 1.3,
                            children: [
                              _buildMetricCard(label: "Today vs Yesterday", value: "85%", subtitle: "Naik 5%"),
                              _buildMetricCard(label: "Total Screen Time", value: "1h 42m", subtitle: "Today", isGradient: true),
                            ],
                          ),
                          const SizedBox(height: 16),
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(color: Colors.grey.withOpacity(0.08)),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text('Screen Time Today', style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF1B2755), fontSize: 15)),
                                const Text('Penggunaan per jam', style: TextStyle(color: Colors.grey, fontSize: 11)),
                                const SizedBox(height: 12),
                                CustomLineChart(data: _harianData),
                              ],
                            ),
                          ),
                        ] else if (_activeTab == 'Mingguan') ...[
                          GridView.count(
                            crossAxisCount: 2,
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            crossAxisSpacing: 16,
                            mainAxisSpacing: 16,
                            childAspectRatio: 1.3,
                            children: [
                              _buildMetricCard(label: "Rata-rata Minggu Ini", value: "3h 15m", subtitle: "Turun 30m dari minggu lalu"),
                              _buildMetricCard(label: "Hari Terbaik", value: "Jumat", subtitle: "Fokus tertinggi!", isGradient: true),
                            ],
                          ),
                          const SizedBox(height: 16),
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(color: Colors.grey.withOpacity(0.08)),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text('Tren Fokus Harian', style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF1B2755), fontSize: 15)),
                                const Text('Senin - Minggu', style: TextStyle(color: Colors.grey, fontSize: 11)),
                                const SizedBox(height: 12),
                                CustomLineChart(data: _mingguanData),
                              ],
                            ),
                          ),
                        ] else if (_activeTab == 'Bulanan') ...[
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(20),
                            decoration: const BoxDecoration(
                              borderRadius: BorderRadius.all(Radius.circular(20)),
                              gradient: LinearGradient(
                                colors: [Color(0xFF4AA5F9), Color(0xFF1B2755)],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                            ),
                            child: const Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Total Screen Time Bulan Ini', style: TextStyle(fontSize: 12, color: Colors.white70)),
                                SizedBox(height: 6),
                                Text('85j 30m', style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold, color: Colors.white)),
                                SizedBox(height: 6),
                                Text('Bulan ini Anda menghemat 12 jam!', style: TextStyle(fontSize: 12, color: Colors.white70)),
                              ],
                            ),
                          ),
                          const SizedBox(height: 16),
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(color: Colors.grey.withOpacity(0.08)),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text('Tren Fokus Bulanan', style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF1B2755), fontSize: 15)),
                                const Text('Per minggu', style: TextStyle(color: Colors.grey, fontSize: 11)),
                                const SizedBox(height: 12),
                                CustomLineChart(data: _bulananData),
                              ],
                            ),
                          ),
                        ],

                        // Most Used Apps List
                        const SizedBox(height: 24),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Most Used Apps',
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF1B2755),
                              ),
                            ),
                            GestureDetector(
                              onTap: () {},
                              child: const Text(
                                'See All',
                                style: TextStyle(
                                  color: Color(0xFF204A94),
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: apps.length,
                          itemBuilder: (context, index) {
                            final app = apps[index];
                            return Container(
                              margin: const EdgeInsets.only(bottom: 12),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      Image.asset(
                                        'assets/${app.logo}',
                                        width: 32,
                                        height: 32,
                                        fit: BoxFit.contain,
                                        errorBuilder: (context, error, stackTrace) => const Icon(Icons.android),
                                      ),
                                      const SizedBox(width: 12),
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            app.name,
                                            style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: Color(0xFF1B2755),
                                              fontSize: 13,
                                            ),
                                          ),
                                          Text(
                                            app.timeLimit,
                                            style: const TextStyle(
                                              fontSize: 10,
                                              color: Colors.grey,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                        decoration: BoxDecoration(
                                          color: const Color(0xFFE0F2FE),
                                          borderRadius: BorderRadius.circular(12),
                                        ),
                                        child: Text(
                                          '${app.progress}%',
                                          style: const TextStyle(
                                            color: Color(0xFF204A94),
                                            fontWeight: FontWeight.bold,
                                            fontSize: 9,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      const Icon(Icons.chevron_right, size: 16, color: Colors.grey),
                                    ],
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          const BottomNavigation(activePage: 'statistics'),
        ],
      ),
    );
  }
}
