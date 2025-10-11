// File: screens/home/home_screen.dart

import 'package:flutter/material.dart';
import 'package:scheduling_application/models/user.dart';
import '../../models/campus.dart';
import '../../models/doctor.dart'; 
import '../home/details_screen.dart'; // Cần import DetailsScreen
// 💥 Thêm các imports cho Thông báo
import '../../models/notification.dart'; 
import '../notification/notification_screen.dart'; // Giả định file này tồn tại

// 💥 CHUYỂN THÀNH STATEFUL WIDGET ĐỂ QUẢN LÝ TRẠNG THÁI LỌC VÀ HIỂN THỊ THÔNG BÁO
import '../../models/campus.dart'; 
import 'details_screen.dart';

class HomeScreen extends StatefulWidget {
  final User user;
  final void Function(Doctor) onBookAppointment;

  const HomeScreen({
    super.key,
    required this.user,
    required this.onBookAppointment,
  final void Function(Doctor) onBookAppointment; 
  // 💥 THÊM THAM SỐ THÔNG BÁO TỪ DASHBOARD
  final List<AppNotification> notifications; 
  final Function(String) markNotificationAsRead; 

  const HomeScreen({
    super.key, 
    required this.onBookAppointment,
    required this.notifications, // Dữ liệu thông báo
    required this.markNotificationAsRead, // Callback đánh dấu đã đọc
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<Doctor> allDoctors = Doctor.getDoctors();
  // Trạng thái lọc: Lưu chuyên khoa đang được chọn (null = hiển thị mặc định)
  String? _selectedSpecialty;
  String? _selectedSpecialty; 

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

  void _selectSpecialty(String specialty) {
    setState(() {
      _selectedSpecialty = (_selectedSpecialty == specialty) ? null : specialty;
    });
  }

  List<Doctor> get _filteredDoctors {
    if (_selectedSpecialty == null) {
      return allDoctors.take(3).toList();
    }
    return allDoctors
        .where((doctor) => doctor.specialty == _selectedSpecialty)
        .toList();
  }

  // 💥 WIDGET CATEGORY MỚI: DÙNG GRID VIEW (Gọn gàng và chứa được nhiều)
  Widget _buildCategoryGrid() {
    // Chiều cao cố định cho 2 hàng (2 * 90px cao của mỗi item)
    const double itemHeight = 90.0;
    const double spacing = 10.0;
    const double fixedHeight = (2 * itemHeight) + spacing; // Khoảng 190.0

    return SizedBox(
      height: fixedHeight,
      child: GridView.builder(
        physics: const BouncingScrollPhysics(),

        itemCount: categories
            .length, // Hiển thị tất cả các mục, nhưng chỉ 2 hàng đầu được nhìn thấy

        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 4,
          childAspectRatio: 0.85,
  
  // ----------------------------------------------------
  // I. CÁC HÀM XÂY DỰNG GIAO DIỆN CHÍNH
  // ----------------------------------------------------

  // 1. HEADER (Đã thêm logic Thông báo)
  Widget _buildWelcomeHeader(BuildContext context) {
    const userName = 'Nguyễn Minh Thiện'; 
    // Tính toán số lượng thông báo chưa đọc
    final unreadCount = widget.notifications.where((n) => !n.isRead).length;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Chào mừng trở lại 👋',
                style: TextStyle(fontSize: 14, color: Colors.black54),
              ),
              Text(
                userName,
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.w900, color: Color(0xFF0D47A1)),
              ),
            ],
          ),
        ),
        
        // 💥 KHU VỰC THÔNG BÁO VÀ ẢNH ĐẠI DIỆN
        Row(
          children: [
            // Icon Thông báo
            Stack(
              children: [
                IconButton(
                  icon: const Icon(Icons.notifications_none, size: 30, color: Colors.blue),
                  onPressed: () {
                    _showNotificationBottomSheet(context); // Mở Bottom Sheet
                  }, 
                ),
                if (unreadCount > 0)
                  Positioned(
                    right: 8,
                    top: 8,
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      constraints: const BoxConstraints(
                        minWidth: 20,
                        minHeight: 20,
                      ),
                      child: Text(
                        '$unreadCount',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(width: 10),
            
            // Ảnh đại diện
            CircleAvatar(
              radius: 25,
              backgroundColor: Colors.blue[100],
              child: const Icon(Icons.person, color: Colors.blue),
            ),
          ],
        ),
      ],
    );
  }

  // 2. THANH TÌM KIẾM
  Widget _buildSearchBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(12),
      ),
      child: const TextField(
        decoration: InputDecoration(
          hintText: 'Tìm kiếm Bác sĩ, Chuyên khoa, Bệnh viện...',
          border: InputBorder.none,
          prefixIcon: Icon(Icons.search, color: Colors.grey),
        ),
      ),
    );
  }
  
  // 3. GRID DANH MỤC
  Widget _buildCategoryGrid() {
    const double itemHeight = 90.0;
    const double spacing = 10.0;
    const double fixedHeight = (2 * itemHeight) + spacing; 

    return SizedBox(
      height: fixedHeight,
      child: GridView.builder(
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
          
          return GestureDetector(
            onTap: () => _selectSpecialty(categoryName),
            child: Column(
              children: [
                CircleAvatar(
                  radius: 28,
                  backgroundColor: isSelected ? Colors.blue : Colors.blue[50],
                  child: Icon(
                    category['icon'] as IconData,
                    color: isSelected ? Colors.white : Colors.blue,
                    size: 28,
                  ),
                ),
                const SizedBox(height: 5),
                Expanded(
                  child: Text(
                    categoryName,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: isSelected
                          ? FontWeight.bold
                          : FontWeight.normal,
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

  // 4. BOTTOM SHEET THÔNG BÁO
  void _showNotificationBottomSheet(BuildContext context) {
    final sortedNotifications = List<AppNotification>.from(widget.notifications)
      ..sort((a, b) => b.date.compareTo(a.date));

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext ctx) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.7, 
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Thông Báo Của Bạn', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(ctx),
                  ),
                ],
              ),
              const Divider(),
              Expanded(
                child: sortedNotifications.isEmpty 
                  ? const Center(child: Text('Không có thông báo mới.', style: TextStyle(color: Colors.grey)))
                  : ListView.builder(
                      itemCount: sortedNotifications.length,
                      itemBuilder: (context, index) {
                        final notification = sortedNotifications[index];
                        return ListTile(
                          leading: Icon(
                            notification.isRead ? Icons.notifications_none : Icons.notifications_active,
                            color: notification.isRead ? Colors.grey : Colors.red,
                          ),
                          title: Text(
                            notification.title,
                            style: TextStyle(fontWeight: notification.isRead ? FontWeight.normal : FontWeight.bold),
                          ),
                          subtitle: Text(
                            '${notification.date.day}/${notification.date.month} | ${notification.body}',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          onTap: () {
                            widget.markNotificationAsRead(notification.id); // Gọi callback đánh dấu đã đọc
                            Navigator.pop(ctx); // Đóng bottom sheet
                            // Mở màn hình chi tiết thông báo
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (c) => NotificationDetailScreen(notification: notification),
                              ),
                            );
                          },
                        );
                      },
                    ),
              ),
            ],
          ),
        );
      },
    );
  }
  
  // ----------------------------------------------------
  // II. BUILD METHOD
  // ----------------------------------------------------

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Trang Chủ'),
        backgroundColor: Colors.blue,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. HEADER - Khu vực Chào mừng & Thông báo
            _buildWelcomeHeader(context),
            const SizedBox(height: 20),

            // 2. SEARCH BAR - Thanh tìm kiếm
            _buildSearchBar(),
            const SizedBox(height: 25),

            // 3. CATEGORIES - Danh mục nổi bật
            const Text(
              'Chuyên khoa phổ biến',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            _buildCategoryGrid(), 
            const SizedBox(height: 25),

            // 4. FEATURED DOCTORS - Bác sĩ nổi bật (Tiêu đề động)
            Text(
              _selectedSpecialty == null
                  ? 'Bác sĩ nổi bật'
                  : 'Bác sĩ chuyên khoa ${_selectedSpecialty}', // Tiêu đề thay đổi theo filter
              _selectedSpecialty == null 
                ? 'Bác sĩ nổi bật'
                : 'Bác sĩ chuyên khoa ${_selectedSpecialty}', 
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),

            // Danh sách bác sĩ được liệt kê (sử dụng danh sách đã lọc)
            ..._filteredDoctors.map(
              (doctor) => Padding(
                padding: const EdgeInsets.only(bottom: 15),
                child: DoctorCard(
                  doctor: doctor,
                  onBookAppointment: widget.onBookAppointment,
                ),
              ),
            ),

            // Danh sách bác sĩ được liệt kê 
            ..._filteredDoctors.map((doctor) => Padding(
                padding: const EdgeInsets.only(bottom: 15),
                child: DoctorCard(
                  doctor: doctor,
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

  // --- WIDGET XÂY DỰNG GIAO DIỆN KHÁC (Giữ nguyên) ---

  Widget _buildWelcomeHeader(BuildContext context) {
    final userName = widget.user.fullname;
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Chào mừng trở lại 👋',
                style: TextStyle(fontSize: 14, color: Colors.black54),
              ),
              Text(
                userName,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w900,
                  color: Color(0xFF0D47A1),
                ),
              ),
            ],
          ),
        ),
        CircleAvatar(
          radius: 25,
          backgroundColor: Colors.blue[100],
          child: const Icon(Icons.person, color: Colors.blue),
        ),
      ],
    );
  }

  Widget _buildSearchBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(12),
      ),
      child: const TextField(
        decoration: InputDecoration(
          hintText: 'Tìm kiếm Bác sĩ, Chuyên khoa, Bệnh viện...',
          border: InputBorder.none,
          prefixIcon: Icon(Icons.search, color: Colors.grey),
        ),
      ),
    );
  }

  // Xóa _buildCategoryList() cũ
}

// --- WIDGET DOCTOR CARD (Cần giữ nguyên vì nó là StatefulWidget) ---
}


// --- WIDGET DOCTOR CARD (Giữ nguyên) ---

/// Widget Card bác sĩ có hiệu ứng hover
class DoctorCard extends StatefulWidget {
  final Doctor doctor;
  final void Function(Doctor) onBookAppointment;

  const DoctorCard({
    Key? key,
    required this.doctor,
    required this.onBookAppointment,
  }) : super(key: key);

  @override
  _DoctorCardState createState() => _DoctorCardState();
}

class _DoctorCardState extends State<DoctorCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    // ... (Code DoctorCard giữ nguyên) ...
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedScale(
        scale: _isHovered ? 1.05 : 1.0,
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOut,
        child: Card(
          elevation: _isHovered ? 6 : 2,
          color: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: BorderSide(
              color: _isHovered ? Colors.blue.shade200 : Colors.grey.shade200,
              width: 1,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                ClipOval(
                  child: Image.network(
                    widget.doctor.image,
                    width: 60,
                    height: 60,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(width: 12),

                // Thông tin bác sĩ
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.doctor.name,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF0D47A1),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        widget.doctor.specialty,
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.blue,
                        ),
                      ),
                      Text(
                        widget.doctor.hospital,
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.black54,
                        ),
                      ),
                    ],
                  ),
                ),

                // Nút sang trang chi tiết
                IconButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DetailsScreen(
                          doctor: widget.doctor,
                          onBookAppointment: widget.onBookAppointment,
                        ),
                      ),
                    );
                  },
                  icon: const Icon(
                    Icons.arrow_circle_right_outlined,
                    size: 35,
                    color: Colors.blue,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
