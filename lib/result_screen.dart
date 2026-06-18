import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; //دي مضافه جديد /
//import 'package:screenshot/screenshot.dart';
//import 'package:gallery_saver_plus/gallery_saver.dart';
import 'dart:io';
import 'main.dart';
import 'services/api_service.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:permission_handler/permission_handler.dart';
import 'l10n/app_localizations.dart';
import 'package:path_provider/path_provider.dart';
import 'l10n/app_localizations.dart';

//import 'dart:typed_data';

class ResultScreen extends StatefulWidget {

  // final String name;
  // final String age;
  // final String gender;
  // final String maritalStatus;
  // final String email;
  final String diagnosis;
  final double confidence;

  final String originalImageUrl;
  final String heatmapImageUrl;

  final String reportId;





  const ResultScreen({
    super.key,
    // required this.name,
    // required this.age,
    // required this.gender,
    // required this.maritalStatus,
    // required this.email,
    required this.diagnosis,
    required this.confidence,

    required this.originalImageUrl,
    required this.heatmapImageUrl,

    required this.reportId,


  });

  @override
  State<ResultScreen> createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen> {

  int selectedTab = 0;
  String? _token;

  @override
  void initState() {
    super.initState();
    // Load token so the protected image endpoints can be fetched
    ApiService.getToken().then((t) {
      if (mounted) setState(() => _token = t);
    });
  }

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

                // pw.Text("${isArabic ? "الاسم" : "Name"}: ${widget.name}", style: pw.TextStyle(font: font)),
                // pw.Text("${isArabic ? "السن" : "Age"}: ${widget.age}", style: pw.TextStyle(font: font)),
                // pw.Text("${isArabic ? "النوع" : "Gender"}: ${widget.gender}", style: pw.TextStyle(font: font)),
                // pw.Text("${isArabic ? "الحالة الاجتماعية" : "Marital Status"}: ${widget.maritalStatus}", style: pw.TextStyle(font: font)),
                // pw.Text("${isArabic ? "البريد الإلكتروني" : "Email"}: ${widget.email}", style: pw.TextStyle(font: font)),

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
                  "${isArabic ? "التشخيص" : "Diagnosis"}: ${widget.diagnosis}",
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
                  "${isArabic ? "نسبة الثقة" : "Confidence"}: ${widget.confidence.toStringAsFixed(2)}%",
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
  ///Widget للتوجل
  Widget buildTab(
      String title,
      int index,
      Color activeColor,
      ) {
    final isSelected = selectedTab == index;

    return GestureDetector(
      onTap: () {
        setState(() {
          selectedTab = index;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        padding: const EdgeInsets.symmetric(
          horizontal: 15,
          vertical: 8,
        ),
        decoration: BoxDecoration(
          color: isSelected
              ? activeColor
              : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          title,
          style: TextStyle(
            color: isSelected ? Colors.white : appText(context),
          ),
        ),
      ),
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appBg(context),

      appBar: AppBar(
        elevation: 0,
        title:  Text(
          AppLocalizations.of(context)!.analysisResult,
          //"Analysis Result",
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            const SizedBox(height: 20),
            /// الحاجات الخاصه بالبروفيل

            //  Text(
            //    AppLocalizations.of(context)!.patientInfo,
            //   //"Patient Information",
            //   style: TextStyle(
            //     color: Colors.white,
            //     fontSize: 20,
            //     fontWeight: FontWeight.bold,
            //   ),
            // ),
            ///التوجل نفسه
            Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: appSurface(context),
                borderRadius: BorderRadius.circular(25),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [

                  buildTab(
                    ///Original
                    AppLocalizations.of(context)!.original,
                    0,
                     const Color(0xff2563EB),
                  ),

                  buildTab(
                    ///Heatmap
                    AppLocalizations.of(context)!.heatmap,
                    1,
                      const Color(0xff2563EB),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            ///الصوره
            _token == null
                ? const SizedBox(
                    height: 300,
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  )
                : AnimatedSwitcher(
                    duration: const Duration(milliseconds: 300),
                    child: ClipRRect(
                      key: ValueKey(selectedTab),
                      borderRadius: BorderRadius.circular(12),
                      child: Image.network(
                        selectedTab == 0
                            ? "${ApiService.baseUrl}/api/reports/${widget.reportId}/original-image"
                            : "${ApiService.baseUrl}/api/reports/${widget.reportId}/heatmap-image",
                        headers: {
                          "Authorization": "Bearer $_token",
                          "ngrok-skip-browser-warning": "true",
                        },
                        height: 300,
                        width: double.infinity,
                        fit: BoxFit.cover,
                        loadingBuilder: (context, child, progress) =>
                            progress == null
                                ? child
                                : const SizedBox(
                                    height: 300,
                                    child: Center(
                                      child: CircularProgressIndicator(),
                                    ),
                                  ),
                        errorBuilder: (context, error, stack) => const SizedBox(
                          height: 300,
                          child: Center(
                            child: Text(
                              "Image not available",
                              style: TextStyle(color: Colors.white38),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),


//             Text("${AppLocalizations.of(context)!.name}: $name",
//               //"Name: $name",
//                 style: const TextStyle(color: Colors.white70)),
//
//             Text("${AppLocalizations.of(context)!.age}: $age",
//               //"Age: $age",
//                 style: const TextStyle(color: Colors.white70)),
//
//             Text("${AppLocalizations.of(context)!.gender}: $gender",
//               //"Gender: $gender",
//                 style: const TextStyle(color: Colors.white70)),
//
//             Text("${AppLocalizations.of(context)!.maritalStatus}: $maritalStatus",
//               //"Marital Status: $maritalStatus",
//                 style: const TextStyle(color: Colors.white70)),
//
//             Text("${AppLocalizations.of(context)!.email}: $email",
//               //"Email: $email",
//                 style: const TextStyle(color: Colors.white70)),

            const SizedBox(height: 30),

             Text(
               AppLocalizations.of(context)!.diagnosis,
              //"Diagnosis:",
              style: TextStyle(
                color: appText(context),
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 15),

            Text(
              widget.diagnosis == "No disease detected"
                  ? "Healthy"
                  : widget.diagnosis,
              style: TextStyle(
                color: widget.diagnosis == "No disease detected"
                    ? Colors.green
                    : Colors.redAccent,
                fontSize: 18,
              ),
            ),

            //  Text(
            //    widget.diagnosis,
            //    //"${AppLocalizations.of(context)!.diagnosis}: $diagnosis",
            //   //AppLocalizations.of(context)!.pneumoniaDetected,
            //   //"Pneumonia Detected",
            //   style: TextStyle(
            //     color: Colors.redAccent,
            //     fontSize: 18,
            //   ),
            // ),

            const SizedBox(height: 15),

             Text(
               "${AppLocalizations.of(context)!.confidence}: ${widget.confidence.toStringAsFixed(2)}%",
               //"${AppLocalizations.of(context)!.confidence}: 92%",
              //"Confidence: 92%",
              style: TextStyle(
                color: appHint(context),
                fontSize: 16,
              ),
            ),

            const SizedBox(height: 40),

            // 🟢 التعديل تم هنا فقط داخل الـ onPressed لاستدعاء الـ API الجديد
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xff2563EB),
              ),
              onPressed: () async {
                // إظهار رسالة تفيد ببدء التحميل من السيرفر
                ScaffoldMessenger.of(context).showSnackBar(
                   SnackBar(
                    content: Text(AppLocalizations.of(context)!.downloadingReport),
                    duration: Duration(seconds: 2),
                  ),
                );

                try {
                  // Use the real report id of this report
                  await ApiService.downloadPdfReport(widget.reportId);
                }
                catch (e) {

                  String errorKey =
                  e.toString().replaceFirst('Exception: ', '');

                  String errorMessage;

                  if (errorKey.startsWith('fileProcessingError')) {
                    errorMessage =
                        AppLocalizations.of(context)!.fileProcessingError;
                  } else {
                    switch (errorKey) {

                      case 'sessionExpired':
                        errorMessage =
                            AppLocalizations.of(context)!.sessionExpired;
                        break;

                      case 'downloadPdfFailed':
                        errorMessage =
                            AppLocalizations.of(context)!.downloadPdfFailed;
                        break;

                      default:
                        errorMessage = errorKey;
                    }
                  }

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(errorMessage),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
                // catch (e) {
                //   // عرض الخطأ في حالة فشل التحميل من السيرفر
                //   ScaffoldMessenger.of(context).showSnackBar(
                //     SnackBar(
                //       content: Text("خطأ أثناء التحميل: $e"),
                //       backgroundColor: Colors.red,
                //     ),
                //   );
                // }
              },
              icon: const Icon(Icons.download),
              label:  Text(
                AppLocalizations.of(context)!.downloadPdf,
                style: TextStyle(color: Colors.white),
              ),
            ),

            // ElevatedButton.icon(
            //   style: ElevatedButton.styleFrom(
            //     backgroundColor: const Color(0xff2563EB),
            //   ),
            //   onPressed: () async {
            //     await generatePDF(context);
            //   },
            //   icon: const Icon(Icons.download),
            //   label:  Text(
            //     AppLocalizations.of(context)!.downloadPdf,
            //     //"Download PDF Report",
            //     style: TextStyle(color: Colors.white),
            //   ),
            // ),
          ],
        ),
      ),
    );
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