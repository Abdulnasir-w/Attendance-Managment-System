import 'package:attendance_ms/Components/custom_text_form.dart';
import 'package:attendance_ms/Providers/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

import '../../Components/custom_button.dart';
import '../../Components/custom_snakbar.dart';

class FogotScreen extends StatefulWidget {
  const FogotScreen({super.key});

  @override
  State<FogotScreen> createState() => _FogotScreenState();
}

class _FogotScreenState extends State<FogotScreen> {
  TextEditingController emailController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  bool isLoading = false;

  @override
  void dispose() {
    super.dispose();
    emailController.dispose();
  }

  Future<void> forgotPassword() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    try {
      if (formKey.currentState!.validate()) {
        setState(() {
          isLoading = true;
        });
        await authProvider.forgotPassword(emailController.text.trim());
        if (mounted) {
          CustomSnakbar.showCustomSnackbar(
            context,
            message: "Email Send Successfully Please Check Your Email",
            alignment: Alignment.bottomCenter,
            type: SnackBarType.success,
          );
        }
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        automaticallyImplyLeading: true,
      ),
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(
              "assets/login.svg",
              width: 250,
              height: 250,
            ),
            const SizedBox(
              height: 10,
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
            const SizedBox(
              height: 20,
            ),
            MyCustomButton(
              isLoading: isLoading,
              title: "Reset Password",
              onPressed: forgotPassword,
            ),
          ],
        ),
      ),
    );
  }
}
