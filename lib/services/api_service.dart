import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

/// Central API client
class ApiService {
  // Server URL
  // Emulator: 10.0.2.2 — real device: PC IP (e.g. 192.168.1.7)
  static const String baseUrl = "http://10.0.2.2:5098/api";

  // Save token
  static Future<void> _saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString("token", token);
  }

  // Read token
  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString("token");
  }

  // Clear token
  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove("token");
  }

  // Login request
  static Future<Map<String, dynamic>> login(
      String email, String password) async {
    // Build URL
    final url = Uri.parse("$baseUrl/auth/login");

    // Send request
    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"email": email, "password": password}),
    );

    // Check status
    if (response.statusCode == 200) {
      // Parse body
      final data = jsonDecode(response.body) as Map<String, dynamic>;
      // Store token
      await _saveToken(data["token"]);
      return data;
    } else {
      throw Exception("الإيميل أو الباسورد غير صحيح");
    }
  }

  // Register request
  static Future<Map<String, dynamic>> register(
      String email, String password, String confirmPassword) async {
    final url = Uri.parse("$baseUrl/auth/register");

    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "email": email,
        "password": password,
        "confirmPassword": confirmPassword,
      }),
    );

    // Created or OK
    if (response.statusCode == 201 || response.statusCode == 200) {
      final data = jsonDecode(response.body) as Map<String, dynamic>;
      await _saveToken(data["token"]);
      return data;
    } else {
      // Read error
      String message = "فشل إنشاء الحساب";
      try {
        final body = jsonDecode(response.body);
        if (body is Map && body["message"] != null) {
          message = body["message"].toString();
        }
      } catch (_) {}
      throw Exception(message);
    }
  }

  // Upload analysis
  // Needs token + multipart
  static Future<Map<String, dynamic>> analyzeImage(String imagePath) async {
    // Read token
    final token = await getToken();
    final url = Uri.parse("$baseUrl/reports");

    final request = http.MultipartRequest("POST", url);
    // Auth header
    request.headers["Authorization"] = "Bearer $token";
    // Field "image"
    request.files.add(await http.MultipartFile.fromPath("image", imagePath));

    final streamed = await request.send();
    final response = await http.Response.fromStream(streamed);

    if (response.statusCode == 201 || response.statusCode == 200) {
      return jsonDecode(response.body) as Map<String, dynamic>;
    } else if (response.statusCode == 401) {
      throw Exception("انتهت الجلسة، سجّل دخول من جديد");
    } else {
      throw Exception("فشل تحليل الصورة");
    }
  }

  // Fetch reports
  // Needs token
  static Future<List<dynamic>> getReports() async {
    final token = await getToken();
    final url = Uri.parse("$baseUrl/reports?page=1&limit=50");

    final response = await http.get(
      url,
      headers: {"Authorization": "Bearer $token"},
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body) as Map<String, dynamic>;
      // Extract reports
      return (data["reports"] as List<dynamic>?) ?? [];
    } else if (response.statusCode == 401) {
      throw Exception("انتهت الجلسة، سجّل دخول من جديد");
    } else {
      throw Exception("فشل تحميل السجل");
    }
  }
}
