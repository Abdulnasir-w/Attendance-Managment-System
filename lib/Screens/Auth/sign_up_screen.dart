import 'package:flutter/material.dart';

import '../../Components/custom_text_form.dart';

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

  @override
  void dispose() {
    super.dispose();
    emailController.dispose();
    passwordController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const SizedBox(
            height: 20,
          ),
          MyCustomTextFormField(
            keyBoardType: TextInputType.name,
            labelText: 'Name',
            prefixIcon: Icons.lock_outline,
            hintText: 'Enter Your Name',
            textEditingController: nameController,
          ),
          const SizedBox(
            height: 20,
          ),
          MyCustomTextFormField(
            keyBoardType: TextInputType.emailAddress,
            labelText: 'Email',
            prefixIcon: Icons.lock_outline,
            hintText: 'Enter Your Email',
            textEditingController: emailController,
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
          ),
        ],
      ),
    );
  }
}
