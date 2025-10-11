import 'package:flutter/material.dart';
import '../../models/doctor.dart'; // Đảm bảo model Doctor đã được import

// ----------------------------------------------------
// 1. MÀN HÌNH CHI TIẾT BÁC SĨ (DetailsScreen)
// ----------------------------------------------------
class DetailsScreen extends StatelessWidget {
  final Doctor doctor;
  final void Function(Doctor) onBookAppointment; 
  
  const DetailsScreen({
    super.key, 
    required this.doctor,
    required this.onBookAppointment,
  });

  // Hàm hiển thị Form Đặt lịch Modal
  void _showBookingForm(BuildContext context, Doctor doctor) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true, // Cho phép cuộn để tránh bàn phím che khuất
      builder: (BuildContext context) {
        return Padding(
          padding: EdgeInsets.only(
            // Đẩy bottom sheet lên khi bàn phím xuất hiện
            bottom: MediaQuery.of(context).viewInsets.bottom, 
          ),
          child: BookingFormModal(
            doctor: doctor,
            onConfirm: (bookingDetails) {
              // Sau khi form được điền và xác nhận, gọi callback chính
              Navigator.pop(context); // Đóng modal
              onBookAppointment(doctor); // Gọi hàm đặt lịch chính
              
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Đã đặt lịch khám với Bác sĩ ${doctor.name} vào ngày ${bookingDetails.date.day}/${bookingDetails.date.month}.'),
                  duration: const Duration(seconds: 3),
                ),
              );
            },
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(doctor.name),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- AVATAR + THÔNG TIN CƠ BẢN ---
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
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF0D47A1),
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        doctor.specialty,
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.blue,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        doctor.hospital,
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.black54,
                        ),
                      ),
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

            // --- RATING HIỂN THỊ 5 NGÔI SAO ---
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

            // --- BÌNH LUẬN ĐỘNG ---
            const Text(
              "Bình luận của bệnh nhân:",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            ...doctor.comments.map(
              (comment) => Card(
                margin: const EdgeInsets.only(bottom: 8),
                elevation: 1,
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(Icons.person_pin, color: Colors.blue, size: 20),
                      const SizedBox(width: 10),
                      Expanded(child: Text(comment, style: const TextStyle(fontSize: 14))),
                    ],
                  ),
                ),
              ),
            ),

            const SizedBox(height: 30),

            // --- NÚT ĐẶT LỊCH KHÁM ---
            Center(
              child: SizedBox(
                width: double.infinity, 
                child: ElevatedButton.icon(
                  onPressed: () {
                    // 💥 GỌI HÀM HIỂN THỊ FORM
                    _showBookingForm(context, doctor);
                  },
                  icon: const Icon(Icons.calendar_today),
                  label: const Text(
                    'Đặt lịch khám ngay',
                    style: TextStyle(fontSize: 16),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 15,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
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

// ----------------------------------------------------
// 2. MODEL TẠM THỜI CHO CHI TIẾT ĐẶT LỊCH (BookingDetails)
// ----------------------------------------------------
class BookingDetails {
  String name;
  String phone;
  String address;
  String note;
  TimeOfDay time;
  DateTime date;

  BookingDetails({
    required this.name,
    required this.phone,
    required this.address,
    required this.note,
    required this.time,
    required this.date,
  });
}

// ----------------------------------------------------
// 3. WIDGET FORM ĐẶT LỊCH (BookingFormModal)
// ----------------------------------------------------
class BookingFormModal extends StatefulWidget {
  final Doctor doctor;
  final Function(BookingDetails) onConfirm;

  const BookingFormModal({super.key, required this.doctor, required this.onConfirm});

  @override
  State<BookingFormModal> createState() => _BookingFormModalState();
}

class _BookingFormModalState extends State<BookingFormModal> {
  final _formKey = GlobalKey<FormState>();
  
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _addressController = TextEditingController();
  final _noteController = TextEditingController();

  DateTime _selectedDate = DateTime.now().add(const Duration(days: 1)); // Mặc định ngày mai
  TimeOfDay _selectedTime = const TimeOfDay(hour: 9, minute: 0); // Mặc định 9:00 sáng

  // Hàm hiển thị Date Picker
  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 90)),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  // Hàm hiển thị Time Picker
  Future<void> _selectTime() async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime,
    );
    if (picked != null && picked != _selectedTime) {
      setState(() {
        _selectedTime = picked;
      });
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      height: MediaQuery.of(context).size.height * 0.9,
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              // Tiêu đề
              Center(
                child: Text(
                  'Đặt Lịch Khám Bác sĩ ${widget.doctor.name}',
                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.blue),
                ),
              ),
              const SizedBox(height: 15),

              // Thông tin bác sĩ
              Text('Chuyên khoa: ${widget.doctor.specialty}', style: const TextStyle(fontSize: 16)),
              Text('Bệnh viện: ${widget.doctor.hospital}', style: const TextStyle(fontSize: 16)),
              const Divider(height: 25),

              // Họ tên
              _buildTextField(
                controller: _nameController,
                label: 'Họ tên bệnh nhân (*)',
                icon: Icons.person,
                validator: (value) => (value == null || value.isEmpty) ? 'Vui lòng nhập họ tên' : null,
              ),
              const SizedBox(height: 15),

              // Số điện thoại
              _buildTextField(
                controller: _phoneController,
                label: 'Số điện thoại (*)',
                icon: Icons.phone,
                keyboardType: TextInputType.phone,
                validator: (value) => (value == null || value.isEmpty) ? 'Vui lòng nhập số điện thoại' : null,
              ),
              const SizedBox(height: 15),

              // Địa chỉ
              _buildTextField(
                controller: _addressController,
                label: 'Địa chỉ (*)',
                icon: Icons.location_on,
                validator: (value) => (value == null || value.isEmpty) ? 'Vui lòng nhập địa chỉ' : null,
              ),
              const SizedBox(height: 20),

              // Ngày đến khám
              Text('Ngày đến khám (*):', style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 8),
              _buildDateTimeButton(
                icon: Icons.calendar_today,
                text: 'Ngày: ${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}',
                onPressed: _selectDate,
              ),
              const SizedBox(height: 15),

              // Giờ khám bệnh
              Text('Giờ khám bệnh (*):', style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 8),
              _buildDateTimeButton(
                icon: Icons.access_time,
                text: 'Giờ: ${_selectedTime.format(context)}',
                onPressed: _selectTime,
              ),
              const SizedBox(height: 20),

              // Ghi chú
              _buildTextField(
                controller: _noteController,
                label: 'Ghi chú (Tùy chọn)',
                icon: Icons.notes,
                maxLines: 3,
                validator: (value) => null,
              ),
              const SizedBox(height: 30),

              // Nút Xác nhận Đặt lịch
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      final bookingDetails = BookingDetails(
                        name: _nameController.text,
                        phone: _phoneController.text,
                        address: _addressController.text,
                        note: _noteController.text,
                        time: _selectedTime,
                        date: _selectedDate,
                      );
                      widget.onConfirm(bookingDetails);
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  child: const Text('Xác nhận Đặt lịch', style: TextStyle(fontSize: 18)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Widget helper cho TextFormField
  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator,
    int maxLines = 1,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      maxLines: maxLines,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: Colors.blue),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        contentPadding: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
      ),
      validator: validator,
    );
  }

  // Widget helper cho Date/Time Button
  Widget _buildDateTimeButton({
    required IconData icon,
    required String text,
    required VoidCallback onPressed,
  }) {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton.icon(
        icon: Icon(icon, color: Colors.blue),
        label: Text(text, style: const TextStyle(fontSize: 16)),
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          foregroundColor: Colors.black87,
          side: const BorderSide(color: Colors.grey, width: 1),
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          alignment: Alignment.centerLeft,
        ),
      ),
    );
  }
}