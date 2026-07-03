import 'package:flutter/material.dart';

class PermissionScreen extends StatefulWidget {
  const PermissionScreen({super.key});

  @override
  State<PermissionScreen> createState() => _PermissionScreenState();
}

class _PermissionScreenState extends State<PermissionScreen> with SingleTickerProviderStateMixin {
  bool _usageGranted = true;
  bool _notificationGranted = true;
  late AnimationController _mascotController;
  late Animation<double> _mascotFloat;

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

  Widget _buildPermissionCard({
    required String title,
    required String description,
    required String iconPath,
    required bool isGranted,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isGranted ? const Color(0xFF204A94) : const Color(0xFFA5C0DD),
            width: isGranted ? 1.5 : 1.0,
          ),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFFDCE8F5).withOpacity(0.5),
              blurRadius: 10,
              offset: const Offset(4, 6),
            ),
          ],
        ),
        child: Row(
          children: [
            Image.asset(
              'assets/$iconPath',
              width: 48,
              height: 48,
              fit: BoxFit.contain,
              errorBuilder: (context, error, stackTrace) => Container(
                width: 48,
                height: 48,
                decoration: const BoxDecoration(color: Color(0xFFE3F0FB), shape: BoxShape.circle),
                child: const Icon(Icons.security, color: Color(0xFF204A94)),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1B2755),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    description,
                    style: const TextStyle(
                      fontSize: 11,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            // Custom Checkbox
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                color: isGranted ? const Color(0xFF204A94) : Colors.white,
                borderRadius: BorderRadius.circular(6),
                border: Border.all(
                  color: const Color(0xFF204A94),
                  width: 2,
                ),
              ),
              child: isGranted
                  ? const Icon(
                      Icons.check,
                      size: 16,
                      color: Colors.white,
                    )
                  : null,
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Spacer(flex: 1),
              // Floating Mascot
              AnimatedBuilder(
                animation: _mascotFloat,
                builder: (context, child) {
                  return Transform.translate(
                    offset: Offset(0, _mascotFloat.value),
                    child: child,
                  );
                },
                child: Image.asset(
                  'assets/mascot-permission.png',
                  height: 160,
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) => const Icon(
                    Icons.privacy_tip_outlined,
                    size: 100,
                    color: Color(0xFF204A94),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              const Text(
                'Hampir sampai!',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1B2755),
                ),
              ),
              const SizedBox(height: 8),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                child: Text(
                  'Untuk mempersonalisasi pengalaman Anda, kami membutuhkan beberapa izin',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF204A94),
                    height: 1.3,
                  ),
                ),
              ),
              const SizedBox(height: 32),

              // Permissions List
              _buildPermissionCard(
                title: 'Akses Penggunaan',
                description: 'Izinkan untuk melacak penggunaan aplikasi dan waktu layar.',
                iconPath: 'icon-usage.png',
                isGranted: _usageGranted,
                onTap: () => setState(() => _usageGranted = !_usageGranted),
              ),
              _buildPermissionCard(
                title: 'Notifikasi',
                description: 'Izinkan untuk mengingatkan Anda tentang batasan dan tantangan.',
                iconPath: 'icon-notification.png',
                isGranted: _notificationGranted,
                onTap: () => setState(() => _notificationGranted = !_notificationGranted),
              ),

              const Spacer(flex: 2),

              // Continue Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pushReplacementNamed(context, '/select-apps');
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF204A94),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 3,
                    shadowColor: const Color(0xFF204A94).withOpacity(0.3),
                  ),
                  child: const Text(
                    'Continue',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              GestureDetector(
                onTap: () {
                  Navigator.pushReplacementNamed(context, '/select-apps');
                },
                child: const Text(
                  'You can change this later',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey,
                  ),
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}
