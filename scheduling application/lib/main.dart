import 'package:flutter/material.dart';
import 'package:scheduling_application/models/doctor.dart';
import 'package:scheduling_application/models/user.dart';

// Screens (adjust paths if your project structure differs)
import 'screens/login_screen.dart';
import 'screens/dashboard_screen.dart';
import 'screens/home/home_screen.dart';
import 'screens/home/details_screen.dart';
import 'screens/admin_home_screen.dart';
import 'screens/screens.dart'; // optional aggregator for smaller screens (register, appointments, etc.)
import 'services/auth.dart';
// If your UpdateProfileScreen isn't exported by screens.dart, import it explicitly:
// import 'screens/update_profile/update_profile_screen.dart';

/// Optional global navigator key (useful for showing snackbars from non-widget code)
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Try auto-login before runApp so we can decide initial route and pass user
  final User? user = await AuthService.instance.tryAutoLogin();
  final String initialRoute = (user != null) ? '/dashboard' : '/login';

  runApp(DoctorApp(initialRoute: initialRoute, initialUser: user));
}

class DoctorApp extends StatelessWidget {
  final String initialRoute;
  final User? initialUser;

  const DoctorApp({super.key, required this.initialRoute, this.initialUser});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Ứng dụng Đặt lịch Khám bệnh',
      navigatorKey: navigatorKey,

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

      // Use the computed initial route (dashboard if persisted user found)
      initialRoute: initialRoute,

      // Static named routes that don't require arguments
      routes: {
        '/login': (context) => const LoginScreen(),
        '/admin_home': (context) => const AdminHomeScreen(),
        '/register': (context) => const RegisterScreen(),
        '/appointments': (context) => const MyAppointmentsScreen(),
        '/notifications': (context) => const NotificationsScreen(),
        '/change_password': (context) => const ChangePasswordScreen(),
        '/support': (context) => const SupportScreen(),
      },

      // Dynamic routing for screens that require arguments (User, Doctor...)
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case '/dashboard':
            {
              // Accept either the initialUser passed from main OR an argument supplied during navigation
              final User? userArg = (settings.arguments is User) ? settings.arguments as User : initialUser;
              if (userArg == null) {
                // If still null, redirect to login
                return MaterialPageRoute(builder: (c) => const LoginScreen(), settings: settings);
              }
              return MaterialPageRoute(builder: (c) => DashboardScreen(user: userArg), settings: settings);
            }

          case '/home':
            {
              final args = settings.arguments;
              final User? userArg = (args is User) ? args : initialUser;
              if (userArg == null) {
                return MaterialPageRoute(builder: (c) => const LoginScreen());
              }
              return MaterialPageRoute(
                builder: (context) => HomeScreen(
                  user: userArg,
                  notifications: [], // pass real notifications here if available
                  markNotificationAsRead: (id) {
                    /* noop or implement */
                  },
                  onBookAppointment: (doctor) {
                    /* implement */
                  },
                ),
                settings: settings,
              );
            }

          case '/update_profile':
            {
              final args = settings.arguments;
              final User? userArg = (args is User) ? args : initialUser;
              if (userArg == null) return _errorRoute('Missing or invalid User for /update_profile');
              return MaterialPageRoute(
                builder: (context) => UpdateProfileScreen(user: userArg),
                settings: settings,
              );
            }

          case '/details':
            {
              final args = settings.arguments;
              if (args is! Doctor) return _errorRoute('Missing or invalid Doctor for /details');
              final doctor = args;
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
                settings: settings,
              );
            }

          default:
            return null;
        }
      },
    );
  }

  MaterialPageRoute _errorRoute(String message) {
    return MaterialPageRoute(
      builder: (context) => Scaffold(
        appBar: AppBar(title: const Text('Lỗi điều hướng')),
        body: Center(child: Text(message)),
      ),
    );
  }
}