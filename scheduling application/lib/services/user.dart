import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/user.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserService {
  static const String baseUrl = "http://192.168.111.218:5101/api/user";
  // static const String baseUrl = "http://10.12.189.19:5101/api/user";

  Future<bool> changePassword(String oldPassword, String newPassword) async {
    final url = Uri.parse('$baseUrl/change-password');

    // 1. Lấy token đã lưu từ SharedPreferences
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    if (token == null) {
      // Nếu không có token, không thể thực hiện
      return false;
    }

    // 2. Gửi yêu cầu PUT với token trong Header
    final response = await http.put(
      url,
      headers: {
        'Content-Type': 'application/json',
        // Thêm Authorization header để xác thực người dùng
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
        'oldPassword': oldPassword,
        'newPassword': newPassword,
      }),
    );

    // 3. Trả về true nếu thành công (status code 200)
    return response.statusCode == 200;
  }

  Future<User> getUserById(String id) async {
    // Trả về User không nullable
    final url = Uri.parse('$baseUrl/$id');
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    if (token == null) {
      throw Exception('Authentication token not found.');
    }

    final response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      return User.fromJson(json);
    } else if (response.statusCode == 404) {
      throw Exception('User not found.');
    } else if (response.statusCode == 401) {
      throw Exception('Unauthorized. Please log in again.');
    } else {
      // Các lỗi khác
      throw Exception(
        'Failed to load user data. Status code: ${response.statusCode}',
      );
    }
  }

  Future<User> UpdateUserInfo(
    String id,
    String fullName,
    String email,
    String phone,
    String address,
    DateTime birthDay,
    String gender,
  ) async {
    print(id);
    final url = Uri.parse('$baseUrl/update-user/$id');

    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    if (token == null) {
      throw Exception('Authentication token not found.');
    }

    final response = await http.put(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
        'fullName': fullName,
        'email': email,
        'phone': phone,
        'address': address,
        'birthDay': birthDay.toIso8601String(),
        'gender': gender,
      }),
    );

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      return User.fromJson(json);
    } else {
      print('Status: ${response.statusCode}');
      print('Body: ${response.body}');
      throw Exception('Failed to update user information.');
    }
  }

  Future<User> getCurrentUser() async {
    final url = Uri.parse('$baseUrl/me');
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    if (token == null) {
      throw Exception('Authentication token not found.');
    }

    final response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      return User.fromJson(json);
    } else {
      throw Exception('Failed to load current user data.');
    }
  }
}
