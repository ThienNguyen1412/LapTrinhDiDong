import 'package:flutter/material.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Danh sách thông báo mẫu
    final List<Map<String, String>> notifications = [
      {
        'title': 'Xác nhận lịch khám',
        'content': 'Lịch khám của bạn lúc 09:00 ngày 08/10/2025 đã được xác nhận.'
      },
      {
        'title': 'Cập nhật hồ sơ',
        'content': 'Bạn đã cập nhật thông tin cá nhân thành công.'
      },
      {
        'title': 'Thông báo hệ thống',
        'content': 'Ứng dụng sẽ bảo trì từ 22:00 đến 23:00 ngày 10/10/2025.'
      },
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('Thông báo')),
      body: ListView.builder(
        itemCount: notifications.length,
        itemBuilder: (context, index) {
          final notification = notifications[index];
          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: ListTile(
              leading: const Icon(Icons.notifications, color: Colors.teal),
              title: Text(notification['title'] ?? ''),
              subtitle: Text(notification['content'] ?? ''),
            ),
          );
        },
      ),
    );
  }
}