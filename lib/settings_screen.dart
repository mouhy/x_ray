import 'package:flutter/material.dart';
import 'package:al_power_diseases_diagnosis/main.dart';
import 'l10n/app_localizations.dart';


class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final appState = MyApp.of(context);

    return Scaffold(
      appBar: AppBar(title:  Text(
        AppLocalizations.of(context)!.settings,
         // "Settings"
      )
      ),
      body: Column(
        children: [
          SwitchListTile(
            title:  Text(
              AppLocalizations.of(context)!.darkMode,
                //"Dark Mode"
            ),
            value: appState!.themeMode == ThemeMode.dark,
            onChanged: (value) {
              appState.toggleTheme(value);
            },
          ),
          ListTile(
            title: const Text("English"),
            onTap: () {
              appState.changeLanguage('en');
            },
          ),
          ListTile(
            title: const Text("العربية"),
            onTap: () {
              appState.changeLanguage('ar');
            },
          ),
        ],
      ),
    );
  }
}
// class SettingsScreen extends StatelessWidget {
//   const SettingsScreen({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//
//     return Scaffold(
//       backgroundColor: const Color(0xff0F172A),
//       appBar: AppBar(
//         backgroundColor: const Color(0xff0F172A),
//         title: const Text("Settings"),
//       ),
//       body: const Center(
//         child: Text(
//           "App Settings",
//           style: TextStyle(color: Colors.white, fontSize: 20),
//         ),
//       ),
//     );
//   }
// }