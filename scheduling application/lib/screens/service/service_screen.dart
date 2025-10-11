// File: screens/service/service_screen.dart

import 'package:flutter/material.dart';
import '../../models/doctor.dart';
import '../../models/notification.dart'; 
// ⚠️ Giả định bạn đã cập nhật file này
import '../../models/health_package.dart'; 
// ⚠️ Giả định bạn có file này, nếu không hãy đổi lại thành screens/screens.dart hoặc file tương ứng
import '../notification/notification_screen.dart'; 
// 💥 Thêm import cho màn hình chi tiết dịch vụ
import 'service_detail_screen.dart'; 

class ServiceScreen extends StatelessWidget { 
  final void Function(Doctor) onBookAppointment;
  final List<AppNotification> unreadNotifications; 
  final Function(String) markNotificationAsRead; 

  // Lấy dữ liệu Doctor và HealthPackage (Không dùng const vì gọi hàm)
  final List<Doctor> doctors = Doctor.getDoctors(); 
  final List<HealthPackage> packages = HealthPackage.getPackages(); 
  
  // Constructor KHÔNG CÓ const
  ServiceScreen({ 
    super.key,
    required this.onBookAppointment,
    required this.unreadNotifications, 
    required this.markNotificationAsRead, 
  });

  // ----------------------------------------------------
  // I. CÁC HÀM XÂY DỰNG GIAO DIỆN CHUNG (Giữ nguyên)
  // ----------------------------------------------------

  // 1. HEADER (Tích hợp thông báo) (Giữ nguyên)
  Widget _buildWelcomeHeader(BuildContext context) {
    // Tái sử dụng code Header, đã xóa userName vì không dùng
    final unreadCount = unreadNotifications.where((n) => !n.isRead).length;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Các dịch vụ chăm sóc 👋',
                style: TextStyle(fontSize: 14, color: Colors.black54),
              ),
              Text(
                'Y tế tốt nhất',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.w900, color: Color(0xFF0D47A1)),
              ),
            ],
          ),
        ),
        
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
                      constraints: const BoxConstraints(minWidth: 20, minHeight: 20),
                      child: Text(
                        '$unreadCount',
                        style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
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

  // 2. BOTTOM SHEET THÔNG BÁO (Giữ nguyên)
  void _showNotificationBottomSheet(BuildContext context) {
    final sortedNotifications = List<AppNotification>.from(unreadNotifications)
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
              // ... (Phần UI cho Bottom Sheet Notification giữ nguyên)
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
                            markNotificationAsRead(notification.id);
                            Navigator.pop(ctx);
                            // ⚠️ Điều hướng đến màn hình chi tiết thông báo
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

  // 3. THANH TÌM KIẾM (Giữ nguyên)
  Widget _buildSearchBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(12),
      ),
      child: const TextField(
        decoration: InputDecoration(
          hintText: 'Tìm kiếm gói khám, dịch vụ...',
          border: InputBorder.none,
          prefixIcon: Icon(Icons.search, color: Colors.grey),
        ),
      ),
    );
  }

  // ----------------------------------------------------
  // II. CÁC HÀM XÂY DỰNG GÓI KHÁM SỨC KHỎE 
  // ----------------------------------------------------

  // 💥 Card hiển thị thông tin gói khám (ĐÃ ĐIỀU CHỈNH THAM SỐ)
  Widget _buildPackageCard(BuildContext context, HealthPackage pkg, {required Color cardColor, required Color borderColor, required Color titleColor, required bool showDiscountTag}) {
    // 💥 Dùng getter formattedPrice và formattedOldPrice
    final String priceText = pkg.formattedPrice;
    final String? oldPriceText = pkg.formattedOldPrice;

    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (c) => ServiceDetailScreen(
                    healthPackage: pkg,
                    onBookAppointment: onBookAppointment, 
                ),
            ),
        );
      },
      child: Container(
        width: 280, 
        margin: const EdgeInsets.only(right: 15),
        decoration: BoxDecoration(
          color: cardColor,
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: borderColor),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 3,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (pkg.image != null) 
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.network(
                    pkg.image!, 
                    height: 80,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(
                      height: 80,
                      color: Colors.grey[200],
                      child: const Center(child: Text('Lỗi tải ảnh')),
                    ),
                  ),
                ),
              const SizedBox(height: 10),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded( 
                    child: Text(
                      pkg.name,
                      style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: titleColor),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  if (showDiscountTag) 
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Text('ƯU ĐÃI', style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 5),
              Text(
                pkg.description,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontSize: 13, color: Colors.black54),
              ),
              const Spacer(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Hiển thị giá cũ nếu có và đang giảm giá
                      if (pkg.isDiscount && oldPriceText != null)
                        Text(
                          oldPriceText,
                          style: const TextStyle(
                            fontSize: 13,
                            color: Colors.grey,
                            decoration: TextDecoration.lineThrough,
                          ),
                        ),
                      Text(
                        priceText,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: pkg.isDiscount ? Colors.red.shade700 : Colors.green.shade700,
                        ),
                      ),
                    ],
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (c) => ServiceDetailScreen(
                                  healthPackage: pkg,
                                  onBookAppointment: onBookAppointment,
                              ),
                          ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                    child: const Text('Xem chi tiết'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // 1. GÓI KHÁM ĐANG ƯU ĐÃI (Hiển thị ngang - isDiscount = true)
  Widget _buildDiscountPackages(BuildContext context) {
    final discountPackages = packages.where((p) => p.isDiscount).toList();

    if (discountPackages.isEmpty) return const SizedBox.shrink(); 

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Ưu đãi đặc biệt hôm nay 🔥',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.red),
            ),
            TextButton(
              onPressed: () {}, 
              child: const Text('Xem tất cả'),
            ),
          ],
        ),
        const SizedBox(height: 15),
        
        SizedBox(
          height: 250, 
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: discountPackages.length,
            itemBuilder: (context, index) {
              return _buildPackageCard(
                context, 
                discountPackages[index], 
                cardColor: Colors.orange[50]!, 
                borderColor: Colors.orange.shade200, 
                titleColor: Colors.red.shade800,
                showDiscountTag: true, 
              );
            },
          ),
        ),
        const SizedBox(height: 25),
      ],
    );
  }

  // 2. GÓI KHÁM ĐẶC BIỆT NỔI BẬT (Hiển thị ngang - isDiscount = false và isFeatured = true)
  Widget _buildFeaturedPackages(BuildContext context) {
    final featuredPackages = packages.where((p) => !p.isDiscount && p.isFeatured).toList();

    if (featuredPackages.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Gói Khám Đặc Biệt Nổi Bật ✨',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.purple),
        ),
        const SizedBox(height: 15),
        
        SizedBox(
          height: 250, 
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: featuredPackages.length,
            itemBuilder: (context, index) {
              return _buildPackageCard(
                context, 
                featuredPackages[index], 
                cardColor: Colors.purple[50]!, 
                borderColor: Colors.purple.shade200, 
                titleColor: Colors.purple.shade800,
                showDiscountTag: false, 
              );
            },
          ),
        ),
        const SizedBox(height: 25),
      ],
    );
  }

  // 3. GÓI KHÁM TIÊU CHUẨN (Hiển thị dọc - isDiscount = false và isFeatured = false)
  Widget _buildStandardPackages(BuildContext context) {
    // Lấy các gói không phải ưu đãi VÀ không phải nổi bật
    final standardPackages = packages.where((p) => !p.isDiscount && !p.isFeatured).toList();

    if (standardPackages.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Các Gói Khám Sức Khỏe Tiêu Chuẩn',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 15),
        
        ListView.builder(
          shrinkWrap: true, 
          physics: const NeverScrollableScrollPhysics(), 
          itemCount: standardPackages.length,
          itemBuilder: (context, index) {
            final pkg = standardPackages[index];
            return Container(
              margin: const EdgeInsets.only(bottom: 12),
              child: Card(
                elevation: 2,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                child: ListTile(
                  contentPadding: const EdgeInsets.all(12),
                  leading: const Icon(Icons.medical_services_outlined, size: 30, color: Colors.blue),
                  title: Text(pkg.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                  // 💥 Dùng getter formattedPrice
                  subtitle: Text(
                    '${pkg.description}\nGiá: ${pkg.formattedPrice}',
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 18, color: Colors.blue),
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (c) => ServiceDetailScreen(
                                healthPackage: pkg,
                                onBookAppointment: onBookAppointment,
                            ),
                        ),
                    );
                  },
                ),
              ),
            );
          },
        ),
        const SizedBox(height: 30),
      ],
    );
  }

  // ----------------------------------------------------
  // III. BUILD METHOD (ĐÃ CẬP NHẬT)
  // ----------------------------------------------------

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Dịch Vụ & Gói Khám'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.blue,
        elevation: 1,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. HEADER
            _buildWelcomeHeader(context), 
            const SizedBox(height: 20),

            // 2. SEARCH BAR
            _buildSearchBar(),
            const SizedBox(height: 30),

            // 3. GÓI KHÁM ƯU ĐÃI (Ngang)
            _buildDiscountPackages(context),

            // 4. GÓI KHÁM ĐẶC BIỆT NỔI BẬT (Ngang)
            _buildFeaturedPackages(context),

            // 5. GÓI KHÁM TIÊU CHUẨN (Dọc)
            _buildStandardPackages(context),

            // Placeholder cuối cùng
             Container(
              alignment: Alignment.center,
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                borderRadius: BorderRadius.circular(10)
              ),
              child: const Text(
                'Sử dụng tab "Trang Chủ" để tìm kiếm và đặt lịch bác sĩ',
                style: TextStyle(color: Colors.blue, fontWeight: FontWeight.w500),
              ),
            ),
          ],
        ),
      ),
    );
  }
}