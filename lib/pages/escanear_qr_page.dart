import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mobile_scanner/mobile_scanner.dart' as ms;
import 'package:google_mlkit_barcode_scanning/google_mlkit_barcode_scanning.dart'
    as mlkit;
import 'package:google_mlkit_commons/google_mlkit_commons.dart';
import 'package:provider/provider.dart';
import '../providers/alumno_provider.dart';

class EscanearQrPage extends StatefulWidget {
  const EscanearQrPage({super.key});

  @override
  State<EscanearQrPage> createState() => _EscanearQrPageState();
}

class _EscanearQrPageState extends State<EscanearQrPage> {
  bool yaEscaneado = false;

  void procesarQr(String codigoQr) async {
    if (yaEscaneado) return;
    yaEscaneado = true;

    try {
      final alumnoProvider = Provider.of<AlumnoProvider>(
        context,
        listen: false,
      );
      final success = await alumnoProvider.registrarAsistenciaConQr(codigoQr);

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            success
                ? 'Asistencia registrada 😎'
                : 'Error al registrar asistencia 😕',
          ),
          backgroundColor: success ? Colors.green : Colors.red,
        ),
      );
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('QR inválido o corrupto 😕'),
          backgroundColor: Colors.red,
        ),
      );
    }

    Future.delayed(const Duration(seconds: 3), () {
      yaEscaneado = false;
    });
  }

  Future<void> escanearDesdeGaleria() async {
    final picker = ImagePicker();
    final XFile? imagen = await picker.pickImage(source: ImageSource.gallery);
    if (imagen == null) return;

    final inputImage = InputImage.fromFilePath(imagen.path);
    final scanner = mlkit.BarcodeScanner();
    final List<mlkit.Barcode> barcodes = await scanner.processImage(inputImage);
    await scanner.close();

    if (barcodes.isNotEmpty) {
      final codigoQr = barcodes.first.rawValue;
      if (codigoQr != null) {
        procesarQr(codigoQr);
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('No se detectó ningún QR 😕'),
          backgroundColor: Colors.orange,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Escanear QR de Asistencia'),
        actions: [
          IconButton(
            icon: const Icon(Icons.close),
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
      body: ms.MobileScanner(
        onDetect: (capture) {
          final List<ms.Barcode> barcodes = capture.barcodes;
          if (barcodes.isNotEmpty) {
            final codigoQr = barcodes.first.rawValue;
            if (codigoQr != null) {
              procesarQr(codigoQr);
            }
          }
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: escanearDesdeGaleria,
        icon: const Icon(Icons.photo),
        label: const Text("Desde galería"),
      ),
    );
  }
}
