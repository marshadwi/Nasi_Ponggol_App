import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'main_navigation.dart';
import 'admin/admin_main_navigation.dart';
import 'register_screen.dart';
import 'forgot_password_screen.dart';
import '../config.dart';
import '../utils/app_styles.dart'; // <--- IMPORT "CSS"

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _obscurePassword = true;
  bool _isLoading = false;

  final String apiUrl = Config.loginUrl;

  Future<void> _login() async {
    if (_emailController.text.isEmpty || _passwordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Email dan Password harus diisi!'), backgroundColor: Colors.red),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        body: {
          "email": _emailController.text,
          "password": _passwordController.text,
        },
      ).timeout(const Duration(seconds: 10));

      final data = jsonDecode(response.body);

      if (!mounted) return;

      if (data['status'] == 'success') {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Login Berhasil!'), backgroundColor: Colors.green),
        );
        
        String role = data['data']['role'] ?? 'user';
        if (role == 'admin') {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => AdminMainNavigation(userData: data['data'])),
            );
        } else {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => MainNavigation(userData: data['data'])),
            );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(data['message']), backgroundColor: Colors.red),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Gagal terhubung ke server! Periksa koneksi internetmu.'), backgroundColor: Colors.red),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppStyles.whiteColor, // <-- DARI CSS
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Icon(Icons.fastfood, size: 80, color: Colors.blue.shade800),
                const SizedBox(height: 16),
                const Text(
                  'Selamat Datang Kembali!',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Silakan masuk untuk memesan Nasi Ponggol.',
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
                
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const ForgotPasswordScreen()),
                      );
                    },
                    child: const Text('Lupa Password?'),
                  ),
                ),
                
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: _login,
                  style: AppStyles.authButtonStyle, // <-- DARI CSS
                  child: _isLoading 
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text('Masuk', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                ),
                
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('Belum punya akun?'),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const RegisterScreen()),
                        );
                      },
                      child: const Text('Daftar Sekarang'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
