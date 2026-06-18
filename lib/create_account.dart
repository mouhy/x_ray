import 'package:flutter/material.dart';
import 'main.dart';
import 'l10n/app_localizations.dart';
import 'services/api_service.dart';

class CreateAccount extends StatefulWidget {
  const CreateAccount({super.key});

  @override
  State<CreateAccount> createState() => _CreateAccountState();
}

class _CreateAccountState extends State<CreateAccount> {

  final formKey = GlobalKey<FormState>();

  //final firstNameController = TextEditingController();
  //final lastNameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  bool isPasswordHidden = true;
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appBg(context),
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

                    const SizedBox(height: 40),

                     Text(
                      //'Create Account',
                      AppLocalizations.of(context)!.createAccount,
                      style: TextStyle(
                        color: appText(context),
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 40),

                    /// First + Last Name
                    // Row(
                    //   children: [
                    //
                    //     Expanded(
                    //       child: TextFormField(
                    //         controller: firstNameController,
                    //         style: const TextStyle(color: Colors.white),
                    //         validator: (value) {
                    //           if (value == null || value.isEmpty) {
                    //             return AppLocalizations.of(context)!.required;
                    //               //'Required'
                    //           }
                    //           return null;
                    //         },
                    //         decoration: InputDecoration(
                    //           filled: true,
                    //           fillColor: const Color(0xff1E293B),
                    //           labelText: AppLocalizations.of(context)!.firstName,
                    //           //'First Name',
                    //           labelStyle:
                    //           const TextStyle(color: Colors.white70),
                    //           border: OutlineInputBorder(
                    //             borderRadius: BorderRadius.circular(12),
                    //             borderSide: BorderSide.none,
                    //           ),
                    //         ),
                    //       ),
                    //     ),
                    //
                    //     const SizedBox(width: 15),
                    //
                    //     Expanded(
                    //       child: TextFormField(
                    //         controller: lastNameController,
                    //         style: const TextStyle(color: Colors.white),
                    //         validator: (value) {
                    //           if (value == null || value.isEmpty) {
                    //             return AppLocalizations.of(context)!.required;
                    //               //'Required';
                    //           }
                    //           return null;
                    //         },
                    //         decoration: InputDecoration(
                    //           filled: true,
                    //           fillColor: const Color(0xff1E293B),
                    //           labelText: AppLocalizations.of(context)!.lastName,
                    //           //'Last Name',
                    //           labelStyle:
                    //           const TextStyle(color: Colors.white70),
                    //           border: OutlineInputBorder(
                    //             borderRadius: BorderRadius.circular(12),
                    //             borderSide: BorderSide.none,
                    //           ),
                    //         ),
                    //       ),
                    //     ),
                    //   ],
                    // ),

                    const SizedBox(height: 20),

                    /// Email
                    TextFormField(
                      controller: emailController,
                      keyboardType: TextInputType.emailAddress,
                      style: TextStyle(color: appText(context)),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return  AppLocalizations.of(context)!.emailEmpty;
                          //'Email must not be empty';
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: appSurface(context),
                        labelText: AppLocalizations.of(context)!.email,
                        //'Email Address',
                        labelStyle:
                        TextStyle(color: appHint(context)),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),

                    /// Password
                    TextFormField(
                      controller: passwordController,
                      obscureText: isPasswordHidden,
                      style: TextStyle(color: appText(context)),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return AppLocalizations.of(context)!.passwordEmpty;
                          //'Password required';
                        }
                        if (value.length < 6) {
                          return AppLocalizations.of(context)!.min6;
                          //'Min 6 characters';
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: appSurface(context),
                        labelText: AppLocalizations.of(context)!.password,
                        //'Password',
                        labelStyle:
                        TextStyle(color: appHint(context)),
                        suffixIcon: IconButton(
                          icon: Icon(
                            isPasswordHidden
                                ? Icons.visibility_off
                                : Icons.visibility,
                            color: appHint(context),
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

                    const SizedBox(height: 20),

                    /// Confirm Password
                    TextFormField(
                      controller: confirmPasswordController,
                      obscureText: isPasswordHidden,
                      style: TextStyle(color: appText(context)),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return AppLocalizations.of(context)!.confirmPasswordRequired;
                          //'Confirm your password';
                        }
                        if (value != passwordController.text) {
                          return AppLocalizations.of(context)!.passwordsNotMatch;
                          //'Passwords do not match';
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: appSurface(context),
                        labelText: AppLocalizations.of(context)!.confirmPassword,
                        //'Confirm Password',
                        labelStyle:
                        TextStyle(color: appHint(context)),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),

                    const SizedBox(height: 30),

                    /// Register Button
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
                                if (!formKey.currentState!.validate()) return;

                                setState(() => isLoading = true);
                                try {
                                  await ApiService.register(
                                    emailController.text.trim(),
                                    passwordController.text,
                                    confirmPasswordController.text,
                                  );

                                  if (!mounted) return;
                                  ScaffoldMessenger.of(context).showSnackBar(
                                     SnackBar(
                                      content: Text(
                                        AppLocalizations.of(context)!.registerSuccess,
                                      ),
                                      backgroundColor: Colors.green,
                                    ),
                                  );
                                  Navigator.pop(context); // Back to login
                                }
                                // catch (e) {
                                //   if (!mounted) return;
                                //   ScaffoldMessenger.of(context).showSnackBar(
                                //     SnackBar(
                                //       content: Text(
                                //         e.toString().replaceFirst('Exception: ', ''),
                                //       ),
                                //       backgroundColor: Colors.red,
                                //     ),
                                //   );
                                // }
                                catch (e) {
                                  if (!mounted) return;

                                  String errorKey =
                                  e.toString().replaceFirst('Exception: ', '');

                                  String errorMessage;

                                  switch (errorKey) {
                                    case 'registerFailed':
                                      errorMessage =
                                          AppLocalizations.of(context)!.registerFailed;
                                      break;

                                    default:
                                      errorMessage = errorKey;
                                  }

                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(errorMessage),
                                      backgroundColor: Colors.red,
                                    ),
                                  );
                                }
                                finally {
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
                                AppLocalizations.of(context)!.register,
                                //'Register',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                      ),
                    ),

                    const SizedBox(height: 20),

                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child:  Text(
                        AppLocalizations.of(context)!.backToLogin,
                          //"Back to Login",
                        style: TextStyle(
                          color: Color(0xff3B82F6),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
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