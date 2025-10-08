import 'package:flutter/material.dart';
import 'home_screen.dart';
import 'profile_screen.dart';
import '../models/campus.dart';
import 'news_screen.dart';
// ⚠️ Đảm bảo file appointment_screen.dart chứa cả class Appointment MODEL
import 'appointment_screen.dart'; 
// Thêm import cho model Doctor nếu cần (Giả định nằm trong ../models/campus.dart)
// import '../models/campus.dart'; 

// --- Màn hình giả (Placeholder Screens) ---

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return const Center(child: Text('Nội dung Màn hình Thông báo'));
  }
}

// ------------------------------------------

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _selectedIndex = 0;
  int _nextAppointmentId = 2; // Dùng để tạo ID duy nhất

  // 💥 QUẢN LÝ TRẠNG THÁI LỊCH HẸN
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

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  // 💥 HÀM THÊM LỊCH HẸN (dùng cho DetailsScreen)
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

    // Chuyển sang tab Lịch hẹn (Index 1) và hiển thị thông báo
    _onItemTapped(1); 
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('✅ Đặt lịch thành công với ${doctor.name} vào 25/11/2025')),
    );
  }

  // 💥 HÀM XÓA LỊCH HẸN (dùng cho AppointmentScreen)
  void _deleteAppointment(Appointment appt) {
    setState(() {
      _appointments.removeWhere((a) => a.id == appt.id);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Đã hủy lịch hẹn với ${appt.doctorName}')),
    );
  }

  // 💥 HÀM SỬA LỊCH HẸN (chỉ hiển thị thông báo, cần logic sửa thực tế)
  void _editAppointment(Appointment appt) {
    // Trong thực tế, bạn sẽ mở một dialog hoặc chuyển đến trang Edit Appointment
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Mở form sửa lịch hẹn: ${appt.doctorName}')),
    );
  }

  @override
  Widget build(BuildContext context) {
    // 💥 CẬP NHẬT DANH SÁCH MÀN HÌNH ĐỂ TRUYỀN CALLBACKS VÀ DATA
    final List<Widget> _screens = <Widget>[
      // HomeScreen phải có khả năng điều hướng đến DetailsScreen và truyền _addAppointment
      HomeScreen(onBookAppointment: _addAppointment), 
      
      // AppointmentScreen nhận data và callbacks
      AppointmentScreen(
        appointments: _appointments,
        onDelete: _deleteAppointment,
        onEdit: _editAppointment,
        onBookAppointment: _addAppointment,
      ),
      NewsScreen(),
      const NotificationScreen(),
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