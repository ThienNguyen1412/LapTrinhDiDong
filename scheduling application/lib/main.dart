// File: main.dart

import 'package:flutter/material.dart';
// 💥 KHÔNG CẦN import details_screen.dart và home_screen.dart nếu không dùng route trực tiếp
// import 'screens/home/details_screen.dart'; 
// import 'screens/home/home_screen.dart'; 
import 'screens/login_screen.dart'; // Màn hình Đăng nhập
import 'screens/dashboard_screen.dart'; // Màn hình chính
import 'models/doctor.dart'; // Cần nếu DoctorApp muốn truyền Doctor object (nhưng không cần cho main)
import 'screens/screens.dart'; // Chứa các màn hình phụ (MyAppointmentsScreen, RegisterScreen, v.v.)
import 'package:flutter/material.dart';
import 'screens/login_screen.dart';    // Thêm màn hình Đăng nhập mới
import 'models/campus.dart';
// ⚠️ Cần đảm bảo rằng các import dưới đây trỏ đến file chính xác
import 'screens/home/details_screen.dart'; 
import 'screens/home/home_screen.dart';
import 'screens/login_screen.dart'; 
import 'screens/dashboard_screen.dart';
import 'models/campus.dart'; // Chứa model Doctor
import './screens/home/home_screen.dart';
// Giả định rằng 'screens/screens.dart' chứa tất cả các màn hình khác
// MyAppointmentsScreen, UpdateProfileScreen, NotificationsScreen, ChangePasswordScreen, SupportScreen
// Nếu không, bạn cần import từng file riêng lẻ.
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
        // 3. Các màn hình cũ (giữ lại)
        // Lưu ý: Các route này có thể được truy cập từ bên trong DashBoard
        
        '/home': (context) => HomeScreen(onBookAppointment: (doctor) {},), 
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
        // 3. Các màn hình phụ truy cập từ ProfileScreen/Settings (Nếu không dùng Navigator.push)
        '/home': (context) => HomeScreen(onBookAppointment: (doctor) {
            // ⚠️ Cần truyền hàm xử lý đặt lịch nếu bạn muốn truy cập /home trực tiếp
            // Tuy nhiên, việc này không cần thiết vì HomeScreen đã được nhúng trong Dashboard.
            // Nếu vẫn muốn giữ, cần cung cấp logic
            ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Không thể đặt lịch khi truy cập Home trực tiếp qua route!'))
            );
          }), 
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