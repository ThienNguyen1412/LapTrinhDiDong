// File: screens/home/home_screen.dart

import 'dart:async'; // Cần cho Timer
import 'package:flutter/material.dart';
import '../../models/notification.dart';
import '../notification/notification_screen.dart';

// ✨ THÊM CÁC IMPORT CẦN THIẾT
import '../../models/doctor.dart';
import '../appointment/book_new_appointment_screen.dart';


// Dữ liệu cho các mục trong lưới tính năng
class FeatureItem {
  final IconData icon;
  final String label;
  // ✨ Thêm một định danh duy nhất cho mỗi mục
  final String id;

  const FeatureItem({required this.icon, required this.label, required this.id});
}

class HomeScreen extends StatefulWidget {
  final List<AppNotification> notifications;
  final Function(String) markNotificationAsRead;
  // ✨ THÊM THAM SỐ ĐỂ NHẬN HÀM TỪ DASHBOARD
  final void Function(Doctor) onBookAppointment;

  const HomeScreen({
    super.key,
    required this.notifications,
    required this.markNotificationAsRead,
    required this.onBookAppointment, // Thêm vào constructor
  });
import 'package:flutter/material.dart';
import 'package:scheduling_application/models/user.dart';
import '../../models/doctor.dart';
import 'details_screen.dart';

class HomeScreen extends StatefulWidget {
  final User user;
  final void Function(Doctor) onBookAppointment;

  const HomeScreen({
    Key? key,
    required this.user,
    required this.onBookAppointment,
  }) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late final PageController _pageController;
  Timer? _bannerTimer;
  int _currentPage = 0;

  final List<String> _bannerImages = [
    'https://cdn.phenikaamec.com/phenikaa-mec/image/5-14-2025/6d9f06a3-13cb-4b9a-97a8-84b7b51c9eff-image.webp', // Placeholder 1
    'https://dakhoa.hungyenweb.com/wp-content/uploads/2018/06/banner-phong-kham-da-khoa-2.jpg', // Placeholder 2
    'https://phusanthienan.com/wp-content/uploads/2024/12/1banner-web-Chinh-thuc-Hifu.jpg', // Placeholder 3
  final String avatarUrl = 'https://img.lovepik.com/free-png/20220101/lovepik-tortoise-png-image_401154498_wh860.png';
  final List<Doctor> allDoctors = Doctor.getDoctors();
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

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: 0);
    _startBannerTimer();
  }

  @override
  void dispose() {
    _bannerTimer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  void _startBannerTimer() {
    _bannerTimer = Timer.periodic(const Duration(seconds: 3), (timer) {
      if (_currentPage < _bannerImages.length - 1) {
        _currentPage++;
      } else {
        _currentPage = 0;
      }
      if (_pageController.hasClients) {
        _pageController.animateToPage(
          _currentPage,
          duration: const Duration(milliseconds: 400),
          curve: Curves.easeIn,
        );
      }
    });
  }


  @override
  Widget build(BuildContext context) {
    // ✨ CẬP NHẬT DANH SÁCH TÍNH NĂNG VỚI `id`
    final List<FeatureItem> features = [
      const FeatureItem(id: 'book_appointment', icon: Icons.description_outlined, label: 'Đặt lịch\nkhám bệnh'),
      const FeatureItem(id: 'lookup_results', icon: Icons.find_in_page_outlined, label: 'Tra cứu kết quả\nkhám bệnh'),
      const FeatureItem(id: 'guide', icon: Icons.info_outline, label: 'Hướng dẫn\nđặt khám'),
      const FeatureItem(id: 'vaccine', icon: Icons.vaccines_outlined, label: 'Đặt lịch\ntiêm chủng'),
      const FeatureItem(id: 'payment', icon: Icons.credit_card_outlined, label: 'Thanh toán\nviện phí'),
      const FeatureItem(id: 'hotline', icon: Icons.phone_in_talk_outlined, label: 'Đặt khám\n1900-2115'),
    ];

    return Scaffold(
      backgroundColor: const Color(0xFFF0F4F8),
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60.0),
        child: _buildHeaderContent(context),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSearchBar(),
              const SizedBox(height: 16),
              Card(
                elevation: 2,
                shadowColor: Colors.grey.withOpacity(0.2),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 24.0, horizontal: 8.0),
                  child: GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: features.length,
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      childAspectRatio: 1.1,
                      mainAxisSpacing: 16,
                      crossAxisSpacing: 8,
                    ),
                    itemBuilder: (context, index) {
                      final feature = features[index];
                      // ✨ WRAP WIDGET BẰNG INKWELL VÀ XỬ LÝ SỰ KIỆN NHẤN VÀO
                      return InkWell(
                        onTap: () {
                          // Kiểm tra id của nút được nhấn
                          if (feature.id == 'book_appointment') {
                            // Điều hướng đến màn hình đặt lịch
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => BookNewAppointmentScreen(
                                  // Truyền hàm đã nhận từ Dashboard xuống
                                  onBookAppointment: widget.onBookAppointment,
                                ),
                              ),
                            );
                          } else {
                            // Xử lý cho các nút khác (hiển thị thông báo)
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Chức năng "${feature.label.replaceAll('\n', ' ')}" sắp ra mắt!')),
                            );
                          }
                        },
                        borderRadius: BorderRadius.circular(16),
                        child: _buildFeatureItem(feature),
                      );
                    },
                  ),
                ),
              ),
              const SizedBox(height: 24),
              const Padding(
                padding: EdgeInsets.only(left: 4.0),
                child: Text(
                  'ĐƯỢC TIN TƯỞNG HỢP TÁC VÀ ĐỒNG HÀNH',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    color: Colors.black54,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              _buildPartnershipBanner(),
            ],
          ),
        ),
      ),
    );
  }

  // Widget header (giữ nguyên)
  Widget _buildHeaderContent(BuildContext context) {
    final unreadCount = widget.notifications.where((n) => !n.isRead).length;
    const userName = 'THIEN';

    String getGreeting() {
      final hour = DateTime.now().hour;
      if (hour < 12) return 'Chào buổi sáng';
      if (hour < 18) return 'Chào buổi chiều';
      return 'Chào buổi tối';
    }

    return AppBar(
      backgroundColor: const Color(0xFF0D1F3C),
      elevation: 0,
      automaticallyImplyLeading: false,
      titleSpacing: 16,
      title: Row(
        children: [
          const CircleAvatar(
            radius: 20,
            backgroundColor: Colors.blue,
            child: Text('NT', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                getGreeting(),
                style: const TextStyle(fontSize: 12, color: Colors.white70),
              ),
              const Text(
                userName,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
              ),
            ],
          ),
          const Icon(Icons.keyboard_arrow_right, color: Colors.white70),
        ],
      ),
      actions: [
        IconButton(
          onPressed: () {},
          icon: const Icon(Icons.star_border_purple500_outlined, color: Colors.white),
        ),
        Stack(
          alignment: Alignment.center,
          children: [
            IconButton(
              icon: const Icon(Icons.notifications_none, color: Colors.white),
              onPressed: () => _showNotificationBottomSheet(context),
            ),
            if (unreadCount > 0)
              Positioned(
                top: 12,
                right: 12,
                child: Container(
                  height: 8,
                  width: 8,
                  decoration: const BoxDecoration(
                    color: Colors.redAccent,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
          ],
        ),
        const SizedBox(width: 8),
      ],
    );
  }

  // Widget thanh tìm kiếm (giữ nguyên)
  Widget _buildSearchBar() {
    return Material(
      elevation: 2.0,
      shadowColor: Colors.black12,
      borderRadius: BorderRadius.circular(30.0),
      child: TextField(
        decoration: InputDecoration(
          hintText: 'Tìm CSYT/bác sĩ/chuyên khoa/dịch vụ',
          prefixIcon: const Icon(Icons.search, color: Colors.grey),
          filled: true,
          fillColor: Colors.white,
          contentPadding: const EdgeInsets.symmetric(vertical: 0),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }

  // Widget cho mỗi mục trong lưới tính năng (giữ nguyên)
  Widget _buildFeatureItem(FeatureItem item) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.blue.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(item.icon, color: Colors.blue.shade700, size: 28),
        ),
        const SizedBox(height: 8),
        Text(
          item.label,
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 12, height: 1.2),
        ),
      ],
    );
  }
  
  // Widget banner (giữ nguyên)
  Widget _buildPartnershipBanner() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          SizedBox(
            height: 120,
            child: PageView.builder(
              controller: _pageController,
              itemCount: _bannerImages.length,
              onPageChanged: (index) {
                setState(() {
                  _currentPage = index;
                });
              },
              itemBuilder: (context, index) {
                return Image.network(
                  _bannerImages[index],
                  fit: BoxFit.cover,
                   errorBuilder: (context, error, stackTrace) {
                      return Container(
                        color: Colors.grey[300],
                        child: const Center(child: Icon(Icons.image_not_supported, color: Colors.grey)),
                      );
                    },
                );
              },
            ),
          ),
          Positioned(
            bottom: 10.0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(_bannerImages.length, (index) {
                return AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  margin: const EdgeInsets.symmetric(horizontal: 4.0),
                  height: 8.0,
                  width: _currentPage == index ? 24.0 : 8.0,
                  decoration: BoxDecoration(
                    color: _currentPage == index
                        ? Colors.white
                        : Colors.white.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(12),
  List<Doctor> get _filteredDoctors {
    if (_selectedSpecialty == null) {
      return allDoctors.take(3).toList();
    }
    return allDoctors.where((doctor) => doctor.specialty == _selectedSpecialty).toList();
  }

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
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                    ),
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }
  
  // Bottom sheet (giữ nguyên)
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

  Widget _buildWelcomeHeader(BuildContext context) {
    final userName = widget.user.fullname;
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Thông Báo Của Bạn',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(ctx),
                  ),
                ],
              ),
              const Divider(),
              Expanded(
                child: sortedNotifications.isEmpty
                    ? const Center(
                        child: Text('Không có thông báo mới.',
                            style: TextStyle(color: Colors.grey)))
                    : ListView.builder(
                        itemCount: sortedNotifications.length,
                        itemBuilder: (context, index) {
                          final notification = sortedNotifications[index];
                          return ListTile(
                            leading: Icon(
                              notification.isRead
                                  ? Icons.notifications_none
                                  : Icons.notifications_active,
                              color: notification.isRead ? Colors.grey : Colors.red,
                            ),
                            title: Text(
                              notification.title,
                              style: TextStyle(
                                  fontWeight: notification.isRead
                                      ? FontWeight.normal
                                      : FontWeight.bold),
                            ),
                            subtitle: Text(
                              '${notification.date.day}/${notification.date.month} | ${notification.body}',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            onTap: () {
                              widget.markNotificationAsRead(notification.id);
                              Navigator.pop(ctx);
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (c) => NotificationDetailScreen(
                                      notification: notification),
                                ),
                              );
                            },
                          );
                        },
                      ),
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
          backgroundImage: NetworkImage(avatarUrl),
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
            _buildWelcomeHeader(context),
            const SizedBox(height: 20),
            _buildSearchBar(),
            const SizedBox(height: 25),
            const Text(
              'Chuyên khoa phổ biến',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            _buildCategoryGrid(),
            const SizedBox(height: 25),
            Text(
              _selectedSpecialty == null
                  ? 'Bác sĩ nổi bật'
                  : 'Bác sĩ chuyên khoa ${_selectedSpecialty}',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            ..._filteredDoctors.map(
              (doctor) => Padding(
                padding: const EdgeInsets.only(bottom: 15),
                child: DoctorCard(
                  doctor: doctor,
                  onBookAppointment: widget.onBookAppointment,
                ),
              ),
            ),
            if (_filteredDoctors.isEmpty)
              const Center(
                child: Text('Không tìm thấy bác sĩ nào thuộc chuyên khoa này.'),
              ),
          ],
        ),
      ),
    );
  }
}

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