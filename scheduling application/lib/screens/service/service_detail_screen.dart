// File: screens/service/service_detail_screen.dart

import 'package:flutter/material.dart';
import '../../models/health_package.dart';
import '../../models/doctor.dart'; 
// Cần import Doctor model vì onBookAppointment có type Doctor, nếu file này không có thì cần import
// 💥 CẦN THÊM IMPORT NÀY: Giả sử ServiceBookingScreen nằm trong cùng thư mục
import 'service_booking_screen.dart'; 

class ServiceDetailScreen extends StatelessWidget {
  final HealthPackage healthPackage;
  final void Function(Doctor) onBookAppointment;
  
  const ServiceDetailScreen({
    super.key,
    required this.healthPackage,
    required this.onBookAppointment,
  });

  // 💥 CẬP NHẬT HÀM ĐẶT DỊCH VỤ ĐỂ CHUYỂN HƯỚNG
  void _bookService(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (ctx) => ServiceBookingScreen(healthPackage: healthPackage),
      ),
    );
  }

  // 💥 HÀM XÂY DỰNG DANH SÁCH CÁC BƯỚC KHÁM (GIỮ NGUYÊN)
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
              // Số thứ tự
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
              // Nội dung bước
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
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Ảnh dịch vụ
            if (healthPackage.image != null)
              ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: Image.network(
                  healthPackage.image!,
                  height: 200,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
            const SizedBox(height: 20),
            
            // Tên và mô tả
            Text(
              healthPackage.name,
              style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: Color(0xFF0D47A1)),
            ),
            const SizedBox(height: 10),
            Text(
              healthPackage.description,
              style: const TextStyle(fontSize: 16, color: Colors.black87),
            ),
            const Divider(height: 30),

            // PHẦN CÁC BƯỚC KHÁM
            const Text(
              'Quy trình và các bước khám (Chi tiết)',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF0D47A1)),
            ),
            const SizedBox(height: 15),
            _buildStepsList(), 
            const Divider(height: 30),

            // Thông tin giá (Giả định bạn đã cập nhật HealthPackage để dùng getter định dạng)
            Text(
              'Giá Dịch Vụ:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.grey[700]),
            ),
            Row(
              children: [
                if (healthPackage.isDiscount && healthPackage.oldPrice != null)
                  Padding(
                    padding: const EdgeInsets.only(right: 10),
                    child: Text(
                      // 💡 Nếu bạn dùng price là int, bạn cần dùng getter định dạng ở đây
                      '${healthPackage.oldPrice} VNĐ', 
                      style: const TextStyle(
                        fontSize: 18,
                        color: Colors.grey,
                        decoration: TextDecoration.lineThrough,
                      ),
                    ),
                  ),
                Text(
                   // 💡 Nếu bạn dùng price là int, bạn cần dùng getter định dạng ở đây
                  '${healthPackage.price} VNĐ', 
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w900,
                    color: healthPackage.isDiscount ? Colors.red.shade700 : Colors.green.shade700,
                  ),
                ),
                if (healthPackage.isDiscount)
                  const Padding(
                    padding: EdgeInsets.only(left: 10),
                    child: Chip(
                      label: Text('GIẢM GIÁ', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                      backgroundColor: Colors.red,
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
      
      // Nút Đặt Dịch Vụ (Floating/Bottom Bar)
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ElevatedButton(
          // 💥 GỌI HÀM ĐƯỢC CẬP NHẬT
          onPressed: () => _bookService(context),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.green.shade600,
            foregroundColor: Colors.white,
            minimumSize: const Size(double.infinity, 55), 
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
          child: const Text('ĐẶT DỊCH VỤ NGAY', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        ),
      ),
    );
  }
}