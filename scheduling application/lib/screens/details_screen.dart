import 'package:flutter/material.dart';
import '../models/campus.dart'; // Đảm bảo model Doctor đã được import

// Giả định rằng bạn có một hàm Doctor model
// class Doctor {
//   final String name;
//   //... (các thuộc tính khác)
//   //...
// }


class DetailsScreen extends StatelessWidget {
  final Doctor doctor;
  
  // 💥 THÊM CALLBACK FUNCTION:
  // Hàm này sẽ được gọi khi người dùng nhấn nút "Đặt lịch khám"
  final void Function(Doctor) onBookAppointment; 
  
  const DetailsScreen({
    super.key, 
    required this.doctor,
    required this.onBookAppointment, // BẮT BUỘC phải truyền vào
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(doctor.name),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- AVATAR + THÔNG TIN CƠ BẢN ---
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  radius: 50,
                  backgroundImage: NetworkImage(doctor.image),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        doctor.name,
                        style: const TextStyle(
                          fontSize: 24, // Tăng cỡ chữ
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF0D47A1),
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        doctor.specialty,
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.blue,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        doctor.hospital,
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.black54,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Row(
                        children: [
                          const Icon(Icons.phone, color: Colors.green, size: 18),
                          const SizedBox(width: 5),
                          Text(doctor.phone),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            // --- RATING HIỂN THỊ 5 NGÔI SAO ---
            Row(
              children: [
                ...List.generate(5, (index) {
                  double rating = doctor.rating;
                  if (index < rating.floor()) {
                    return const Icon(Icons.star, color: Colors.amber, size: 24);
                  } else if (index < rating && rating - rating.floor() >= 0.5) {
                    return const Icon(Icons.star_half, color: Colors.amber, size: 24);
                  } else {
                    return const Icon(Icons.star_border, color: Colors.amber, size: 24);
                  }
                }),
                const SizedBox(width: 8),
                Text(
                  '${doctor.rating}',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(width: 5),
                Text(
                  '(${doctor.reviews} đánh giá)',
                  style: const TextStyle(color: Colors.grey),
                ),
              ],
            ),

            const SizedBox(height: 20),

            // --- BÌNH LUẬN ĐỘNG ---
            const Text(
              "Bình luận của bệnh nhân:",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            ...doctor.comments.map(
              (comment) => Card(
                margin: const EdgeInsets.only(bottom: 8),
                elevation: 1,
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(Icons.person_pin, color: Colors.blue, size: 20),
                      const SizedBox(width: 10),
                      Expanded(child: Text(comment, style: const TextStyle(fontSize: 14))),
                    ],
                  ),
                ),
              ),
            ),

            const SizedBox(height: 30),

            // --- NÚT ĐẶT LỊCH KHÁM ---
            Center(
              child: SizedBox(
                width: double.infinity, // Mở rộng nút ra hết chiều rộng
                child: ElevatedButton.icon(
                  onPressed: () {
                    // 💥 GỌI CALLBACK ĐỂ THÊM LỊCH HẸN VÀO DASHBOARD
                    onBookAppointment(doctor);
                    // Không cần showSnackBar ở đây, vì hàm callback sẽ lo việc đó
                    // và chuyển màn hình.
                  },
                  icon: const Icon(Icons.calendar_today),
                  label: const Text(
                    'Đặt lịch khám ngay',
                    style: TextStyle(fontSize: 16),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 15,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}