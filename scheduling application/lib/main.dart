// File: main.dart

import 'package:flutter/material.dart';
// 💥 KHÔNG CẦN import details_screen.dart và home_screen.dart nếu không dùng route trực tiếp
// import 'screens/home/details_screen.dart'; 
// import 'screens/home/home_screen.dart'; 
import 'screens/login_screen.dart'; // Màn hình Đăng nhập
import 'screens/dashboard_screen.dart'; // Màn hình chính
import 'models/doctor.dart'; // Cần nếu DoctorApp muốn truyền Doctor object (nhưng không cần cho main)
import 'screens/screens.dart'; // Chứa các màn hình phụ (MyAppointmentsScreen, RegisterScreen, v.v.)

void main() {
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
      
      initialRoute: '/login', 
      
      // 💥 TỐI ƯU HÓA ROUTES: Chỉ giữ lại các entry point chính và các màn hình phụ được gọi từ Profile/Settings.
      routes: {
        // ENTRY POINTS
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
      
      // 💥 BỎ onGenerateRoute: Vì bạn nên dùng Navigator.push trực tiếp (như đã làm trong DoctorCard)
      // để truyền Doctor object và callback đặt lịch cho DetailsScreen.
    );
  }
}