import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';
import '../../config.dart';
import '../../utils/app_styles.dart';

class AdminChatListScreen extends StatefulWidget {
  const AdminChatListScreen({super.key});

  @override
  State<AdminChatListScreen> createState() => _AdminChatListScreenState();
}

class _AdminChatListScreenState extends State<AdminChatListScreen> {
  List<Map<String, dynamic>> _users = [];
  bool _isLoading = true;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _fetchChatUsers();
    _timer = Timer.periodic(const Duration(seconds: 5), (timer) {
      _fetchChatUsers();
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  Future<void> _fetchChatUsers() async {
    try {
      final response = await http.get(Uri.parse("${Config.chatUrl}?action=get_users"));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['status'] == 'success') {
          if (mounted) {
            setState(() {
              _users = List<Map<String, dynamic>>.from(data['data']);
              _isLoading = false;
            });
          }
        }
      }
    } catch (e) {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppStyles.backgroundColor,
      appBar: AppBar(
        title: const Text('Pesan Pelanggan'),
        backgroundColor: AppStyles.whiteColor,
        foregroundColor: Colors.black,
      ),
      body: _isLoading 
        ? const Center(child: CircularProgressIndicator())
        : _users.isEmpty
          ? const Center(child: Text('Belum ada pesan masuk dari pelanggan.'))
          : ListView.builder(
              itemCount: _users.length,
              itemBuilder: (context, index) {
                final user = _users[index];
                return ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Colors.blue,
                    backgroundImage: (user['profile_pic'] != null && user['profile_pic'] != "") 
                                     ? NetworkImage(Config.profileImageUrl + user['profile_pic']) 
                                     : null,
                    child: (user['profile_pic'] == null || user['profile_pic'] == "") 
                           ? const Icon(Icons.person, color: Colors.white) 
                           : null,
                  ),
                  title: Text(user['nama'] ?? 'Pelanggan'),
                  subtitle: Text('Terakhir: ${user['last_chat']}'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => AdminChatDetailScreen(
                      userId: user['id'].toString(), 
                      userName: user['nama'] ?? 'Pelanggan'
                    )));
                  },
                );
              },
            ),
    );
  }
}

class AdminChatDetailScreen extends StatefulWidget {
  final String userId;
  final String userName;
  const AdminChatDetailScreen({super.key, required this.userId, required this.userName});

  @override
  State<AdminChatDetailScreen> createState() => _AdminChatDetailScreenState();
}

class _AdminChatDetailScreenState extends State<AdminChatDetailScreen> {
  final TextEditingController _messageController = TextEditingController();
  List<Map<String, dynamic>> _messages = [];
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _fetchChats();
    _timer = Timer.periodic(const Duration(seconds: 3), (timer) {
      _fetchChats();
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  Future<void> _fetchChats() async {
    try {
      final response = await http.get(Uri.parse("${Config.chatUrl}?action=get&user_id=${widget.userId}"));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['status'] == 'success') {
          if (mounted) {
            setState(() {
              _messages = List<Map<String, dynamic>>.from(data['data']);
            });
          }
        }
      }
    } catch (e) {
      // Ignore background errors
    }
  }

  Future<void> _sendMessage() async {
    if (_messageController.text.trim().isEmpty) return;
    
    final text = _messageController.text;
    _messageController.clear();
    
    // Optimistic update
    setState(() {
      _messages.add({
        "is_admin": "1",
        "message": text,
        "created_at": DateTime.now().toString()
      });
    });
    
    try {
      await http.post(Uri.parse(Config.chatUrl), body: {
        "action": "send",
        "user_id": widget.userId,
        "is_admin": "1",
        "message": text
      });
      _fetchChats();
    } catch (e) {
      // handle error
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppStyles.backgroundColor,
      appBar: AppBar(
        title: Text(widget.userName),
        backgroundColor: AppStyles.whiteColor,
        foregroundColor: Colors.black,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final msg = _messages[index];
                final isMe = msg['is_admin'].toString() == '1';
                final text = msg['message'] ?? '';
                final time = msg['created_at'].toString().length >= 16 ? msg['created_at'].toString().substring(11, 16) : '';
                
                return Align(
                  alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.75),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    decoration: BoxDecoration(
                      color: isMe ? Colors.blue : Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 5)]
                    ),
                    child: Column(
                      crossAxisAlignment: isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                      children: [
                        Text(text, style: TextStyle(color: isMe ? Colors.white : Colors.black87, fontSize: 16)),
                        const SizedBox(height: 4),
                        Text(time, style: TextStyle(color: isMe ? Colors.white70 : Colors.grey, fontSize: 11)),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          Container(
            padding: const EdgeInsets.all(12),
            color: Colors.white,
            child: SafeArea(
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _messageController,
                      decoration: const InputDecoration(
                        hintText: "Balas pesan pelanggan...",
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.send, color: Colors.blue),
                    onPressed: _sendMessage,
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
