import 'package:flutter/material.dart';
import '../../models/doctor.dart';
import 'book_new_appointment_screen.dart';
import 'appointment_detail_screen.dart';
import '../../models/appointment.dart' as model;

// --- WIDGET CHÍNH ---
class AppointmentScreen extends StatelessWidget {
  final List<model.Appointment> appointments;
  final Function(model.Appointment) onDelete;
  final Function(model.Appointment) onEdit;
  final void Function(Doctor) onBookAppointment;

  // ✨ SỬA LỖI: Cập nhật constructor với `super.key`
  const AppointmentScreen({
    super.key,
    required this.appointments,
    required this.onDelete,
    required this.onEdit,
    required this.onBookAppointment,
  });

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Lịch Hẹn'),
          backgroundColor: Colors.blue.shade800,
          elevation: 0,
          automaticallyImplyLeading: false, // Bỏ nút back
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Sắp tới'),
              Tab(text: 'Hoàn thành'),
              Tab(text: 'Đã hủy'),
            ],
            indicatorColor: Colors.white,
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white70,
          ),
        ),
        body: TabBarView(
          children: [
            // Truyền các hàm và dữ liệu xuống AppointmentListView
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
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => BookNewAppointmentScreen(
                  onBookAppointment: onBookAppointment,
                ),
              ),
            );
          },
          label: const Text('Đặt Lịch Mới'),
          icon: const Icon(Icons.add),
          backgroundColor: Colors.blueAccent,
        ),
      ),
    );
  }
}

// --- WIDGET HIỂN THỊ DANH SÁCH ---
class AppointmentListView extends StatelessWidget {
  final List<model.Appointment> appointments;
  final Function(model.Appointment) onDelete;
  final Function(model.Appointment) onEdit;
  final String statusFilter;

  // ✨ SỬA LỖI: Cập nhật constructor với `super.key`
  const AppointmentListView({
    super.key,
    required this.appointments,
    required this.onDelete,
    required this.onEdit,
    required this.statusFilter,
  });

  @override
  Widget build(BuildContext context) {
    final filteredAppointments =
        appointments.where((a) => a.status == statusFilter).toList();

    if (filteredAppointments.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.calendar_today_outlined,
                size: 60, color: Colors.grey.shade400),
            const SizedBox(height: 16),
            const Text(
              'Không có lịch hẹn nào.',
              style: TextStyle(color: Colors.grey, fontSize: 16),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.only(top: 8.0, bottom: 80.0),
      itemCount: filteredAppointments.length,
      itemBuilder: (context, index) {
        final appointment = filteredAppointments[index];

        Color statusColor;
        IconData statusIcon;
        switch (statusFilter) {
          case 'upcoming':
            statusColor = Colors.blue;
            statusIcon = Icons.pending_actions;
            break;
          case 'completed':
            statusColor = Colors.green;
            statusIcon = Icons.check_circle;
            break;
          case 'cancelled':
            statusColor = Colors.red;
            statusIcon = Icons.cancel;
            break;
          default:
            statusColor = Colors.grey;
            statusIcon = Icons.help_outline;
        }

        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          elevation: 3,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: ListTile(
            leading: CircleAvatar(
              // ✨ SỬA LỖI: Thay thế `withOpacity` bằng `withAlpha`
              // 0.1 opacity tương đương với alpha là 26
              backgroundColor: statusColor.withAlpha(26),
              child: Icon(statusIcon, color: statusColor),
            ),
            title: Text(
              appointment.doctorName,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Text(
              '${appointment.specialty}\n${appointment.date} lúc ${appointment.time}',
            ),
            isThreeLine: true,
            trailing: (statusFilter == 'upcoming')
                ? Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit_calendar_outlined,
                            color: Colors.orange),
                        onPressed: () => onEdit(appointment),
                        tooltip: 'Sửa lịch hẹn',
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete_outline, color: Colors.red),
                        onPressed: () => onDelete(appointment),
                        tooltip: 'Hủy lịch hẹn',
                      ),
                    ],
                  )
                : null,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      AppointmentDetailScreen(appointment: appointment),
                ),
              );
            },
          ),
        );
      },
    );
  }
}