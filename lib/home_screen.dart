import 'package:flutter/material.dart';
import 'main.dart';
import 'upload_screen.dart';
//import 'profile_screen.dart';
import 'history_screen.dart';
import 'settings_screen.dart';
import 'login.dart';
import 'l10n/app_localizations.dart';
import 'services/api_service.dart';


class HomeScreen extends StatelessWidget {
  final String email;
  const HomeScreen({super.key, required this.email});

  @override
  Widget build(BuildContext context) {

    Widget _buildStepBox(String text) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: appSurface(context),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          text,
          style: TextStyle(
            color: appText(context),
            fontSize: 16,
          ),
        ),
      );
    }
    return Scaffold(
      backgroundColor: appBg(context),
      appBar: AppBar(
        elevation: 0,
        title: const Text(
          "MediScan AI",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      drawer: Drawer(
        backgroundColor: appSurface(context),
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
             DrawerHeader(
              decoration: BoxDecoration(
                color: Color(0xff2563EB),
              ),
              child: Text(
                //Menu
                AppLocalizations.of(context)!.menu,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
                     ///الخاص بالبروفيل
            // ListTile(
            //   leading: const Icon(Icons.person, color: Colors.white),
            //   title:  Text(
            //       //"Profile",
            //       AppLocalizations.of(context)!.profile,
            //       style: TextStyle(color: Colors.white)),
            //   onTap: () {
            //     Navigator.pop(context);
            //     Navigator.push(
            //       context,
            //       MaterialPageRoute(
            //         builder: (context) => ProfileScreen(email: email),
            //       ),
            //     );
            //   },
            // ),

            ListTile(
              leading: Icon(Icons.history, color: appText(context)),
              title:  Text(
                  //"History",
                AppLocalizations.of(context)!.history,
                  style: TextStyle(color: appText(context))),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const HistoryScreen()),
                );
              },
            ),

            ListTile(
              leading: Icon(Icons.settings, color: appText(context)),
              title:  Text(
                  //"Settings",
                AppLocalizations.of(context)!.settings,
                  style: TextStyle(color: appText(context))),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const SettingsScreen()),
                );
              },
            ),

            ListTile(
              leading: const Icon(Icons.logout, color: Colors.red),
              title:  Text(
                  //"Log out",
                AppLocalizations.of(context)!.logout,
                  style: TextStyle(color: appText(context))),
              onTap: () async {
                await ApiService.logout(); // Clear token
                if (!context.mounted) return;
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const LoginScreen()),
                      (route) => false,
                );
              },
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
          
              const SizedBox(height: 40),
          
               Text(
                //"AI-Powered\nChest Diagnosis",
                AppLocalizations.of(context)!.appTitle,
                style: TextStyle(
                  color: appText(context),
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
          
              const SizedBox(height: 20),
          
               Text(
                //"Upload chest X-ray images and receive instant AI analysis.",
                 AppLocalizations.of(context)!.appDescription,
                style: TextStyle(color: appHint(context)),
              ),
          
              const SizedBox(height: 40),
          
              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xff2563EB),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>  UploadScreen(email: email),
                      ),
                    );
                  },
                  child:  Text(
                      //"Start Analysis",
                    AppLocalizations.of(context)!.startAnalysis,
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
          
              ),

              const SizedBox(
                  height: 40
              ),

               Text(
                //"How It Works",
                AppLocalizations.of(context)!.howItWorks,
                style: TextStyle(
                  color: appText(context),
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(
                  height: 20
              ),

              _buildStepBox(
                  //"1️⃣ Upload X-ray Image"
                AppLocalizations.of(context)!.step1
              ),
              const SizedBox(
                  height: 15
              ),

              _buildStepBox(
                  //"2️⃣ AI Analyzes the Image"
                AppLocalizations.of(context)!.step2
              ),
              const SizedBox(
                  height: 15
              ),

              _buildStepBox(
                  //"3️⃣ Get Instant Diagnosis"
                AppLocalizations.of(context)!.step3
              ),
            ],
          ),
        ),
      ),
    );
  }
}