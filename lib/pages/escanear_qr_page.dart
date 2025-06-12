import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
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
      final decoded = json.decode(utf8.decode(base64.decode(codigoQr)));

      final materiaId = decoded['materia_id'];
      final gestionCursoId = decoded['gestion_curso_id'];
      final fecha = decoded['fecha'];

      final alumnoProvider = Provider.of<AlumnoProvider>(
        context,
        listen: false,
      );

      final success = await alumnoProvider.registrarAsistenciaConQr(
        materiaId: materiaId,
        gestionCursoId: gestionCursoId,
        fecha: fecha,
      );

      if (!mounted) return;
      Navigator.pop(context);

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
    } catch (e) {
      if (!mounted) return;
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('QR inválido o corrupto 😕'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Escanear QR de Asistencia')),
      body: MobileScanner(
        onDetect: (capture) {
          final List<Barcode> barcodes = capture.barcodes;
          if (barcodes.isNotEmpty) {
            final codigoQr = barcodes.first.rawValue;
            if (codigoQr != null) {
              procesarQr(codigoQr);
            }
          }
        },
      ),
    );
  }
}
