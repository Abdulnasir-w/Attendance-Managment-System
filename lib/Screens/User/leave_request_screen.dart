import 'package:attendance_ms/Components/custom_button.dart';
import 'package:attendance_ms/Components/custom_snakbar.dart';
import 'package:attendance_ms/Components/custom_text_form.dart';
import 'package:attendance_ms/Providers/Auth/auth_provider.dart';
import 'package:attendance_ms/Providers/User/leave_request_provider.dart';
import 'package:attendance_ms/Utils/validator.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class LeaveRequestScreen extends StatefulWidget {
  const LeaveRequestScreen({super.key});

  @override
  State<LeaveRequestScreen> createState() => _LeaveRequestScreenState();
}

class _LeaveRequestScreenState extends State<LeaveRequestScreen> {
  final TextEditingController reasonController = TextEditingController();
  final TextEditingController dateController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  bool isLoading = false;

  @override
  void dispose() {
    super.dispose();
    reasonController.dispose();
    dateController.dispose();
  }

  Future<void> submitRequest() async {
    final leave = Provider.of<LeaveRequestProvider>(context, listen: false);
    final auth = Provider.of<AuthProvider>(context, listen: false);
    if (formKey.currentState!.validate()) {
      try {
        setState(() {
          isLoading = true;
        });
        await leave.requestLeave(
          auth.user!.uId,
          dateController.text.trim(),
          reasonController.text,
        );
        if (mounted) {
          Navigator.pop(context);
        }
        if (mounted) {
          CustomSnakbar.showCustomSnackbar(context,
              message: "Request Submitted Successfully",
              alignment: Alignment.bottomCenter,
              type: SnackBarType.success);
        }
      } catch (e) {
        setState(() {
          isLoading = false;
        });
        if (mounted) {
          CustomSnakbar.showCustomSnackbar(context,
              message: e.toString(),
              alignment: Alignment.bottomCenter,
              type: SnackBarType.error);
        }
      } finally {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? selectedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (selectedDate != null && selectedDate != DateTime.now()) {
      setState(() {
        dateController.text = DateFormat('MM/dd/yyyy').format(selectedDate);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Request For Leave",
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.lightBlue,
        automaticallyImplyLeading: true,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Form(
                key: formKey,
                child: Column(
                  children: [
                    GestureDetector(
                      onTap: () => _selectDate(context),
                      child: AbsorbPointer(
                        child: MyCustomTextFormField(
                          hintText: "MM/DD/YYYY",
                          labelText: "Date",
                          prefixIcon: Icons.date_range_outlined,
                          textEditingController: dateController,
                          validator: (value) => validateNotEmpty(value),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    MyCustomTextFormField(
                      hintText: "Enter a Valid Reason for Leave ",
                      labelText: "Reason",
                      textEditingController: reasonController,
                      maxLines: 21,
                      keyBoardType: TextInputType.text,
                      validator: (value) => validateNotEmpty(value),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    MyCustomButton(
                      isLoading: isLoading,
                      title: 'Request For Leave',
                      onPressed: submitRequest,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
