import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io';                                 // 🟢 مضافة جديد للتعامل مع الملفات
import 'package:path_provider/path_provider.dart'; // 🟢 مضافة جديد لتحديد مكان الحفظ
import 'package:open_filex/open_filex.dart';       // 🟢 مضافة جديد لفتح الملف تلقائياً بعد تحميله
import 'package:printing/printing.dart'; // تأكد من وجود السطر ده
import 'package:pdf/pdf.dart';



/// Central API client
class ApiService {
  // Server URL (ngrok tunnel to the team backend).
  /// NOTE: a free ngrok URL changes every restart — update this line when it changes.
  static const String baseUrl =
      "https://pouncing-arise-cussed.ngrok-free.dev";

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
    await prefs.remove("email");
  }

  // Save email (used for auto-login)
  static Future<void> _saveEmail(String email) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString("email", email);
  }

  // Read saved email
  static Future<String?> getSavedEmail() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString("email");
  }

  // Is the user already logged in?
  static Future<bool> isLoggedIn() async {
    final token = await getToken();
    return token != null && token.isNotEmpty;
  }

  /// Login request
  static Future<Map<String, dynamic>> login(
      String email, String password) async {
    // Build URL
    final url = Uri.parse("https://pouncing-arise-cussed.ngrok-free.dev/api/auth/login");

    // Send request
    final response = await http.post(
      url,
      headers: {
        "Content-Type": "application/json",
        "ngrok-skip-browser-warning": "true",
      },
      body: jsonEncode({"email": email, "password": password}),
    );

    // Check status
    if (response.statusCode == 200) {
      // Parse body
      final data = jsonDecode(response.body) as Map<String, dynamic>;
      // Store token
      await _saveToken(data["token"]);
      await _saveEmail(email);
      return data;
    } else if (response.statusCode == 401) {
      ///ترجمه خلصت
      throw Exception("invalidEmailOrPassword");
    } else {
      ///ترجمه خلصت
      throw Exception("serverError:${response.statusCode}");
    }
  }

  /// create account request
  static Future<Map<String, dynamic>> register(
      String email, String password, String confirmPassword) async {
    final url = Uri.parse("https://pouncing-arise-cussed.ngrok-free.dev/api/auth/register");

    final response = await http.post(
      url,
      headers: {
        "Content-Type": "application/json",
        "ngrok-skip-browser-warning": "true",
      },
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
      await _saveEmail(email);
      return data;
    }
    else {
      // Read error
      ///الترحمه خلصت
      // String message = "registerFailed";
      // try {
      //   final body = jsonDecode(response.body);
      //   if (body is Map && body["message"] != null) {
      //     message = body["message"].toString();
      //   }
      // } catch (_) {}
      // throw Exception(message);
      throw Exception("registerFailed");
    }
  }

  // Upload analysis
  // Needs token + multipart
  static Future<Map<String, dynamic>> analyzeImage(String imagePath) async {
    /// Read token
    final token = await getToken();
    final url = Uri.parse("https://pouncing-arise-cussed.ngrok-free.dev/api/reports");

    final request = http.MultipartRequest("POST", url);
    // Auth header
    request.headers["Authorization"] = "Bearer $token";
    request.headers["ngrok-skip-browser-warning"] = "true";
    // Field "image"
    request.files.add(await http.MultipartFile.fromPath("image", imagePath));

    final streamed = await request.send();
    final response = await http.Response.fromStream(streamed);

    if (response.statusCode == 201 || response.statusCode == 200) {
      return jsonDecode(response.body) as Map<String, dynamic>;
    } else if (response.statusCode == 401) {
      throw Exception("sessionExpired");
    } else {
      throw Exception("analysisFailed");
    }
  }

  // Fetch reports
  // Needs token
  static Future<List<dynamic>> getReports() async {
    final token = await getToken();
    final url = Uri.parse("https://pouncing-arise-cussed.ngrok-free.dev/api/reports");

    final response = await http.get(
      url,
      headers: {
        "Authorization": "Bearer $token",
        "ngrok-skip-browser-warning": "true",
      },
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

  // 🟢 الفانكشن المصلحة تماماً بدون أخطاء سنتكس وبطريقة مضمونة
  static Future<void> downloadPdfReport(String reportId) async {
    try {
      final token = await getToken();
      final url = Uri.parse("https://pouncing-arise-cussed.ngrok-free.dev/api/reports/$reportId/pdf");

      final response = await http.get(
        url,
        headers: {
          "Authorization": "Bearer $token",
          "ngrok-skip-browser-warning": "true",
        },
      );

      if (response.statusCode == 200) {
        // الحصول على مسار التخزين المؤقت وحفظ الملف
        final directory = await getTemporaryDirectory();
        final savePath = "${directory.path}/report_$reportId.pdf";

        final file = File(savePath);
        await file.writeAsBytes(response.bodyBytes);

        // فتح شاشة عرض وطباعة الـ PDF الرسمية للموبايل
        await Printing.layoutPdf(
          onLayout: (PdfPageFormat format) async => response.bodyBytes,
          name: "report_$reportId.pdf",
        );
      } else if (response.statusCode == 401) {
        throw Exception("sessionExpired");
      } else {
        throw Exception("downloadPdfFailed");
      }
    } catch (e) {
      throw Exception("fileProcessingError: $e");
    }
  }
  // 🟢 الفانكشن الجديدة مضافة هنا بالكامل في آخر الكلاس دون أي تعديل على القديم
  // static Future<void> downloadPdfReport(String reportId) async {
  //   final token = await getToken();
  //   final url = Uri.parse("https://pouncing-arise-cussed.ngrok-free.dev/api/reports/$reportId/pdf");
  //
  //   final response = await http.get(
  //     url,
  //     headers: {
  //       "Authorization": "Bearer $token",
  //       "ngrok-skip-browser-warning": "true",
  //     },
  //   );
  //
  //   if (response.statusCode == 200) {
  //     // الحصول على مسار التخزين الداخلي للموبايل وحفظ الملف باسم الـ ID بتاعه
  //     final directory = await getApplicationDocumentsDirectory();
  //     final savePath = "${directory.path}/report_$reportId.pdf";
  //
  //     final file = File(savePath);
  //     await file.writeAsBytes(response.bodyBytes);
  //
  //     // فتح الملف تلقائياً بعد اكتمال تحميله
  //     await OpenFilex.open(savePath);
  //   } else if (response.statusCode == 401) {
  //     throw Exception("انتهت الجلسة، سجّل دخول من جديد");
  //   } else {
  //     throw Exception("فشل تحميل ملف الـ PDF من السيرفر");
  //   }
  // }
  static Future<String> getOriginalImageUrl(String reportId) async {

    return "$baseUrl/api/reports/$reportId/original-image";
  }

  static Future<String> getHeatmapImageUrl(String reportId) async {

    return "$baseUrl/api/reports/$reportId/heatmap-image";
  }

  // Report by id
  static Future<Map<String, dynamic>> getReportById(String reportId) async {
    final token = await getToken();
    final url = Uri.parse("$baseUrl/api/reports/$reportId");

    final response = await http.get(
      url,
      headers: {
        "Authorization": "Bearer $token",
        "ngrok-skip-browser-warning": "true",
      },
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body) as Map<String, dynamic>;
    } else if (response.statusCode == 401) {
      throw Exception("sessionExpired");
    } else {
      throw Exception("loadReportFailed");
    }
  }
}
// import 'dart:convert';
// import 'package:http/http.dart' as http;
// import 'package:shared_preferences/shared_preferences.dart';
//
// /// Central API client
// class ApiService {
//   // Server URL (ngrok tunnel to the team backend).
//   /// NOTE: a free ngrok URL changes every restart — update this line when it changes.
//   static const String baseUrl =
//       "https://pouncing-arise-cussed.ngrok-free.dev";
//
//   // Save token
//   static Future<void> _saveToken(String token) async {
//     final prefs = await SharedPreferences.getInstance();
//     await prefs.setString("token", token);
//   }
//
//   // Read token
//   static Future<String?> getToken() async {
//     final prefs = await SharedPreferences.getInstance();
//     return prefs.getString("token");
//   }
//
//   // Clear token
//   static Future<void> logout() async {
//     final prefs = await SharedPreferences.getInstance();
//     await prefs.remove("token");
//   }
//
//   /// Login request
//   static Future<Map<String, dynamic>> login(
//       String email, String password) async {
//     // Build URL
//     final url = Uri.parse("https://pouncing-arise-cussed.ngrok-free.dev/api/auth/login");
//
//     // Send request
//     final response = await http.post(
//       url,
//       headers: {
//         "Content-Type": "application/json",
//         "ngrok-skip-browser-warning": "true",
//       },
//       body: jsonEncode({"email": email, "password": password}),
//     );
//
//     // Check status
//     if (response.statusCode == 200) {
//       // Parse body
//       final data = jsonDecode(response.body) as Map<String, dynamic>;
//       // Store token
//       await _saveToken(data["token"]);
//       return data;
//     } else if (response.statusCode == 401) {
//       throw Exception("الإيميل أو الباسورد غير صحيح");
//     } else {
//       throw Exception("خطأ من السيرفر (${response.statusCode})");
//     }
//   }
//
//   /// Register request
//   static Future<Map<String, dynamic>> register(
//       String email, String password, String confirmPassword) async {
//     final url = Uri.parse("https://pouncing-arise-cussed.ngrok-free.dev/api/auth/register");
//
//     final response = await http.post(
//       url,
//       headers: {
//         "Content-Type": "application/json",
//         "ngrok-skip-browser-warning": "true",
//       },
//       body: jsonEncode({
//         "email": email,
//         "password": password,
//         "confirmPassword": confirmPassword,
//       }),
//     );
//
//     // Created or OK
//     if (response.statusCode == 201 || response.statusCode == 200) {
//       final data = jsonDecode(response.body) as Map<String, dynamic>;
//       await _saveToken(data["token"]);
//       return data;
//     } else {
//       // Read error
//       String message = "فشل إنشاء الحساب";
//       try {
//         final body = jsonDecode(response.body);
//         if (body is Map && body["message"] != null) {
//           message = body["message"].toString();
//         }
//       } catch (_) {}
//       throw Exception(message);
//     }
//   }
//
//   // Upload analysis
//   // Needs token + multipart
//   static Future<Map<String, dynamic>> analyzeImage(String imagePath) async {
//     /// Read token
//     final token = await getToken();
//     final url = Uri.parse("https://pouncing-arise-cussed.ngrok-free.dev/api/reports");
//
//     final request = http.MultipartRequest("POST", url);
//     // Auth header
//     request.headers["Authorization"] = "Bearer $token";
//     request.headers["ngrok-skip-browser-warning"] = "true";
//     // Field "image"
//     request.files.add(await http.MultipartFile.fromPath("image", imagePath));
//
//     final streamed = await request.send();
//     final response = await http.Response.fromStream(streamed);
//
//     if (response.statusCode == 201 || response.statusCode == 200) {
//       return jsonDecode(response.body) as Map<String, dynamic>;
//     } else if (response.statusCode == 401) {
//       throw Exception("انتهت الجلسة، سجّل دخول من جديد");
//     } else {
//       throw Exception("فشل تحليل الصورة");
//     }
//   }
//
//   // Fetch reports
//   // Needs token
//   static Future<List<dynamic>> getReports() async {
//     final token = await getToken();
//     final url = Uri.parse("https://pouncing-arise-cussed.ngrok-free.dev/api/reports");
//
//     final response = await http.get(
//       url,
//       headers: {
//         "Authorization": "Bearer $token",
//         "ngrok-skip-browser-warning": "true",
//       },
//     );
//
//     if (response.statusCode == 200) {
//       final data = jsonDecode(response.body) as Map<String, dynamic>;
//       // Extract reports
//       return (data["reports"] as List<dynamic>?) ?? [];
//     } else if (response.statusCode == 401) {
//       throw Exception("انتهت الجلسة، سجّل دخول من جديد");
//     } else {
//       throw Exception("فشل تحميل السجل");
//     }
//   }
// }
