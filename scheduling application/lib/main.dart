import 'package:flutter/material.dart';
import 'package:scheduling_application/models/doctor.dart';
import 'package:scheduling_application/models/user.dart';
import 'screens/login_screen.dart';
import 'screens/home/details_screen.dart';
import 'screens/home/home_screen.dart';
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
      routes: {
        '/login': (context) => const LoginScreen(),
        '/appointments': (context) => const MyAppointmentsScreen(),
        '/notifications': (context) => const NotificationsScreen(),
        '/change_password': (context) => const ChangePasswordScreen(),
        '/support': (context) => const SupportScreen(),
        '/register': (context) => const RegisterScreen(),
      },
      onGenerateRoute: (settings) {
        if (settings.name == '/dashboard') {
          // Nhận object User qua arguments
          final user = settings.arguments as User;
          return MaterialPageRoute(
            builder: (context) => DashboardScreen(user: user),
          );
        }
        if (settings.name == '/home') {
          final user = settings.arguments as User;
          return MaterialPageRoute(
            builder: (context) =>
                HomeScreen(user: user, onBookAppointment: (doctor) {}),
          );
        }
        if (settings.name == '/update_profile') {
         final user = settings.arguments as User;
          // Đảm bảo tham số không null và có chứa userId
            return MaterialPageRoute(
              builder: (context) {
                return UpdateProfileScreen(user: user);
              },
            );
          
        }
        if (settings.name == '/details') {
          final doctor = settings.arguments as Doctor;
          return MaterialPageRoute(
            builder: (context) => DetailsScreen(
              doctor: doctor,
              onBookAppointment: (_) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text(
                      'Không thể đặt lịch qua named route! Vui lòng dùng Navigator.push.',
                    ),
                  ),
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
