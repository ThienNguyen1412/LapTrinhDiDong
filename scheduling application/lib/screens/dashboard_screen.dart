import 'package:flutter/material.dart';
import 'home/home_screen.dart';
import 'profile/profile_screen.dart';
import '../models/campus.dart'; // Chứa model Doctor
import '../models/notification.dart'; // Import model AppNotification
import 'news/news_screen.dart';
// ⚠️ Đảm bảo file appointment_screen.dart chứa cả class Appointment MODEL
import 'appointment/appointment_screen.dart'; 
// Import NotificationScreen đã được thiết kế
import 'notification/notification_screen.dart'; 

// ------------------------------------------

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _selectedIndex = 0;
  int _nextAppointmentId = 2; 

  // 💥 1. QUẢN LÝ TRẠNG THÁI LỊCH HẸN
  List<Appointment> _appointments = [
    Appointment(
      id: 'appt1',
      doctorName: 'Bác sĩ Minh', 
      specialty: 'Nhi khoa', 
      date: '10/11/2025', 
      time: '14:30 PM', 
      status: 'upcoming'
    ),
  ];
  
  // 💥 2. QUẢN LÝ TRẠNG THÁI THÔNG BÁO
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
      body: 'Bạn đã đặt lịch khám với Bác sĩ ${doctor.name}, chuyên khoa ${doctor.specialty} vào ngày 25/11/2025. Vui lòng kiểm tra mục Lịch hẹn.',
      date: DateTime.now(),
      isRead: false,
    );

    setState(() {
      _notifications.add(newNotification);
    });
    
    // Gọi hàm thêm lịch hẹn gốc
    _addAppointment(doctor); 
  }

  // 💥 4. HÀM GỐC THÊM LỊCH HẸN (đã được tách ra)
  void _addAppointment(Doctor doctor) {
    final newAppointment = Appointment(
      id: 'appt${_nextAppointmentId++}',
      doctorName: doctor.name,
      specialty: doctor.specialty,
      date: '25/11/2025', // Ngày/Giờ giả định
      time: '10:00 AM',
      status: 'upcoming',
    );
    
    setState(() {
      _appointments.add(newAppointment);
    });

    // Chuyển sang tab Lịch hẹn (Index 1)
    _onItemTapped(1); 
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('✅ Đặt lịch thành công với ${doctor.name} vào 25/11/2025')),
    );
  }

  // 💥 5. HÀM ĐÁNH DẤU THÔNG BÁO ĐÃ ĐỌC
  void _markNotificationAsRead(String id) {
    setState(() {
      final index = _notifications.indexWhere((noti) => noti.id == id);
      if (index >= 0 && !_notifications[index].isRead) {
        // Cập nhật bằng cách sử dụng copyWith (được định nghĩa trong model)
        _notifications[index] = _notifications[index].copyWith(isRead: true);
      }
    });
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
      HomeScreen(onBookAppointment: _addNotificationForAppointment), 
      
      // AppointmentScreen nhận data và callbacks
      AppointmentScreen(
        appointments: _appointments,
        onDelete: _deleteAppointment,
        onEdit: _editAppointment,
        onBookAppointment: _addNotificationForAppointment, // Vẫn dùng hàm thêm thông báo
      ),
      NewsScreen(),
      
      // 💥 NotificationScreen nhận danh sách và hàm đánh dấu đã đọc
      NotificationScreen(
        notifications: _notifications,
        markAsRead: _markNotificationAsRead,
      ),
      ProfileScreen(),
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
          BottomNavigationBarItem(icon: Icon(Icons.article), label: 'Tin tức'),
          BottomNavigationBarItem(icon: Icon(Icons.notifications), label: 'Thông báo'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Hồ sơ'),
        ],
      ),
    );
  }
}