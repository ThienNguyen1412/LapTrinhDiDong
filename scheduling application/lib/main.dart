import 'package:flutter/material.dart';
import 'screens/details_screen.dart'; // Giữ nguyên
import 'screens/home_screen.dart';     // Giữ nguyên
import 'screens/login_screen.dart';    // Thêm màn hình Đăng nhập mới
import 'models/campus.dart';
import 'screens/screens.dart';
void main() {
  runApp(const DoctorApp()); 
}

class DoctorApp extends StatelessWidget {
  const DoctorApp({super.key}); 

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Thông tin Bác sĩ & Đăng nhập',
      
      // Cập nhật Theme hiện đại hơn (như đề xuất trước)
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal), 
        useMaterial3: true,
        fontFamily: 'Roboto',
        appBarTheme: const AppBarTheme(
          centerTitle: true,
          backgroundColor: Colors.white,
          foregroundColor: Colors.teal,
          elevation: 0,
        ),
      ),
      
      // Đặt màn hình Đăng nhập là màn hình khởi tạo
      initialRoute: '/login', 
      
      routes: {
        // 1. Màn hình Đăng nhập (Mới)
        '/login': (context) => const LoginScreen(), 
        
        // 2. Màn hình chính sau khi đăng nhập (Dashboard chứa Trang chủ và Hồ sơ)
        '/dashboard': (context) => const DashboardScreen(),
        
        // 3. Các màn hình cũ (giữ lại)
        // Lưu ý: Các route này có thể được truy cập từ bên trong DashBoard
        '/home': (context) => HomeScreen(), 
        //Trang lịch hẹn
        '/appointments': (context) => MyAppointmentsScreen(),
        //Trang cập nhật thông tin
        '/update_profile': (context) => UpdateProfileScreen(),
        //Trang thông báo
        '/notifications': (context) => NotificationsScreen(),
        //Trang đổi mật khẩu
        '/change_password': (context) => ChangePasswordScreen(),
        //Trang hỗ trợ
        '/support': (context) => SupportScreen(),
        //Trang đăng ký
        '/register': (context) => RegisterScreen(),
      },
      onGenerateRoute: (settings) {
        if (settings.name == '/details') {
          final doctor = settings.arguments as Doctor;
          return MaterialPageRoute(
            builder: (context) => DetailsScreen(doctor: doctor),
          );
        }
        return null;
      },
    );
  }
}