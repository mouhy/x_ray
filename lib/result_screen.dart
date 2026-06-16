import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; //دي مضافه جديد /
//import 'package:screenshot/screenshot.dart';
//import 'package:gallery_saver_plus/gallery_saver.dart';
import 'dart:io';
import 'package:pdf/widgets.dart' as pw;
import 'package:permission_handler/permission_handler.dart';
import 'l10n/app_localizations.dart';
import 'package:path_provider/path_provider.dart';
import 'package:printing/printing.dart';
import 'l10n/app_localizations.dart';
import 'services/api_service.dart';

//import 'dart:typed_data';

class ResultScreen extends StatelessWidget {

  final String name;
  final String age;
  final String gender;
  final String maritalStatus;
  final String email;
  final String diagnosis;
  final double confidence;
  final String? reportId;





  const ResultScreen({
    super.key,
    required this.name,
    required this.age,
    required this.gender,
    required this.maritalStatus,
    required this.email,
    required this.diagnosis,
    required this.confidence,
    this.reportId,


  });

  Future<void> generatePDF(BuildContext context) async {

    final pdf = pw.Document();

    /// ✅ تحديد اللغة
    final isArabic = Localizations.localeOf(context).languageCode == 'ar';

    /// ✅ تحميل الخط العربي
    final fontData = await rootBundle.load("assets/fonts/NotoSansArabic-Regular.ttf");
    final arabicFont = pw.Font.ttf(fontData);

    /// ✅ اختيار الخط
    final font = isArabic ? arabicFont : pw.Font.helvetica();

    /// ✅ اتجاه الكتابة
    final textDirection = isArabic ? pw.TextDirection.rtl : pw.TextDirection.ltr;

    pdf.addPage(
      pw.Page(
        build: (pw.Context pwContext) {
          return pw.Directionality(
            textDirection: textDirection,
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [

                pw.Text(
                  isArabic ? "تقرير طبي بالذكاء الاصطناعي" : "AI Medical Report",
                  style: pw.TextStyle(
                    font: font,
                    fontSize: 24,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),

                pw.SizedBox(height: 20),

                pw.Text(
                  isArabic ? "بيانات المريض" : "Patient Information",
                  style: pw.TextStyle(
                    font: font,
                    fontSize: 18,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),

                pw.SizedBox(height: 10),

                pw.Text("${isArabic ? "الاسم" : "Name"}: $name", style: pw.TextStyle(font: font)),
                pw.Text("${isArabic ? "السن" : "Age"}: $age", style: pw.TextStyle(font: font)),
                pw.Text("${isArabic ? "النوع" : "Gender"}: $gender", style: pw.TextStyle(font: font)),
                pw.Text("${isArabic ? "الحالة الاجتماعية" : "Marital Status"}: $maritalStatus", style: pw.TextStyle(font: font)),
                pw.Text("${isArabic ? "البريد الإلكتروني" : "Email"}: $email", style: pw.TextStyle(font: font)),

                pw.SizedBox(height: 20),

                pw.Text(
                  isArabic ? "نتيجة التشخيص" : "Diagnosis Result",
                  style: pw.TextStyle(
                    font: font,
                    fontSize: 18,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),

                pw.SizedBox(height: 10),

                pw.Text(
                  "${isArabic ? "التشخيص" : "Diagnosis"}: $diagnosis",
                  style: pw.TextStyle(font: font),
                ),
                // pw.Text(
                //   isArabic ? "التشخيص: التهاب رئوي" : "Diagnosis: Pneumonia Detected",
                //   style: pw.TextStyle(font: font),
                // ),

                // pw.Text(
                //   isArabic ? "نسبة الثقة: 92%" : "Confidence: 92%",
                //   style: pw.TextStyle(font: font),
                // ),
                pw.Text(
                  "${isArabic ? "نسبة الثقة" : "Confidence"}: ${confidence.toStringAsFixed(2)}%",
                  style: pw.TextStyle(font: font),
                ),
              ],
            ),
          );
        },
      ),
    );

    var status = await Permission.storage.request();

    if (status.isGranted) {
      try {
        final time = DateTime.now().millisecondsSinceEpoch;
        final file = File("/storage/emulated/0/Download/result_report_$time.pdf");
        await file.writeAsBytes(await pdf.save());

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("PDF saved successfully!"),
            backgroundColor: Colors.green,
          ),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Error saving PDF: $e"),
            backgroundColor: Colors.red,
          ),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Storage permission denied"),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  // Future<void> generatePDF(BuildContext context) async {
  //
  //   final pdf = pw.Document();
  //
  //   pdf.addPage(
  //     pw.Page(
  //       build: (pw.Context pwContext) {
  //         return pw.Column(
  //           crossAxisAlignment: pw.CrossAxisAlignment.start,
  //           children: [
  //
  //             pw.Text(
  //               "AI Medical Report",
  //               style: pw.TextStyle(
  //                 fontSize: 24,
  //                 fontWeight: pw.FontWeight.bold,
  //               ),
  //             ),
  //
  //             pw.SizedBox(height: 20),
  //
  //             pw.Text(
  //               "Patient Information",
  //               style: pw.TextStyle(
  //                 fontSize: 18,
  //                 fontWeight: pw.FontWeight.bold,
  //               ),
  //             ),
  //
  //             pw.SizedBox(height: 10),
  //
  //             pw.Text("Name: $name"),
  //             pw.Text("Age: $age"),
  //             pw.Text("Gender: $gender"),
  //             pw.Text("Marital Status: $maritalStatus"),
  //             pw.Text("Email: $email"),
  //
  //             pw.SizedBox(height: 20),
  //
  //             pw.Text(
  //               "Diagnosis Result",
  //               style: pw.TextStyle(
  //                 fontSize: 18,
  //                 fontWeight: pw.FontWeight.bold,
  //               ),
  //             ),
  //
  //             pw.SizedBox(height: 10),
  //
  //             pw.Text("Diagnosis: Pneumonia Detected"),
  //             pw.Text("Confidence: 92%"),
  //           ],
  //         );
  //       },
  //     ),
  //   );
  //
  //   var status = await Permission.storage.request();
  //
  //   if (status.isGranted) {
  //     try {
  //       final file = File("/storage/emulated/0/Download/result_report.pdf");
  //       await file.writeAsBytes(await pdf.save());
  //
  //       ScaffoldMessenger.of(context).showSnackBar(
  //         const SnackBar(
  //           content: Text("PDF saved successfully!"),
  //           backgroundColor: Colors.green,
  //         ),
  //       );
  //     } catch (e) {
  //       ScaffoldMessenger.of(context).showSnackBar(
  //         SnackBar(
  //           content: Text("Error saving PDF: $e"),
  //           backgroundColor: Colors.red,
  //         ),
  //       );
  //     }
  //   } else {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       const SnackBar(
  //         content: Text("Storage permission denied"),
  //         backgroundColor: Colors.red,
  //       ),
  //     );
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff0F172A),

      appBar: AppBar(
        backgroundColor: const Color(0xff0F172A),
        elevation: 0,
        title:  Text(
          AppLocalizations.of(context)!.analysisResult,
          //"Analysis Result",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            const SizedBox(height: 20),

             Text(
               AppLocalizations.of(context)!.patientInfo,
              //"Patient Information",
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 10),

            Text("${AppLocalizations.of(context)!.name}: $name",
              //"Name: $name",
                style: const TextStyle(color: Colors.white70)),

            Text("${AppLocalizations.of(context)!.age}: $age",
              //"Age: $age",
                style: const TextStyle(color: Colors.white70)),

            Text("${AppLocalizations.of(context)!.gender}: $gender",
              //"Gender: $gender",
                style: const TextStyle(color: Colors.white70)),

            Text("${AppLocalizations.of(context)!.maritalStatus}: $maritalStatus",
              //"Marital Status: $maritalStatus",
                style: const TextStyle(color: Colors.white70)),

            Text("${AppLocalizations.of(context)!.email}: $email",
              //"Email: $email",
                style: const TextStyle(color: Colors.white70)),

            const SizedBox(height: 30),

             Text(
               AppLocalizations.of(context)!.diagnosis,
              //"Diagnosis:",
              style: TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 15),

             Text(
               diagnosis,
               //"${AppLocalizations.of(context)!.diagnosis}: $diagnosis",
              //AppLocalizations.of(context)!.pneumoniaDetected,
              //"Pneumonia Detected",
              style: TextStyle(
                color: Colors.redAccent,
                fontSize: 18,
              ),
            ),

            const SizedBox(height: 15),

             Text(
               "${AppLocalizations.of(context)!.confidence}: ${confidence.toStringAsFixed(2)}%",
               //"${AppLocalizations.of(context)!.confidence}: 92%",
              //"Confidence: 92%",
              style: TextStyle(
                color: Colors.white70,
                fontSize: 16,
              ),
            ),

            const SizedBox(height: 40),

            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xff2563EB),
              ),
              onPressed: () async {
                await generatePDF(context);
              },
              icon: const Icon(Icons.download),
              label:  Text(
                AppLocalizations.of(context)!.downloadPdf,
                //"Download PDF Report",
                style: TextStyle(color: Colors.white),
              ),
            ),

            // Server report (images + PDF) — only when we have a report id
            if (reportId != null) ...[
              const SizedBox(height: 30),
              const Text(
                "X-Ray Images",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              FutureBuilder<Map<String, String>>(
                future: ApiService.imageHeaders(),
                builder: (context, snap) {
                  if (!snap.hasData) {
                    return const SizedBox(
                      height: 120,
                      child: Center(
                        child: CircularProgressIndicator(color: Colors.white),
                      ),
                    );
                  }
                  final headers = snap.data!;
                  return Column(
                    children: [
                      _imageBlock(
                        "Original",
                        ApiService.reportImageUrl(reportId!, heatmap: false),
                        headers,
                      ),
                      const SizedBox(height: 16),
                      _imageBlock(
                        "AI Heatmap",
                        ApiService.reportImageUrl(reportId!, heatmap: true),
                        headers,
                      ),
                    ],
                  );
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xff10B981),
                ),
                onPressed: () => _downloadServerPdf(context),
                icon: const Icon(Icons.cloud_download),
                label: const Text(
                  "Download Server PDF",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  // Image block
  Widget _imageBlock(String label, String url, Map<String, String> headers) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(color: Colors.white70)),
        const SizedBox(height: 6),
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Image.network(
            url,
            headers: headers,
            height: 220,
            width: double.infinity,
            fit: BoxFit.contain,
            loadingBuilder: (context, child, progress) => progress == null
                ? child
                : const SizedBox(
                    height: 220,
                    child: Center(
                      child: CircularProgressIndicator(color: Colors.white),
                    ),
                  ),
            errorBuilder: (context, error, stack) => const SizedBox(
              height: 80,
              child: Center(
                child: Text(
                  "Image not available",
                  style: TextStyle(color: Colors.white38),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  // Download server PDF
  Future<void> _downloadServerPdf(BuildContext context) async {
    try {
      final bytes = await ApiService.downloadReportPdf(reportId!);
      await Printing.sharePdf(bytes: bytes, filename: 'report_$reportId.pdf');
    } catch (e) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString().replaceFirst('Exception: ', '')),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}
// class ResultScreen extends StatelessWidget {
//
//
//
//   const ResultScreen({
//     super.key
//   });
//
//   Future<void> generatePDF(BuildContext context) async {
//     final pdf = pw.Document();
//
//     // إنشاء الصفحة والبيانات
//     pdf.addPage(
//       pw.Page(
//         build: (pw.Context pwContext) {
//           return pw.Column(
//             crossAxisAlignment: pw.CrossAxisAlignment.start,
//             children: [
//               pw.Text(
//                 "AI Medical Report",
//                 style: pw.TextStyle(
//                   fontSize: 24,
//                   fontWeight: pw.FontWeight.bold,
//                 ),
//               ),
//               pw.SizedBox(height: 20),
//               pw.Text("Diagnosis: Pneumonia Detected"),
//               pw.SizedBox(height: 10),
//               pw.Text("Confidence: 92%"),
//             ],
//           );
//         },
//       ),
//     );
//
//     // طلب صلاحية التخزين
//     var status = await Permission.storage.request();
//
//     if (status.isGranted) {
//       try {
//         final file = File("/storage/emulated/0/Download/result_report.pdf");
//         await file.writeAsBytes(await pdf.save());
//
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(
//             content: Text("PDF saved successfully!"),
//             backgroundColor: Colors.green,
//           ),
//         );
//       } catch (e) {
//         // لو حصل أي error في الحفظ
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(
//             content: Text("Error saving PDF: $e"),
//             backgroundColor: Colors.red,
//           ),
//         );
//       }
//     } else {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(
//           content: Text("Storage permission denied"),
//           backgroundColor: Colors.red,
//         ),
//       );
//     }
//   }
//
//  // final ScreenshotController screenshotController = ScreenshotController();
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xff0F172A),
//       appBar: AppBar(
//         backgroundColor: const Color(0xff0F172A),
//         elevation: 0,
//         title: const Text(
//           "Analysis Result",
//           style: TextStyle(
//             color: Colors.white,
//             fontWeight: FontWeight.bold,
//           ),
//         ),
//         iconTheme: const IconThemeData(
//           color: Colors.white, // ده بيغير لون السهم
//         ),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(24),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children:  [
//
//             SizedBox(height: 30),
//
//             Text(
//               "Diagnosis:",
//               style: TextStyle(
//                 color: Colors.white,
//                 fontSize: 22,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//
//             SizedBox(height: 20),
//
//             Text(
//               "Pneumonia Detected",
//               style: TextStyle(
//                 color: Colors.redAccent,
//                 fontSize: 18,
//               ),
//             ),
//
//             SizedBox(
//                 height: 20
//             ),
//
//             Text(
//               "confidence: 92%",
//               style: TextStyle(
//                 color: Colors.white70,
//                 fontSize: 16,
//               ),
//             ),
//             const SizedBox(
//                 height: 40
//             ),
//
//             ElevatedButton.icon(
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: const Color(0xff2563EB),
//               ),
//               onPressed: () async {
//
//                 try {
//
//                   await generatePDF(context);
//
//                   // ScaffoldMessenger.of(context).showSnackBar(
//                   //   const SnackBar(
//                   //     content: Text("PDF downloaded successfully"),
//                   //   ),
//                   // );
//
//                 } catch (e) {
//
//                   ScaffoldMessenger.of(context).showSnackBar(
//                     SnackBar(
//                       content: Text("Error: $e"),
//                       backgroundColor: Colors.red,
//                     ),
//                   );
//                 }
//               },
//               icon: const Icon(Icons.download),
//               label:  Text(
//                 "Download PDF Report",
//                 style: TextStyle(
//                   color: Colors.white,
//                 ),
//               ),
//             )
//             // SizedBox(
//             //   width: double.infinity,
//             //   height: 50,
//             //   child: ElevatedButton.icon(
//             //     style: ElevatedButton.styleFrom(
//             //       backgroundColor: const Color(0xff2563EB),
//             //     ),
//             //     onPressed: () async {
//             //
//             //       final image = await screenshotController.capture();
//             //
//             //       if (image != null) {
//             //
//             //         final directory = await getTemporaryDirectory();
//             //
//             //         final filePath = '${directory.path}/result.png';
//             //
//             //         final file = File(filePath);
//             //
//             //         await file.writeAsBytes(image);
//             //
//             //         await GallerySaver.saveImage(filePath);
//             //
//             //         ScaffoldMessenger.of(context).showSnackBar(
//             //           const SnackBar(
//             //             content: Text("Result saved to gallery"),
//             //           ),
//             //         );
//             //       }
//             //     },
//             //     icon: const Icon(Icons.download),
//             //     label: const Text("Download Result"),
//             //   ),
//             // ),
//           ],
//         ),
//       ),
//     );
//   }
// }