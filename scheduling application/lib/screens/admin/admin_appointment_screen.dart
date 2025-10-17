import 'package:flutter/material.dart';
import '../../models/appointment.dart'; // Đảm bảo model Appointment được import

/// Màn hình quản lý các lịch hẹn (dành cho Admin)
class AdminAppointmentScreen extends StatefulWidget {
  final List<Appointment> pendingAppointments;
  final Function(String id, String newStatus) updateAppointmentStatus;

  const AdminAppointmentScreen({
    super.key,
    required this.pendingAppointments,
    required this.updateAppointmentStatus,
  });

  @override
  State<AdminAppointmentScreen> createState() => _AdminAppointmentScreenState();
}

class _AdminAppointmentScreenState extends State<AdminAppointmentScreen> {
  // Lọc lịch hẹn theo trạng thái (chỉ Pending)
  List<Appointment> get _pendingAppointments {
    return widget.pendingAppointments
        .where((app) => app.status == 'Pending')
        .toList();
  }

  // Hàm xác nhận lịch hẹn
  void _confirmAppointment(String id) {
    widget.updateAppointmentStatus(id, 'Confirmed');
  }

  // Hàm hủy lịch hẹn
  void _cancelAppointment(String id) {
    widget.updateAppointmentStatus(id, 'Canceled');
  }

  // Widget xây dựng Card hiển thị chi tiết lịch hẹn
  Widget _buildAppointmentCard(Appointment app, BuildContext context) {
    // 💥 KHẮC PHỤC LỖI: Truy cập trực tiếp các thuộc tính của Appointment
    // Thay vì app.bookingDetails.X hay app.doctor.X
    
    return Card(
      margin: const EdgeInsets.only(bottom: 15),
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Dòng 1: Tiêu đề - Thông tin chung
            const Text(
              'Yêu cầu Đặt lịch khám mới',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF0D47A1)),
            ),
            const Divider(),

            // Dòng 2: Thông tin Bác sĩ
            Row(
              children: [
                const Icon(Icons.person, size: 18, color: Colors.blue),
                const SizedBox(width: 8),
                Text(
                  // 💥 Đã sửa lỗi: Sử dụng app.doctorName và app.specialty
                  'BS: ${app.doctorName} (${app.specialty})', 
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
              ],
            ),
            const SizedBox(height: 8),

            // Dòng 3: Thời gian
            Row(
              children: [
                const Icon(Icons.calendar_today, size: 18, color: Colors.blue),
                const SizedBox(width: 8),
                Text(
                  // 💥 Đã sửa lỗi: Sử dụng app.date và app.time
                  'Thời gian: ${app.date} lúc ${app.time}',
                  style: const TextStyle(fontSize: 16),
                ),
              ],
            ),
            const SizedBox(height: 8),

            // Dòng 4: ID/Trạng thái
            Row(
              children: [
                const Icon(Icons.vpn_key, size: 18, color: Colors.grey),
                const SizedBox(width: 8),
                Text('ID: ${app.id} | Trạng thái: ${app.status}', style: const TextStyle(fontSize: 14, color: Colors.grey)),
              ],
            ),
            // Dòng 5 (Giả định thông tin Bệnh nhân/Địa chỉ nếu có)
            const SizedBox(height: 10),
            
            const Divider(),

            // Khu vực nút bấm Admin
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                // Nút Hủy
                OutlinedButton(
                  onPressed: app.status != 'Pending' ? null : () => _cancelAppointment(app.id),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.red,
                    side: const BorderSide(color: Colors.red),
                  ),
                  child: const Text('Hủy'),
                ),
                const SizedBox(width: 10),
                // Nút Xác nhận
                ElevatedButton(
                  onPressed: app.status != 'Pending' ? null : () => _confirmAppointment(app.id),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                  ),
                  child: const Text('Xác nhận'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: _pendingAppointments.isEmpty
          ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.check_circle_outline, size: 60, color: Colors.green),
                  SizedBox(height: 10),
                  Text(
                    '🎉 Không có lịch hẹn nào đang chờ xử lý.',
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16.0),
              itemCount: _pendingAppointments.length,
              itemBuilder: (context, index) {
                final appointment = _pendingAppointments[index];
                return _buildAppointmentCard(appointment, context);
              },
            ),
    );
  }
}