import 'package:flutter/material.dart';
import '../config.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../utils/app_styles.dart'; // <--- IMPORT "CSS"

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _obscurePassword = true;
  bool _isLoading = false;

  final String apiUrl = Config.registerUrl;

  Future<void> _register() async {
    if (_nameController.text.isEmpty || _emailController.text.isEmpty || _passwordController.text.isEmpty || _phoneController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Semua kolom harus diisi!'), backgroundColor: Colors.red),
      );
      return;
    }

    // Validasi Password
    String password = _passwordController.text;
    bool hasMinLength = password.length >= 8;
    bool isAlphanumeric = RegExp(r'^[a-zA-Z0-9]+$').hasMatch(password);

    if (!hasMinLength || !isAlphanumeric) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Password harus minimal 8 karakter dan hanya boleh berisi huruf dan angka!'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        body: {
          "nama": _nameController.text,
          "phone": _phoneController.text,
          "email": _emailController.text,
          "password": _passwordController.text,
        },
      ).timeout(const Duration(seconds: 10));

      final data = jsonDecode(response.body);

      if (!mounted) return;

      if (data['status'] == 'success') {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Registrasi Berhasil! Silakan Login.'), backgroundColor: Colors.green),
        );
        Navigator.pop(context); // Kembali ke login
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(data['message']), backgroundColor: Colors.red),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Gagal terhubung ke server!'), backgroundColor: Colors.red),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppStyles.whiteColor, // <-- DARI CSS
      appBar: AppBar(
        title: const Text('Buat Akun Baru', style: TextStyle(color: Colors.black)),
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
              const Text(
                'Daftar sekarang dan nikmati Nasi Ponggol Setan favorit Anda!',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
              const SizedBox(height: 32),
              
              TextField(
                controller: _nameController,
                decoration: AppStyles.authInputDecoration.copyWith(
                  labelText: 'Nama Lengkap',
                  prefixIcon: const Icon(Icons.person),
                ),
              ),
              const SizedBox(height: 16),
              
              TextField(
                controller: _phoneController,
                keyboardType: TextInputType.phone,
                decoration: AppStyles.authInputDecoration.copyWith(
                  labelText: 'Nomor WhatsApp',
                  prefixIcon: const Icon(Icons.phone),
                ),
              ),
              const SizedBox(height: 16),

              TextField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: AppStyles.authInputDecoration.copyWith(
                  labelText: 'Email',
                  prefixIcon: const Icon(Icons.email),
                ),
              ),
              const SizedBox(height: 16),
              
              TextField(
                controller: _passwordController,
                obscureText: _obscurePassword,
                decoration: AppStyles.authInputDecoration.copyWith(
                  labelText: 'Password',
                  prefixIcon: const Icon(Icons.lock),
                  suffixIcon: IconButton(
                    icon: Icon(_obscurePassword ? Icons.visibility_off : Icons.visibility),
                    onPressed: () {
                      setState(() {
                        _obscurePassword = !_obscurePassword;
                      });
                    },
                  ),
                ),
              ),
              
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: _register,
                style: AppStyles.authButtonStyle, // <-- DARI CSS
                child: _isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text('Daftar', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Sudah punya akun? ", style: TextStyle(color: Colors.grey)),
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text(
                      'Login di sini',
                      style: TextStyle(color: AppStyles.primaryColor, fontWeight: FontWeight.bold),
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

