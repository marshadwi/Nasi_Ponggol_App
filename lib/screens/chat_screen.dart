import 'package:flutter/material.dart';
import '../utils/app_styles.dart'; // <--- MENGHUBUNGKAN "CSS" (Styling) KE "HTML" (UI)

import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../config.dart';

class ChatScreen extends StatefulWidget {
  final Map<String, dynamic>? userData; // Menerima data user untuk ID
  const ChatScreen({super.key, this.userData});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  List<Map<String, dynamic>> _messages = [];
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _fetchChats();
    // Auto-refresh chat every 3 seconds for real-time feel
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
    if (widget.userData == null) return;
    try {
      final userId = widget.userData!['id'].toString();
      final response = await http.get(Uri.parse("${Config.chatUrl}?action=get&user_id=$userId"));
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
    if (_messageController.text.trim().isEmpty || widget.userData == null) return;
    
    final text = _messageController.text;
    _messageController.clear();
    
    // Optimistic UI update
    setState(() {
      _messages.add({
        "is_admin": "0",
        "message": text,
        "created_at": DateTime.now().toString()
      });
    });
    
    try {
      await http.post(Uri.parse(Config.chatUrl), body: {
        "action": "send",
        "user_id": widget.userData!['id'].toString(),
        "is_admin": "0",
        "message": text
      });
      _fetchChats();
    } catch (e) {
      // handle error
    }
  }

  // ========================================================
  // BAGIAN "HTML & CSS" YANG SUDAH DIPISAH AGAR RAPI
  // ========================================================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppStyles.backgroundColor, // <-- Pakai dari CSS
      appBar: _buildAppBar(),
      body: Column(
        children: [
          Expanded(child: _buildChatList()),
          _buildMessageInput(),
          const SizedBox(height: 90), // <-- TAMBAHAN AGAR TIDAK TERTUTUP HEADER BAWAH
        ],
      ),
    );
  }

  // 1. BAGIAN HEADER (APP BAR)
  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      title: Row(
        children: [
          const CircleAvatar(
            backgroundColor: AppStyles.primaryColor,
            child: Icon(Icons.support_agent, color: AppStyles.whiteColor),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("Admin Ponggol Setan", style: AppStyles.appBarTitleStyle), // <-- Pakai dari CSS
              Row(
                children: [
                  Container(
                    width: 8, height: 8,
                    decoration: const BoxDecoration(color: AppStyles.onlineColor, shape: BoxShape.circle),
                  ),
                  const SizedBox(width: 4),
                  const Text("Online", style: AppStyles.onlineTextStyle), // <-- Pakai dari CSS
                ],
              )
            ],
          ),
        ],
      ),
      backgroundColor: AppStyles.whiteColor,
      foregroundColor: AppStyles.appBarForegroundColor, // <-- DARI CSS
      elevation: 0.5,
    );
  }

  // 2. BAGIAN DAFTAR PESAN (CHAT LIST)
  Widget _buildChatList() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _messages.length,
      itemBuilder: (context, index) {
        final msg = _messages[index];
        final isMe = msg['is_admin'].toString() == '0';
        final text = msg['message'] ?? '';
        final time = msg['created_at'].toString().length >= 16 ? msg['created_at'].toString().substring(11, 16) : '';
        return _buildChatBubble(text, isMe, time);
      },
    );
  }

  // 3. BAGIAN DESAIN BALON CHAT (CHAT BUBBLE)
  Widget _buildChatBubble(String text, bool isMe, String time) {
    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.75, // Maksimal lebar 75% layar
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: isMe ? AppStyles.primaryColor : AppStyles.whiteColor, // <-- Pakai dari CSS
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(16),
            topRight: const Radius.circular(16),
            bottomLeft: isMe ? const Radius.circular(16) : const Radius.circular(4), 
            bottomRight: isMe ? const Radius.circular(4) : const Radius.circular(16),
          ),
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 5, offset: const Offset(0, 2))
          ]
        ),
        child: Column(
          crossAxisAlignment: isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
            Text(
              text,
              style: isMe ? AppStyles.myChatTextStyle : AppStyles.otherChatTextStyle, // <-- Pakai dari CSS
            ),
            const SizedBox(height: 4),
            Text(
              time,
              style: AppStyles.timeTextStyle, // <-- Pakai dari CSS
            ),
          ],
        ),
      ),
    );
  }

  // 4. BAGIAN KOTAK KETIK PESAN (INPUT TEXT)
  Widget _buildMessageInput() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: AppStyles.inputContainerDecoration, // <-- Pakai dari CSS
      child: SafeArea(
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: _messageController,
                decoration: AppStyles.messageInputDecoration, // <-- Pakai dari CSS
              ),
            ),
            const SizedBox(width: 12),
            GestureDetector(
              onTap: _sendMessage,
              child: const CircleAvatar(
                radius: 24,
                backgroundColor: AppStyles.primaryColor,
                child: Icon(Icons.send_rounded, color: AppStyles.whiteColor, size: 20),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
