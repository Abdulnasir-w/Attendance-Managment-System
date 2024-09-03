import 'package:attendance_ms/Providers/Admin/generate_report_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class GenerateReportScreen extends StatelessWidget {
  const GenerateReportScreen({super.key});

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
        child: ElevatedButton(
          onPressed: () async {
            await Provider.of<GenerateReportProvider>(context, listen: false)
                .generateReport();
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                  content: Text('Report generated and shared successfully')),
            );
          },
          child: const Text('Generate & Share Report'),
        ),
      ),
    );
  }
}
