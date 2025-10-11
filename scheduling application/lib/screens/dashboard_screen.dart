// File: dashboard_screen.dart

import 'package:flutter/material.dart';
import 'package:scheduling_application/models/user.dart';
import 'home/home_screen.dart';
import 'home/home_screen.dart'; // Trang chủ (Index 0)
import 'profile/profile_screen.dart';
import '../models/doctor.dart'; // Chứa model Doctor
import '../models/notification.dart'; 
import 'news/news_screen.dart';
// ⚠️ Đảm bảo file appointment_screen.dart chứa cả class Appointment MODEL
import 'appointment/appointment_screen.dart';
// Import NotificationScreen đã được thiết kế
import 'notification/notification_screen.dart';
import 'appointment/appointment_screen.dart'; 
import 'notification/notification_screen.dart'; 
import 'service/service_screen.dart'; // Màn hình Dịch vụ (Index 2)

// Giả định Model Appointment đã được định nghĩa và có thể import/sử dụng
// Nếu Appointment chưa được định nghĩa, bạn cần tạo một model Appointment.

// ------------------------------------------

class DashboardScreen extends StatefulWidget {
  final User user;
  const DashboardScreen({Key? key, required this.user}) : super(key: key);
  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _selectedIndex = 0;
  int _nextAppointmentId = 2;

  // 1. QUẢN LÝ TRẠNG THÁI LỊCH HẸN
  List<Appointment> _appointments = [
    Appointment(
      id: 'appt1',
      doctorName: 'Bác sĩ Minh',
      specialty: 'Nhi khoa',
      date: '10/11/2025',
      time: '14:30 PM',
      status: 'upcoming',
    ),
  ];

  // 💥 2. QUẢN LÝ TRẠNG THÁI THÔNG BÁO
  
  // 2. QUẢN LÝ TRẠNG THÁI THÔNG BÁO
  List<AppNotification> _notifications = AppNotification.initialNotifications();

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  // 💥 3. HÀM THÊM THÔNG BÁO (khi đặt lịch thành công)
  void _addNotificationForAppointment(Doctor doctor) {
    final newNotification = AppNotification(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: 'Lịch khám đã được đặt thành công! 🎉',
      body:
          'Bạn đã đặt lịch khám với Bác sĩ ${doctor.name}, chuyên khoa ${doctor.specialty} vào ngày 25/11/2025. Vui lòng kiểm tra mục Lịch hẹn.',
      date: DateTime.now(),
      isRead: false,
    );

  // HÀM ĐÁNH DẤU THÔNG BÁO ĐÃ ĐỌC
  void _markNotificationAsRead(String id) {
    setState(() {
      final index = _notifications.indexWhere((noti) => noti.id == id);
      if (index >= 0 && !_notifications[index].isRead) {
        _notifications[index] = _notifications[index].copyWith(isRead: true);
      }
    });

    // Gọi hàm thêm lịch hẹn gốc
    _addAppointment(doctor);
  }

  // HÀM GỐC THÊM LỊCH HẸN
  void _addAppointment(Doctor doctor) {
    final newAppointment = Appointment(
      id: 'appt${_nextAppointmentId++}',
      doctorName: doctor.name,
      specialty: doctor.specialty,
      date: '25/11/2025',
      time: '10:00 AM',
      status: 'upcoming',
    );

    setState(() {
      _appointments.add(newAppointment);
    });

    // Chuyển sang tab Lịch hẹn (Index 1)
    _onItemTapped(1);
    _onItemTapped(1); // Chuyển sang tab Lịch hẹn (Index 1)
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          '✅ Đặt lịch thành công với ${doctor.name} vào 25/11/2025',
        ),
      ),
    );
  }

  // HÀM THÊM THÔNG BÁO (khi đặt lịch thành công)
  void _addNotificationForAppointment(Doctor doctor) {
    final newNotification = AppNotification(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: 'Lịch khám đã được đặt thành công! 🎉',
      body: 'Bạn đã đặt lịch khám với Bác sĩ ${doctor.name}, chuyên khoa ${doctor.specialty} vào ngày 25/11/2025. Vui lòng kiểm tra mục Lịch hẹn.',
      date: DateTime.now(),
      isRead: false,
    );

    setState(() {
      _notifications.add(newNotification);
    });
    
    _addAppointment(doctor); 
  }

  // 💥 6. HÀM XÓA VÀ SỬA LỊCH HẸN (Giữ nguyên)
  
  void _deleteAppointment(Appointment appt) {
    setState(() {
      _appointments.removeWhere((a) => a.id == appt.id);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Đã hủy lịch hẹn với ${appt.doctorName}')),
    );
  }

  void _editAppointment(Appointment appt) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Mở form sửa lịch hẹn: ${appt.doctorName}')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> _screens = <Widget>[
      // HomeScreen gọi hàm thêm thông báo khi đặt lịch
      HomeScreen(
        user: widget.user,
        onBookAppointment: _addNotificationForAppointment,
      ),

      // AppointmentScreen nhận data và callbacks
    
    // Danh sách 6 màn hình theo thứ tự: [Trang chủ, Lịch hẹn, Dịch vụ, Tin tức, Thông báo, Hồ sơ]
    final List<Widget> _screens = <Widget>[
      // 0. Trang Chủ 
      // 💥 SỬA LỖI: CẦN TRUYỀN ĐỦ THAM SỐ CHO HOMESCREEN MỚI
      HomeScreen(
        onBookAppointment: _addNotificationForAppointment, 
        notifications: _notifications,
        markNotificationAsRead: _markNotificationAsRead,
      ), 
      
      // 1. Lịch hẹn
      AppointmentScreen(
        appointments: _appointments,
        onDelete: _deleteAppointment,
        onEdit: _editAppointment,
        onBookAppointment:
            _addNotificationForAppointment, // Vẫn dùng hàm thêm thông báo
      ),
      NewsScreen(),

      // 💥 NotificationScreen nhận danh sách và hàm đánh dấu đã đọc
      NotificationScreen(
        notifications: _notifications,
        markAsRead: _markNotificationAsRead,
        onBookAppointment: _addNotificationForAppointment, 
      ),
      
      // 2. Dịch vụ (Sử dụng ServiceScreen)
      ServiceScreen(
        onBookAppointment: _addNotificationForAppointment, 
        unreadNotifications: _notifications, 
        markNotificationAsRead: _markNotificationAsRead, 
      ),

      // 3. Tin tức
      const NewsScreen(),
    
      
      // 4. Hồ sơ
      const ProfileScreen(),
    ];

    return Scaffold(
      body: _screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Trang chủ'),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today),
            label: 'Lịch hẹn',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.article), label: 'Tin tức'),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications),
            label: 'Thông báo',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Hồ sơ'),
          // 6 mục trong Bottom Navigation Bar
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Trang chủ'), 
          BottomNavigationBarItem(icon: Icon(Icons.calendar_today), label: 'Lịch hẹn'), 
          BottomNavigationBarItem(icon: Icon(Icons.medical_services), label: 'Dịch vụ'), 
          BottomNavigationBarItem(icon: Icon(Icons.article), label: 'Tin tức'), 
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Hồ sơ'), 
        ],
      ),
    );
  }
}
