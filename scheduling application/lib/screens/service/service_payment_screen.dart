// File: screens/service/service_payment_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; 
import 'package:qr_flutter/qr_flutter.dart'; 
import 'package:vietqr_gen/vietqr_generator.dart'; 
import 'package:uuid/uuid.dart'; // THÊM IMPORT UUID
import '../../../models/health_package.dart';
import '../../../models/notification.dart'; // THÊM IMPORT NOTIFICATION

class ServicePaymentScreen extends StatefulWidget {
final HealthPackage healthPackage;
final Map<String, dynamic> bookingInfo;
// BỔ SUNG: Callback để thêm thông báo mới
final Function(AppNotification) addNotification; 

const ServicePaymentScreen({
super.key,
required this.healthPackage,
required this.bookingInfo,
required this.addNotification, // Bắt buộc truyền vào
});

@override
State<ServicePaymentScreen> createState() => _ServicePaymentScreenState();
}

class _ServicePaymentScreenState extends State<ServicePaymentScreen> {
final Uuid _uuid = const Uuid(); // Dùng để tạo ID ngẫu nhiên
int _selectedPaymentMethod = 0; // 0: Thanh toán sau, 1: Chuyển khoản

// Dữ liệu ngân hàng MỚI (ACB - BIN 970404)
final Bank _bankEnum = Bank.acb; 
final String _accountNo = '23071517'; 
final String _accountName = 'Nguyễn Minh Thiện';
final String _bankName = 'Ngân hàng ACB';

// Dữ liệu ĐỘNG
late final String transferAmount; 
late final String transferContent; 
late final String vietQrPayload; 

@override
void initState() {
super.initState();

// 1. Tính toán Số tiền và Nội dung chuyển khoản động
transferAmount = widget.healthPackage.price.toString(); 

String phone = widget.bookingInfo['phone'] as String;
transferContent = 'CK${widget.healthPackage.id}${phone.replaceAll(RegExp(r'[^0-9]'), '')}';

// 2. TẠO CHUỖI PAYLOAD VIETQR CHUẨN SỬ DỤNG CÚ PHÁP MỚI CỦA BẠN
try {
vietQrPayload = VietQR.generate(
bank: _bankEnum, 
accountNumber: _accountNo, 
amount: double.tryParse(transferAmount) ?? 0.0, 
message: transferContent, 
);
} catch (e) {
debugPrint("Lỗi khi dùng VietQR.generate: $e. Thử dùng payload cơ bản.");
vietQrPayload = "LỖI TẠO QR. VUI LÒNG KIỂM TRA LẠI THƯ VIỆN.";
}
}

// Hàm mới: Tạo đối tượng AppNotification
AppNotification _createBookingNotification(String paymentMethod) {
final String title;
final String body;
final DateTime now = DateTime.now();
final String pkgName = widget.healthPackage.name;

if (paymentMethod == 'Thanh toán sau') {
title = 'Xác nhận đặt dịch vụ thành công';
body = 'Lịch hẹn ${pkgName} của bạn đã được xác nhận. Vui lòng thanh toán tại quầy khi sử dụng dịch vụ. Cám ơn bạn!';
} else { // Chuyển khoản VietQR
title = 'Yêu cầu thanh toán ${pkgName} đã được ghi nhận';
body = 'Chúng tôi đang chờ xác nhận chuyển khoản. Mã chuyển khoản: ${transferContent}. Vui lòng chờ thông báo xác nhận thanh toán trong 1-2 giờ làm việc.';
}

// Giả định cấu trúc của AppNotification: id, title, body, date, isRead
return AppNotification(
id: _uuid.v4(), // Tạo ID duy nhất bằng UUID
title: title,
body: body,
date: now,
isRead: false,
);
}

// Hàm hoàn tất đặt lịch (vẫn là giả lập)
void _completeBooking(BuildContext context, String method) {
// 1. TẠO VÀ GỌI CALLBACK THÊM THÔNG BÁO
final AppNotification newNotification = _createBookingNotification(method);
widget.addNotification(newNotification); // Gọi callback để thêm thông báo vào Dashboard

// 2. HIỂN THỊ SNACKBAR & POP
ScaffoldMessenger.of(context).showSnackBar(
SnackBar(
content: Text(
'ĐẶT LỊCH THÀNH CÔNG! Phương thức: $method. Vui lòng kiểm tra email/SMS xác nhận và Thông báo trong ứng dụng.',
style: const TextStyle(color: Colors.white),
),
backgroundColor: Colors.green,
duration: const Duration(seconds: 4),
),
);
// Pop về màn hình gốc (Dashboard)
Navigator.popUntil(context, (route) => route.isFirst); 
}

// Hàm sao chép dữ liệu (giữ nguyên)
void _copyToClipboard(String text, String label) {
Clipboard.setData(ClipboardData(text: text));
ScaffoldMessenger.of(context).showSnackBar(
SnackBar(
content: Text('Đã sao chép $label: $text'),
backgroundColor: Colors.blue,
),
);
}

@override
Widget build(BuildContext context) {
return Scaffold(
appBar: AppBar(
title: const Text('Bước 2/2: Thanh Toán & Xác Nhận'),
backgroundColor: Colors.blue,
foregroundColor: Colors.white,
),
body: SingleChildScrollView(
padding: const EdgeInsets.all(20.0),
child: Column(
crossAxisAlignment: CrossAxisAlignment.start,
children: <Widget>[
// Tóm tắt thông tin gói khám
_buildSummaryCard(widget.healthPackage),
const SizedBox(height: 25),

const Text(
'Chọn Phương Thức Thanh Toán',
style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF0D47A1)),
),
const SizedBox(height: 15),

// 1. THANH TOÁN SAU KHÁM
_buildPaymentOption(
value: 0,
title: 'Thanh Toán Sau Khám',
subtitle: 'Thanh toán trực tiếp tại quầy tiếp tân sau khi hoàn tất dịch vụ.',
icon: Icons.credit_card_off,
),
const SizedBox(height: 10),

// 2. CHUYỂN KHOẢN (THANH TOÁN TRƯỚC)
_buildPaymentOption(
value: 1,
title: 'Chuyển Khoản Ngân Hàng (VietQR Động)',
subtitle: 'Thanh toán online để tiết kiệm thời gian chờ đợi.',
icon: Icons.qr_code_2,
),
const SizedBox(height: 25),

// HIỂN THỊ CHI TIẾT CHUYỂN KHOẢN NẾU ĐƯỢC CHỌN
if (_selectedPaymentMethod == 1) _buildTransferDetails(),
],
),
),
bottomNavigationBar: Padding(
padding: const EdgeInsets.all(16.0),
child: ElevatedButton(
onPressed: () => _completeBooking(
context,
_selectedPaymentMethod == 0 ? 'Thanh toán sau' : 'Chuyển khoản VietQR',
),
style: ElevatedButton.styleFrom(
backgroundColor: _selectedPaymentMethod == 0 ? Colors.green.shade600 : Colors.orange.shade700,
foregroundColor: Colors.white,
minimumSize: const Size(double.infinity, 55),
shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
),
child: Text(
_selectedPaymentMethod == 0 ? 'XÁC NHẬN & THANH TOÁN SAU' : 'HOÀN TẤT CHUYỂN KHOẢN',
style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
),
),
),
);
}

// Hàm hiển thị Tóm tắt thông tin gói khám (Giữ nguyên)
Widget _buildSummaryCard(HealthPackage pkg) {
String priceText = pkg.formattedPrice; 
final String customerName = widget.bookingInfo['name'] as String? ?? 'N/A';
final String customerPhone = widget.bookingInfo['phone'] as String? ?? 'N/A';
final String note = widget.bookingInfo['note'] as String? ?? 'Không có';

return Card(
elevation: 3,
shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
child: Padding(
padding: const EdgeInsets.all(16.0),
child: Column(
crossAxisAlignment: CrossAxisAlignment.start,
children: [
const Text('Tóm Tắt Đặt Lịch', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.blue)),
const Divider(height: 15),
const Text('Thông Tin Khách Hàng', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black87)),
const SizedBox(height: 5),
_buildSummaryRow('Họ và Tên', customerName),
_buildSummaryRow('SĐT', customerPhone),
_buildSummaryRow('Ghi Chú', note),
const Divider(),
_buildSummaryRow('Dịch Vụ', pkg.name),
_buildSummaryRow('Ngày Khám', widget.bookingInfo['date'] != null ? 
'${(widget.bookingInfo['date'] as DateTime).day}/${(widget.bookingInfo['date'] as DateTime).month}/${(widget.bookingInfo['date'] as DateTime).year}' : 'N/A'),
_buildSummaryRow('Giờ Khám', widget.bookingInfo['time'] != null ? 
(widget.bookingInfo['time'] as TimeOfDay).format(context) : 'N/A'),
const Divider(height: 15),
_buildSummaryRow('TỔNG TIỀN', priceText, isTotal: true),
],
),
),
);
}

// Hàm hiển thị một dòng tóm tắt (Giữ nguyên)
Widget _buildSummaryRow(String title, String value, {bool isTotal = false}) {
return Padding(
padding: const EdgeInsets.symmetric(vertical: 5.0),
child: Row(
mainAxisAlignment: MainAxisAlignment.spaceBetween,
children: [
Text(title, style: TextStyle(
fontSize: isTotal ? 16 : 15, 
fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
color: isTotal ? Colors.red.shade700 : Colors.black87,
)),
Text(value, style: TextStyle(
fontSize: isTotal ? 16 : 15, 
fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
color: isTotal ? Colors.red.shade700 : Colors.black,
)),
],
),
);
}

// Hàm hiển thị tùy chọn thanh toán (Giữ nguyên)
Widget _buildPaymentOption({
required int value,
required String title,
required String subtitle,
required IconData icon,
}) {
return InkWell(
onTap: () {
setState(() {
_selectedPaymentMethod = value;
});
},
child: Container(
padding: const EdgeInsets.all(12),
decoration: BoxDecoration(
color: _selectedPaymentMethod == value ? Colors.blue.shade50 : Colors.white,
border: Border.all(
color: _selectedPaymentMethod == value ? Colors.blue.shade600 : Colors.grey.shade300,
width: 2,
),
borderRadius: BorderRadius.circular(10),
),
child: Row(
children: [
Icon(icon, size: 30, color: _selectedPaymentMethod == value ? Colors.blue.shade700 : Colors.grey),
const SizedBox(width: 15),
Expanded(
child: Column(
crossAxisAlignment: CrossAxisAlignment.start,
children: [
Text(
title,
style: TextStyle(
fontSize: 16,
fontWeight: FontWeight.bold,
color: _selectedPaymentMethod == value ? Colors.blue.shade900 : Colors.black,
),
),
Text(
subtitle,
style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
),
],
),
),
Radio<int>(
value: value,
groupValue: _selectedPaymentMethod,
onChanged: (int? newValue) {
setState(() {
_selectedPaymentMethod = newValue!;
});
},
activeColor: Colors.blue.shade600,
),
],
),
),
);
}

// Hàm hiển thị Chi tiết chuyển khoản và Mã QR (Giữ nguyên)
Widget _buildTransferDetails() {
return Container(
padding: const EdgeInsets.all(16),
decoration: BoxDecoration(
color: Colors.grey.shade50,
borderRadius: BorderRadius.circular(10),
border: Border.all(color: Colors.orange.shade200),
),
child: Column(
crossAxisAlignment: CrossAxisAlignment.center,
children: [
Text(
'Quét Mã VietQR ĐỘNG (Số tiền: ${widget.healthPackage.formattedPrice})',
style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.orange),
textAlign: TextAlign.center,
),
const SizedBox(height: 15),

// KHUNG CHỨA VIETQR ĐỘNG
Container(
padding: const EdgeInsets.all(8),
decoration: BoxDecoration(
border: Border.all(color: Colors.blueGrey.shade200),
borderRadius: BorderRadius.circular(8),
color: Colors.white,
),
child: QrImageView(
data: vietQrPayload, 
version: QrVersions.auto,
size: 180.0,
backgroundColor: Colors.white,
errorStateBuilder: (cxt, err) {
return const Center(
child: Text(
"Không thể tạo QR. Vui lòng kiểm tra lại data.",
textAlign: TextAlign.center,
style: TextStyle(fontSize: 12),
),
);
},
),
),
const SizedBox(height: 15),

_buildInfoRow('Ngân hàng', _bankName, Icons.account_balance, isCopyable: false),
_buildInfoRow('Tên tài khoản', _accountName, Icons.person_outline, isCopyable: false),
_buildInfoRow('Số tài khoản', _accountNo, Icons.credit_card, isCopyable: true, copyValue: _accountNo),

_buildInfoRow('Số tiền', widget.healthPackage.formattedPrice, Icons.monetization_on, isHighlight: true, isCopyable: true, copyValue: transferAmount),

_buildInfoRow(
'Nội dung', 
transferContent, 
Icons.notes, 
isHighlight: true,
isCopyable: true,
copyValue: transferContent,
),
const SizedBox(height: 10),

const Text(
'Lưu ý: Vui lòng ghi đúng Số tiền và Nội dung chuyển khoản để chúng tôi xác nhận nhanh chóng.',
style: TextStyle(fontSize: 13, color: Colors.red),
textAlign: TextAlign.center,
),
],
),
);
}

// Hàm hiển thị một dòng thông tin có thể sao chép (Giữ nguyên)
Widget _buildInfoRow(String label, String value, IconData icon, {bool isHighlight = false, bool isCopyable = false, String? copyValue}) {
return Padding(
padding: const EdgeInsets.symmetric(vertical: 4.0),
child: Row(
crossAxisAlignment: CrossAxisAlignment.center,
children: [
Icon(icon, size: 18, color: Colors.grey.shade600),
const SizedBox(width: 8),
Text(
'$label: ',
style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
),
Expanded(
child: Text(
value,
style: TextStyle(
fontWeight: isHighlight ? FontWeight.bold : FontWeight.normal,
color: isHighlight ? Colors.blue.shade800 : Colors.black,
fontSize: 14,
),
),
),
if (isCopyable)
GestureDetector(
onTap: () => _copyToClipboard(copyValue ?? value, label),
child: const Padding(
padding: EdgeInsets.only(left: 8.0),
child: Icon(Icons.copy, size: 18, color: Colors.blue),
),
),
],
),
);
}
}