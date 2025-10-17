import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/speciality.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SpecialityService {
  static const String baseUrl = "http://192.168.111.218:5101/api/specialitty";

  final<Speciality> ListSpeciality() async {
    final url = Uri.parse('$baseUrl');
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token') ?? '';

    final response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => Speciality.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load specialities');
    }
  }
}
