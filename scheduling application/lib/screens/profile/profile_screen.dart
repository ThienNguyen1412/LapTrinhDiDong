import 'package:flutter/material.dart';
// 💥 Import màn hình Admin Dashboard (Giả định)
import '../admin_home_screen.dart'; 

class ProfileScreen extends StatelessWidget {
  // 💥 Cờ giả định để kiểm tra quyền Admin
  final bool isAdmin = true; // Đặt là true để thấy nút

  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Thông tin mẫu
    const String name = 'Nguyễn Minh Thiện (Admin)';
    const String email = 'thiennguyen@gmail.com';
    const String phone = '0901 234 567';
    const String avatarUrl =
        'https://img.lovepik.com/free-png/20220101/lovepik-tortoise-png-image_401154498_wh860.png';
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

    // Danh sách chức năng cơ bản
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

    // 💥 Thêm chức năng Admin nếu là Admin
    if (isAdmin) {
      features.insert(0, 
        _ProfileFeature(
          icon: Icons.admin_panel_settings,
          title: 'Truy Cập Admin Dashboard',
          onTap: () {
            // Điều hướng tới màn hình Admin Dashboard
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (c) => const AdminHomeScreen(),
              ),
            );
          },
          // 💥 Tùy chỉnh màu sắc để nổi bật
          color: Colors.red.shade700, 
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Hồ sơ'),
        backgroundColor: Colors.teal, // Thống nhất màu sắc AppBar
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Quay lại đăng nhập',
            onPressed: () {
              Navigator.pushNamedAndRemoveUntil(
                context,
                '/login', // Giả định route đăng nhập là '/login'
                (route) => false,
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Phần Thông tin người dùng (Giữ nguyên)
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
            // Các chức năng (Đã cập nhật)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: features.map((feature) {
                  return Card(
                    elevation: 2,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    child: ListTile(
                      leading: Icon(feature.icon, color: feature.color ?? Colors.teal), // Sử dụng màu tùy chỉnh
                      title: Text(
                        feature.title, 
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: feature.color != null ? FontWeight.bold : FontWeight.normal,
                          color: feature.color ?? Colors.black, // Sử dụng màu tùy chỉnh
                        ),
                      ),
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

// Model chức năng (ĐÃ CẬP NHẬT THÊM THUỘC TÍNH MÀU SẮC)
class _ProfileFeature {
  final IconData icon;
  final String title;
  final VoidCallback onTap;
  final Color? color; // 💥 Thêm thuộc tính màu sắc

  _ProfileFeature({
    required this.icon,
    required this.title,
    required this.onTap,
    this.color, // Có thể null
  });
}