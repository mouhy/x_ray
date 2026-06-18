import 'package:al_power_diseases_diagnosis/login.dart';
import 'package:al_power_diseases_diagnosis/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'l10n/app_localizations.dart';
import 'services/api_service.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  // Lets any screen reach the app state (theme / language)
  static _MyAppState? of(BuildContext context) =>
      context.findAncestorStateOfType<_MyAppState>();

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  ThemeMode themeMode = ThemeMode.system;
  Locale locale = const Locale('en');

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  // Load saved theme + language on startup
  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    final lang = prefs.getString("lang") ?? "en";
    setState(() {
      // If the user picked a theme before -> use it. Otherwise follow the system.
      if (prefs.containsKey("isDark")) {
        themeMode =
            prefs.getBool("isDark")! ? ThemeMode.dark : ThemeMode.light;
      } else {
        themeMode = ThemeMode.system;
      }
      locale = Locale(lang);
    });
  }

  // Toggle + persist theme
  Future<void> toggleTheme(bool isDark) async {
    setState(() {
      themeMode = isDark ? ThemeMode.dark : ThemeMode.light;
    });
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool("isDark", isDark);
  }

  // Change + persist language
  Future<void> changeLanguage(String code) async {
    setState(() {
      locale = Locale(code);
    });
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString("lang", code);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      themeMode: themeMode,
      theme: appLightTheme,
      darkTheme: appDarkTheme,
      locale: locale,
      supportedLocales: const [
        Locale('en'),
        Locale('ar'),
      ],
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      // Decides the first screen based on whether a token is saved
      home: const AuthGate(),
    );
  }
}

// ===================== Brand colors =====================
const Color kBlue = Color(0xff2563EB);
const Color kDarkBg = Color(0xff0F172A);
const Color kDarkSurface = Color(0xff1E293B);
const Color kLightBg = Color(0xffF1F5F9);
const Color kLightSurface = Color(0xffFFFFFF);

// ===================== Themes =====================
final ThemeData appDarkTheme = ThemeData(
  brightness: Brightness.dark,
  scaffoldBackgroundColor: kDarkBg,
  primaryColor: kBlue,
  colorScheme: ColorScheme.fromSeed(
    seedColor: kBlue,
    brightness: Brightness.dark,
  ).copyWith(surface: kDarkSurface),
  appBarTheme: const AppBarTheme(
    backgroundColor: kDarkBg,
    foregroundColor: Colors.white,
    elevation: 0,
  ),
  iconTheme: const IconThemeData(color: Colors.white),
  inputDecorationTheme: const InputDecorationTheme(
    filled: true,
    fillColor: kDarkSurface,
  ),
);

final ThemeData appLightTheme = ThemeData(
  brightness: Brightness.light,
  scaffoldBackgroundColor: kLightBg,
  primaryColor: kBlue,
  colorScheme: ColorScheme.fromSeed(
    seedColor: kBlue,
    brightness: Brightness.light,
  ).copyWith(surface: kLightSurface),
  appBarTheme: const AppBarTheme(
    backgroundColor: kLightBg,
    foregroundColor: kDarkBg,
    elevation: 0,
  ),
  iconTheme: const IconThemeData(color: kDarkBg),
  inputDecorationTheme: const InputDecorationTheme(
    filled: true,
    fillColor: kLightSurface,
  ),
);

// ===================== Theme-aware color helpers =====================
// Use these in screens instead of hardcoded colors so they flip with the theme.
bool _isDark(BuildContext c) => Theme.of(c).brightness == Brightness.dark;
Color appBg(BuildContext c) => _isDark(c) ? kDarkBg : kLightBg;
Color appSurface(BuildContext c) => _isDark(c) ? kDarkSurface : kLightSurface;
Color appText(BuildContext c) => _isDark(c) ? Colors.white : kDarkBg;
Color appHint(BuildContext c) => _isDark(c) ? Colors.white70 : Colors.black54;

// ===================== Auth gate (auto-login) =====================
class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  Future<Map<String, String?>> _load() async {
    final token = await ApiService.getToken();
    final email = await ApiService.getSavedEmail();
    return {"token": token, "email": email};
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, String?>>(
      future: _load(),
      builder: (context, snap) {
        // Still checking
        if (snap.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
        final token = snap.data?["token"];
        // Already logged in → go straight to home
        if (token != null && token.isNotEmpty) {
          return HomeScreen(email: snap.data?["email"] ?? "");
        }
        // Not logged in → login screen
        return const LoginScreen();
      },
    );
  }
}
