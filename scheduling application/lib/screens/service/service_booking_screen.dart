// File: screens/service/service_booking_screen.dart

import 'package:flutter/material.dart';
import '../../models/health_package.dart';
import '../../models/notification.dart'; // 💥 Cần import Notification Model
// 💥 Thêm import cho màn hình thanh toán mới
import 'service_payment_screen.dart'; 

class ServiceBookingScreen extends StatefulWidget {
final HealthPackage healthPackage;
  // 💥 BỔ SUNG: Thêm callback để truyền xuống màn hình thanh toán
  final Function(AppNotification) addNotification; 

const ServiceBookingScreen({
super.key,
required this.healthPackage,
    required this.addNotification, // 💥 Bắt buộc phải có
});

@override
State<ServiceBookingScreen> createState() => _ServiceBookingScreenState();
}

class _ServiceBookingScreenState extends State<ServiceBookingScreen> {
// Key để quản lý trạng thái của Form
final _formKey = GlobalKey<FormState>();

// Controllers cho các trường nhập liệu
final TextEditingController _nameController = TextEditingController();
final TextEditingController _phoneController = TextEditingController();
final TextEditingController _noteController = TextEditingController();

// State cho Ngày/Giờ Khám
DateTime? _selectedDate;
TimeOfDay? _selectedTime;

// Hàm chọn ngày
Future<void> _selectDate(BuildContext context) async {
final DateTime? picked = await showDatePicker(
context: context,
initialDate: DateTime.now(),
firstDate: DateTime.now(),
lastDate: DateTime.now().add(const Duration(days: 365)),
);
if (picked != null && picked != _selectedDate) {
setState(() {
_selectedDate = picked;
});
}
}

// Hàm chọn giờ
Future<void> _selectTime(BuildContext context) async {
final TimeOfDay? picked = await showTimePicker(
context: context,
initialTime: TimeOfDay.now(),
);
if (picked != null && picked != _selectedTime) {
setState(() {
_selectedTime = picked;
});
}
}

// 💥 CẬP NHẬT: Hàm xử lý chuyển sang trang thanh toán
void _submitBooking() {
// Kích hoạt validation cho TextFormField
bool formValid = _formKey.currentState!.validate();

// Kiểm tra validation thủ công cho Date/Time
bool dateValid = _selectedDate != null;
bool timeValid = _selectedTime != null;

// Nếu Form và Date/Time đều hợp lệ
if (formValid && dateValid && timeValid) {
// 1. Thu thập thông tin khách hàng
final bookingInfo = {
'name': _nameController.text,
'phone': _phoneController.text,
'date': _selectedDate,
'time': _selectedTime,
'note': _noteController.text,
};

// 2. Điều hướng đến màn hình thanh toán
Navigator.push(
context,
MaterialPageRoute(
builder: (ctx) => ServicePaymentScreen(
healthPackage: widget.healthPackage,
bookingInfo: bookingInfo,
            // 💥 BỔ SUNG: Truyền callback xuống màn hình thanh toán
            addNotification: widget.addNotification,
),
),
);
} else {
// Nếu có lỗi ở Date/Time, kích hoạt rebuild để hiển thị lỗi validation thủ công
setState(() {}); 
ScaffoldMessenger.of(context).showSnackBar(
const SnackBar(
content: Text('Vui lòng điền đầy đủ thông tin bắt buộc và chọn ngày/giờ khám.'),
backgroundColor: Colors.red,
),
);
}
}

@override
void dispose() {
_nameController.dispose();
_phoneController.dispose();
_noteController.dispose();
super.dispose();
}

@override
Widget build(BuildContext context) {
String formattedDate = _selectedDate == null 
? 'Chọn Ngày Khám' 
: '${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}';

String formattedTime = _selectedTime == null 
? 'Chọn Giờ Khám' 
: _selectedTime!.format(context);

return Scaffold(
appBar: AppBar(
title: const Text('Bước 1/2: Điền Thông Tin'), // Cập nhật title
backgroundColor: Colors.blue,
foregroundColor: Colors.white,
),
body: SingleChildScrollView(
padding: const EdgeInsets.all(20.0),
child: Form(
key: _formKey,
child: Column(
crossAxisAlignment: CrossAxisAlignment.start,
children: <Widget>[
// Tên Gói Dịch Vụ
Text(
'Gói: ${widget.healthPackage.name}',
style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.blue),
),
const Divider(height: 30),

// 1. Họ Tên
_buildTextFormField(
controller: _nameController,
labelText: 'Họ và Tên (*)',
icon: Icons.person,
validator: (value) {
if (value == null || value.isEmpty) {
return 'Vui lòng nhập Họ và Tên';
}
return null;
},
),
const SizedBox(height: 15),

// 2. Số Điện Thoại
_buildTextFormField(
controller: _phoneController,
labelText: 'Số Điện Thoại (*)',
icon: Icons.phone,
keyboardType: TextInputType.phone,
validator: (value) {
if (value == null || value.isEmpty) {
return 'Vui lòng nhập Số điện thoại';
}
// Thêm logic kiểm tra định dạng SĐT nếu cần
if (value.length < 10 || value.length > 11) {
return 'Số điện thoại không hợp lệ';
}
return null;
},
),
const SizedBox(height: 20),

// 3. Ngày Khám
const Text(
'Ngày Khám (*)',
style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.black87),
),
const SizedBox(height: 5),
_buildDateOrTimeButton(
text: formattedDate,
icon: Icons.calendar_today,
onPressed: () => _selectDate(context),
validator: () => _selectedDate == null ? 'Vui lòng chọn ngày khám' : null,
),
const SizedBox(height: 15),

// 4. Giờ Khám
const Text(
'Giờ Khám (*)',
style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.black87),
),
const SizedBox(height: 5),
_buildDateOrTimeButton(
text: formattedTime,
icon: Icons.access_time,
onPressed: () => _selectTime(context),
validator: () => _selectedTime == null ? 'Vui lòng chọn giờ khám' : null,
),
const SizedBox(height: 20),

// 5. Ghi Chú
_buildTextFormField(
controller: _noteController,
labelText: 'Ghi Chú (Tùy chọn)',
icon: Icons.notes,
maxLines: 4,
),
const SizedBox(height: 30),

// Nút TIẾP THEO
ElevatedButton(
onPressed: _submitBooking,
style: ElevatedButton.styleFrom(
backgroundColor: Colors.blue.shade600, // Thay đổi màu sắc và tên nút
foregroundColor: Colors.white,
minimumSize: const Size(double.infinity, 55),
shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
),
child: const Text('TIẾP THEO', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
),
],
),
),
),
);
}

// Widget chung cho TextFormField (Giữ nguyên)
Widget _buildTextFormField({
required TextEditingController controller,
required String labelText,
required IconData icon,
TextInputType keyboardType = TextInputType.text,
String? Function(String?)? validator,
int maxLines = 1,
}) {
    // ... (logic giữ nguyên)
return TextFormField(
controller: controller,
keyboardType: keyboardType,
maxLines: maxLines,
validator: validator,
decoration: InputDecoration(
labelText: labelText,
prefixIcon: Icon(icon, color: Colors.blue),
border: OutlineInputBorder(
borderRadius: BorderRadius.circular(10),
),
enabledBorder: OutlineInputBorder(
borderRadius: BorderRadius.circular(10),
borderSide: BorderSide(color: Colors.blue.shade200, width: 1),
),
focusedBorder: OutlineInputBorder(
borderRadius: BorderRadius.circular(10),
borderSide: const BorderSide(color: Colors.blue, width: 2),
),
),
);
}

// Widget chung cho nút chọn Ngày/Giờ (Giữ nguyên)
Widget _buildDateOrTimeButton({
required String text,
required IconData icon,
required VoidCallback onPressed,
required String? Function() validator,
}) {
// ... (logic giữ nguyên)
return Column(
crossAxisAlignment: CrossAxisAlignment.start,
children: [
InkWell(
onTap: onPressed,
child: Container(
height: 55,
padding: const EdgeInsets.symmetric(horizontal: 12),
decoration: BoxDecoration(
border: Border.all(color: Colors.blue.shade200, width: 1),
borderRadius: BorderRadius.circular(10),
),
child: Row(
children: [
Icon(icon, color: Colors.blue),
const SizedBox(width: 15),
Text(
text,
style: TextStyle(
fontSize: 16,
color: (text == 'Chọn Ngày Khám' || text == 'Chọn Giờ Khám') ? Colors.grey : Colors.black,
),
),
const Spacer(),
const Icon(Icons.edit, size: 20, color: Colors.blue),
],
),
),
),
// Hiển thị lỗi thủ công cho Date/Time Picker
if (validator() != null && (_formKey.currentState?.validate() == false || (text == 'Chọn Ngày Khám' && _selectedDate == null) || (text == 'Chọn Giờ Khám' && _selectedTime == null)))
Padding(
padding: const EdgeInsets.only(top: 8.0, left: 12.0),
child: Text(
validator()!,
style: TextStyle(color: Theme.of(context).colorScheme.error, fontSize: 12),
),
),
],
);
}
}