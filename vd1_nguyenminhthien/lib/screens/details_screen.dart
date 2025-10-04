import 'package:flutter/material.dart';
import '../models/campus.dart';

class DetailsScreen extends StatelessWidget {
  final Doctor doctor;
  const DetailsScreen({super.key, required this.doctor});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(doctor.name)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Avatar + Thông tin cơ bản
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
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text('Chuyên khoa: ${doctor.specialty}'),
                      Text('Bệnh viện: ${doctor.hospital}'),
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

            // Rating hiển thị 5 ngôi sao
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

            // Bình luận động từ doctor.comments
            const Text(
              "Bình luận của bệnh nhân:",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            ...doctor.comments.map(
              (comment) => Card(
                margin: const EdgeInsets.only(bottom: 8),
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(Icons.person, color: Colors.blue),
                      const SizedBox(width: 10),
                      Expanded(child: Text(comment)),
                    ],
                  ),
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Nút đặt lịch khám
            Center(
              child: ElevatedButton.icon(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Đặt lịch khám với ${doctor.name}')),
                  );
                },
                icon: const Icon(Icons.calendar_today),
                label: const Text('Đặt lịch khám'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 12,
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
