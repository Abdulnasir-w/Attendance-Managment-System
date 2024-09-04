// ignore_for_file: use_build_context_synchronously

import 'dart:io';

import 'package:attendance_ms/Components/custom_snakbar.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

class ReportScreen extends StatelessWidget {
  final List<List<dynamic>> report;
  const ReportScreen({super.key, required this.report});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text(
            "Report",
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
            ),
          ),
          centerTitle: true,
          backgroundColor: Colors.lightBlue,
          iconTheme: const IconThemeData(color: Colors.white),
          actions: [
            IconButton(
              icon: const Icon(Icons.download),
              onPressed: () async {
                await generatePdfReport(report, context);
              },
            ),
          ]),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
        child: SingleChildScrollView(
          child: DataTable(
            dividerThickness: 3,
            clipBehavior: Clip.hardEdge,
            border: TableBorder.all(borderRadius: BorderRadius.circular(15)),
            headingRowColor: WidgetStatePropertyAll(Colors.lightBlue[100]),
            columnSpacing: 70,
            columns: const [
              DataColumn(label: Text("Names")),
              DataColumn(label: Text("Presents")),
              DataColumn(label: Text("Absents")),
            ],
            rows: report.map(
              (row) {
                return DataRow(
                  color: WidgetStatePropertyAll(Colors.grey[50]),
                  cells: [
                    DataCell(Text(row[0].toString())),
                    DataCell(Text(row[1].toString())),
                    DataCell(Text(row[2].toString())),
                  ],
                );
              },
            ).toList(),
          ),
        ),
      ),
    );
  }

  Future<void> generatePdfReport(
      List<List<dynamic>> report, BuildContext context) async {
    final pdf = pw.Document();
    final headers = ['Names', "Presents", "Absents"];

    pdf.addPage(
      pw.Page(
        build: (pw.Context context) {
          return pw.TableHelper.fromTextArray(
            headers: headers,
            data: report
                .map((row) => row.map((e) => e.toString()).toList())
                .toList(),
            border: pw.TableBorder.all(),
            headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold),
            headerDecoration:
                const pw.BoxDecoration(color: PdfColors.lightBlue),
            cellHeight: 30,
            cellAlignments: {
              0: pw.Alignment.centerLeft,
              1: pw.Alignment.center,
              2: pw.Alignment.center,
            },
          );
        },
      ),
    );
    try {
      final output = await getExternalStorageDirectory();
      final file = File("${output!.path}/report.pdf");
      await file.writeAsBytes(await pdf.save());

      CustomSnakbar.showCustomSnackbar(
        context,
        message: "Save Successfully",
        alignment: Alignment.topCenter,
        type: SnackBarType.success,
      );
    } catch (e) {
      CustomSnakbar.showCustomSnackbar(
        context,
        message: e.toString(),
        alignment: Alignment.topCenter,
        type: SnackBarType.error,
      );
    }
  }
}
