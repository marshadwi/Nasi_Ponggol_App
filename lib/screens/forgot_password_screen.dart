import 'package:flutter/material.dart';
import '../utils/app_styles.dart'; // <--- IMPORT "CSS"

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final TextEditingController _emailController = TextEditingController();

  void _resetPassword() {
    if (_emailController.text.isNotEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Tautan reset password telah dikirim ke email Anda!'), backgroundColor: Colors.green),
      );
      Navigator.pop(context); // Kembali ke login
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Masukkan email yang valid!'), backgroundColor: Colors.red),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppStyles.whiteColor, // <-- DARI CSS
      appBar: AppBar(
        backgroundColor: AppStyles.whiteColor,
        iconTheme: const IconThemeData(color: Colors.black),
        elevation: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Icon(Icons.lock_reset, size: 80, color: Colors.blue.shade800),
              const SizedBox(height: 16),
              const Text(
                'Lupa Password Anda?',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              const Text(
                'Jangan khawatir! Masukkan email yang terdaftar dan kami akan mengirimkan instruksi untuk mengatur ulang password Anda.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
              const SizedBox(height: 32),
              
              TextField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: AppStyles.authInputDecoration.copyWith(
                  labelText: 'Email',
                  prefixIcon: const Icon(Icons.email),
                ),
              ),
              
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: _resetPassword,
                style: AppStyles.authButtonStyle, // <-- DARI CSS
                child: const Text('Kirim Tautan Reset', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              ),
              
              const SizedBox(height: 16),
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Kembali ke Login', style: TextStyle(fontSize: 16)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
