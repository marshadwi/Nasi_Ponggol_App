import 'package:flutter/material.dart';
import '../config.dart';
import 'login_screen.dart';
import 'edit_profile_screen.dart';
import '../utils/app_styles.dart'; // <--- IMPORT "CSS"

class ProfileScreen extends StatefulWidget {
  final Map<String, dynamic>? userData;
  const ProfileScreen({super.key, this.userData});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  Map<String, dynamic> _userData = {};

  @override
  void initState() {
    super.initState();
    _userData = widget.userData ?? {"id": 1, "nama": "Guest", "email": "-", "profile_pic": ""};
  }

  void _goToEditProfile() async {
    final updatedData = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => EditProfileScreen(userData: _userData)),
    );

    if (updatedData != null) {
      setState(() {
        _userData = updatedData;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    String? profilePic = _userData['profile_pic'];
    final String imageUrl = Config.profileImageUrl;

    return Scaffold(
      backgroundColor: AppStyles.backgroundColor, // <-- DARI CSS
      appBar: AppBar(
        title: const Text("Profil Saya", style: AppStyles.appBarTitleStyle), // <-- DARI CSS
        backgroundColor: AppStyles.whiteColor,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 40,
                backgroundColor: Colors.blue.shade100,
                backgroundImage: (profilePic != null && profilePic.isNotEmpty)
                    ? NetworkImage(imageUrl + profilePic)
                    : null,
                child: (profilePic == null || profilePic.isEmpty) 
                    ? Icon(Icons.person, size: 40, color: Colors.blue.shade800)
                    : null,
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(_userData['nama'], style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                    Text(_userData['email'], style: const TextStyle(color: Colors.grey)),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              style: AppStyles.authButtonStyle, // <-- DARI CSS
              icon: const Icon(Icons.edit, size: 18),
              label: const Text("Edit Profil"),
              onPressed: _goToEditProfile,
            ),
          ),
          const SizedBox(height: 32),
          ListTile(
            leading: const Icon(Icons.location_on_outlined),
            title: const Text("Alamat Tersimpan"),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
               showDialog(
                 context: context,
                 builder: (c) => AlertDialog(
                   title: const Row(children: [Icon(Icons.location_on, color: Colors.red), SizedBox(width: 8), Text("Alamat Tersimpan")]),
                   content: const Text("Alamat pengiriman otomatis disinkronisasi dengan lokasi GPS terakhir Anda pada saat melakukan Checkout pesanan."),
                   actions: [TextButton(onPressed: () => Navigator.pop(c), child: const Text("Mengerti"))],
                 )
               );
            },
          ),
          ListTile(
            leading: const Icon(Icons.settings_outlined),
            title: const Text("Pengaturan"),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
               showDialog(
                 context: context,
                 builder: (c) => AlertDialog(
                   title: const Row(children: [Icon(Icons.settings, color: Colors.grey), SizedBox(width: 8), Text("Pengaturan Aplikasi")]),
                   content: const Text("Versi Aplikasi: 1.0.0 (Release)\nTema: Terang (Default)\nNotifikasi: Otomatis Aktif"),
                   actions: [TextButton(onPressed: () => Navigator.pop(c), child: const Text("Tutup"))],
                 )
               );
            },
          ),
          ListTile(
            leading: const Icon(Icons.help_outline),
            title: const Text("Bantuan"),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
               showDialog(
                 context: context,
                 builder: (c) => AlertDialog(
                   title: const Row(children: [Icon(Icons.help, color: Colors.blue), SizedBox(width: 8), Text("Pusat Bantuan")]),
                   content: const Text("Jika Anda mengalami kendala terkait pesanan atau pembayaran, silakan hubungi Customer Service kami via WhatsApp:\n\n+62 812-3456-7890"),
                   actions: [TextButton(onPressed: () => Navigator.pop(c), child: const Text("Tutup"))],
                 )
               );
            },
          ),
          const SizedBox(height: 32),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton(
              style: AppStyles.dangerOutlinedButtonStyle, // <-- DARI CSS
              onPressed: () {
                Navigator.of(context, rootNavigator: true).pushReplacement(
                  MaterialPageRoute(builder: (context) => const LoginScreen()),
                );
              },
              child: const Text("Keluar (Logout)", style: TextStyle(fontWeight: FontWeight.bold)),
            ),
          )
        ],
      ),
    );
  }
}

