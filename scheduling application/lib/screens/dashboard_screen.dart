import 'package:flutter/material.dart';
import 'package:scheduling_application/models/user.dart';
import 'home/home_screen.dart';
import 'profile/profile_screen.dart';
import '../models/doctor.dart';
import '../models/notification.dart';
import 'news/news_screen.dart';
import 'appointment/appointment_screen.dart';
import 'notification/notification_screen.dart';
import 'service/service_screen.dart';

class DashboardScreen extends StatefulWidget {
  final User user;
  const DashboardScreen({Key? key, required this.user}) : super(key: key);

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _selectedIndex = 0;
  int _nextAppointmentId = 2;

  // Quản lý trạng thái lịch hẹn
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

  // Quản lý trạng thái thông báo
  List<AppNotification> _notifications = AppNotification.initialNotifications();

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  // Hàm thêm thông báo khi đặt lịch thành công
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

  // Hàm gốc thêm lịch hẹn
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

    _onItemTapped(1);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          '✅ Đặt lịch thành công với ${doctor.name} vào 25/11/2025',
        ),
      ),
    );
  }

  // Hàm đánh dấu thông báo đã đọc
  void _markNotificationAsRead(String id) {
    setState(() {
      final index = _notifications.indexWhere((noti) => noti.id == id);
      if (index >= 0 && !_notifications[index].isRead) {
        _notifications[index] = _notifications[index].copyWith(isRead: true);
      }
    });
  }

  // Hàm xóa và sửa lịch hẹn
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
      // 0. Trang chủ
      HomeScreen(
        user: widget.user,
        onBookAppointment: _addNotificationForAppointment,
      ),
      // 1. Lịch hẹn
      AppointmentScreen(
        appointments: _appointments,
        onDelete: _deleteAppointment,
        onEdit: _editAppointment,
        onBookAppointment: _addNotificationForAppointment,
      ),
      // 2. Dịch vụ
      ServiceScreen(
        onBookAppointment: _addNotificationForAppointment,
        unreadNotifications: _notifications,
        markNotificationAsRead: _markNotificationAsRead,
      ),
      // 3. Tin tức
      NewsScreen(),
      // 4. Thông báo
      NotificationScreen(
        notifications: _notifications,
        markAsRead: _markNotificationAsRead,
      ),
      // 5. Hồ sơ
      ProfileScreen(user: widget.user),
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
          BottomNavigationBarItem(icon: Icon(Icons.calendar_today), label: 'Lịch hẹn'),
          BottomNavigationBarItem(icon: Icon(Icons.medical_services), label: 'Dịch vụ'),
          BottomNavigationBarItem(icon: Icon(Icons.article), label: 'Tin tức'),
          BottomNavigationBarItem(icon: Icon(Icons.notifications), label: 'Thông báo'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Hồ sơ'),
        ],
      ),
    );
  }
}