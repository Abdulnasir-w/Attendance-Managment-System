import 'package:attendance_ms/Components/custom_button.dart';
import 'package:attendance_ms/Components/custom_snakbar.dart';
import 'package:attendance_ms/Providers/Auth/auth_provider.dart' as myauth;
import 'package:attendance_ms/Screens/Admin/home_screen.dart';
import 'package:attendance_ms/Screens/Auth/sign_up_screen.dart';
import 'package:attendance_ms/Screens/User/home_screen.dart';
import 'package:attendance_ms/Utils/validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

import '../../Components/custom_text_form.dart';
import 'fogot_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  bool isLoading = false;

  @override
  void dispose() {
    super.dispose();
    emailController.dispose();
    passwordController.dispose();
  }

  Future<void> _login() async {
    final authProvider =
        Provider.of<myauth.AuthProvider>(context, listen: false);
    if (formKey.currentState!.validate()) {
      try {
        setState(() {
          isLoading = true;
        });
        await authProvider.signIn(
          emailController.text.trim(),
          passwordController.text.trim(),
        );
        if (mounted) {
          if (authProvider.isAdmin()) {
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) => const AdminHomeScreen()));
          } else {
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) => const UserHomeScreen()));
          }
        }

        if (mounted) {
          CustomSnakbar.showCustomSnackbar(
            context,
            message: "Login Successfully",
            alignment: Alignment.topCenter,
            type: SnackBarType.success,
          );
        }
      } on FirebaseAuthException catch (e) {
        if (mounted) {
          CustomSnakbar.showCustomSnackbar(
            context,
            message: e.code,
            alignment: Alignment.topCenter,
            type: SnackBarType.error,
          );
        }
      } catch (e) {
        if (mounted) {
          CustomSnakbar.showCustomSnackbar(
            context,
            message: e.toString(),
            alignment: Alignment.topCenter,
            type: SnackBarType.error,
          );
        }
        setState(() {
          isLoading = false;
        });
      } finally {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(
          right: 15,
          left: 15,
        ),
        child: SingleChildScrollView(
          // keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(
                height: 130,
              ),
              SvgPicture.asset(
                "assets/login.svg",
                height: 270,
                width: 270,
              ),
              Form(
                key: formKey,
                child: Column(
                  children: [
                    const SizedBox(
                      height: 30,
                    ),
                    MyCustomTextFormField(
                      keyBoardType: TextInputType.emailAddress,
                      labelText: 'Email',
                      prefixIcon: Icons.email_outlined,
                      hintText: 'Enter Your Email',
                      textEditingController: emailController,
                      validator: (value) => validateEmail(value),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    MyCustomTextFormField(
                      keyBoardType: TextInputType.visiblePassword,
                      labelText: 'Password',
                      prefixIcon: Icons.lock_outline,
                      hintText: 'Enter Your Password',
                      textEditingController: passwordController,
                      maxLines: 1,
                      isPassfield: true,
                      validator: (value) => validateNotEmpty(value),
                    ),
                  ],
                ),
              ),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const FogotScreen()));
                  },
                  child: Text(
                    "Forgot Password ?",
                    style: TextStyle(
                        color: Colors.blue[300],
                        textBaseline: TextBaseline.alphabetic),
                  ),
                ),
              ),
              const SizedBox(
                height: 5,
              ),
              MyCustomButton(
                title: "Login",
                isLoading: isLoading,
                onPressed: _login,
              ),
              const SizedBox(
                height: 10,
              ),
              const Divider(
                color: Colors.black,
                thickness: 1,
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Don't have an Account ? ",
                    style: TextStyle(color: Colors.black45),
                  ),
                  InkWell(
                      onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const SignUpScreen())),
                      child: Text(
                        "Sign Up",
                        style: TextStyle(color: Colors.blue[300]),
                      ))
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
