import 'package:flutter/material.dart';
import '../models/app_state.dart';
import '../services/screen_time_service.dart';

class SetLimitScreen extends StatefulWidget {
  const SetLimitScreen({super.key});

  @override
  State<SetLimitScreen> createState() => _SetLimitScreenState();
}

class _SetLimitScreenState extends State<SetLimitScreen> with SingleTickerProviderStateMixin {
  late AnimationController _mascotController;
  late Animation<double> _mascotFloat;

  final List<String> _limitOptions = ["30 min", "1 hour", "1 h 30 min", "50 min"];

  @override
  void initState() {
    super.initState();
    _mascotController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat(reverse: true);
    _mascotFloat = Tween<double>(begin: 0, end: -10).animate(
      CurvedAnimation(parent: _mascotController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _mascotController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = AppStateProvider.of(context);
    // Fetch checked apps; if none are checked, fall back to showing all for preview
    final activeApps = state.activeApps.isEmpty ? state.selectedApps : state.activeApps;
    final isDark = state.themeMode == ThemeMode.dark;

    final scaffoldBg = isDark ? const Color(0xFF121212) : Colors.white;
    final cardBg = isDark ? const Color(0xFF1E1E1E) : Colors.white;
    final primaryTextColor = isDark ? const Color(0xFF9FA8DA) : const Color(0xFF204A94);
    final secondaryTextColor = isDark ? Colors.white : const Color(0xFF1B2755);
    final dividerColor = isDark ? Colors.white24 : const Color(0xFF1B2755);
    final shadowColor = isDark ? Colors.black.withOpacity(0.3) : Colors.black.withOpacity(0.01);
    final buttonBgColor = isDark ? const Color(0xFF3F51B5) : const Color(0xFF204A94);

    return Scaffold(
      backgroundColor: scaffoldBg,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            children: [
              const SizedBox(height: 16),
              // Mascot
              AnimatedBuilder(
                animation: _mascotFloat,
                builder: (context, child) {
                  return Transform.translate(
                    offset: Offset(0, _mascotFloat.value),
                    child: child,
                  );
                },
                child: Image.asset(
                  'assets/mascot-limit.png',
                  height: 120,
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) => Icon(
                    Icons.hourglass_empty_outlined,
                    size: 80,
                    color: primaryTextColor,
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'Set Daily Limit',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: secondaryTextColor,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Atur batas waktu harian Anda untuk setiap aplikasi',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: primaryTextColor,
                ),
              ),
              const SizedBox(height: 16),

              // Active apps list
              Expanded(
                child: ListView.builder(
                  physics: const BouncingScrollPhysics(),
                  itemCount: activeApps.length,
                  itemBuilder: (context, index) {
                    final app = activeApps[index];
                    // Ensure default limit is in options
                    String selectedLimit = app.timeLimit;
                    if (!_limitOptions.contains(selectedLimit)) {
                      selectedLimit = _limitOptions[1]; // default 1 hour
                    }

                    return Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                      decoration: BoxDecoration(
                        color: cardBg,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: dividerColor),
                        boxShadow: [
                          BoxShadow(
                            color: shadowColor,
                            blurRadius: 6,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
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
                                errorBuilder: (context, error, stackTrace) => Icon(Icons.android, color: primaryTextColor),
                              ),
                              const SizedBox(width: 12),
                              Text(
                                app.name,
                                style: TextStyle(
                                  color: primaryTextColor,
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),

                          // Styled Dropdown
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            decoration: BoxDecoration(
                              border: Border.all(color: dividerColor),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton<String>(
                                dropdownColor: cardBg,
                                value: selectedLimit,
                                icon: Icon(Icons.keyboard_arrow_down, color: primaryTextColor, size: 18),
                                elevation: 8,
                                style: TextStyle(
                                  color: primaryTextColor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 13,
                                ),
                                onChanged: (String? value) {
                                  if (value != null) {
                                    state.updateAppLimit(app.name, value);
                                  }
                                },
                                items: _limitOptions.map<DropdownMenuItem<String>>((String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(value),
                                  );
                                }).toList(),
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),

              // Save button
              Padding(
                padding: const EdgeInsets.only(bottom: 16.0, top: 12.0),
                child: Column(
                  children: [
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () async {
                          final hasUsagePermission = await ScreenTimeService.checkUsagePermission();
                          final hasOverlayPermission = await ScreenTimeService.checkOverlayPermission();
                          if (hasUsagePermission && hasOverlayPermission) {
                            final packages = activeApps.map((a) {
                              if (a.name.toLowerCase() == 'tiktok') {
                                return 'com.zhiliaoapp.musically';
                              } else if (a.name.toLowerCase() == 'instagram') {
                                return 'com.instagram.android';
                              } else if (a.name.toLowerCase() == 'youtube') {
                                return 'com.google.android.youtube';
                              } else if (a.name.toLowerCase() == 'facebook') {
                                return 'com.facebook.katana';
                              }
                              return '';
                            }).where((p) => p.isNotEmpty).toList();

                            int timeLimitInMinutes = 15; // default fallback
                            if (activeApps.isNotEmpty) {
                              final limitStr = activeApps.first.timeLimit;
                              if (limitStr.contains('hour') || limitStr.contains('h')) {
                                if (limitStr.contains('1 h 30')) {
                                  timeLimitInMinutes = 90;
                                } else {
                                  timeLimitInMinutes = 60;
                                }
                              } else if (limitStr.contains('min')) {
                                final parts = limitStr.split(' ');
                                timeLimitInMinutes = int.tryParse(parts[0]) ?? 15;
                              }
                            }

                            await ScreenTimeService.startMonitoring(packages, timeLimitInMinutes);
                          }
                          if (context.mounted) {
                            Navigator.pushReplacementNamed(context, '/home');
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: buttonBgColor,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          elevation: 3,
                          shadowColor: isDark ? Colors.black.withOpacity(0.3) : buttonBgColor.withOpacity(0.3),
                        ),
                        child: const Text(
                          'Save & Start',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    GestureDetector(
                      onTap: () {
                        Navigator.pushReplacementNamed(context, '/home');
                      },
                      child: const Text(
                        'Anda dapat mengubah ini nanti',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
