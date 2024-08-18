import 'package:attendance_ms/Components/custom_text_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../Components/custom_button.dart';

class FogotScreen extends StatefulWidget {
  const FogotScreen({super.key});

  @override
  State<FogotScreen> createState() => _FogotScreenState();
}

class _FogotScreenState extends State<FogotScreen> {
  TextEditingController emailController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    super.dispose();
    emailController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset("assets/login.svg"),
          const SizedBox(
            height: 20,
          ),
          Form(
            key: formKey,
            child: MyCustomTextFormField(
              keyBoardType: TextInputType.emailAddress,
              labelText: 'Email',
              prefixIcon: Icons.email_outlined,
              hintText: 'Enter Your Email',
              textEditingController: emailController,
            ),
          ),
          MyCustomButton(
            title: "Reset Password",
            onPressed: () {},
          ),
        ],
      ),
    );
  }
}
