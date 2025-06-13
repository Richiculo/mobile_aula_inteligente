import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import '../providers/alumno_provider.dart';
import './dialog_calificacion.dart';
import './dialog_asistencia.dart';
import './dialog_participacion.dart';
import './dialog_detalle_nota.dart';

class ListaAlumnosMateriaPage extends StatefulWidget {
  final int mgcId;
  final int materiaId;
  final int gestionCursoId;
  const ListaAlumnosMateriaPage({
    super.key,
    required this.mgcId,
    required this.materiaId,
    required this.gestionCursoId,
  });

  @override
  State<ListaAlumnosMateriaPage> createState() =>
      _ListaAlumnosMateriaPageState();
}

class _ListaAlumnosMateriaPageState extends State<ListaAlumnosMateriaPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      final alumnoProvider = Provider.of<AlumnoProvider>(
        context,
        listen: false,
      );
      alumnoProvider.setContextoNota(
        materiaId: widget.materiaId,
        gestionCursoId: widget.gestionCursoId,
      );
      alumnoProvider.cargarAlumnos(widget.mgcId);
    });
  }

  Color getNotaColor(double? nota) {
    if (nota == null) return Colors.grey;
    if (nota >= 51) return Colors.green;
    if (nota >= 40) return Colors.orange;
    return Colors.red;
  }

  Widget _buildAlumnoCard(Map<String, dynamic> alumno) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header del alumno
              Row(
                children: [
                  Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      color: Colors.blue[100],
                      borderRadius: BorderRadius.circular(25),
                    ),
                    child: Icon(
                      Icons.person,
                      color: Colors.blue[700],
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${alumno['nombre']} ${alumno['apellidos']}',
                          style: GoogleFonts.poppins(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          alumno['email'],
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                            color: Colors.grey[600],
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Nota final badge
                  if (alumno['nota_final'] != null)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: getNotaColor(
                          alumno['nota_final'],
                        ).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: getNotaColor(
                            alumno['nota_final'],
                          ).withOpacity(0.3),
                          width: 1,
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.grade,
                            color: getNotaColor(alumno['nota_final']),
                            size: 16,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '${alumno['nota_final']}',
                            style: GoogleFonts.poppins(
                              color: getNotaColor(alumno['nota_final']),
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),

              const SizedBox(height: 16),

              // Panel de acciones
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.grey[50],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Row(
                        children: [
                          Icon(Icons.school, size: 16, color: Colors.grey[600]),
                          const SizedBox(width: 4),
                          Text(
                            'Gestión académica',
                            style: GoogleFonts.poppins(
                              fontSize: 12,
                              color: Colors.grey[600],
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                    PopupMenuButton<String>(
                      icon: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.blue[50],
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: Colors.blue[200]!,
                            width: 1,
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.more_horiz,
                              size: 16,
                              color: Colors.blue[600],
                            ),
                            const SizedBox(width: 4),
                            Text(
                              'Acciones',
                              style: GoogleFonts.poppins(
                                fontSize: 12,
                                color: Colors.blue[600],
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                      onSelected: (value) async {
                        if (value == 'nota') {
                          mostrarDialogoCalificacion(
                            context,
                            alumno,
                            widget.materiaId,
                            widget.gestionCursoId,
                          );
                        } else if (value == 'asistencia') {
                          mostrarDialogoAsistencia(
                            context,
                            alumno,
                            widget.materiaId,
                            widget.gestionCursoId,
                          );
                        } else if (value == 'participacion') {
                          mostrarDialogoParticipacion(
                            context,
                            alumno,
                            widget.materiaId,
                            widget.gestionCursoId,
                          );
                        } else if (value == 'detalle') {
                          final alumnoProvider = Provider.of<AlumnoProvider>(
                            context,
                            listen: false,
                          );
                          if (alumnoProvider.gestionSeleccionada == null) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Seleccioná una gestión primero'),
                              ),
                            );
                            return;
                          }
                          final nota = await alumnoProvider.obtenerNotaDeAlumno(
                            alumnoId: alumno['id'],
                            materiaId: widget.materiaId,
                            gestionCursoId: widget.gestionCursoId,
                            gestionId: alumnoProvider.gestionSeleccionada!,
                          );
                          if (!context.mounted) return;
                          mostrarDialogoDetalleNota(context, alumno, nota);
                        }
                      },
                      itemBuilder:
                          (context) => [
                            PopupMenuItem(
                              value: 'nota',
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.edit,
                                    size: 16,
                                    color: Colors.blue[600],
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    'Calificar',
                                    style: GoogleFonts.poppins(),
                                  ),
                                ],
                              ),
                            ),
                            PopupMenuItem(
                              value: 'asistencia',
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.check_circle,
                                    size: 16,
                                    color: Colors.green[600],
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    'Asistencia',
                                    style: GoogleFonts.poppins(),
                                  ),
                                ],
                              ),
                            ),
                            PopupMenuItem(
                              value: 'participacion',
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.forum,
                                    size: 16,
                                    color: Colors.orange[600],
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    'Participación',
                                    style: GoogleFonts.poppins(),
                                  ),
                                ],
                              ),
                            ),
                            PopupMenuItem(
                              value: 'detalle',
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.visibility,
                                    size: 16,
                                    color: Colors.purple[600],
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    'Ver Detalles',
                                    style: GoogleFonts.poppins(),
                                  ),
                                ],
                              ),
                            ),
                          ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEstadisticasAlumnos(List<dynamic> alumnos) {
    if (alumnos.isEmpty) return const SizedBox.shrink();

    final totalAlumnos = alumnos.length;
    final alumnosConNota = alumnos.where((a) => a['nota_final'] != null).length;
    final alumnosAprobados =
        alumnos
            .where((a) => a['nota_final'] != null && a['nota_final'] >= 51)
            .length;
    final promedioGeneral =
        alumnos.where((a) => a['nota_final'] != null).isEmpty
            ? 0.0
            : alumnos
                    .where((a) => a['nota_final'] != null)
                    .map((a) => a['nota_final'] as double)
                    .reduce((a, b) => a + b) /
                alumnosConNota;

    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.analytics, color: Colors.blue[700], size: 24),
              const SizedBox(width: 8),
              Text(
                'Resumen de Alumnos',
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildStatChip(
                  'Total',
                  totalAlumnos.toString(),
                  Icons.people,
                  Colors.blue[600]!,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _buildStatChip(
                  'Con Nota',
                  alumnosConNota.toString(),
                  Icons.assignment_turned_in,
                  Colors.green[600]!,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _buildStatChip(
                  'Aprobados',
                  alumnosAprobados.toString(),
                  Icons.check_circle,
                  Colors.orange[600]!,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _buildStatChip(
                  'Promedio',
                  promedioGeneral.toStringAsFixed(1),
                  Icons.trending_up,
                  Colors.purple[600]!,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatChip(
    String label,
    String value,
    IconData icon,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(height: 4),
          Text(
            value,
            style: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          Text(
            label,
            style: GoogleFonts.poppins(
              fontSize: 10,
              color: color,
              fontWeight: FontWeight.w600,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final alumnoProvider = Provider.of<AlumnoProvider>(context);

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text(
          'Alumnos Inscritos',
          style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        elevation: 0,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1.0),
          child: Container(color: Colors.grey[200], height: 1.0),
        ),
      ),
      body:
          alumnoProvider.isLoading
              ? const Center(child: CircularProgressIndicator())
              : alumnoProvider.alumnos.isEmpty
              ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.people_outline,
                      size: 64,
                      color: Colors.grey[400],
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'No hay alumnos inscritos',
                      style: GoogleFonts.poppins(
                        fontSize: 18,
                        color: Colors.grey[600],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Los alumnos aparecerán aquí cuando se inscriban',
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        color: Colors.grey[500],
                      ),
                    ),
                  ],
                ),
              )
              : Column(
                children: [
                  // Estadísticas resumen
                  _buildEstadisticasAlumnos(alumnoProvider.alumnos),

                  // Lista de alumnos
                  Expanded(
                    child: ListView.builder(
                      padding: const EdgeInsets.only(bottom: 16),
                      itemCount: alumnoProvider.alumnos.length,
                      itemBuilder: (context, index) {
                        final alumno = alumnoProvider.alumnos[index];
                        return _buildAlumnoCard(alumno);
                      },
                    ),
                  ),
                ],
              ),
    );
  }
}
