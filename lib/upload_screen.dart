import 'package:flutter/material.dart';
import 'result_screen.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'history_manager.dart';
import 'profile_screen.dart';
import 'l10n/app_localizations.dart';
import 'services/api_service.dart';


class UploadScreen extends StatefulWidget {
  const UploadScreen({super.key, required this.email});
  final String email;
  //const UploadScreen({super.key, required email});

  @override
  State<UploadScreen> createState() => _UploadScreenState();
}

class _UploadScreenState extends State<UploadScreen> {

  String name = "";
  String age = "";
  String gender = "";
  String maritalStatus = "";
  String email = "";

  bool isAnalyzing = false;

  File? selectedImage;
  final ImagePicker picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  // Load profile
  Future<void> _loadProfile() async {
    final prefs = await SharedPreferences.getInstance();
    if (!mounted) return;
    final e = widget.email;
    setState(() {
      name = prefs.getString("profile_name_$e") ?? "";
      age = prefs.getInt("profile_age_$e")?.toString() ?? "";
      gender = prefs.getString("profile_gender_$e") ?? "";
      maritalStatus = prefs.getString("profile_marital_$e") ?? "";
    });
  }

  Future<void> pickImage(ImageSource source) async {
    final XFile? image = await picker.pickImage(source: source);

    if (image != null) {
      setState(() {
        selectedImage = File(image.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff0F172A),
      appBar: AppBar(
        backgroundColor: const Color(0xff0F172A),
        elevation: 0,
        title: Text(
          AppLocalizations.of(context)!.uploadXray,
            //"Upload X-Ray",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        iconTheme: const IconThemeData(
          color: Colors.white, // ياحمار ده بيغير لون السهم
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [

            const SizedBox(height: 40),

            // Container(
            //   height: 200,
            //   width: double.infinity,
            //   decoration: BoxDecoration(
            //     border: Border.all(color: Colors.white24),
            //     borderRadius: BorderRadius.circular(12),
            //   ),
            //   child: const Center(
            //     child: Text(
            //       "Drag & Drop X-Ray Image",
            //       style: TextStyle(color: Colors.white70),
            //     ),
            //   ),
            // ),
            GestureDetector(
              onTap: () {
                showModalBottomSheet(
                  context: context,
                  builder: (context) {
                    return SafeArea(
                      child: Wrap(
                        children: [
                          ListTile(
                            leading: const Icon(Icons.photo_library),
                            title:  Text(
                              AppLocalizations.of(context)!.gallery,
                                //"Choose from Gallery"
                            ),
                            onTap: () {
                              Navigator.pop(context);
                              pickImage(ImageSource.gallery);
                            },
                          ),
                          ListTile(
                            leading: const Icon(Icons.camera_alt),
                            title:  Text(
                              AppLocalizations.of(context)!.camera,
                                //"Use Camera"
                            ),
                            onTap: () {
                              Navigator.pop(context);
                              pickImage(ImageSource.camera);
                            },
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
              child: Container(
                height: 200,
                width: double.infinity,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.white24),
                  borderRadius: BorderRadius.circular(12),
                  color: const Color(0xff1E293B),
                ),
                child: selectedImage == null
                    ?  Center(
                  child: Text(
                    AppLocalizations.of(context)!.tapToUpload,
                    //"Tap to upload X-Ray Image",
                    style: TextStyle(color: Colors.white70),
                  ),
                )
                    : ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.file(
                    selectedImage!,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),

            const SizedBox(
                height: 40
            ),

            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xff2563EB),
                ),
                onPressed: () async {

                  print("open profilr form upload");

                  final data = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ProfileScreen(email: widget.email),
                    ),
                  );

                  print("RECEIVED DATA: $data"); // 👈 مهم

                  if (data != null) {
                    print(data);
                    setState(() {
                      name = data["name"];
                      age = data["age"];
                      gender = data["gender"];
                      maritalStatus = data["maritalStatus"];
                      //email = data["email"];
                    });
                  }
                },
                child:  Text(
                  AppLocalizations.of(context)!.editProfile,
                    //"Edit Profile"
                ),
              ),
            ),

            if (name.isNotEmpty)
              Text(
                "Name: $name",
                style: const TextStyle(color: Colors.white),
              ),

            const SizedBox(
              height: 20,
            ),

            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xff2563EB),
                ),

                //هنا الزار
                onPressed: isAnalyzing
                    ? null
                    : () async {
                  /// لو مفيش صورة
                  if (selectedImage == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          AppLocalizations.of(context)!.uploadImageFirst,
                          //"Please upload image first"
                        ),
                        backgroundColor: Colors.red,
                      ),
                    );
                    return;
                  }

                  if (name.isEmpty || age.isEmpty || gender.isEmpty || maritalStatus.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                       SnackBar(
                        content: Text(
                          AppLocalizations.of(context)!.enterProfileFirst,
                            //"Please enter profile data first"
                        ),
                        backgroundColor: Colors.red,
                      ),
                    );
                    return;
                  }

                  setState(() => isAnalyzing = true);
                  try {
                    // Call API
                    final result =
                        await ApiService.analyzeImage(selectedImage!.path);

                    // Read result
                    final String diagnosis =
                        result["primaryDisease"]?.toString() ??
                            "No disease detected";

                    // To percent (handle 0-1 or 0-100 scale)
                    final double rawConf =
                        (result["overallConfidence"] as num?)?.toDouble() ?? 0;
                    final double confidence =
                        rawConf <= 1 ? rawConf * 100 : rawConf;

                    HistoryManager.history
                        .add("Analyzed Image - ${DateTime.now()}");

                    if (!mounted) return;
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ResultScreen(
                          name: name,
                          age: age,
                          gender: gender,
                          maritalStatus: maritalStatus,
                          email: widget.email,
                          diagnosis: diagnosis,
                          confidence: confidence,
                        ),
                      ),
                    );
                  } catch (e) {
                    if (!mounted) return;
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          e.toString().replaceFirst('Exception: ', ''),
                        ),
                        backgroundColor: Colors.red,
                      ),
                    );
                  } finally {
                    if (mounted) setState(() => isAnalyzing = false);
                  }
                },

                child: isAnalyzing
                    ? const SizedBox(
                        height: 22,
                        width: 22,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      )
                    : Text(
                        AppLocalizations.of(context)!.analyzeNow,
                        //"Analyze Now",
                        style: const TextStyle(
                          color: Colors.white,
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