import 'dart:async';
import 'package:flutter/material.dart';
import '../../models/doctor.dart';
import '../../models/user.dart';
import '../../models/notification.dart';
import '../appointment/book_new_appointment_screen.dart';
import 'details_screen.dart';
import '../notification/notification_screen.dart';

class FeatureItem {
  final IconData icon;
  final String label;
  final String id;
  const FeatureItem({required this.icon, required this.label, required this.id});
}

class HomeScreen extends StatefulWidget {
  final User user;
  final List<AppNotification> notifications;
  final void Function(String) markNotificationAsRead;
  final void Function(Doctor) onBookAppointment;

  const HomeScreen({
    Key? key,
    required this.user,
    required this.notifications,
    required this.markNotificationAsRead,
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
    'https://cdn.phenikaa.../6d9f06a3-13cb-4b9a-97a8-84b7b51c9eff-image.webp',
    'https://dakhoa.hungyenweb.com/wp-content/uploads/2018/06/banner-phong-kham-da-khoa-2.jpg',
    'https://phusanthienan.com/wp-content/uploads/2024/12/1banner-web-Chinh-thuc-Hifu.jpg',
  ];

  final String _fallbackAvatar =
      'https://img.lovepik.com/free-png/20220101/lovepik-tortoise-png-image_401154498_wh860.png';

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
    _bannerTimer = Timer.periodic(const Duration(seconds: 4), (timer) {
      if (_bannerImages.isEmpty) return;
      _currentPage = (_currentPage + 1) % _bannerImages.length;
      if (_pageController.hasClients) {
        _pageController.animateToPage(
          _currentPage,
          duration: const Duration(milliseconds: 400),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  Widget _buildHeaderContent(BuildContext context) {
    final unreadCount = widget.notifications.where((n) => !n.isRead).length;
    final userName = widget.user.fullname.isNotEmpty ? widget.user.fullname : 'Người dùng';

    String getGreeting() {
      final hour = DateTime.now().hour;
      if (hour < 12) return 'Chào buổi sáng';
      if (hour < 18) return 'Chào buổi chiều';
      return 'Chào buổi tối';
    }

    return AppBar(
      backgroundColor: const Color(0xFF0D47A1),
      elevation: 0,
      automaticallyImplyLeading: false,
      titleSpacing: 12,
      title: Row(
        children: [
          CircleAvatar(
            radius: 20,
            backgroundImage: NetworkImage(_fallbackAvatar),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(getGreeting(), style: const TextStyle(fontSize: 12, color: Colors.white70)),
                Text(userName, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
              ],
            ),
          ),
          IconButton(
            onPressed: () => _showNotificationBottomSheet(context),
            icon: Stack(
              children: [
                const Icon(Icons.notifications_none, color: Colors.white),
                if (unreadCount > 0)
                  Positioned(
                    right: 0,
                    top: 0,
                    child: Container(
                      height: 10,
                      width: 10,
                      decoration: const BoxDecoration(color: Colors.redAccent, shape: BoxShape.circle),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Material(
      elevation: 2.0,
      borderRadius: BorderRadius.circular(30.0),
      child: TextField(
        decoration: InputDecoration(
          hintText: 'Tìm CSYT / bác sĩ / chuyên khoa / dịch vụ',
          prefixIcon: const Icon(Icons.search, color: Colors.grey),
          filled: true,
          fillColor: Colors.white,
          contentPadding: const EdgeInsets.symmetric(vertical: 12),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(30), borderSide: BorderSide.none),
        ),
      ),
    );
  }

  // responsive feature item (keeps content from overflowing)
  Widget _buildFeatureItem(FeatureItem item) {
    return LayoutBuilder(builder: (context, constraints) {
      // scale sizes based on item height to avoid overflow
      final double h = constraints.maxHeight.isFinite && constraints.maxHeight > 0 ? constraints.maxHeight : 80.0;
      final double iconSize = (h * 0.42).clamp(18.0, 30.0);
      final double pad = (h * 0.06).clamp(6.0, 12.0);
      final double fontSize = (h * 0.14).clamp(11.0, 13.0);

      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: EdgeInsets.all(pad),
            decoration: BoxDecoration(color: Colors.blue.withOpacity(0.1), borderRadius: BorderRadius.circular(12)),
            child: Icon(item.icon, color: Colors.blue.shade700, size: iconSize),
          ),
          SizedBox(height: h * 0.06),
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              item.label,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: fontSize, height: 1.0),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      );
    });
  }

  void _showNotificationBottomSheet(BuildContext context) {
    final sortedNotifications = List<AppNotification>.from(widget.notifications)..sort((a, b) => b.date.compareTo(a.date));

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext ctx) {
        return SafeArea(
          child: SizedBox(
            height: MediaQuery.of(context).size.height * 0.75,
            child: Column(
              children: [
                AppBar(
                  title: const Text('Thông báo'),
                  automaticallyImplyLeading: false,
                  actions: [
                    IconButton(icon: const Icon(Icons.close), onPressed: () => Navigator.pop(ctx)),
                  ],
                ),
                Expanded(
                  child: sortedNotifications.isEmpty
                      ? const Center(child: Text('Không có thông báo mới.', style: TextStyle(color: Colors.grey)))
                      : ListView.builder(
                          itemCount: sortedNotifications.length,
                          itemBuilder: (context, index) {
                            final notification = sortedNotifications[index];
                            return ListTile(
                              leading: Icon(notification.isRead ? Icons.notifications_none : Icons.notifications_active,
                                  color: notification.isRead ? Colors.grey : Colors.red),
                              title: Text(notification.title,
                                  style: TextStyle(fontWeight: notification.isRead ? FontWeight.normal : FontWeight.bold)),
                              subtitle: Text('${notification.date.day}/${notification.date.month} | ${notification.body}',
                                  maxLines: 1, overflow: TextOverflow.ellipsis),
                              onTap: () {
                                widget.markNotificationAsRead(notification.id);
                                Navigator.pop(ctx);
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
          ),
        );
      },
    );
  }

  Widget _buildBanner() {
    if (_bannerImages.isEmpty) return const SizedBox.shrink();
    return SizedBox(
      height: 130,
      child: Stack(
        children: [
          PageView.builder(
            controller: _pageController,
            itemCount: _bannerImages.length,
            onPageChanged: (index) => setState(() => _currentPage = index),
            itemBuilder: (context, index) {
              return Image.network(
                _bannerImages[index],
                fit: BoxFit.cover,
                width: double.infinity,
                errorBuilder: (context, error, stackTrace) {
                  return Container(color: Colors.grey[300], child: const Center(child: Icon(Icons.image_not_supported)));
                },
              );
            },
          ),
          Positioned(
            bottom: 8,
            left: 0,
            right: 0,
            child: Row(mainAxisAlignment: MainAxisAlignment.center, children: List.generate(_bannerImages.length, (index) {
              return AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                margin: const EdgeInsets.symmetric(horizontal: 4.0),
                height: 8.0,
                width: _currentPage == index ? 24.0 : 8.0,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(_currentPage == index ? 0.95 : 0.6),
                  borderRadius: BorderRadius.circular(12),
                ),
              );
            })),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // simplified single-line labels (no '\n') to reduce height
    final List<FeatureItem> features = [
      const FeatureItem(id: 'book_appointment', icon: Icons.description_outlined, label: 'Đặt lịch'),
      const FeatureItem(id: 'lookup_results', icon: Icons.find_in_page_outlined, label: 'Tra cứu'),
      const FeatureItem(id: 'guide', icon: Icons.info_outline, label: 'Hướng dẫn'),
      const FeatureItem(id: 'vaccine', icon: Icons.vaccines_outlined, label: 'Tiêm chủng'),
      const FeatureItem(id: 'payment', icon: Icons.credit_card_outlined, label: 'Thanh toán'),
      const FeatureItem(id: 'hotline', icon: Icons.phone_in_talk_outlined, label: '1900-2115'),
    ];

    // layout constants for the feature grid
    const int crossAxisCount = 3;
    // childAspectRatio controls each item's height; adjust to find best fit
    const double childAspectRatio = 1.8;
    // INCREASED vertical spacing to avoid overflow
    const double mainAxisSpacing = 28; // increased from 12 -> 28
    const double crossAxisSpacing = 12; // slightly increased
    const double verticalPadding = 20; // increased padding inside card

    // compute dynamic bottom padding to avoid device nav bar overlap
    final double bottomExtra = MediaQuery.of(context).viewPadding.bottom + 36;

    return Scaffold(
      backgroundColor: const Color(0xFFF0F4F8),
      appBar: PreferredSize(preferredSize: const Size.fromHeight(72.0), child: _buildHeaderContent(context)),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.fromLTRB(16, 16, 16, bottomExtra),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            _buildSearchBar(),
            const SizedBox(height: 20),
            // Feature grid card (kept) — compute and force height so it "kéo dài" xuống and has more vertical spacing
            Card(
              elevation: 2,
              shadowColor: Colors.grey.withOpacity(0.2),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: verticalPadding, horizontal: 12.0),
                child: LayoutBuilder(builder: (context, constraints) {
                  // Available width inside the card (subtract horizontal padding)
                  final double availableWidth = constraints.maxWidth;
                  // calculate item width given crossAxisCount and spacing
                  final double totalCrossSpacing = (crossAxisCount - 1) * crossAxisSpacing;
                  final double itemWidth = (availableWidth - totalCrossSpacing) / crossAxisCount;
                  // derive itemHeight from childAspectRatio (itemWidth / aspect)
                  final double itemHeight = itemWidth / childAspectRatio;
                  final int rows = (features.length / crossAxisCount).ceil();
                  // total height = rows * itemHeight + spacing between rows + vertical paddings
                  final double gridHeight = rows * itemHeight + (rows - 1) * mainAxisSpacing;

                  // add some extra buffer for safety (icons + text)
                  final double buffer = 20.0;

                  // EXTRA EXTEND: increases the card height so it "giãn cách" (you can tweak)
                  final double extraExtend = 10.0;

                  final double finalHeight = gridHeight + buffer + (verticalPadding * 2) + extraExtend;

                  return SizedBox(
                    height: finalHeight,
                    child: GridView.builder(
                      padding: EdgeInsets.zero,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: features.length,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: crossAxisCount,
                        childAspectRatio: childAspectRatio,
                        mainAxisSpacing: mainAxisSpacing,
                        crossAxisSpacing: crossAxisSpacing,
                      ),
                      itemBuilder: (context, index) {
                        final feature = features[index];
                        return InkWell(
                          onTap: () {
                            if (feature.id == 'book_appointment') {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => BookNewAppointmentScreen(onBookAppointment: widget.onBookAppointment),
                                ),
                              );
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('Chức năng "${feature.label}" sắp ra mắt!')),
                              );
                            }
                          },
                          borderRadius: BorderRadius.circular(12),
                          child: _buildFeatureItem(feature),
                        );
                      },
                    ),
                  );
                }),
              ),
            ),

            // extra spacing between card and banner to make layout "kéo dài" visually
            const SizedBox(height: 28),

            const Padding(
              padding: EdgeInsets.only(left: 4.0),
              child: Text('ĐƯỢC TIN TƯỞNG HỢP TÁC VÀ ĐỒNG HÀNH', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.black54)),
            ),
            const SizedBox(height: 12),
            _buildBanner(),
            const SizedBox(height: 18),
          ]),
        ),
      ),
    );
  }
}

class DoctorCard extends StatefulWidget {
  final Doctor doctor;
  final void Function(Doctor) onBookAppointment;

  const DoctorCard({Key? key, required this.doctor, required this.onBookAppointment}) : super(key: key);

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
        scale: _isHovered ? 1.03 : 1.0,
        duration: const Duration(milliseconds: 180),
        curve: Curves.easeOut,
        child: Card(
          elevation: _isHovered ? 6 : 2,
          color: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: BorderSide(color: _isHovered ? Colors.blue.shade200 : Colors.grey.shade200, width: 1),
          ),
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(children: [
              ClipOval(child: Image.network(widget.doctor.image, width: 60, height: 60, fit: BoxFit.cover, errorBuilder: (c, e, s) => const Icon(Icons.person, size: 60, color: Colors.grey))),
              const SizedBox(width: 12),
              Expanded(
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(widget.doctor.name, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF0D47A1))),
                  const SizedBox(height: 4),
                  Text(widget.doctor.specialty, style: const TextStyle(fontSize: 16, color: Colors.blue)),
                  Text(widget.doctor.hospital, style: const TextStyle(fontSize: 14, color: Colors.black54)),
                ]),
              ),
              IconButton(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => DetailsScreen(doctor: widget.doctor, onBookAppointment: widget.onBookAppointment)));
                },
                icon: const Icon(Icons.arrow_circle_right_outlined, size: 35, color: Colors.blue),
              )
            ]),
          ),
        ),
      ),
    );
  }
}