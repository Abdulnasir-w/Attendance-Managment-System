import 'package:attendance_ms/Components/custom_button.dart';
import 'package:attendance_ms/Components/custom_snakbar.dart';
import 'package:attendance_ms/Providers/Admin/generate_report_provider.dart';
import 'package:attendance_ms/Screens/Admin/Report%20Generate/report_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class GenerateReportScreen extends StatefulWidget {
  const GenerateReportScreen({super.key});

  @override
  State<GenerateReportScreen> createState() => _GenerateReportScreenState();
}

class _GenerateReportScreenState extends State<GenerateReportScreen> {
  bool isLoading = false;

  Future<void> generateReport() async {
    try {
      setState(() {
        isLoading = true;
      });
      final report =
          await Provider.of<GenerateReportProvider>(context, listen: false)
              .generateReport();
      if (mounted) {
        CustomSnakbar.showCustomSnackbar(
          context,
          message: "Report Generated Successfully",
          alignment: Alignment.topCenter,
          type: SnackBarType.success,
        );
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ReportScreen(report: report)));
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      if (mounted) {
        CustomSnakbar.showCustomSnackbar(
          context,
          message: e.toString(),
          alignment: Alignment.topCenter,
          type: SnackBarType.error,
        );
      }
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
        title: const Text(
          "Generate Report",
          style: TextStyle(fontSize: 18, color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: Colors.lightBlue,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Center(
        child: MyCustomButton(
          isLoading: isLoading,
          onPressed: () async {
            generateReport();
          },
          title: 'Generate & Share Report',
        ),
      ),
    );
  }
}
