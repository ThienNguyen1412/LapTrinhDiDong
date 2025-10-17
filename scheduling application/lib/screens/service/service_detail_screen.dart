// File: screens/service/service_detail_screen.dart

import 'package:flutter/material.dart';
import '../../models/health_package.dart';
import '../../models/doctor.dart';
import '../../models/notification.dart';
// ✨ 1. THÊM IMPORT NÀY ĐỂ CÓ THỂ SỬ DỤNG BookingDetails và BookingFormModal
import '../home/details_screen.dart';

class ServiceDetailScreen extends StatelessWidget {
  final HealthPackage healthPackage;
  // ✨ 2. CẬP NHẬT "CHỮ KÝ" (SIGNATURE) CỦA HÀM TẠI ĐÂY
  final void Function(Doctor, BookingDetails) onBookAppointment;
  final Function(AppNotification) addNotification;

  const ServiceDetailScreen({
    super.key,
    required this.healthPackage,
    required this.onBookAppointment,
    required this.addNotification,
  });

  // ✨ 3. THAY THẾ HÀM `_bookService` BẰNG HÀM HIỂN THỊ FORM ĐẶT LỊCH
  // Tái sử dụng lại logic từ `DetailsScreen` để đảm bảo tính nhất quán
  void _showBookingForm(BuildContext context) {
    // Vì gói khám không gắn với 1 bác sĩ cụ thể, ta sẽ giả định chọn bác sĩ đầu tiên
    // Trong thực tế, bạn có thể có logic phức tạp hơn ở đây
    final Doctor associatedDoctor = Doctor.getDoctors().first;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.of(ctx).viewInsets.bottom),
        child: BookingFormModal(
          doctor: associatedDoctor, // Truyền bác sĩ giả định vào form
          onConfirm: (bookingDetails) {
            Navigator.pop(ctx); // Đóng modal
            // Gọi hàm onBookAppointment với đầy đủ thông tin
            onBookAppointment(associatedDoctor, bookingDetails);
          },
        ),
      ),
    );
  }

  // Hàm xây dựng danh sách các bước khám (giữ nguyên)
  Widget _buildStepsList() {
    if (healthPackage.steps.isEmpty) {
      return const Text(
        'Không có thông tin chi tiết các bước khám.',
        style: TextStyle(fontSize: 15, color: Colors.grey),
      );
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: healthPackage.steps.asMap().entries.map((entry) {
        int index = entry.key;
        String step = entry.value;
        return Padding(
          padding: const EdgeInsets.only(bottom: 8.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  color: Colors.blue.shade600,
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    '${index + 1}',
                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  step,
                  style: const TextStyle(fontSize: 16, height: 1.4),
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(healthPackage.name),
        backgroundColor: Colors.blue.shade800,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (healthPackage.image != null)
              Image.network(
                healthPackage.image!,
                width: double.infinity,
                height: 200,
                fit: BoxFit.cover,
                errorBuilder: (c, e, s) => Container(
                    height: 200,
                    color: Colors.grey[200],
                    child: const Center(child: Icon(Icons.image_not_supported))),
              ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    healthPackage.name,
                    style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFF0D47A1)),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    healthPackage.description,
                    style: TextStyle(fontSize: 16, color: Colors.grey.shade700, height: 1.5),
                  ),
                  const Divider(height: 32),
                  const Text(
                    'Quy trình và các bước khám',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 15),
                  _buildStepsList(), 
                  const Divider(height: 32),
                  Text(
                    'Giá Dịch Vụ:',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.grey[700]),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Text(
                        healthPackage.formattedPrice, 
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w900,
                          color: healthPackage.isDiscount ? Colors.red.shade700 : Colors.green.shade700,
                        ),
                      ),
                      if (healthPackage.isDiscount && healthPackage.oldPrice != null)
                        Padding(
                          padding: const EdgeInsets.only(left: 10),
                          child: Text(
                            healthPackage.formattedOldPrice ?? '', 
                            style: const TextStyle(
                              fontSize: 18,
                              color: Colors.grey,
                              decoration: TextDecoration.lineThrough,
                            ),
                          ),
                        ),
                      if (healthPackage.isDiscount)
                        const Padding(
                          padding: EdgeInsets.only(left: 10),
                          child: Chip(
                            label: Text('GIẢM GIÁ', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 10)),
                            backgroundColor: Colors.red,
                            padding: EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ElevatedButton.icon(
          icon: const Icon(Icons.calendar_today_outlined),
          label: const Text('ĐẶT DỊCH VỤ NGAY'),
          onPressed: () => _showBookingForm(context), // ✨ GỌI HÀM MỚI
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.green.shade600,
            foregroundColor: Colors.white,
            minimumSize: const Size(double.infinity, 55), 
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}