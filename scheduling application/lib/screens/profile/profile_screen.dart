import 'package:flutter/material.dart';
import 'package:scheduling_application/models/user.dart';

class ProfileScreen extends StatelessWidget {
  final User user;
  const ProfileScreen({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    // Lấy thông tin từ user truyền vào
    final String name = user.fullname;
    final String email = user.email;
    final String phone = user.phone ?? 'Chưa cập nhật';
    final String avatarUrl = 'https://img.lovepik.com/free-png/20220101/lovepik-tortoise-png-image_401154498_wh860.png';

    // Danh sách chức năng
    final List<_ProfileFeature> features = [
      _ProfileFeature(
        icon: Icons.person,
        title: 'Lịch Hẹn Của Tôi',
        onTap: () {
          Navigator.pushNamed(context, '/appointments');
        },
      ),
      _ProfileFeature(
        icon: Icons.edit,
        title: 'Cập nhật thông tin',
        onTap: () {
          Navigator.pushNamed(context, '/update_profile', arguments: user);
        },
      ),
      _ProfileFeature(
        icon: Icons.lock_reset,
        title: 'Đổi mật khẩu',
        onTap: () {
          Navigator.pushNamed(context, '/change_password');
        },
      ),
      _ProfileFeature(
        icon: Icons.notifications,
        title: 'Thông báo',
        onTap: () {
          Navigator.pushNamed(context, '/notifications');
        },
      ),
      _ProfileFeature(
        icon: Icons.support_agent,
        title: 'Hỗ trợ',
        onTap: () {
          Navigator.pushNamed(context, '/support');
        },
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Hồ sơ'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Quay lại đăng nhập',
            onPressed: () {
              Navigator.pushNamedAndRemoveUntil(
                context,
                '/login',
                (route) => false,
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Card(
              elevation: 4,
              margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CircleAvatar(
                      radius: 48,
                      backgroundImage: NetworkImage(avatarUrl),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      name,
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      email,
                      style: const TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.phone, size: 18, color: Colors.blue),
                        const SizedBox(width: 6),
                        Text(phone, style: const TextStyle(fontSize: 16)),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            // Các chức năng
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: features.map((feature) {
                  return Card(
                    elevation: 2,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    child: ListTile(
                      leading: Icon(feature.icon, color: Colors.blue),
                      title: Text(feature.title, style: const TextStyle(fontSize: 16)),
                      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                      onTap: () => feature.onTap(),
                    ),
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Model chức năng
class _ProfileFeature {
  final IconData icon;
  final String title;
  final VoidCallback onTap;

  _ProfileFeature({
    required this.icon,
    required this.title,
    required this.onTap,
  });
}