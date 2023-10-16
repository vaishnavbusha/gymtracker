import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/rendering.dart';
import 'package:path_provider/path_provider.dart';
import 'package:screenshot/screenshot.dart';
import 'dart:typed_data';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart ' as pw;
import 'package:share_plus/share_plus.dart';

class QRGeneratorNotifier extends ChangeNotifier {
  bool isLoading = false;
  Uint8List? imageFile;
  ScreenshotController? screenshotController;
  QRGeneratorNotifier() {
    screenshotController = ScreenshotController();
  }
  Future isGeneratingPDF() async {
    notifyListeners();
    isLoading = true;

    await screenshotController!
        .capture(delay: const Duration(milliseconds: 10))
        .then(
      (value) {
        imageFile = value!;
      },
    );

    await screenToPdf('scanner', imageFile!);
    notifyListeners();
  }

  Future screenToPdf(String fileName, Uint8List screenShot) async {
    pw.Document pdf = pw.Document();
    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (context) {
          return pw.Expanded(
            child: pw.Image(
              pw.MemoryImage(screenShot),
              fit: pw.BoxFit.cover,
            ),
          );
        },
      ),
    );
    String path = (await getTemporaryDirectory()).path;
    File pdfFile = await File('$path/$fileName.pdf').create();

    pdfFile.writeAsBytesSync(await pdf.save());
    await Share.shareFiles([pdfFile.path]);
    isLoading = false;
    notifyListeners();
  }
}
