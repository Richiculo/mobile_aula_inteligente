import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import '../providers/alumno_provider.dart';

Future<void> mostrarDialogoCalificacion(
  BuildContext context,
  Map<String, dynamic> alumno,
  int materiaId,
  int gestionCursoId,
) async {
  final _serController = TextEditingController();
  final _saberController = TextEditingController();
  final _hacerController = TextEditingController();
  final _decidirController = TextEditingController();
  final alumnoProvider = Provider.of<AlumnoProvider>(context, listen: false);

  await showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) {
      return Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        elevation: 0,
        backgroundColor: Colors.transparent,
        child: Container(
          constraints: BoxConstraints(
            maxWidth: 400,
            maxHeight:
                MediaQuery.of(context).size.height * 0.9, // Limitar altura
          ),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.3),
                spreadRadius: 2,
                blurRadius: 10,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Header del diálogo (fijo)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20), // Reducido de 24 a 20
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.blue[600]!, Colors.blue[400]!],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                ),
                child: Column(
                  children: [
                    Container(
                      width: 50, // Reducido de 60 a 50
                      height: 50,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(25),
                      ),
                      child: const Icon(
                        Icons.grade,
                        color: Colors.white,
                        size: 25, // Reducido de 30 a 25
                      ),
                    ),
                    const SizedBox(height: 8), // Reducido de 12 a 8
                    Text(
                      'Calificar Alumno',
                      style: GoogleFonts.poppins(
                        fontSize: 18, // Reducido de 20 a 18
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${alumno['nombre']} ${alumno['apellidos']}',
                      style: GoogleFonts.poppins(
                        fontSize: 13, // Reducido de 14 a 13
                        color: Colors.white.withOpacity(0.9),
                        fontWeight: FontWeight.w500,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),

              // Contenido scrolleable
              Flexible(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(20), // Reducido de 24 a 20
                    child: Column(
                      children: [
                        // Información de puntuación
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(
                            12,
                          ), // Reducido de 16 a 12
                          decoration: BoxDecoration(
                            color: Colors.blue[50],
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: Colors.blue[200]!,
                              width: 1,
                            ),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Icons.info_outline,
                                color: Colors.blue[600],
                                size: 18, // Reducido de 20 a 18
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  'Cada dimensión tiene un máximo de 25 puntos',
                                  style: GoogleFonts.poppins(
                                    fontSize: 11, // Reducido de 12 a 11
                                    color: Colors.blue[700],
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 16), // Reducido de 24 a 16
                        // Campos de calificación
                        _buildCalificacionField(
                          controller: _serController,
                          label: 'Ser',
                          icon: Icons.person,
                          color: Colors.green[600]!,
                        ),
                        const SizedBox(height: 12), // Reducido de 16 a 12
                        _buildCalificacionField(
                          controller: _saberController,
                          label: 'Saber',
                          icon: Icons.school,
                          color: Colors.blue[600]!,
                        ),
                        const SizedBox(height: 12),
                        _buildCalificacionField(
                          controller: _hacerController,
                          label: 'Hacer',
                          icon: Icons.build,
                          color: Colors.orange[600]!,
                        ),
                        const SizedBox(height: 12),
                        _buildCalificacionField(
                          controller: _decidirController,
                          label: 'Decidir',
                          icon: Icons.psychology,
                          color: Colors.purple[600]!,
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              // Botones de acción (fijos)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.only(
                  left: 20,
                  right: 20,
                  bottom: 20,
                ), // Reducido padding
                child: Row(
                  children: [
                    Expanded(
                      child: TextButton(
                        onPressed: () => Navigator.pop(context),
                        style: TextButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                            vertical: 14,
                          ), // Reducido de 16 a 14
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                            side: BorderSide(color: Colors.grey[300]!),
                          ),
                        ),
                        child: Text(
                          'Cancelar',
                          style: GoogleFonts.poppins(
                            fontSize: 13, // Reducido de 14 a 13
                            fontWeight: FontWeight.w600,
                            color: Colors.grey[700],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () async {
                          final ser =
                              _serController.text.isNotEmpty
                                  ? double.tryParse(_serController.text)
                                  : null;
                          final saber =
                              _saberController.text.isNotEmpty
                                  ? double.tryParse(_saberController.text)
                                  : null;
                          final hacer =
                              _hacerController.text.isNotEmpty
                                  ? double.tryParse(_hacerController.text)
                                  : null;
                          final decidir =
                              _decidirController.text.isNotEmpty
                                  ? double.tryParse(_decidirController.text)
                                  : null;

                          // Validación de puntos máximos
                          if ((ser ?? 0) > 25 ||
                              (saber ?? 0) > 25 ||
                              (hacer ?? 0) > 25 ||
                              (decidir ?? 0) > 25) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Row(
                                  children: [
                                    Icon(
                                      Icons.error_outline,
                                      color: Colors.white,
                                      size: 20,
                                    ),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: Text(
                                        'Ninguna nota puede ser mayor a 25 puntos',
                                        style: GoogleFonts.poppins(
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                backgroundColor: Colors.red[600],
                                behavior: SnackBarBehavior.floating,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                            );
                            return;
                          }

                          final success = await alumnoProvider.calificarAlumno(
                            alumnoId: alumno['id'],
                            materiaId: materiaId,
                            gestionCursoId: gestionCursoId,
                            ser: ser,
                            saber: saber,
                            hacer: hacer,
                            decidir: decidir,
                          );

                          if (!context.mounted) return;
                          Navigator.pop(context);

                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Row(
                                children: [
                                  Icon(
                                    success
                                        ? Icons.check_circle
                                        : Icons.error_outline,
                                    color: Colors.white,
                                    size: 20,
                                  ),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Text(
                                      success
                                          ? 'Nota registrada correctamente'
                                          : 'Error al registrar nota',
                                      style: GoogleFonts.poppins(
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              backgroundColor:
                                  success ? Colors.green[600] : Colors.red[600],
                              behavior: SnackBarBehavior.floating,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue[600],
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                            vertical: 14,
                          ), // Reducido de 16 a 14
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 0,
                        ),
                        child: Text(
                          'Guardar Nota',
                          style: GoogleFonts.poppins(
                            fontSize: 13, // Reducido de 14 a 13
                            fontWeight: FontWeight.w600,
                          ),
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
    },
  );
}

Widget _buildCalificacionField({
  required TextEditingController controller,
  required String label,
  required IconData icon,
  required Color color,
}) {
  return Container(
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(12),
      border: Border.all(color: Colors.grey[300]!),
    ),
    child: TextField(
      controller: controller,
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: GoogleFonts.poppins(
          color: color,
          fontWeight: FontWeight.w500,
        ),
        prefixIcon: Container(
          margin: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: color, size: 18), // Reducido de 20 a 18
        ),
        suffixText: '/25',
        suffixStyle: GoogleFonts.poppins(
          color: Colors.grey[600],
          fontWeight: FontWeight.w500,
        ),
        border: InputBorder.none,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 12, // Reducido de 16 a 12
        ),
        floatingLabelBehavior: FloatingLabelBehavior.auto,
      ),
      style: GoogleFonts.poppins(
        fontSize: 15,
        fontWeight: FontWeight.w500,
      ), // Reducido de 16 a 15
    ),
  );
}
