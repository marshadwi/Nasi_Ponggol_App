import 'package:flutter/material.dart';
import '../utils/app_styles.dart'; // <--- IMPORT "CSS"

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  // Data Notifikasi (Bisa diganti fetch API nanti)
  final List<Map<String, dynamic>> notifications = [
      {
        "title": "Pesanan Sedang Diproses! 🍳",
        "message": "Nasi Ponggol Setan dan pesanan lainnya sedang dimasak oleh chef kami.",
        "time": "Baru saja",
        "icon": Icons.restaurant,
        "color": Colors.orange,
      },
      {
        "title": "Promo Spesial Hari Ini! 🎉",
        "message": "Dapatkan diskon 20% untuk semua varian Opor Ayam khusus hari ini.",
        "time": "2 jam yang lalu",
        "icon": Icons.local_offer,
        "color": Colors.green,
      },
      {
        "title": "Selamat Datang di Warung Ponggol!",
        "message": "Terima kasih sudah mendaftar. Jangan lupa lengkapi profil Anda ya.",
        "time": "1 hari yang lalu",
        "icon": Icons.waving_hand,
        "color": Colors.blue,
        "isRead": false,
      },
    ];

  void _markAsRead(int index) {
    setState(() {
      notifications[index]["isRead"] = true;
    });
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: [
            Icon(notifications[index]['icon'], color: notifications[index]['color']),
            const SizedBox(width: 10),
            Expanded(child: Text(notifications[index]['title'], style: const TextStyle(fontSize: 16))),
          ],
        ),
        content: Text(notifications[index]['message']),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Tutup", style: TextStyle(color: Colors.blue)),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppStyles.backgroundColor, // <-- DARI CSS
      appBar: AppBar(
        title: const Text("Notifikasi", style: AppStyles.appBarTitleStyle), // <-- DARI CSS
        backgroundColor: AppStyles.whiteColor,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: notifications.length,
        itemBuilder: (context, index) {
          final notif = notifications[index];
          final bool isRead = notif['isRead'] ?? false;
          
          return AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            margin: const EdgeInsets.only(bottom: 12),
            decoration: BoxDecoration(
              color: isRead ? Colors.grey.shade100 : Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: isRead 
                ? [] 
                : [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 15, offset: const Offset(0, 5))],
              border: Border.all(color: isRead ? Colors.transparent : notif['color'].withOpacity(0.3)),
            ),
            child: InkWell(
              onTap: () => _markAsRead(index),
              borderRadius: BorderRadius.circular(16),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: isRead ? Colors.grey.shade200 : notif['color'].withOpacity(0.15),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(notif['icon'], color: isRead ? Colors.grey : notif['color']),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Text(
                                  notif['title'], 
                                  style: TextStyle(
                                    fontWeight: isRead ? FontWeight.w500 : FontWeight.bold,
                                    color: isRead ? Colors.grey.shade600 : Colors.black87,
                                    fontSize: 15
                                  )
                                )
                              ),
                              if (!isRead)
                                Container(
                                  width: 8, height: 8,
                                  decoration: const BoxDecoration(color: Colors.red, shape: BoxShape.circle),
                                )
                            ],
                          ),
                          const SizedBox(height: 6),
                          Text(
                            notif['message'], 
                            style: TextStyle(color: isRead ? Colors.grey.shade500 : Colors.grey.shade700, fontSize: 13),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 8),
                          Text(notif['time'], style: const TextStyle(fontSize: 11, color: Colors.grey)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}