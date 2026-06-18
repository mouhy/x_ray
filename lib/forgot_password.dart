import 'package:flutter/material.dart';
import 'l10n/app_localizations.dart';
import 'login.dart';


class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {

  final emailController = TextEditingController();
  final newPasswordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  final formKey = GlobalKey<FormState>();

  bool isHidden1 = true;
  bool isHidden2 = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff0F172A),

      appBar: AppBar(
        backgroundColor: const Color(0xff0F172A),
        title:  Text(
          AppLocalizations.of(context)!.resetPassword,
            //"Reset Password"
        ),
      ),

      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [

                /// Email
                TextFormField(
                  controller: emailController,
                  style: const TextStyle(color: Colors.white),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return AppLocalizations.of(context)!.emailEmpty;
                    }
                    if (!value.contains("@")) {
                      return AppLocalizations.of(context)!.enterValidEmail;
                      //"Enter valid email";
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    //"Email",
                    labelText: AppLocalizations.of(context)!.email,
                    labelStyle: const TextStyle(color: Colors.white70),
                    filled: true,
                    fillColor: const Color(0xff1E293B),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                /// New Password
                TextFormField(
                  controller: newPasswordController,
                  obscureText: isHidden1,
                  style: const TextStyle(color: Colors.white),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return AppLocalizations.of(context)!.passwordEmpty;
                    }
                    if (value.length < 6) {
                      return AppLocalizations.of(context)!.passwordMin;
                      //"Password must be at least 6 characters";
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    //"New Password",
                    labelText: AppLocalizations.of(context)!.newPassword,
                    labelStyle: const TextStyle(color: Colors.white70),
                    filled: true,
                    fillColor: const Color(0xff1E293B),
                    suffixIcon: IconButton(
                      icon: Icon(
                        isHidden1 ? Icons.visibility_off : Icons.visibility,
                        color: Colors.white70,
                      ),
                      onPressed: () {
                        setState(() {
                          isHidden1 = !isHidden1;
                        });
                      },
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                /// Confirm Password
                TextFormField(
                  controller: confirmPasswordController,
                  obscureText: isHidden2,
                  style: const TextStyle(color: Colors.white),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return AppLocalizations.of(context)!.confirmPasswordText;
                      //"Confirm your password";
                    }
                    if (value != newPasswordController.text) {
                      return AppLocalizations.of(context)!.passwordsNotMatch;
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    //"Confirm Password",
                    labelText: AppLocalizations.of(context)!.confirmPassword,
                    labelStyle: const TextStyle(color: Colors.white70),
                    filled: true,
                    fillColor: const Color(0xff1E293B),
                    suffixIcon: IconButton(
                      icon: Icon(
                        isHidden2 ? Icons.visibility_off : Icons.visibility,
                        color: Colors.white70,
                      ),
                      onPressed: () {
                        setState(() {
                          isHidden2 = !isHidden2;
                        });
                      },
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),

                const SizedBox(height: 30),

                /// زرار حفظ
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
                    // onPressed: () {
                    //   if (newPasswordController.text != confirmPasswordController.text) {
                    //     ScaffoldMessenger.of(context).showSnackBar(
                    //        SnackBar(
                    //         content: Text(
                    //           AppLocalizations.of(context)!.passwordsNotMatch,
                    //             //"Passwords do not match"
                    //         ),
                    //         backgroundColor: Colors.red,
                    //       ),
                    //     );
                    //     return;
                    //   }
                    //
                    //   ScaffoldMessenger.of(context).showSnackBar(
                    //      SnackBar(
                    //       content: Text(
                    //         AppLocalizations.of(context)!.passwordUpdated,
                    //           // "Password Updated Successfully"
                    //       ),
                    //       backgroundColor: Colors.green,
                    //     ),
                    //   );
                    onPressed: () {
                      if (!formKey.currentState!.validate()) {
                        return;
                      }

                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            AppLocalizations.of(context)!.passwordUpdated,
                          ),
                          backgroundColor: Colors.green,
                        ),
                      );

                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (context) => const LoginScreen()),
                            (route) => false,
                      );
                    },
                    child:  Text(
                      AppLocalizations.of(context)!.updatePassword,
                      //"Update Password",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}