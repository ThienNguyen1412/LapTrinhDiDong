import 'package:flutter/material.dart';

/// Lớp Doctor lưu trữ thông tin cho từng bác sĩ
class Doctor {
  final String name;       // Tên bác sĩ
  final String specialty;  // Chuyên khoa
  final String image;      // Link ảnh
  final String hospital;   // Bệnh viện làm việc
  final String phone;      // Số điện thoại
  final double rating;     // Điểm đánh giá trung bình
  final int reviews;       // Số lượng đánh giá
  final Color color;       // Màu nền đại diện
  final List<String> comments; // Danh sách bình luận của bệnh nhân

  Doctor({
    required this.name,
    required this.specialty,
    required this.image,
    required this.hospital,
    required this.phone,
    required this.rating,
    required this.reviews,
    required this.color,
    required this.comments,
  });

  /// Hàm static trả về danh sách bác sĩ mẫu
  static List<Doctor> getDoctors() {
    return [
      Doctor(
        name: 'BS.CKI Nguyễn Công Bình',
        specialty: 'Tim mạch',
        hospital: 'Bệnh viện Nội tiết Trung Ương',
        phone: '0901 234 567',
        rating: 4.8,
        reviews: 120,
        image:
            'https://benhviennoitiet.vn/wp-content/uploads/2024/01/Mask-group7-min-2.png',
        color: Colors.redAccent,
        comments: [
          'Bác sĩ rất tận tâm, tư vấn kỹ càng.',
          'Khám nhanh, không phải chờ lâu.',
          'Rất hài lòng với dịch vụ.'
        ],
      ),
      Doctor(
        name: 'TS.BS Trần Thị Đoàn',
        specialty: 'Răng hàm mặt',
        hospital: 'Bệnh viện Nhi Đồng 1',
        phone: '0908 765 432',
        rating: 4.6,
        reviews: 98,
        image:
            'https://benhviennoitiet.vn/wp-content/uploads/2024/01/Mask-group6-min-1.png',
        color: Colors.blueAccent,
        comments: [
          'Bác sĩ thân thiện và chuyên nghiệp.',
          'Giải thích rất dễ hiểu cho bệnh nhân.',
        ],
      ),
      Doctor(
        name: 'TS.BS Nguyễn Đăng Quân',
        specialty: 'Điều trị tích cực',
        hospital: 'Bệnh viện 115',
        phone: '0912 111 222',
        rating: 4.9,
        reviews: 150,
        image:
            'https://benhviennoitiet.vn/wp-content/uploads/2023/12/Doi-ngu-chuyen-gia-Tam-1.jpg',
        color: Colors.green,
        comments: [
          'Kinh nghiệm dày dặn, chuẩn đoán chính xác.',
          'Luôn quan tâm đến bệnh nhân.',
          'Rất tin tưởng bác sĩ Quân.'
        ],
      ),
      Doctor(
        name: 'BS.CKI. Nguyễn Hải Anh',
        specialty: 'Y, dược học cổ truyền',
        hospital: 'Bệnh viện Đa khoa Hòa Binh',
        phone: '0933 888 999',
        rating: 4.7,
        reviews: 87,
        image:
            'https://lh6.googleusercontent.com/proxy/w45AMWsqEmaDOECh16nRP6cwMyaPN-GJ5ukBCaAlELTraVInxzjRce88mSbbJoLl1hF6lcfSAhv8VFMpzyRXuEgkGIWdGyxxZqc2JFGNRw19QYZLzRaXGmHCINSdjO_BZZo',
        color: Colors.orange,
        comments: [
          'Rất giỏi về y học cổ truyền.',
          'Thái độ nhẹ nhàng, dễ chịu.',
        ],
      ),
      // Bổ sung thêm bác sĩ để ListView có thể cuộn
      Doctor(
        name: 'PGS.TS Nguyễn Văn A',
        specialty: 'Nội tổng quát',
        hospital: 'Bệnh viện Chợ Rẫy',
        phone: '0987 654 321',
        rating: 4.5,
        reviews: 110,
        image:
            'https://randomuser.me/api/portraits/men/32.jpg',
        color: Colors.purple,
        comments: [
          'Bác sĩ rất tận tâm.',
          'Khám bệnh kỹ lưỡng.',
        ],
      ),
      Doctor(
        name: 'BS.CKI Lê Thị B',
        specialty: 'Nhi khoa',
        hospital: 'Bệnh viện Nhi Trung Ương',
        phone: '0971 222 333',
        rating: 4.4,
        reviews: 75,
        image:
            'https://randomuser.me/api/portraits/women/44.jpg',
        color: Colors.pinkAccent,
        comments: [
          'Bác sĩ nhẹ nhàng với trẻ em.',
          'Tư vấn rất chi tiết.',
        ],
      ),
      Doctor(
        name: 'TS.BS Phạm Văn C',
        specialty: 'Ngoại thần kinh',
        hospital: 'Bệnh viện Việt Đức',
        phone: '0912 333 444',
        rating: 4.7,
        reviews: 95,
        image:
            'https://randomuser.me/api/portraits/men/45.jpg',
        color: Colors.teal,
        comments: [
          'Chuyên môn cao.',
          'Rất hài lòng với bác sĩ.',
        ],
      ),
      Doctor(
        name: 'BS.CKI Trần Thị D',
        specialty: 'Da liễu',
        hospital: 'Bệnh viện Da Liễu TP.HCM',
        phone: '0934 555 666',
        rating: 4.3,
        reviews: 60,
        image:
            'https://randomuser.me/api/portraits/women/65.jpg',
        color: Colors.brown,
        comments: [
          'Khám da liễu rất tốt.',
          'Bác sĩ tư vấn tận tình.',
        ],
      ),
    ];
  }
}
