import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../config.dart';
import '../../utils/app_styles.dart';

class AdminUsersScreen extends StatefulWidget {
  const AdminUsersScreen({super.key});

  @override
  State<AdminUsersScreen> createState() => _AdminUsersScreenState();
}

class _AdminUsersScreenState extends State<AdminUsersScreen> {
  bool _isLoading = true;
  List<dynamic> _users = [];

  @override
  void initState() {
    super.initState();
    _fetchUsers();
  }

  Future<void> _fetchUsers() async {
    setState(() => _isLoading = true);
    try {
      final response = await http.get(Uri.parse("${Config.baseUrl}/admin_get_users.php"));
      final data = jsonDecode(response.body);
      if (mounted) {
        if (data['status'] == 'success') {
          setState(() {
            _users = data['data'];
            _isLoading = false;
          });
        }
      }
    } catch (e) {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppStyles.whiteColor,
      appBar: AppBar(
        title: const Text('Daftar Pelanggan', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: AppStyles.whiteColor,
        foregroundColor: AppStyles.appBarForegroundColor,
        elevation: 0,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _users.isEmpty
              ? const Center(child: Text("Belum ada pelanggan terdaftar"))
              : RefreshIndicator(
                  onRefresh: _fetchUsers,
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: _users.length,
                    itemBuilder: (context, index) {
                      final user = _users[index];
                      return _buildUserCard(user);
                    },
                  ),
                ),
    );
  }

  Widget _buildUserCard(Map<String, dynamic> user) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: AppStyles.cardDecoration,
      child: Row(
        children: [
          CircleAvatar(
            radius: 24,
            backgroundColor: Colors.grey.shade300,
            backgroundImage: (user['profile_pic'] != null && user['profile_pic'] != "") 
              ? NetworkImage('${Config.baseUrl}/uploads/profiles/${user['profile_pic']}') 
              : null,
            child: (user['profile_pic'] == null || user['profile_pic'] == "") 
              ? const Icon(Icons.person, color: Colors.white, size: 30) 
              : null,
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(user['nama'] ?? 'User', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                Text(user['email'] ?? '', style: const TextStyle(color: Colors.grey)),
                const SizedBox(height: 4),
                Text(user['phone'] ?? '', style: const TextStyle(color: Colors.blue, fontWeight: FontWeight.w500)),
              ],
            ),
          )
        ],
      ),
    );
  }
}
