import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import '../providers/profesor_provider.dart';

class QrAsistenciaPage extends StatefulWidget {
  final int materiaId;

  const QrAsistenciaPage({super.key, required this.materiaId});

  @override
  State<QrAsistenciaPage> createState() => _QrAsistenciaPageState();
}

class _QrAsistenciaPageState extends State<QrAsistenciaPage> {
  String? _selectedGestion;
  String? _selectedCurso;
  String? _qrData;
  bool _isGenerating = false;

  @override
  void initState() {
    super.initState();
    final provider = Provider.of<ProfesorProvider>(context, listen: false);
    if (provider.materias.isEmpty) {
      provider.cargarMaterias(1); // carga por defecto gestión 1
    }
  }

  Future<void> _generarQr() async {
    if (_selectedGestion == null || _selectedCurso == null) return;

    setState(() {
      _isGenerating = true;
    });

    final provider = Provider.of<ProfesorProvider>(context, listen: false);

    final asignacion = provider.materias.firstWhere(
      (m) =>
          m['materia'] == widget.materiaId &&
          m['gestion_periodo'] == _selectedGestion &&
          m['curso_nombre'] == _selectedCurso,
      orElse: () => {},
    );

    if (asignacion.isNotEmpty) {
      final gestionCursoId = asignacion['gestion_curso'];
      await provider.cargarQrAsistencia(
        materiaId: widget.materiaId,
        gestionCursoId: gestionCursoId,
      );
      setState(() {
        _qrData = provider.qrData;
        _isGenerating = false;
      });
    } else {
      setState(() {
        _qrData = null;
        _isGenerating = false;
      });
    }
  }

  Widget _buildSelectionCard() {
    final profesorProvider = Provider.of<ProfesorProvider>(context);

    final gestiones =
        profesorProvider.materias
            .map((m) => m['gestion_periodo'] as String)
            .toSet()
            .toList();
    final cursos =
        profesorProvider.materias
            .map((m) => m['curso_nombre'] as String)
            .toSet()
            .toList();

    return Card(
      margin: const EdgeInsets.all(16),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.blue[100],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    Icons.settings,
                    color: Colors.blue[700],
                    size: 24,
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  'Configuración de Asistencia',
                  style: GoogleFonts.poppins(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Selector de Gestión
            Text(
              'Gestión',
              style: GoogleFonts.poppins(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 8),
            DropdownButtonFormField<String>(
              decoration: InputDecoration(
                hintText: 'Selecciona una gestión',
                hintStyle: GoogleFonts.poppins(color: Colors.grey[500]),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.grey[300]!),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.grey[300]!),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.blue[600]!, width: 2),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                prefixIcon: Icon(
                  Icons.calendar_today,
                  color: Colors.grey[600],
                  size: 20,
                ),
              ),
              value: _selectedGestion,
              items:
                  gestiones.map((g) {
                    return DropdownMenuItem(
                      value: g,
                      child: Text(g, style: GoogleFonts.poppins()),
                    );
                  }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedGestion = value;
                  _qrData = null;
                });
              },
            ),
            const SizedBox(height: 16),

            // Selector de Curso
            Text(
              'Curso',
              style: GoogleFonts.poppins(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 8),
            DropdownButtonFormField<String>(
              decoration: InputDecoration(
                hintText: 'Selecciona un curso',
                hintStyle: GoogleFonts.poppins(color: Colors.grey[500]),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.grey[300]!),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.grey[300]!),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.blue[600]!, width: 2),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                prefixIcon: Icon(
                  Icons.class_,
                  color: Colors.grey[600],
                  size: 20,
                ),
              ),
              value: _selectedCurso,
              items:
                  cursos.map((c) {
                    return DropdownMenuItem(
                      value: c,
                      child: Text(c, style: GoogleFonts.poppins()),
                    );
                  }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedCurso = value;
                  _qrData = null;
                });
              },
            ),
            const SizedBox(height: 24),

            // Botón Generar QR
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed:
                    (_selectedGestion != null &&
                            _selectedCurso != null &&
                            !_isGenerating)
                        ? _generarQr
                        : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue[600],
                  foregroundColor: Colors.white,
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child:
                    _isGenerating
                        ? Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  Colors.white,
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Text(
                              'Generando...',
                              style: GoogleFonts.poppins(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        )
                        : Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.qr_code, size: 24),
                            const SizedBox(width: 8),
                            Text(
                              'Generar Código QR',
                              style: GoogleFonts.poppins(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQrCard() {
    if (_qrData == null) return const SizedBox.shrink();

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.qr_code_scanner, color: Colors.green[600], size: 24),
                const SizedBox(width: 8),
                Text(
                  'Código QR Generado',
                  style: GoogleFonts.poppins(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.grey[300]!),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    spreadRadius: 1,
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: QrImageView(
                data: _qrData!,
                size: 280,
                backgroundColor: Colors.white,
                foregroundColor: Colors.black,
              ),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.blue[50],
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.blue[200]!),
              ),
              child: Row(
                children: [
                  Icon(Icons.info_outline, color: Colors.blue[600], size: 20),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Los estudiantes pueden escanear este código para registrar su asistencia',
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        color: Colors.blue[700],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.qr_code_2, size: 80, color: Colors.grey[400]),
          const SizedBox(height: 16),
          Text(
            'Configura los parámetros',
            style: GoogleFonts.poppins(
              fontSize: 18,
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Selecciona gestión y curso para generar el QR',
            style: GoogleFonts.poppins(fontSize: 14, color: Colors.grey[500]),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text(
          'Generar QR de Asistencia',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 1,
        iconTheme: const IconThemeData(color: Colors.black87),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Card de configuración
            _buildSelectionCard(),

            // Contenido principal
            _qrData != null
                ? _buildQrCard()
                : Padding(
                  padding: const EdgeInsets.symmetric(vertical: 40),
                  child: _buildEmptyState(),
                ),
          ],
        ),
      ),
    );
  }
}
