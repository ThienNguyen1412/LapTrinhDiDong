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

  void _selectSpecialty(String specialty) {
    setState(() {
      _selectedSpecialty = (_selectedSpecialty == specialty) ? null : specialty;
    });
  }

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
                ),
              ],
            ),
          );
        },
      ),
    );
  }

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