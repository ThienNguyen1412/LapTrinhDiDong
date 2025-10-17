import 'package:flutter/material.dart';
import 'package:scheduling_application/models/user.dart';
import 'package:scheduling_application/models/doctor.dart';
import 'package:scheduling_application/models/notification.dart';
import 'package:scheduling_application/models/appointment.dart' as model;

import 'home/home_screen.dart';
import 'appointment/appointment_screen.dart';
import 'service/service_screen.dart';
import 'news/news_screen.dart';
import 'notification/notification_screen.dart';
import 'profile/profile_screen.dart';

class DashboardScreen extends StatefulWidget {
  final User user;
  const DashboardScreen({Key? key, required this.user}) : super(key: key);

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _selectedIndex = 0;
  int _nextAppointmentId = 2;

  // Appointments stored using the appointment model alias
  final List<model.Appointment> _appointments = [
    // Example initial appointment (adjust fields according to your model)
    model.Appointment(
      id: 'appt1',
      doctorName: 'Bác sĩ Minh',
      specialty: 'Nhi khoa',
      date: '10/11/2025',
      time: '14:30',
      status: 'upcoming',
    ),
  ];

  // Notifications
  List<AppNotification> _notifications = AppNotification.initialNotifications();

  // Helper: add new appointment
  void _addAppointment(Doctor doctor) {
    final newAppt = model.Appointment(
      id: 'appt${_nextAppointmentId++}',
      doctorName: doctor.name,
      specialty: doctor.specialty,
      date: '25/11/2025',
      time: '10:00',
      status: 'upcoming',
    );

    setState(() {
      _appointments.add(newAppt);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('✅ Đặt lịch thành công với ${doctor.name}')),
    );
  }

  // When booking from Home, add both appointment and a notification
  void _handleBookAppointment(Doctor doctor) {
    _addAppointment(doctor);

    final newNotification = AppNotification(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: 'Đã đặt lịch với ${doctor.name}',
      body: 'Bạn đã đặt lịch khám với ${doctor.name} (${doctor.specialty}) vào 25/11/2025.',
      date: DateTime.now(),
      isRead: false,
    );

    setState(() {
      _notifications.add(newNotification);
      _selectedIndex = 1; // switch to Appointments tab
    });
  }

  // Mark notification as read
  void _markNotificationAsRead(String id) {
    setState(() {
      final idx = _notifications.indexWhere((n) => n.id == id);
      if (idx >= 0 && !_notifications[idx].isRead) {
        _notifications[idx] = _notifications[idx].copyWith(isRead: true);
      }
    });
  }

  // Delete appointment
  void _deleteAppointment(model.Appointment appt) {
    setState(() {
      _appointments.removeWhere((a) => a.id == appt.id);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Đã hủy lịch hẹn với ${appt.doctorName}')),
    );
  }

  // Edit appointment (placeholder)
  void _editAppointment(model.Appointment appt) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Mở form sửa lịch hẹn: ${appt.doctorName}')),
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> screens = <Widget>[
      HomeScreen(
        user: widget.user,
        notifications: _notifications,
        markNotificationAsRead: _markNotificationAsRead,
        onBookAppointment: _handleBookAppointment,
      ),
      AppointmentScreen(
        appointments: _appointments,
        onDelete: _deleteAppointment,
        onEdit: _editAppointment,
        onBookAppointment: _handleBookAppointment,
      ),
      ServiceScreen(
        onBookAppointment: _handleBookAppointment,
        unreadNotifications: _notifications,
        markNotificationAsRead: _markNotificationAsRead,
        addNotification: (notif) {
          setState(() => _notifications.add(notif));
        },
      ),
      const NewsScreen(),
      NotificationScreen(
        notifications: _notifications,
        markAsRead: _markNotificationAsRead,
      ),
      ProfileScreen(user: widget.user),
    ];

    return Scaffold(
      body: screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blue.shade800,
        unselectedItemColor: Colors.grey,
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