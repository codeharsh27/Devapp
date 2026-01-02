import 'dart:typed_data';

import 'package:blog_app/feature/resume/data/models/resume_models.dart';
import 'package:blog_app/feature/resume/domain/services/pdf_service.dart';
import 'package:blog_app/init_dependency.dart';
import 'package:flutter/material.dart';
import 'package:printing/printing.dart';

class ResumePreviewPage extends StatelessWidget {
  final ResumeData resumeData;
  final Uint8List? initialBytes;

  const ResumePreviewPage({
    super.key,
    required this.resumeData,
    this.initialBytes,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Resume Preview'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text(
              'Edit',
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
      body: PdfPreview(
        build: (format) => initialBytes != null
            ? Future.value(initialBytes)
            : serviceLocator<PdfService>().generateResume(resumeData),
        canChangeOrientation: false,
        canChangePageFormat: false,
        pdfFileName: 'resume.pdf',
      ),
    );
  }
}
