import 'package:al_power_diseases_diagnosis/enter_email.dart';
import 'package:flutter/material.dart';
import 'main.dart';
import 'splash_screen.dart';
import 'create_account.dart';
import 'l10n/app_localizations.dart';
import 'forgot_password.dart';
import 'services/api_service.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  bool isPasswordHidden = true;
  bool isLoading = false;
  String currentLang = 'en';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff0F172A), // خلفية داكنة
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Center(
            child: SingleChildScrollView(
              child: Form(
                key: formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                        height: 40
                    ),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.language, color: Colors.white),
                          onPressed: () {
                            final appState = MyApp.of(context);

                            if (currentLang == 'en') {
                              appState!.changeLanguage('ar');
                              currentLang = 'ar';
                            } else {
                              appState!.changeLanguage('en');
                              currentLang = 'en';
                            }

                            setState(() {});
                          },
                        ),
                      ],
                    ),

                     Text(
                      //'Welcome Back',
                       AppLocalizations.of(context)!.welcomeBack,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(
                        height: 8
                    ),

                     Text(
                      //'Enter your credentials to access the workspace.',
                      AppLocalizations.of(context)!.loginDescription,
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 14,
                      ),
                    ),

                    const SizedBox(
                        height: 40
                    ),

                    /// Email Field
                    TextFormField(
                      controller: emailController,
                      keyboardType: TextInputType.emailAddress,
                      style: const TextStyle(
                          color: Colors.white
                      ),
                      validator: (value)
                      {
                        if (value == null || value.isEmpty)
                             {
                               return AppLocalizations.of(context)!.emailEmpty;
                               //'email must not be empty';
                             }
                             return null;
                      },
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: const Color(0xff1E293B),
                        labelText: AppLocalizations.of(context)!.email,
                        //'Email Address',
                        labelStyle: const TextStyle(color: Colors.white70),
                        prefixIcon:
                        const Icon(Icons.email, color: Colors.white70),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),

                    const SizedBox(
                        height: 20
                    ),

                    /// Password Field
                    TextFormField(
                      controller: passwordController,
                      keyboardType: TextInputType.visiblePassword,
                      obscureText: isPasswordHidden,
                      style: const TextStyle(
                          color: Colors.white
                      ),
                      validator: (value)
                        {
                          if (value == null || value.isEmpty)
                          {
                            return AppLocalizations.of(context)!.passwordEmpty;
                              //'password must not be empty';
                          }
                          return null;
                        },
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: const Color(0xff1E293B),
                        labelText: AppLocalizations.of(context)!.password,
                        //'Password',
                        labelStyle: const TextStyle(color: Colors.white70),
                        prefixIcon: const Icon(
                            Icons.lock, color: Colors.white70
                        ),
                        suffixIcon: IconButton(
                          icon: Icon(
                            isPasswordHidden ? Icons.visibility_off : Icons.visibility,
                            color: Colors.white70,
                          ),
                          onPressed: () {
                            setState(() {
                              isPasswordHidden = !isPasswordHidden;
                            });
                          },
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),

                    /// Forgot Password
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const ForgotPasswordEmailScreen(),
                            ),
                          );
                        },
                        child: Text(
                          AppLocalizations.of(context)!.forgotPassword,
                          //"Forgot Password?",
                          style: TextStyle(
                            color: Color(0xff3B82F6),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(
                        height: 30
                    ),

                    /// Login Button
                    Container(
                      width: double.infinity,
                      height: 55,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(14),
                        gradient: const LinearGradient(
                          colors: [
                            Color(0xff2563EB),
                            Color(0xff1D4ED8),
                          ],
                        ),
                      ),
                      child: MaterialButton(
                        onPressed: isLoading
                            ? null
                            : () async {
                                // Validate fields
                                if (!formKey.currentState!.validate()) return;

                                setState(() => isLoading = true);
                                try {
                                  // Call API
                                  await ApiService.login(
                                    emailController.text.trim(),
                                    passwordController.text,
                                  );

                                  if (!mounted) return;
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => SplashScreen(
                                        email: emailController.text.trim(),
                                      ),
                                    ),
                                  );
                                } catch (e) {
                                  // Handle error
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
                                  if (mounted) setState(() => isLoading = false);
                                }
                              },
                        child: isLoading
                            ? const SizedBox(
                                height: 24,
                                width: 24,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2,
                                ),
                              )
                            : Text(
                                //'Log In',
                                AppLocalizations.of(context)!.login,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                      ),
                    ),

                    const SizedBox(
                        height: 20
                    ),

                    /// Register Row
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                         Text(
                           AppLocalizations.of(context)!.noAccount,
                          //"Don't have an account?",
                          style: TextStyle(color: Colors.white70),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const CreateAccount(),
                              ),
                            );
                          },
                          child:  Text(
                            AppLocalizations.of(context)!.createAccount,
                            //'Create account',
                            style: TextStyle(
                              color: Color(0xff3B82F6),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}