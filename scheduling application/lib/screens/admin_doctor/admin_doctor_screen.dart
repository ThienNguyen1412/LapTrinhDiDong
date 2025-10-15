// File: lib/screens/admin_doctor/admin_doctor_screen.dart

import 'package:flutter/material.dart';
import '../../models/doctor.dart'; // Import Doctor model

class AdminDoctorScreen extends StatefulWidget {
  const AdminDoctorScreen({super.key});

  @override
  State<AdminDoctorScreen> createState() => _AdminDoctorScreenState();
}

class _AdminDoctorScreenState extends State<AdminDoctorScreen> {
  // Danh sách bác sĩ sẽ được lấy từ Doctor model
  List<Doctor> _doctors = Doctor.getDoctors();
  String _searchQuery = '';

  // Hàm lọc danh sách bác sĩ dựa trên từ khóa tìm kiếm
  List<Doctor> get _filteredDoctors {
    if (_searchQuery.isEmpty) {
      return _doctors;
    }
    final query = _searchQuery.toLowerCase();
    return _doctors.where((doctor) {
      return doctor.name.toLowerCase().contains(query) ||
             doctor.specialty.toLowerCase().contains(query);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // 1. Ô tìm kiếm
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: TextField(
            onChanged: (value) {
              setState(() {
                _searchQuery = value;
              });
            },
            decoration: InputDecoration(
              hintText: 'Tìm kiếm Bác sĩ theo tên hoặc chuyên khoa...',
              prefixIcon: const Icon(Icons.search),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: BorderSide.none,
              ),
              filled: true,
              fillColor: Colors.grey[200],
            ),
          ),
        ),

        // 2. Tiêu đề và tổng số lượng
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Danh sách Bác sĩ',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              Text(
                'Tổng: ${_filteredDoctors.length}',
                style: TextStyle(fontSize: 16, color: Colors.blue.shade700, fontWeight: FontWeight.w600),
              ),
            ],
          ),
        ),
        
        // 3. Danh sách bác sĩ
        Expanded(
          child: ListView.builder(
            itemCount: _filteredDoctors.length,
            itemBuilder: (context, index) {
              final doctor = _filteredDoctors[index];
              return _buildDoctorCard(context, doctor);
            },
          ),
        ),
      ],
    );
  }

  // Widget riêng để xây dựng Card thông tin bác sĩ
  Widget _buildDoctorCard(BuildContext context, Doctor doctor) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: ListTile(
        contentPadding: const EdgeInsets.all(12),
        // Avatar bác sĩ
        leading: CircleAvatar(
          radius: 30,
          backgroundColor: doctor.color.withOpacity(0.2),
          backgroundImage: NetworkImage(doctor.image),
        ),
        // Tên và chuyên khoa
        title: Text(
          doctor.name,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Color(0xFF0D47A1)),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text(
              doctor.specialty,
              style: TextStyle(color: doctor.color, fontWeight: FontWeight.w600),
            ),
            Row(
              children: [
                const Icon(Icons.star, color: Colors.amber, size: 16),
                const SizedBox(width: 4),
                Text('${doctor.rating} (${doctor.reviews} đánh giá)'),
              ],
            ),
            Text(doctor.hospital, style: const TextStyle(fontSize: 13, color: Colors.black54)),
          ],
        ),
        // Hành động
        trailing: IconButton(
          icon: const Icon(Icons.info_outline, color: Colors.blue),
          onPressed: () {
            // TODO: Chuyển đến màn hình Chi tiết Bác sĩ (Admin view) hoặc chỉnh sửa
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Xem/Sửa chi tiết BS ${doctor.name}')),
            );
          },
        ),
      ),
    );
  }
}