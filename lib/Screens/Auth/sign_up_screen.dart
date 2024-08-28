import 'package:attendance_ms/Components/custom_snakbar.dart';
import 'package:attendance_ms/Providers/Auth/auth_provider.dart' as myauth;
import 'package:attendance_ms/Screens/Auth/sign_in_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

import '../../Components/custom_button.dart';
import '../../Components/custom_text_form.dart';
import '../../Utils/validator.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  bool isLoading = false;

  @override
  void dispose() {
    super.dispose();
    emailController.dispose();
    passwordController.dispose();
    nameController.dispose();
  }

  Future<void> _signUp() async {
    final authProvider =
        Provider.of<myauth.AuthProvider>(context, listen: false);
    if (formKey.currentState!.validate()) {
      try {
        setState(() {
          isLoading = true;
        });
        await authProvider.signUp(
          nameController.text.trim(),
          emailController.text.trim(),
          passwordController.text.trim(),
        );
        if (mounted) {
          CustomSnakbar.showCustomSnackbar(
            context,
            message: "Account Created Successfully",
            alignment: Alignment.topCenter,
            type: SnackBarType.success,
          );
        }

        if (mounted) {
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) => const LoginScreen()));
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
        isLoading = false;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(right: 15, left: 15),
        child: SingleChildScrollView(
          // keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,

          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
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
                      labelText: 'Name',
                      prefixIcon: Icons.person_2_outlined,
                      hintText: 'Enter Your Name',
                      textEditingController: nameController,
                      validator: (value) => validateNotEmpty(value),
                    ),
                    const SizedBox(
                      height: 20,
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
              const SizedBox(
                height: 30,
              ),
              MyCustomButton(
                title: "Sign Up",
                isLoading: isLoading,
                onPressed: _signUp,
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
                    "Already have an Account ? ",
                    style: TextStyle(color: Colors.black45),
                  ),
                  InkWell(
                      onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const LoginScreen())),
                      child: Text(
                        "Login",
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
