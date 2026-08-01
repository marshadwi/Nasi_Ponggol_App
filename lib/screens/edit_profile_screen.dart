import 'package:flutter/material.dart';
import '../config.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';
import '../utils/app_styles.dart'; // <--- IMPORT "CSS"

class EditProfileScreen extends StatefulWidget {
  final Map<String, dynamic> userData;
  const EditProfileScreen({super.key, required this.userData});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  final TextEditingController _passwordController = TextEditingController();
  
  File? _newProfilePic;
  final ImagePicker _picker = ImagePicker();
  bool _isLoading = false;
  bool _obscurePassword = true;
  
  final String apiUrl = Config.editProfileUrl;
  final String imageUrl = Config.profileImageUrl;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.userData['nama']);
    _emailController = TextEditingController(text: widget.userData['email']);
  }

  Future<void> _pickImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _newProfilePic = File(image.path);
      });
    }
  }

  Future<void> _saveProfile() async {
    if (_nameController.text.isEmpty || _emailController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Nama dan Email tidak boleh kosong!'), backgroundColor: AppStyles.errorColor));
      return;
    }

    if (_passwordController.text.isNotEmpty) {
      String pwd = _passwordController.text;
      bool isAlphanumeric = RegExp(r'^[a-zA-Z0-9]+$').hasMatch(pwd);
      if (pwd.length < 8 || !isAlphanumeric) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Password baru minimal 8 karakter dan hanya boleh berisi huruf dan angka!'), backgroundColor: AppStyles.errorColor));
        return;
      }
    }

    setState(() => _isLoading = true);

    try {
      var request = http.MultipartRequest('POST', Uri.parse(apiUrl));
      request.fields['id'] = widget.userData['id'].toString();
      request.fields['nama'] = _nameController.text;
      request.fields['email'] = _emailController.text;
      if (_passwordController.text.isNotEmpty) {
        request.fields['password'] = _passwordController.text;
      }

      if (_newProfilePic != null) {
        request.files.add(await http.MultipartFile.fromPath('profile_pic', _newProfilePic!.path));
      }

      var response = await request.send();
      var responseData = await response.stream.bytesToString();
      var data = jsonDecode(responseData);

      if (mounted) {
        if (data['status'] == 'success') {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(data['message']), backgroundColor: AppStyles.successColor));
          Navigator.pop(context, data['data']); // Return updated data
        } else {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(data['message']), backgroundColor: Colors.red));
        }
      }
    } catch (e) {
      print("Error detail: $e");
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e'), backgroundColor: AppStyles.errorColor));
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    String? currentPic = widget.userData['profile_pic'];

    return Scaffold(
      backgroundColor: AppStyles.whiteColor, // <-- DARI CSS
      appBar: AppBar(
        title: const Text('Edit Profil', style: TextStyle(color: Colors.black)),
        backgroundColor: AppStyles.whiteColor,
        iconTheme: const IconThemeData(color: Colors.black),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            Center(
              child: Stack(
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundColor: Colors.blue.shade100,
                    backgroundImage: _newProfilePic != null 
                        ? FileImage(_newProfilePic!) as ImageProvider
                        : (currentPic != null && currentPic.isNotEmpty
                            ? NetworkImage(imageUrl + currentPic)
                            : null),
                    child: (_newProfilePic == null && (currentPic == null || currentPic.isEmpty))
                        ? Icon(Icons.person, size: 50, color: Colors.blue.shade800)
                        : null,
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: InkWell(
                      onTap: _pickImage,
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(color: Colors.blue.shade800, shape: BoxShape.circle),
                        child: const Icon(Icons.camera_alt, color: Colors.white, size: 20),
                      ),
                    ),
                  )
                ],
              ),
            ),
            const SizedBox(height: 32),
            TextField(
              controller: _nameController,
              decoration: AppStyles.authInputDecoration.copyWith(
                labelText: 'Username / Nama Lengkap',
                prefixIcon: const Icon(Icons.person),
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
                labelText: 'Password Baru (Kosongkan jika tidak diganti)',
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
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _saveProfile,
                style: AppStyles.authButtonStyle, // <-- DARI CSS
                child: _isLoading 
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text('Simpan Perubahan', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppStyles.whiteColor)),
              ),
            )
          ],
        ),
      ),
    );
  }
}

