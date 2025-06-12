import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

Color getNotaColor(double? nota) {
  if (nota == null) return Colors.grey;
  if (nota >= 51) return Colors.green;
  if (nota >= 40) return Colors.orange;
  return Colors.red;
}

IconData getNotaIcon(double? nota) {
  if (nota == null) return Icons.help_outline;
  if (nota >= 51) return Icons.check_circle;
  if (nota >= 40) return Icons.warning;
  return Icons.cancel;
}

void mostrarDialogoDetalleNota(
  BuildContext context,
  Map<String, dynamic> alumno,
  Map<String, dynamic>? nota,
) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) {
      final notaColor = getNotaColor(nota?['nota_final']);
      final notaIcon = getNotaIcon(nota?['nota_final']);

      return Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        elevation: 0,
        backgroundColor: Colors.transparent,
        insetPadding: const EdgeInsets.all(16),
        child: Container(
          width: MediaQuery.of(context).size.width > 400 ? 400 : null,
          height: MediaQuery.of(context).size.height * 0.7,
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
              // Header - altura fija
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
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
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(25),
                      ),
                      child: const Icon(
                        Icons.assignment,
                        color: Colors.white,
                        size: 25,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Detalle de Notas',
                      style: GoogleFonts.poppins(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${alumno['nombre']} ${alumno['apellidos']}',
                      style: GoogleFonts.poppins(
                        fontSize: 13,
                        color: Colors.white.withOpacity(0.9),
                        fontWeight: FontWeight.w500,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),

              // Contenido scrollable - toma el espacio restante
              Expanded(
                child:
                    nota == null
                        ? // Mensaje de error cuando no hay nota
                        Center(
                          child: Padding(
                            padding: const EdgeInsets.all(20),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  width: 80,
                                  height: 80,
                                  decoration: BoxDecoration(
                                    color: Colors.grey[100],
                                    borderRadius: BorderRadius.circular(40),
                                  ),
                                  child: Icon(
                                    Icons.error_outline,
                                    color: Colors.grey[600],
                                    size: 40,
                                  ),
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  'Sin información',
                                  style: GoogleFonts.poppins(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.grey[700],
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  'No se pudo obtener la información de la nota.',
                                  style: GoogleFonts.poppins(
                                    fontSize: 14,
                                    color: Colors.grey[600],
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ),
                        )
                        : // Contenido con las notas
                        SingleChildScrollView(
                          padding: const EdgeInsets.all(20),
                          child: Column(
                            children: [
                              // Nota Final - Card destacado
                              Container(
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  color: notaColor.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(16),
                                  border: Border.all(
                                    color: notaColor.withOpacity(0.3),
                                    width: 2,
                                  ),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(20),
                                  child: Column(
                                    children: [
                                      Container(
                                        width: 60,
                                        height: 60,
                                        decoration: BoxDecoration(
                                          color: notaColor.withOpacity(0.2),
                                          borderRadius: BorderRadius.circular(
                                            30,
                                          ),
                                        ),
                                        child: Icon(
                                          notaIcon,
                                          color: notaColor,
                                          size: 28,
                                        ),
                                      ),
                                      const SizedBox(height: 12),
                                      Text(
                                        'Nota Final',
                                        style: GoogleFonts.poppins(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.grey[700],
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        '${nota['nota_final'] ?? 'N/A'}',
                                        style: GoogleFonts.poppins(
                                          fontSize: 32,
                                          fontWeight: FontWeight.bold,
                                          color: notaColor,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),

                              const SizedBox(height: 20),

                              // Dimensiones del Ser, Saber, Hacer, Decidir
                              _buildDimensionCard(
                                'Ser',
                                nota['ser'],
                                Icons.favorite,
                                Colors.pink,
                              ),
                              const SizedBox(height: 12),
                              _buildDimensionCard(
                                'Saber',
                                nota['saber'],
                                Icons.school,
                                Colors.indigo,
                              ),
                              const SizedBox(height: 12),
                              _buildDimensionCard(
                                'Hacer',
                                nota['hacer'],
                                Icons.build,
                                Colors.orange,
                              ),
                              const SizedBox(height: 12),
                              _buildDimensionCard(
                                'Decidir',
                                nota['decidir'],
                                Icons.psychology,
                                Colors.teal,
                              ),

                              const SizedBox(height: 20),

                              // Información adicional
                              Container(
                                width: double.infinity,
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: Colors.grey[50],
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: Colors.grey[200]!,
                                    width: 1,
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.info_outline,
                                      color: Colors.grey[600],
                                      size: 16,
                                    ),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: Text(
                                        'Escala: 51-100 (Aprobado), 40-50 (En proceso), 0-39 (Reprobado)',
                                        style: GoogleFonts.poppins(
                                          fontSize: 11,
                                          color: Colors.grey[600],
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
              ),

              // Botón - altura fija en la parte inferior
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue[600],
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 0,
                  ),
                  child: Text(
                    'Cerrar',
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}

Widget _buildDimensionCard(
  String titulo,
  dynamic valor,
  IconData icono,
  Color color,
) {
  final valorNumerico =
      valor is double ? valor : (valor is int ? valor.toDouble() : null);
  final colorNota = getNotaColor(valorNumerico);

  return Container(
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(12),
      border: Border.all(color: Colors.grey[300]!),
      color: Colors.white,
    ),
    child: ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icono, color: color, size: 20),
      ),
      title: Text(
        titulo,
        style: GoogleFonts.poppins(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: color,
        ),
      ),
      trailing: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: colorNota.withOpacity(0.1),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: colorNota.withOpacity(0.3), width: 1),
        ),
        child: Text(
          valor?.toString() ?? 'N/A',
          style: GoogleFonts.poppins(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: colorNota,
          ),
        ),
      ),
    ),
  );
}
