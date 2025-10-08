import 'package:flutter/material.dart';
import 'package:scheduling_application/models/campus.dart';
import 'book_new_appointment_screen.dart'; 
// ⚠️ Cần import các file cần thiết
// import 'book_new_appointment_screen.dart'; 
// import '../models/campus.dart'; // Nếu AppointmentScreen cần model Doctor

// --- APPOINTMENT MODEL (Giữ nguyên) ---
class Appointment {
  final String id;
  final String doctorName;
  final String specialty;
  final String date;
  final String time;
  final String status;

  Appointment({
    required this.id,
    required this.doctorName,
    required this.specialty,
    required this.date,
    required this.time,
    this.status = 'upcoming',
  });
}

// --- APPOINTMENT SCREEN (Widget Chính) ĐÃ CẬP NHẬT ---
class AppointmentScreen extends StatelessWidget {
  final List<Appointment> appointments;
  final Function(Appointment) onDelete;
  final Function(Appointment) onEdit;
  // 💥 THÊM CALLBACK FUNCTION
  final void Function(Doctor) onBookAppointment; // Dùng dynamic vì có thể là Doctor

  const AppointmentScreen({
    super.key,
    required this.appointments,
    required this.onDelete,
    required this.onEdit,
    required this.onBookAppointment, // Bắt buộc
  });

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3, 
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Lịch Hẹn'),
          backgroundColor: Colors.blue,
          elevation: 0,
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Sắp tới'),
              Tab(text: 'Đã hoàn thành'),
              Tab(text: 'Đã hủy'),
            ],
            indicatorColor: Colors.white,
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white70,
          ),
        ),

        // Body chứa nội dung của các Tab (giữ nguyên)
        body: TabBarView(
          children: [
            AppointmentListView(
              appointments: appointments,
              onDelete: onDelete,
              onEdit: onEdit,
              statusFilter: 'upcoming',
            ),
            AppointmentListView(
              appointments: appointments,
              onDelete: onDelete,
              onEdit: onEdit,
              statusFilter: 'completed',
            ),
            AppointmentListView(
              appointments: appointments,
              onDelete: onDelete,
              onEdit: onEdit,
              statusFilter: 'cancelled',
            ),
          ],
        ),

        // 💥 CẬP NHẬT FLOATING ACTION BUTTON
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            // Điều hướng đến màn hình chọn bác sĩ (BookNewAppointmentScreen)
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => BookNewAppointmentScreen(
                  onBookAppointment: onBookAppointment, // Truyền callback
                ),
              ),
            );
          },
          label: const Text('Đặt lịch'),
          icon: const Icon(Icons.add),
          backgroundColor: Colors.blueAccent,
        ),
      ),
    );
  }
}

// --- APPOINTMENT LIST VIEW (Giữ nguyên) ---
class AppointmentListView extends StatelessWidget {
  final List<Appointment> appointments;
  final Function(Appointment) onDelete;
  final Function(Appointment) onEdit;
  final String statusFilter;

  const AppointmentListView({
    super.key,
    required this.appointments,
    required this.onDelete,
    required this.onEdit,
    required this.statusFilter,
  });

  @override
  Widget build(BuildContext context) {
    // Lọc danh sách theo trạng thái (giữ nguyên)
    final filteredAppointments = appointments.where((a) => a.status == statusFilter).toList();

    if (filteredAppointments.isEmpty) {
      return Center(
        child: Text(
          'Không có lịch hẹn $statusFilter nào.',
          style: const TextStyle(color: Colors.grey, fontSize: 16),
        ),
      );
    }

    return ListView.builder(
      itemCount: filteredAppointments.length,
      itemBuilder: (context, index) {
        final appointment = filteredAppointments[index];
        
        Color statusColor;
        switch(statusFilter) {
          case 'upcoming': statusColor = Colors.blue; break;
          case 'completed': statusColor = Colors.green; break;
          case 'cancelled': statusColor = Colors.red; break;
          default: statusColor = Colors.grey;
        }

        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          elevation: 2,
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: statusColor,
              child: const Icon(Icons.person, color: Colors.white),
            ),
            title: Text(
              appointment.doctorName,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Text(
              '${appointment.specialty}\nNgày: ${appointment.date} | Giờ: ${appointment.time}',
            ),
            isThreeLine: true,
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (statusFilter == 'upcoming')
                  IconButton(
                    icon: const Icon(Icons.edit, color: Colors.orange),
                    onPressed: () => onEdit(appointment),
                    tooltip: 'Sửa lịch hẹn',
                  ),
                
                IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () => onDelete(appointment),
                  tooltip: 'Xóa lịch hẹn',
                ),
              ],
            ),
            onTap: () {
              // TODO: Điều hướng đến trang chi tiết lịch hẹn
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Xem chi tiết lịch: ${appointment.doctorName}')),
              );
            },
          ),
        );
      },
    );
  }
}