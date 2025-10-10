// File: screens/appointment/appointment_detail_screen.dart

import 'package:flutter/material.dart';
// Cần import model Appointment
import 'appointment_screen.dart'; // Giả định Appointment Model nằm ở đây

class AppointmentDetailScreen extends StatelessWidget {
  final Appointment appointment;

  const AppointmentDetailScreen({super.key, required this.appointment});

  @override
  Widget build(BuildContext context) {
    Color statusColor;
    String statusText;

    switch (appointment.status) {
      case 'upcoming':
        statusColor = Colors.blue;
        statusText = 'Sắp tới';
        break;
      case 'completed':
        statusColor = Colors.green;
        statusText = 'Đã hoàn thành';
        break;
      case 'cancelled':
        statusColor = Colors.red;
        statusText = 'Đã hủy';
        break;
      default:
        statusColor = Colors.grey;
        statusText = 'Không xác định';
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Chi Tiết Lịch Hẹn'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- Phần Trạng thái và Ngày giờ ---
            Container(
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: statusColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: statusColor),
              ),
              child: Row(
                children: [
                  Icon(Icons.event, color: statusColor, size: 30),
                  const SizedBox(width: 15),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Trạng thái: $statusText',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold, color: statusColor),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        'Ngày: ${appointment.date} | Giờ: ${appointment.time}',
                        style: const TextStyle(fontSize: 16, color: Colors.black87),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),

            // --- Phần Thông tin Bác sĩ ---
            const Text(
              'Thông tin Bác sĩ:',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const Divider(),
            _buildDetailRow(
                'Tên Bác sĩ', appointment.doctorName, Icons.person_outline),
            _buildDetailRow(
                'Chuyên khoa', appointment.specialty, Icons.healing),
            // Giả định bạn có thêm thông tin bệnh viện trong Appointment Model
            _buildDetailRow(
                'ID Lịch hẹn', appointment.id, Icons.info_outline),
            
            const SizedBox(height: 30),

            // --- Phần Hành động (Tùy chọn) ---
            if (appointment.status == 'upcoming')
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Hành động:',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const Divider(),
                  ListTile(
                    leading: const Icon(Icons.edit, color: Colors.orange),
                    title: const Text('Sửa lịch hẹn'),
                    onTap: () {
                      // TODO: Thêm logic gọi hàm onEdit (Truyền qua constructor nếu cần)
                      Navigator.pop(context); 
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Mở form sửa lịch hẹn...')),
                      );
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.cancel, color: Colors.red),
                    title: const Text('Hủy lịch hẹn'),
                    onTap: () {
                      // TODO: Thêm logic gọi hàm onDelete (Truyền qua constructor nếu cần)
                      Navigator.pop(context); 
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Hộp thoại xác nhận hủy...')),
                      );
                    },
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
  
  // Widget helper để hiển thị từng dòng chi tiết
  Widget _buildDetailRow(String label, String value, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: Colors.blue, size: 24),
          const SizedBox(width: 15),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(fontSize: 14, color: Colors.grey),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
            ],
          ),
        ],
      ),
    );
  }
}