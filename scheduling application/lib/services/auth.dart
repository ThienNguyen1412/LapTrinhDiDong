import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/user.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  static const String baseUrl = "http://192.168.111.218:5101/api/auth";

  Future<bool> register(String fullname, String email, String password) async {
    final url = Uri.parse('$baseUrl/register');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'fullname': fullname,
        'email': email,
        'password': password,
      }),
    );
    return response.statusCode == 200;
  }

  Future<User?> login(String email, String password) async {
    final url = Uri.parse('$baseUrl/login');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'password': password}),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final userJson = data['user'];
      final token = data['token'];

      // Lưu token nếu cần
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('token', token);

      return User.fromJson(userJson);
    } else {
      return null;
    }
  }
}
