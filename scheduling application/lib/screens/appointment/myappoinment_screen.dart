import 'package:flutter/material.dart';

class MyAppointmentsScreen extends StatelessWidget {
  const MyAppointmentsScreen({super.key});

  // Data mẫu cho lịch hẹn
  final List<Map<String, dynamic>> appointments = const [
    {
      'doctor': 'BS. Nguyễn Văn A',
      'department': 'Nội tổng quát',
      'date': '08/10/2025',
      'time': '09:00',
      'location': 'Phòng 101 - Tầng 1',
      'status': 'Đã xác nhận',
    },
    {
      'doctor': 'BS. Trần Thị B',
      'department': 'Nhi khoa',
      'date': '12/10/2025',
      'time': '14:30',
      'location': 'Phòng 202 - Tầng 2',
      'status': 'Chờ xác nhận',
    },
    {
      'doctor': 'BS. Lê Văn C',
      'department': 'Da liễu',
      'date': '20/10/2025',
      'time': '10:15',
      'location': 'Phòng 303 - Tầng 3',
      'status': 'Đã hủy',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lịch Hẹn Của Tôi'),
      ),
      body: appointments.isEmpty
          ? const Center(
              child: Text('Hiện chưa có lịch hẹn nào.',
                  style: TextStyle(fontSize: 16)),
            )
          : ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
              itemCount: appointments.length,
              itemBuilder: (context, index) {
                final appointment = appointments[index];
                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                  elevation: 3,
                  child: ListTile(
                    contentPadding:
                        const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                    leading: CircleAvatar(
                      radius: 26,
                      child: Icon(Icons.local_hospital, size: 28),
                    ),
                    title: Text(
                      appointment['doctor'],
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Chuyên khoa: ${appointment['department']}'),
                        Text('Thời gian: ${appointment['date']} - ${appointment['time']}'),
                        Text('Địa điểm: ${appointment['location']}'),
                        Text('Trạng thái: ${appointment['status']}',
                            style: TextStyle(
                                color: appointment['status'] == 'Đã xác nhận'
                                    ? Colors.green
                                    : appointment['status'] == 'Chờ xác nhận'
                                        ? Colors.orange
                                        : Colors.red)),
                      ],
                    ),
                    onTap: () {
                      // Mở chi tiết lịch hẹn nếu muốn
                    },
                  ),
                );
              },
            ),
    );
  }
}