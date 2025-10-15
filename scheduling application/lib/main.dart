// File: main.dart

import 'package:flutter/material.dart';
import 'screens/login_screen.dart'; // Màn hình Đăng nhập
import 'screens/dashboard_screen.dart'; // Màn hình chính
import 'screens/screens.dart'; 



import 'screens/admin_home_screen.dart'; 

void main() {
  // Để chạy AdminHomeScreen ngay lập tức, bạn có thể gọi nó trực tiếp
  // hoặc thông qua route như bên dưới.
  runApp(const DoctorApp()); 
}

class DoctorApp extends StatelessWidget {
  const DoctorApp({super.key}); 

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Ứng dụng Đặt lịch Khám bệnh',
      
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
        fontFamily: 'Roboto',
        appBarTheme: const AppBarTheme(
          centerTitle: true,
          backgroundColor: Colors.white,
          foregroundColor: Colors.blue,
          elevation: 0,
        ),
      ),
      
      // 💥 THAY ĐỔI TRANG KHỞI ĐỘNG: Đặt route Admin làm trang khởi tạo
      initialRoute: '/dashboard',
      
      // 💥 TỐI ƯU HÓA ROUTES
      routes: {
        // ENTRY POINTS
        // 💥 THÊM ROUTE CỦA MÀN HÌNH ADMIN
        '/admin_home': (context) => const AdminHomeScreen(), 
        
        '/login': (context) => const LoginScreen(), 
        '/dashboard': (context) => const DashboardScreen(),
        
        // MÀN HÌNH PHỤ (Truy cập từ Profile/Settings)
        '/register': (context) => const RegisterScreen(),
        '/appointments': (context) => const MyAppointmentsScreen(),
        '/update_profile': (context) => const UpdateProfileScreen(),
        '/notifications': (context) => const NotificationsScreen(),
        '/change_password': (context) => const ChangePasswordScreen(),
        '/support': (context) => const SupportScreen(),
      },
      
      // 💥 BỎ onGenerateRoute: 
    );
  }
}