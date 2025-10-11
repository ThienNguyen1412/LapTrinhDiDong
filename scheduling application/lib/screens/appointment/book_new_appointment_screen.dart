import 'package:flutter/material.dart';
import '../../models/doctor.dart'; // Chứa model Doctor
import '../home/home_screen.dart'; // Chứa DoctorCard

// 💥 CHUYỂN THÀNH STATEFUL WIDGET ĐỂ QUẢN LÝ TRẠNG THÁI LỌC
class BookNewAppointmentScreen extends StatefulWidget {
  final void Function(Doctor) onBookAppointment; 

  BookNewAppointmentScreen({ // KHÔNG CÓ 'const'
    super.key,
    required this.onBookAppointment,
  });

  @override
  State<BookNewAppointmentScreen> createState() => _BookNewAppointmentScreenState();
}

class _BookNewAppointmentScreenState extends State<BookNewAppointmentScreen> {
  
  final List<Doctor> allDoctors = Doctor.getDoctors();
  String? _selectedSpecialty; // Trạng thái lọc


  // Hàm thay đổi trạng thái lọc
  void _selectSpecialty(String specialty) {
    setState(() {
      // Nếu nhấn lại chuyên khoa đã chọn, hủy chọn (hiển thị tất cả)
      _selectedSpecialty = (_selectedSpecialty == specialty) ? null : specialty;
    });
  }
  
  // Hàm lọc danh sách bác sĩ
  List<Doctor> get _filteredDoctors {
    if (_selectedSpecialty == null) {
      return allDoctors; // Nếu không lọc, hiển thị TẤT CẢ bác sĩ
    }
    // Lọc theo chuyên khoa
    return allDoctors
        .where((doctor) => doctor.specialty == _selectedSpecialty)
        .toList();
  }

  // 💥 DANH SÁCH CHUYÊN KHOA ĐÃ MỞ RỘNG
  final List<Map<String, dynamic>> categories = const [
    {'name': 'Nhi khoa', 'icon': Icons.child_care},
    {'name': 'Mắt', 'icon': Icons.remove_red_eye},
    {'name': 'Tai Mũi Họng', 'icon': Icons.hearing},
    {'name': 'Da Liễu', 'icon': Icons.self_improvement},
    {'name': 'Tim mạch', 'icon': Icons.favorite},
    {'name': 'Thần kinh', 'icon': Icons.psychology},
    {'name': 'Cơ xương khớp', 'icon': Icons.accessible_forward},
    {'name': 'Hô hấp', 'icon': Icons.air},
    {'name': 'Nội tiết', 'icon': Icons.medical_services},
    {'name': 'Sản phụ khoa', 'icon': Icons.pregnant_woman},
  ];

  // 💥 WIDGET CATEGORY MỚI: DÙNG GRID VIEW VỚI GIỚI HẠN CHIỀU CAO VÀ CUỘN RIÊNG
  Widget _buildCategoryGrid() {
    // Chiều cao cố định cho 2 hàng (2 * 90px cao của mỗi item)
    const double itemHeight = 90.0;
    const double spacing = 10.0;
    const double fixedHeight = (2 * itemHeight) + spacing; // Khoảng 190.0

    return SizedBox(
      height: fixedHeight, // 💥 GIỚI HẠN CHIỀU CAO CHO 2 HÀNG
      child: GridView.builder(
        // 💥 BẬT TÍNH NĂNG CUỘN NỘI BỘ 
        physics: const BouncingScrollPhysics(),
        
        itemCount: categories.length, 
        
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 4, 
          childAspectRatio: 0.85, 
          crossAxisSpacing: spacing,
          mainAxisSpacing: spacing,
        ),
        itemBuilder: (context, index) {
          final category = categories[index];
          final categoryName = category['name'] as String;
          final isSelected = _selectedSpecialty == categoryName;
          
          return GestureDetector(
            onTap: () => _selectSpecialty(categoryName), // Gọi hàm lọc
            child: Column(
              children: [
                CircleAvatar(
                  radius: 28,
                  backgroundColor: isSelected ? Colors.blue : Colors.blue[50],
                  child: Icon(
                    category['icon'] as IconData, 
                    color: isSelected ? Colors.white : Colors.blue, 
                    size: 28
                  ),
                ),
                const SizedBox(height: 5),
                Expanded(
                  child: Text(
                    categoryName,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                    ),
                    textAlign: TextAlign.center,
                    maxLines: 2, 
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chọn Bác sĩ để Đặt lịch'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- MỤC CHUYÊN KHOA PHỔ BIẾN ---
            const Text(
              'Chọn Chuyên khoa',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            _buildCategoryGrid(), // 💥 SỬ DỤNG GRID VIEW MỚI
            const SizedBox(height: 25),
            // --------------------------------------------------

            Padding(
              padding: const EdgeInsets.only(bottom: 15),
              child: Text(
                _selectedSpecialty == null 
                  ? 'Danh sách tất cả các Bác sĩ:'
                  : 'Kết quả lọc cho: ${_selectedSpecialty}',
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),

            // Tái sử dụng DoctorCard với danh sách đã lọc
            ..._filteredDoctors.map((doctor) => Padding(
                  padding: const EdgeInsets.only(bottom: 15),
                  child: DoctorCard(
                    doctor: doctor,
                    // Truyền callback để đặt lịch
                    onBookAppointment: widget.onBookAppointment, 
                  ),
                )),
                
            if (_filteredDoctors.isEmpty)
              const Center(
                child: Text('Không tìm thấy bác sĩ nào thuộc chuyên khoa này.'),
              ),
          ],
        ),
      ),
    );
  }
  
  // Xóa hàm _buildCategoryList() cũ.
}