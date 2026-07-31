import 'package:flutter/material.dart';
import '../../utils/app_styles.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'admin_settings_screens.dart';
import '../login_screen.dart';

class AdminProfileScreen extends StatelessWidget {
  final Map<String, dynamic> userData;
  const AdminProfileScreen({super.key, required this.userData});

  void _logout(BuildContext context) {
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => const LoginScreen()),
      (Route<dynamic> route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppStyles.backgroundColor,
      appBar: AppBar(
        title: const Text('Profil Administrator', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: AppStyles.whiteColor,
        foregroundColor: AppStyles.appBarForegroundColor,
        elevation: 0,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            // Admin Identity Header
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.blue.shade800, Colors.blue.shade500],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(color: Colors.blue.withOpacity(0.3), blurRadius: 10, offset: const Offset(0, 5)),
                ],
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(4),
                    decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                    child: const CircleAvatar(
                      radius: 35,
                      backgroundColor: Colors.blueGrey,
                      child: Icon(Icons.admin_panel_settings, size: 40, color: Colors.white),
                    ),
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          userData['nama'] ?? 'Administrator',
                          style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          userData['email'] ?? 'admin@gmail.com',
                          style: TextStyle(fontSize: 14, color: Colors.blue.shade100),
                        ),
                        const SizedBox(height: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(color: Colors.white.withOpacity(0.2), borderRadius: BorderRadius.circular(20)),
                          child: const Text('Super Admin', style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)),
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
            const SizedBox(height: 32),

            // Admin Menu Options
            _buildAdminMenuTile(context, Icons.store, 'Pengaturan Toko', 'Jam buka, lokasi, dan pajak', Colors.blue, const StoreSettingsScreen()),
            const SizedBox(height: 12),
            _buildAdminMenuTile(context, Icons.bar_chart, 'Laporan Penjualan', 'Unduh rekapitulasi data penjualan', Colors.green, const SalesReportScreen()),
            const SizedBox(height: 12),
            _buildAdminMenuTile(context, Icons.security, 'Keamanan & Akses', 'Ubah kata sandi dan hak akses', Colors.purple, const SecurityAccessScreen()),
            const SizedBox(height: 40),

            // Logout Button
            SizedBox(
              width: double.infinity,
              height: 50,
              child: OutlinedButton.icon(
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.red,
                  side: const BorderSide(color: Colors.red, width: 2),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                icon: const Icon(Icons.logout),
                label: const Text('Keluar dari Akun Admin', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                onPressed: () => _logout(context),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAdminMenuTile(BuildContext context, IconData icon, String title, String subtitle, Color color, Widget targetScreen) {
    return Container(
      decoration: AppStyles.cardDecoration,
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        leading: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(12)),
          child: Icon(icon, color: color),
        ),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(subtitle, style: const TextStyle(fontSize: 12)),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
        onTap: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => targetScreen));
        },
      ),
    );
  }
}
