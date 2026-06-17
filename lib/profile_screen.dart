/*  PROFILE PAGE DISABLED — kept as a comment, not used anywhere in the app.

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'l10n/app_localizations.dart';

class ProfileScreen extends StatefulWidget {
  final String email;

  const ProfileScreen({super.key, required this.email});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {

  String name = "";
  int? age;
  String? gender;
  String? maritalStatus;

  List<int> ages = List.generate(200, (index) => index + 1);

  TextEditingController nameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  // Load profile
  Future<void> _loadProfile() async {
    final prefs = await SharedPreferences.getInstance();
    final e = widget.email;
    setState(() {
      nameController.text = prefs.getString("profile_name_$e") ?? "";
      age = prefs.getInt("profile_age_$e");
      gender = prefs.getString("profile_gender_$e");
      maritalStatus = prefs.getString("profile_marital_$e");
    });
  }

  @override
  Widget build(BuildContext context) {

    /// ✅ القيم مترجمة
    final genders = [
      AppLocalizations.of(context)!.male,
      AppLocalizations.of(context)!.female,
    ];

    final maritalStatuses = [
      AppLocalizations.of(context)!.single,
      AppLocalizations.of(context)!.married,
      AppLocalizations.of(context)!.widowed,
    ];

    return Scaffold(
      backgroundColor: const Color(0xff0F172A),

      appBar: AppBar(
        backgroundColor: const Color(0xff0F172A),
        title: Text(AppLocalizations.of(context)!.profile),
        automaticallyImplyLeading: false,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context, {
              "name": nameController.text,
              "age": age?.toString() ?? "",
              "gender": gender ?? "",
              "maritalStatus": maritalStatus ?? "",
              "email": widget.email,
            });
          },
        ),
      ),

      body: Padding(
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              Text(
                "${AppLocalizations.of(context)!.email}: ${widget.email}",
                style: const TextStyle(color: Colors.white, fontSize: 16),
              ),

              const SizedBox(height: 20),

              /// 👇 NAME
              TextField(
                controller: nameController,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  labelText: AppLocalizations.of(context)!.name,
                  labelStyle: const TextStyle(color: Colors.white70),
                ),
              ),

              const SizedBox(height: 20),

              /// 👇 AGE
              DropdownButtonFormField<int>(
                value: age,
                dropdownColor: const Color(0xff1E293B),
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  labelText: AppLocalizations.of(context)!.age,
                  labelStyle: const TextStyle(color: Colors.white70),
                ),
                items: ages.map((e) {
                  return DropdownMenuItem(
                    value: e,
                    child: Text(e.toString()),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    age = value;
                  });
                },
              ),

              const SizedBox(height: 20),

              /// 👇 GENDER
              DropdownButtonFormField<String>(
                // Guard value
                value: genders.contains(gender) ? gender : null,
                dropdownColor: const Color(0xff1E293B),
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  labelText: AppLocalizations.of(context)!.gender,
                  labelStyle: const TextStyle(color: Colors.white70),
                ),
                items: genders.map((e) {
                  return DropdownMenuItem(
                    value: e,
                    child: Text(e),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    gender = value;
                  });
                },
              ),

              const SizedBox(height: 20),

              /// 👇 MARITAL STATUS
              DropdownButtonFormField<String>(
                value: maritalStatuses.contains(maritalStatus)
                    ? maritalStatus
                    : null,
                dropdownColor: const Color(0xff1E293B),
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  labelText: AppLocalizations.of(context)!.maritalStatus,
                  labelStyle: const TextStyle(color: Colors.white70),
                ),
                items: maritalStatuses.map((e) {
                  return DropdownMenuItem(
                    value: e,
                    child: Text(e),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    maritalStatus = value;
                  });
                },
              ),

              const SizedBox(height: 30),

              /// 👇 SAVE BUTTON
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xff2563EB),
                  ),
                  onPressed: () async {

                    if (nameController.text.isEmpty ||
                        age == null ||
                        gender == null ||
                        maritalStatus == null) {

                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(AppLocalizations.of(context)!.enterProfileFirst),
                          backgroundColor: Colors.red,
                        ),
                      );
                      return;
                    }

                    // Save locally
                    final prefs = await SharedPreferences.getInstance();
                    final e = widget.email;
                    await prefs.setString("profile_name_$e", nameController.text);
                    await prefs.setInt("profile_age_$e", age!);
                    await prefs.setString("profile_gender_$e", gender!);
                    await prefs.setString("profile_marital_$e", maritalStatus!);

                    final result = {
                      "name": nameController.text,
                      "age": age.toString(),
                      "gender": gender!,
                      "maritalStatus": maritalStatus!,
                      "email": widget.email,
                    };

                    if (!mounted) return;
                    Navigator.pop(context, result);
                  },

                  child: Text(
                    AppLocalizations.of(context)!.saveData,
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
              )

            ],
          ),
        ),
      ),
    );
  }
}
*/
// import 'package:flutter/material.dart';
// import 'l10n/app_localizations.dart';
//
// class ProfileScreen extends StatefulWidget {
//   final String email;
//
//   const ProfileScreen({super.key, required this.email});
//
//   @override
//   State<ProfileScreen> createState() => _ProfileScreenState();
// }
//
// class _ProfileScreenState extends State<ProfileScreen> {
//
//   String name = "";
//   int? age;
//   String? gender;
//   String? maritalStatus;
//
//   List<int> ages = List.generate(200, (index) => index + 1);
//
//   List<String> genders = ["Male", "Female"];
//
//   List<String> maritalStatuses = [
//     "Single",
//     "Married",
//     "Widowed"
//   ];
//
//   bool editName = false;
//
//   TextEditingController nameController = TextEditingController();
//
//   @override
//   Widget build(BuildContext context) {
//
//
//     return Scaffold(
//       backgroundColor: const Color(0xff0F172A),
//
//       appBar: AppBar(
//         backgroundColor: const Color(0xff0F172A),
//         title: Text(AppLocalizations.of(context)!.profile),
//         automaticallyImplyLeading: false,
//         leading: IconButton(
//           icon: const Icon(Icons.arrow_back),
//           onPressed: () {
//             Navigator.pop(context, {
//               "name": nameController.text,
//               "age": age?.toString() ?? "",
//               "gender": gender ?? "",
//               "maritalStatus": maritalStatus ?? "",
//               "email": widget.email,
//             });
//           },
//         ),
//       ),
//
//       body: Padding(
//         padding: const EdgeInsets.all(20),
//         child: SingleChildScrollView(
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//
//               Text(
//                 "${AppLocalizations.of(context)!.email}: ${widget.email}",
//                 style: const TextStyle(color: Colors.white, fontSize: 16),
//               ),
//
//               const SizedBox(height: 20),
//
//               /// 👇 NAME (زي ما هو)
//               TextField(
//                 controller: nameController,
//                 style: const TextStyle(color: Colors.white),
//                 decoration: InputDecoration(
//                   labelText: AppLocalizations.of(context)!.name,
//                   labelStyle: const TextStyle(color: Colors.white70),
//                 ),
//               ),
//
//               const SizedBox(height: 20),
//
//               /// 👇 AGE
//               DropdownButtonFormField<int>(
//                 value: age,
//                 dropdownColor: const Color(0xff1E293B),
//                 style: const TextStyle(color: Colors.white),
//                 decoration: InputDecoration(
//                   labelText: AppLocalizations.of(context)!.age,
//                   labelStyle: const TextStyle(color: Colors.white70),
//                 ),
//                 items: ages.map((e) {
//                   return DropdownMenuItem(
//                     value: e,
//                     child: Text(e.toString()),
//                   );
//                 }).toList(),
//                 onChanged: (value) {
//                   setState(() {
//                     age = value;
//                   });
//                 },
//               ),
//
//               const SizedBox(height: 20),
//
//               /// 👇 GENDER
//               DropdownButtonFormField<String>(
//                 value: gender,
//                 dropdownColor: const Color(0xff1E293B),
//                 style: const TextStyle(color: Colors.white),
//                 decoration: InputDecoration(
//                   labelText: AppLocalizations.of(context)!.gender,
//                   labelStyle: const TextStyle(color: Colors.white70),
//                 ),
//                 items: genders.map((e) {
//                   return DropdownMenuItem(
//                     value: e,
//                     child: Text(e),
//                   );
//                 }).toList(),
//                 onChanged: (value) {
//                   setState(() {
//                     gender = value;
//                   });
//                 },
//               ),
//
//               const SizedBox(height: 20),
//
//               /// 👇 MARITAL STATUS
//               DropdownButtonFormField<String>(
//                 value: maritalStatus,
//                 dropdownColor: const Color(0xff1E293B),
//                 style: const TextStyle(color: Colors.white),
//                 decoration: InputDecoration(
//                   labelText: AppLocalizations.of(context)!.maritalStatus,
//                   labelStyle: const TextStyle(color: Colors.white70),
//                 ),
//                 items: maritalStatuses.map((e) {
//                   return DropdownMenuItem(
//                     value: e,
//                     child: Text(e),
//                   );
//                 }).toList(),
//                 onChanged: (value) {
//                   setState(() {
//                     maritalStatus = value;
//                   });
//                 },
//               ),
//
//               const SizedBox(height: 30),
//
//               /// 👇 SAVE BUTTON
//               SizedBox(
//                 width: double.infinity,
//                 child: ElevatedButton(
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: const Color(0xff2563EB),
//                   ),
//                   onPressed: () {
//
//                     if (nameController.text.isEmpty ||
//                         age == null ||
//                         gender == null ||
//                         maritalStatus == null) {
//
//                       ScaffoldMessenger.of(context).showSnackBar(
//                         SnackBar(
//                           content: Text(AppLocalizations.of(context)!.enterProfileFirst),
//                           backgroundColor: Colors.red,
//                         ),
//                       );
//                       return;
//                     }
//
//                     final result = {
//                       "name": nameController.text,
//                       "age": age.toString(),
//                       "gender": gender!,
//                       "maritalStatus": maritalStatus!,
//                       "email": widget.email,
//                     };
//
//                     Navigator.pop(context, result);
//                   },
//
//                   child: Text(
//                     AppLocalizations.of(context)!.saveData,
//                     style: const TextStyle(color: Colors.white),
//                   ),
//                 ),
//               )
//
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
// import 'package:flutter/material.dart';
// import 'l10n/app_localizations.dart';
//
// class ProfileScreen extends StatefulWidget {
//
//   final String email;
//
//   const ProfileScreen({super.key, required this.email});
//
//   @override
//   State<ProfileScreen> createState() => _ProfileScreenState();
// }
//
// class _ProfileScreenState extends State<ProfileScreen> {
//
//   String name = "";
//   String age = "";
//   String gender = "";
//   String maritalStatus = "";
//
//   List<int> ages = List.generate(200, (index) => index + 1);
//
//   List<String> genders = ["Male", "Female"];
//
//   List<String> maritalStatuses = [
//     "Single",
//     "Married",
//     "Widowed"
//   ];
//
//   bool editName = false;
//   bool editAge = false;
//   bool editGender = false;
//   bool editMarital = false;
//
//   TextEditingController nameController = TextEditingController();
//   TextEditingController ageController = TextEditingController();
//   TextEditingController genderController = TextEditingController();
//   TextEditingController maritalController = TextEditingController();
//
//   Widget buildField(
//       String label,
//       TextEditingController controller,
//       bool isEditing,
//       Function() onEdit,
//       Function() onSave,
//       ) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 10),
//       child: Row(
//         children: [
//
//           Expanded(
//             child: isEditing
//                 ? TextField(
//               controller: controller,
//               style: const TextStyle(color: Colors.white),
//               decoration: InputDecoration(
//                 labelText: label,
//                 labelStyle: const TextStyle(color: Colors.white70),
//               ),
//             )
//                 : Text(
//               "$label: ${controller.text}",
//               style: const TextStyle(color: Colors.white, fontSize: 16),
//             ),
//           ),
//
//           IconButton(
//             icon: Icon(
//               isEditing ? Icons.check : Icons.edit,
//               color: Colors.white,
//             ),
//             onPressed: isEditing ? onSave : onEdit,
//           )
//         ],
//       ),
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//
//     return Scaffold(
//       backgroundColor: const Color(0xff0F172A),
//
//       appBar: AppBar(
//         backgroundColor: const Color(0xff0F172A),
//         title:  Text(
//           AppLocalizations.of(context)!.profile,
//           //"Profile"
//         ),
//         automaticallyImplyLeading: false, // ❗ يمنع زرار الباك
//         leading: IconButton(
//           icon: const Icon(Icons.arrow_back),
//           onPressed: () {
//             Navigator.pop(context, {
//               "name": nameController.text,
//               "age": ageController.text,
//               "gender": genderController.text,
//               "maritalStatus": maritalController.text,
//               "email": widget.email,
//             });
//           },
//         ),
//       ),
//
//       body: Padding(
//         padding: const EdgeInsets.all(20),
//         child: SingleChildScrollView(
//           child: Column(
//
//             crossAxisAlignment: CrossAxisAlignment.start,
//
//             children: [
//
//               Text(
//                 "Email: ${widget.email}",
//                 style: const TextStyle(
//                     color: Colors.white,
//                     fontSize: 16
//                 ),
//               ),
//
//               const SizedBox(height: 20),
//
//               buildField(
//                 AppLocalizations.of(context)!.name,
//                   //"Name",
//                   nameController,
//                   editName,
//                       () => setState(() => editName = true),
//                       () {
//                     setState(() {
//                       name = nameController.text;
//                       editName = false;
//                     });
//                   }),
//
//               buildField(
//                 AppLocalizations.of(context)!.age,
//                   //"Age",
//                   ageController,
//                   editAge,
//                       () => setState(() => editAge = true),
//                       () {
//                     setState(() {
//                       age = ageController.text;
//                       editAge = false;
//                     });
//                   }),
//
//               buildField(
//                 AppLocalizations.of(context)!.gender,
//                   //"Gender",
//                   genderController,
//                   editGender,
//                       () => setState(() => editGender = true),
//                       () {
//                     setState(() {
//                       gender = genderController.text;
//                       editGender = false;
//                     });
//                   }),
//
//               buildField(
//                 AppLocalizations.of(context)!.maritalStatus,
//                   //"Marital Status",
//                   maritalController,
//                   editMarital,
//                       () => setState(() => editMarital = true),
//                       () {
//                     setState(() {
//                       maritalStatus = maritalController.text;
//                       editMarital = false;
//                     });
//                   }),
//
//               const SizedBox(height: 30),
//
//               SizedBox(
//                 width: double.infinity,
//                 child: ElevatedButton(
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: const Color(0xff2563EB),
//                   ),
//                   onPressed: () {
//                     final result = {
//                       "name": nameController.text,
//                       "age": ageController.text,
//                       "gender": genderController.text,
//                       "maritalStatus": maritalController.text,
//                       "email": widget.email,
//                     };
//
//                     print("SENDING DATA: $result"); // 👈 مهم
//
//                     Navigator.pop(context, result);
//                   },
//
//                   child:  Text(
//                     AppLocalizations.of(context)!.saveData,
//                     //"Save Data",
//                     style: TextStyle(color: Colors.white),
//                   ),
//                 ),
//               )
//
//             ],
//
//           ),
//         ),
//       ),
//     );
//   }
// }
//
// // import 'package:flutter/material.dart';
// //
// // class ProfileScreen extends StatelessWidget {
// //   final String email;
// //   const ProfileScreen({super.key, required this.email});
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       backgroundColor: const Color(0xff0F172A),
// //       appBar: AppBar(
// //         backgroundColor: const Color(0xff0F172A),
// //         title: const Text("Profile"),
// //       ),
// //       body: Center(
// //         child: Text(
// //           "Logged in as:\n$email",
// //           textAlign: TextAlign.center,
// //           style: const TextStyle(
// //               color: Colors.white, fontSize: 18),
// //         ),
// //       ),
// //     );
// //   }
// // }
//
