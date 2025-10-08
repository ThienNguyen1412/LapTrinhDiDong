import 'package:flutter/material.dart';
// ⚠️ Cần đảm bảo rằng các import dưới đây trỏ đến file chính xác
import 'screens/details_screen.dart'; 
import 'screens/home_screen.dart';
import 'screens/login_screen.dart'; 
import 'screens/dashboard_screen.dart';
import 'models/campus.dart'; // Chứa model Doctor

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
        // Giữ nguyên Theme hiện đại
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue), // Đổi màu chính sang xanh dương
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
      
      routes: {
        // 1. Màn hình Đăng nhập
        '/login': (context) => const LoginScreen(), 
        
        // 2. Màn hình chính (Dashboard chứa BottomNavigationBar)
        '/dashboard': (context) => const DashboardScreen(),
        
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
      
      // ⚠️ Cập nhật onGenerateRoute
      // Route /details không cần thiết nữa vì đã dùng Navigator.push trong DoctorCard
      // Tuy nhiên, nếu bạn muốn giữ lại cơ chế này cho Route, bạn phải truyền callback
      // qua arguments, điều này rất phức tạp và không được khuyến khích.
      // Chúng ta sẽ giữ lại logic cơ bản, nhưng lưu ý rằng nó KHÔNG ĐỦ để đặt lịch hẹn.
      onGenerateRoute: (settings) {
        if (settings.name == '/details') {
          // Lấy doctor object
          final doctor = settings.arguments as Doctor;
          
          // Tạo một hàm callback giả định: Vì bạn không thể truyền callback qua named routes dễ dàng,
          // việc sử dụng route này sẽ KHÔNG hỗ trợ chức năng đặt lịch. 
          // Nếu bạn muốn đặt lịch, bạn PHẢI dùng Navigator.push như đã cập nhật trong HomeScreen.
          // Tốt nhất là BỎ ROUTE NÀY VÀ CHỈ DÙNG NAVIGATOR.PUSH.

          return MaterialPageRoute(
            builder: (context) => DetailsScreen(
              doctor: doctor,
              // ⚠️ Cần cung cấp một hàm xử lý (dummy function)
              onBookAppointment: (_) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Không thể đặt lịch qua named route! Vui lòng dùng Navigator.push.')),
                );
              },
            ),
          );
        }
        return null;
      },
    );
  }
}

// ⚠️ GHI CHÚ QUAN TRỌNG: 
// Đảm bảo rằng tất cả các màn hình phụ đã được thêm 'const' vào constructor
// nếu chúng là StatelessWidget và không có tham số động.
// Ví dụ: const MyAppointmentsScreen(), const UpdateProfileScreen(), v.v.