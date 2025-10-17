// File: screens/appointment/appointment_detail_screen.dart

import 'package:flutter/material.dart';
// ✨ SỬA LỖI: Import model Appointment từ đúng file
import '../../models/appointment.dart';

class AppointmentDetailScreen extends StatelessWidget {
  final Appointment appointment;

  const AppointmentDetailScreen({super.key, required this.appointment});

  @override
  Widget build(BuildContext context) {
    Color statusColor;
    String statusText;
    IconData statusIcon;

    switch (appointment.status) {
      case 'upcoming':
        statusColor = Colors.blue;
        statusText = 'Sắp tới';
        statusIcon = Icons.pending_actions;
        break;
      case 'completed':
        statusColor = Colors.green;
        statusText = 'Đã hoàn thành';
        statusIcon = Icons.check_circle;
        break;
      case 'cancelled':
        statusColor = Colors.red;
        statusText = 'Đã hủy';
        statusIcon = Icons.cancel;
        break;
      default:
        statusColor = Colors.grey;
        statusText = 'Không xác định';
        statusIcon = Icons.help_outline;
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Chi Tiết Lịch Hẹn'),
        backgroundColor: Colors.blue.shade800,
        foregroundColor: Colors.white,
      ),
      backgroundColor: Colors.grey[50], // Màu nền nhẹ
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- ✨ CẢI TIẾN: Sử dụng Card để nhóm thông tin ---
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    // --- Phần Trạng thái và Ngày giờ ---
                    Row(
                      children: [
                        Icon(statusIcon, color: statusColor, size: 30),
                        const SizedBox(width: 15),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              statusText,
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold, color: statusColor),
                            ),
                            const SizedBox(height: 5),
                            Text(
                              '${appointment.date} lúc ${appointment.time}',
                              style: const TextStyle(fontSize: 16, color: Colors.black87),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const Divider(height: 30),
                    // --- Phần Thông tin Bác sĩ ---
                    _buildDetailRow(
                        'Bác sĩ', appointment.doctorName, Icons.person_outline),
                    _buildDetailRow(
                        'Chuyên khoa', appointment.specialty, Icons.medical_services_outlined),
                    _buildDetailRow(
                        'Mã lịch hẹn', appointment.id, Icons.qr_code_scanner_outlined),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 24),

            // --- ✨ CẢI TIẾN: Nút hành động trông đẹp hơn ---
            if (appointment.status == 'upcoming')
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      ListTile(
                        leading: const Icon(Icons.edit_calendar_outlined, color: Colors.orange),
                        title: const Text('Sửa lịch hẹn'),
                        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                        onTap: () {
                          Navigator.pop(context); 
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Chức năng sửa lịch hẹn...')),
                          );
                        },
                      ),
                      const Divider(height: 1),
                      ListTile(
                        leading: const Icon(Icons.cancel_outlined, color: Colors.red),
                        title: const Text('Hủy lịch hẹn'),
                        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                        onTap: () {
                          // TODO: Hiển thị dialog xác nhận trước khi hủy
                          Navigator.pop(context); 
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Chức năng hủy lịch hẹn...')),
                          );
                        },
                      ),
                    ],
                  ),
                ),
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
          Icon(icon, color: Colors.grey.shade600, size: 22),
          const SizedBox(width: 15),
          Expanded( // Dùng Expanded để text tự xuống dòng nếu quá dài
            child: Column(
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
          ),
        ],
      ),
    );
  }
}