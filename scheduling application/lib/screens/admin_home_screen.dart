import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart'; 
// Import các file cần thiết
import '../models/appointment.dart'; // Giả định Appointment model
import 'admin_appointment/admin_appointment_screen.dart'; 
import 'admin_doctor/admin_doctor_screen.dart';

// ----------------------------------------------------
// 1. Màn hình chính Admin Home
// ----------------------------------------------------
class AdminHomeScreen extends StatelessWidget {
  const AdminHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const _AdminDashboardHome();
  }
}

// ----------------------------------------------------
// 2. Widget quản lý trạng thái và điều hướng
// ----------------------------------------------------
class _AdminDashboardHome extends StatefulWidget {
  const _AdminDashboardHome();

  @override
  State<_AdminDashboardHome> createState() => _AdminDashboardHomeState();
}

class _AdminDashboardHomeState extends State<_AdminDashboardHome> {
  int _selectedIndex = 0; 
  
  // 💥 QUẢN LÝ DỮ LIỆU LỊCH HẸN (MỚI)
  List<Appointment> _appointments = [
    // Lịch hẹn chờ xử lý (Pending)
    Appointment(id: '1001', doctorName: 'BS. Hùng', specialty: 'Răng Hàm Mặt', date: '20/10/2025', time: '09:00 AM', status: 'Pending'),
    Appointment(id: '1002', doctorName: 'BS. Lan', specialty: 'Nhi khoa', date: '21/10/2025', time: '14:30 PM', status: 'Pending'),
    // Lịch hẹn đã Xác nhận
    Appointment(id: '1003', doctorName: 'BS. Minh', specialty: 'Tim mạch', date: '22/10/2025', time: '10:00 AM', status: 'Confirmed'),
  ];
  
  // 💥 HÀM CẬP NHẬT TRẠNG THÁI LỊCH HẸN (MỚI)
  void _updateAppointmentStatus(String id, String newStatus) {
    setState(() {
      final index = _appointments.indexWhere((app) => app.id == id);
      if (index != -1) {
        _appointments[index].status = newStatus;
      }
    });
    // Hiển thị thông báo (tùy chọn)
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Cập nhật lịch hẹn #$id thành: $newStatus'),
        backgroundColor: newStatus == 'Confirmed' ? Colors.green : Colors.red,
      ),
    );
  }

  List<Map<String, dynamic>> get _adminFeatures {
    return [
      {'title': 'Thống kê & Báo cáo', 'icon': Icons.dashboard, 'body': DashboardContent()}, 
      // 💥 ĐÃ CẬP NHẬT: Thay Placeholder bằng AdminAppointmentScreen
      {
        'title': 'Quản lý Lịch hẹn', 
        'icon': Icons.calendar_month, 
        'body': AdminAppointmentScreen(
          pendingAppointments: _appointments, // Truyền toàn bộ list
          updateAppointmentStatus: _updateAppointmentStatus, // Truyền hàm xử lý
        )
      },
      {
        'title': 'Quản lý Bác sĩ',
         'icon': Icons.medical_services,
          'body':const AdminDoctorScreen()},
      {'title': 'Quản lý Người dùng', 'icon': Icons.people, 'body': PlaceholderScreen.create('Quản lý Người dùng', Colors.orange)},
      {'title': 'Quản lý Dịch vụ/Gói khám', 'icon': Icons.business_center, 'body': PlaceholderScreen.create('Quản lý Dịch vụ/Gói khám', Colors.purple)},
      {'title': 'Quản lý Hồ sơ (Website)', 'icon': Icons.settings, 'body': PlaceholderScreen.create('Quản lý Hồ sơ', Colors.black54)},
    ];
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    Navigator.pop(context); 
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Builder(
          builder: (context) {
            return IconButton(
              icon: const Icon(Icons.menu),
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
            );
          },
        ),
        title: Text(_adminFeatures[_selectedIndex]['title']),
        backgroundColor: Colors.red.shade700, 
        foregroundColor: Colors.white,
      ),
      
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.red.shade700,
              ),
              child: const Text(
                'Admin Menu',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            ..._adminFeatures.asMap().entries.map((entry) {
              int index = entry.key;
              Map<String, dynamic> feature = entry.value;
              return ListTile(
                leading: Icon(feature['icon'], color: index == _selectedIndex ? Colors.red.shade700 : Colors.black87),
                title: Text(
                  feature['title'],
                  style: TextStyle(
                    fontWeight: index == _selectedIndex ? FontWeight.bold : FontWeight.normal,
                    color: index == _selectedIndex ? Colors.red.shade700 : Colors.black,
                  ),
                ),
                selected: index == _selectedIndex,
                onTap: () => _onItemTapped(index),
              );
            }).toList(), 
            const Divider(),
            ListTile(
              leading: const Icon(Icons.logout, color: Colors.grey),
              title: const Text('Thoát'),
              onTap: () {
                // Xử lý logic thoát/đăng xuất
                Navigator.pop(context); 
                if (Navigator.canPop(context)) {
                    Navigator.pop(context); 
                } 
              },
            ),
          ],
        ),
      ),
      
      body: _adminFeatures[_selectedIndex]['body'] as Widget,
    );
  }
}

// ----------------------------------------------------
// 3. Nội dung cho Dashboard Thống kê
// ----------------------------------------------------
class DashboardContent extends StatelessWidget {
  DashboardContent({super.key});

  final Map<String, int> _serviceData = {
    'Kiểm tra Sức khỏe Tổng quát Cơ bản': 450, 
    'Gói Chăm Sóc Gia Đình': 200,
    'Sàng Lọc Ung Thư Toàn Diện': 150,
    'Gói Cao Cấp Toàn Diện': 100,
    'Gói Phục Hồi Hậu COVID': 80,
    'Gói Khám Tiền Hôn Nhân Cơ bản': 70,
    'Gói Khám Nhi khoa 0-6 tuổi': 50,
  };

  Widget _buildStatCard(String title, String value, IconData icon, Color color) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, size: 30, color: color),
            const SizedBox(height: 8),
            Text(
              value,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: color),
            ),
            const SizedBox(height: 4),
            Text(title, style: const TextStyle(fontSize: 14, color: Colors.black54)),
          ],
        ),
      ),
    );
  }
  
  final List<Color> _pieColors = [
    Colors.red, Colors.blue, Colors.green, Colors.purple, Colors.orange, Colors.teal, Colors.brown
  ];

  PieChartData pieChartData() {
    // int total = _serviceData.values.fold(0, (sum, item) => sum + item); // Không dùng
    List<PieChartSectionData> sections = [];
    int i = 0;

    _serviceData.forEach((title, value) {
      final isLargest = value == _serviceData.values.reduce((a, b) => a > b ? a : b);

      sections.add(
        PieChartSectionData(
          color: _pieColors[i % _pieColors.length],
          value: value.toDouble(),
          title: '', 
          radius: isLargest ? 45 : 40, 
          titleStyle: TextStyle(
            fontSize: isLargest ? 12 : 10,
            fontWeight: FontWeight.bold,
            color: Colors.white,
            shadows: isLargest ? [const Shadow(color: Colors.black, blurRadius: 2)] : [],
          ),
          // Thay thế phần trăm bằng Widget Text để tránh lỗi (vì không có giá trị phần trăm)
          badgeWidget: isLargest ? const Icon(Icons.star, color: Colors.yellow, size: 16) : null, 
          badgePositionPercentageOffset: isLargest ? 1.05 : null,
        ),
      );
      i++;
    });

    return PieChartData(
      sectionsSpace: 4, 
      centerSpaceRadius: 25, 
      sections: sections,
    );
  }
  
  Widget _buildLegend(String title, Color color, int value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2.0),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 10, 
            height: 10,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: color,
            ),
          ),
          const SizedBox(width: 6),
          Expanded(
            child: Text(
              _truncateString(title, 50), 
              style: const TextStyle(fontSize: 11), 
              overflow: TextOverflow.ellipsis, 
            ),
          ),
        ],
      ),
    );
  }

  String _truncateString(String text, int maxLength) {
    if (text.length <= maxLength) {
      return text;
    }
    return '${text.substring(0, maxLength - 3)}...';
  }

  // -----------------------------------------------------------------------------------------
  // LineChartData mainData() - Giữ nguyên (Vì nó đã được tối ưu hóa để không gây lỗi)
  // -----------------------------------------------------------------------------------------
  LineChartData mainData() {
    const dataColor = Colors.lightBlueAccent;

    return LineChartData(
      gridData: FlGridData(
        show: true,
        drawVerticalLine: true,
        horizontalInterval: 3000, 
        verticalInterval: 1,
        getDrawingHorizontalLine: (value) {
          return FlLine(
            color: Colors.white.withOpacity(0.15),
            strokeWidth: 1,
          );
        },
        getDrawingVerticalLine: (value) {
          return FlLine(
            color: Colors.white.withOpacity(0.15),
            strokeWidth: 1,
          );
        },
      ),
      titlesData: FlTitlesData(
        show: true,
        rightTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        topTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 30,
            interval: 1, 
            getTitlesWidget: (value, meta) {
              const style = TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 12,
                color: Colors.white, 
              );
              Widget text;
              switch (value.toInt()) {
                case 0: text = const Text('T1', style: style); break;
                case 1: text = const Text('T2', style: style); break;
                case 2: text = const Text('T3', style: style); break;
                case 3: text = const Text('T4', style: style); break;
                case 4: text = const Text('T5', style: style); break;
                case 5: text = const Text('T6', style: style); break;
                case 6: text = const Text('T7', style: style); break;
                case 7: text = const Text('T8', style: style); break;
                case 8: text = const Text('T9', style: style); break;
                case 9: text = const Text('T10', style: style); break;
                case 10: text = const Text('T11', style: style); break;
                case 11: text = const Text('T12', style: style); break;
                default: text = const Text('', style: style); break;
              }
              return SideTitleWidget(
                axisSide: meta.axisSide,
                space: 8.0,
                child: text,
              );
            },
          ),
        ),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            interval: 3000, 
            getTitlesWidget: (value, meta) {
              const style = TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 12,
                color: Colors.white, 
              );
              String text;
              if (value == 0) {
                text = '0';
              } else if (value == 3000) {
                text = '30M';
              } else if (value == 6000) {
                text = '60M';
              } else if (value == 9000) {
                text = '90M';
              } else {
                return Container();
              }
              return Text(text, style: style, textAlign: TextAlign.left);
            },
            reservedSize: 40,
          ),
        ),
      ),
      borderData: FlBorderData(
        show: true,
        border: Border.all(color: Colors.white.withOpacity(0.15)),
      ),
      minX: 0,
      maxX: 11, 
      minY: 0,
      maxY: 10000, 
      lineBarsData: [
        LineChartBarData(
          spots: const [
            FlSpot(0, 3500), FlSpot(1, 4800), FlSpot(2, 6000), FlSpot(3, 5200),
            FlSpot(4, 7500), FlSpot(5, 9200), FlSpot(6, 8500), FlSpot(7, 7900), 
            FlSpot(8, 6500), FlSpot(9, 8800), FlSpot(10, 9500), FlSpot(11, 10000),
          ],
          isCurved: true,
          color: dataColor,
          barWidth: 3,
          isStrokeCapRound: true,
          dotData: FlDotData( 
            show: true, 
            getDotPainter: (spot, percent, barData, index) => FlDotCirclePainter(
              radius: 4,
              color: dataColor, 
              strokeWidth: 1,
              strokeColor: Colors.white
            )
          ),
          belowBarData: BarAreaData(
            show: true,
            color: dataColor.withOpacity(0.3),
          ),
        ),
      ],
    );
  }
  // -----------------------------------------------------------------------------------------


  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Thống kê tổng quan (Tuần này)',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 15),
          
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            children: [
              _buildStatCard('Lịch hẹn mới', '45', Icons.pending_actions, Colors.blue),
              _buildStatCard('Tổng Bác sĩ', '72', Icons.person_add_alt_1, Colors.green),
              _buildStatCard('Người dùng mới', '3,500', Icons.group_add, Colors.orange),
              _buildStatCard('Doanh thu (tháng)', '120 Triệu', Icons.monetization_on, Colors.red),
            ],
          ),
          
          const Divider(height: 40),
          
          // BIỂU ĐỒ TRÒN - THỐNG KÊ DỊCH VỤ 
          const Text(
            'Tần suất đặt dịch vụ của khách hàng',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.2),
                  spreadRadius: 1,
                  blurRadius: 5,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: 150, 
                  height: 150, 
                  child: PieChart(
                    pieChartData(),
                    swapAnimationDuration: const Duration(milliseconds: 600),
                    swapAnimationCurve: Curves.easeInOut,
                  ),
                ),
                const SizedBox(width: 15), 
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Chú giải:',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      ..._serviceData.entries.toList().asMap().entries.map((entry) {
                        int index = entry.key;
                        String title = entry.value.key;
                        int value = entry.value.value;
                        return _buildLegend(title, _pieColors[index % _pieColors.length], value);
                      }).toList(),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const Divider(height: 40),
          
          // BIỂU ĐỒ DOANH THU 
          const Text(
            'Biến động Doanh thu 12 tháng gần nhất',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          const Text(
            'Biểu đồ thể hiện tổng doanh thu đạt được theo từng tháng (Đơn vị: Triệu VNĐ).',
            style: TextStyle(fontSize: 14, color: Colors.black87),
          ),
          const SizedBox(height: 10),
          Container(
            height: 200,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: const Color(0xff232d37), 
            ),
            child: Padding(
              padding: const EdgeInsets.only(right: 18.0, left: 12.0, top: 24, bottom: 12),
              child: LineChart(
                mainData(),
              ),
            ),
          ),
          
          const Divider(height: 40),

          // Hoạt động gần đây (Recent Activities) 
          const Text(
            'Hoạt động gần đây',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          Card(
            elevation: 2,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            child: const Column(
              children: [
                ListTile(
                  leading: Icon(Icons.check_circle, color: Colors.green),
                  title: Text('Xác nhận lịch hẹn #1234 của Nguyễn Văn A.'),
                  subtitle: Text('10 phút trước'),
                ),
                Divider(height: 0),
                ListTile(
                  leading: Icon(Icons.person_add, color: Colors.blue),
                  title: Text('Người dùng mới đăng ký: Trần Thị B.'),
                  subtitle: Text('2 giờ trước'),
                ),
                Divider(height: 0),
                ListTile(
                  leading: Icon(Icons.attach_money, color: Colors.amber),
                  title: Text('Thanh toán thành công gói khám: 990.000 VNĐ.'),
                  subtitle: Text('5 giờ trước'),
                ),
              ],
            ),
          ),
          const SizedBox(height: 30),
        ],
      ),
    );
  }
}


// ----------------------------------------------------
// 5. Màn hình Placeholder cho các chức năng quản lý khác
// ----------------------------------------------------
class PlaceholderScreen extends StatelessWidget {
  final String title;
  final Color color;
  
  const PlaceholderScreen._internal({super.key, required this.title, required this.color});
  
  factory PlaceholderScreen.create(String title, Color color) {
    return PlaceholderScreen._internal(title: title, color: color);
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(15),
            border: Border.all(color: color.withOpacity(0.5))
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.construction, size: 50, color: color),
              const SizedBox(height: 10),
              Text(
                title,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: color),
              ),
              const SizedBox(height: 8),
              const Text(
                'Màn hình quản lý này đang được xây dựng.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, color: Colors.black54),
              ),
            ],
          ),
        ),
      ),
    );
  }
}