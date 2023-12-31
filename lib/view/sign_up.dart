import 'dart:developer';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:taxverse_admin/constants.dart';
import 'package:taxverse_admin/controller/providers/auth_provider.dart';

import 'package:taxverse_admin/utils/client_id.dart';
import 'package:taxverse_admin/utils/utils.dart';
import 'package:taxverse_admin/view/bottom_nav.dart';
import 'package:taxverse_admin/view/sign_in.dart';
import 'package:taxverse_admin/view/widgets/frosted_glass.dart';
import 'package:taxverse_admin/view/widgets/userinfo.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final namecontroller = TextEditingController();

  final emailcontroller = TextEditingController();

  final passcontroller = TextEditingController();

  final confirmController = TextEditingController();

  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void dispose() {
    namecontroller.dispose();
    emailcontroller.dispose();
    passcontroller.dispose();

    super.dispose();
  }
  // Validate Email

  String? validateEmail(String? email) {
    if (email == null || email.isEmpty) {
      return 'Email is required';
    }
    if (!EmailValidator.validate(email)) {
      return 'Enter a valid Email';
    }
    return null;
  }

  // Firebase SignUp

  Future<void> signUp(AuthProviderr provider) async {
    if (passConfirmed()) {
      final msg = await provider.signOut(emailcontroller.text, passcontroller.text);

      if (msg == '') {
        log(userName);
        userName = namecontroller.text.trim();
        log(userName);

        addUserDetails(
          namecontroller.text.trim(),
          emailcontroller.text.trim(),
          passcontroller.text.trim(),
        );

        return;
      }

      ScaffoldMessenger.of(scaffoldKey.currentContext!).hideCurrentSnackBar();
      ScaffoldMessenger.of(scaffoldKey.currentContext!).showSnackBar(
        SnackBar(
          content: Text(msg),
        ),
      );
    } else {
      showSnackBar(context, 'PassWord does not match');
    }
  }

  // add user details

  Future addUserDetails(String name, String email, String password) async {
    final CollectionReference clientCollection = FirebaseFirestore.instance.collection('admins');

    // create new document in the 'ClientDetails' collection

    await clientCollection.add({
      'Name': name,
      'Email': email,
      'Password': password,
      'Status': 'Unavailable',
      'is_online': false,
    });

    // Retrieve the auto-generatied document Id

    // String clientId = newClientDocRef.id;

    // ClientInformation.clientId = clientId;

    // await FirebaseFirestore.instance.collection('Client Details').add({
    //   'Name': name,
    //   'Email': email,
    //   'Password': password,
    // });
  }

  passConfirmed() {
    if (passcontroller.text.trim() == confirmController.text.trim()) {
      return true;
    } else {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.hasData) return const BottomNav();

        final mediaQuery = MediaQuery.of(context);

        final authProvider = context.watch<AuthProviderr>();

        return Scaffold(
          body: SafeArea(
            child: Stack(
              children: [
                ListView(
                  children: [
                    const SizedBox(height: 20),
                    SizedBox(
                      width: double.infinity,
                      height: 100,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(7),
                        child: Image.asset(
                          'Asset/TAXVERSE LOGO-1.png',
                        ),
                      ),
                    ),
                    ClipRRect(
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(40),
                        topRight: Radius.circular(40),
                      ),
                      child: SizedBox(
                        height: 700,
                        width: double.infinity,
                        child: Column(
                          children: [
                            const SizedBox(height: 20),
                            Text(
                              'Register With Us!',
                              textAlign: TextAlign.center,
                              style: GoogleFonts.poppins(
                                fontSize: 20,
                                fontWeight: FontWeight.w700,
                                height: 1.5,
                                color: blackColor,
                              ),
                              // TextStyle(fontSize: 20, fontWeight: FontWeight.w700, height: 1.5, color: blackColor),
                            ),
                            const SizedBox(height: 10),
                            Text(
                              'Your information is safe with us',
                              style: GoogleFonts.poppins(),
                            ),
                            const SizedBox(height: 20),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 20),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(18),
                                child: TextFormField(
                                  controller: namecontroller,
                                  decoration: InputDecoration(
                                    contentPadding: const EdgeInsets.symmetric(vertical: 25, horizontal: 20),
                                    border: InputBorder.none,
                                    filled: true,
                                    fillColor: blackColor.withOpacity(0.1),
                                    hintText: 'Enter Your Name',
                                    hintStyle: GoogleFonts.poppins(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w400,
                                      height: 1.5,
                                      color: const Color(0xa0000000),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 20),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 20),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(18),
                                child: TextFormField(
                                  controller: emailcontroller,
                                  autovalidateMode: AutovalidateMode.onUserInteraction,
                                  validator: validateEmail,
                                  decoration: InputDecoration(
                                    contentPadding: const EdgeInsets.symmetric(vertical: 25, horizontal: 20),
                                    border: InputBorder.none,
                                    filled: true,
                                    fillColor: blackColor.withOpacity(0.1),
                                    hintText: 'Enter Your Email',
                                    hintStyle: GoogleFonts.poppins(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w400,
                                      height: 1.5,
                                      color: const Color(0xa0000000),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 20),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 20),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(18),
                                child: TextFormField(
                                  controller: passcontroller,
                                  autovalidateMode: AutovalidateMode.onUserInteraction,
                                  validator: (pass) => pass != null && pass.length < 6 ? 'Enter min 6 Characters' : null,
                                  decoration: InputDecoration(
                                    contentPadding: const EdgeInsets.symmetric(vertical: 25, horizontal: 20),
                                    border: InputBorder.none,
                                    filled: true,
                                    fillColor: blackColor.withOpacity(0.1),
                                    hintText: 'Enter Your Password',
                                    hintStyle: GoogleFonts.poppins(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w400,
                                      height: 1.5,
                                      color: const Color(0xa0000000),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 20),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 20),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(18),
                                child: TextFormField(
                                  controller: confirmController,
                                  autovalidateMode: AutovalidateMode.onUserInteraction,
                                  validator: (pass) => pass != null && pass.length < 6 ? 'Enter min 6 Characters ' : null,
                                  decoration: InputDecoration(
                                    contentPadding: const EdgeInsets.symmetric(vertical: 25, horizontal: 20),
                                    border: InputBorder.none,
                                    filled: true,
                                    fillColor: blackColor.withOpacity(0.1),
                                    hintText: 'Confirm your password',
                                    hintStyle: GoogleFonts.poppins(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w400,
                                      height: 1.5,
                                      color: const Color(0xa0000000),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Container(
                              height: 40,
                            ),
                            InkWell(
                              onTap: () {
                                waringDialogBox(authProvider);
                                // _showDialog();
                              },
                              child: Container(
                                margin: const EdgeInsets.symmetric(horizontal: 35),
                                width: double.infinity,
                                height: 0.088 * mediaQuery.size.height,
                                decoration: BoxDecoration(
                                  color: const Color(0xff000000),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: const Center(
                                  child: Text(
                                    'Sign Up',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: whiteColor,
                                      fontSize: 20,
                                      fontWeight: FontWeight.w700,
                                      height: 1.5,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            InkWell(
                              onTap: () {
                                Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => const SignIn(),
                                    ));
                              },
                              child: RichText(
                                textAlign: TextAlign.center,
                                text: TextSpan(
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w400,
                                    height: 1.5,
                                    color: Color(0xa0000000),
                                  ),
                                  children: [
                                    TextSpan(text: 'Already have a account?', style: GoogleFonts.poppins()),
                                    TextSpan(
                                      text: ' Sign In',
                                      style: GoogleFonts.poppins(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w700,
                                        height: 1.5,
                                        color: const Color(0xff000000),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
                if (authProvider.loading)
                  const Center(
                    child: FrostedGlass(
                      width: double.infinity,
                      height: double.infinity,
                      child: Center(
                        child: SpinKitCircle(
                          color: blackColor,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  void waringDialogBox(AuthProviderr authProvider) {
    AwesomeDialog(
      context: context,
      dialogType: DialogType.warning,
      animType: AnimType.scale,
      showCloseIcon: true,
      title: 'Warning',
      desc: 'You are creating an admin account, so you have to enter a 6-digit password to continue',
      btnOkColor: Colors.green,
      btnOkText: 'Yes',
      btnCancelText: 'Cancel',
      btnCancelOnPress: () {},
      btnCancelColor: Colors.red,
      buttonsTextStyle: AppStyle.poppinsBold16,
      dismissOnBackKeyPress: true,
      titleTextStyle: AppStyle.poppinsBoldGreen16,
      descTextStyle: AppStyle.poppinsBold16,
      transitionAnimationDuration: const Duration(milliseconds: 500),
      btnOkOnPress: () {
        _showDialog(authProvider);
      },
      buttonsBorderRadius: BorderRadius.circular(20),
    ).show();
  }

  void _showDialog(AuthProviderr authProvider) {
    TextEditingController controller = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0), // Adjust the value as needed
          ),
          child: Container(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('Enter 6 Digit Password', style: AppStyle.poppinsBold20),
                const SizedBox(height: 16.0),
                TextField(
                  controller: controller,
                  decoration: InputDecoration(
                    border: const OutlineInputBorder(),
                    hintText: 'Enter Your password',
                    hintStyle: GoogleFonts.poppins(
                      fontSize: 15,
                      fontWeight: FontWeight.w400,
                      height: 1.5,
                      color: const Color(0xa0000000),
                    ),
                  ),
                ),
                const SizedBox(height: 16.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.black,
                        backgroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          side: const BorderSide(color: Colors.black),
                        ),
                      ),
                      child: const Text('Cancel'),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                    const SizedBox(width: 16.0),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.black,
                        backgroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          side: const BorderSide(color: Colors.black),
                        ),
                      ),
                      child: const Text('Submit'),
                      onPressed: () {
                        if (controller.text == '12345678') {
                          Navigator.pop(context);
                          signUp(authProvider);
                        } else {
                          AwesomeDialog(
                            context: context,
                            dialogType: DialogType.error,
                            animType: AnimType.scale,
                            showCloseIcon: true,
                            title: 'Password Is Incorrect',
                            desc: 'Entered Password is Incorrect',
                            btnOkColor: Colors.green,
                            buttonsTextStyle: AppStyle.poppinsBold16,
                            dismissOnBackKeyPress: true,
                            titleTextStyle: AppStyle.poppinsBoldGreen16,
                            descTextStyle: AppStyle.poppinsBold16,
                            transitionAnimationDuration: const Duration(milliseconds: 500),
                            buttonsBorderRadius: BorderRadius.circular(20),
                            btnOkOnPress: () {},
                          ).show();
                        }
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
