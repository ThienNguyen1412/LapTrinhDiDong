// File: models/appointment.dart


/// Lớp Appointment lưu trữ chi tiết lịch hẹn của bệnh nhân
class Appointment {
  final String id;
  final String doctorName;
  final String specialty;
  final String date; // Sử dụng String hoặc DateTime
  final String time; // Sử dụng String hoặc TimeOfDay
  String status; // Ví dụ: 'upcoming', 'completed', 'canceled'

  Appointment({
    required this.id,
    required this.doctorName,
    required this.specialty,
    required this.date,
    required this.time,
    this.status = 'upcoming',
  });
  
  // Phương thức copyWith để tạo bản sao với status được cập nhật
  Appointment copyWith({
    String? status,
  }) {
    return Appointment(
      id: id,
      doctorName: doctorName,
      specialty: specialty,
      date: date,
      time: time,
      status: status ?? this.status,
    );
  }
}