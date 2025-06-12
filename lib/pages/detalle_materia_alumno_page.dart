import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/alumno_provider.dart';

class DetalleMateriaAlumnoPage extends StatefulWidget {
  final int materiaId;
  final int gestionCursoId;
  final String nombreMateria;

  const DetalleMateriaAlumnoPage({
    super.key,
    required this.materiaId,
    required this.gestionCursoId,
    required this.nombreMateria,
  });

  @override
  State<DetalleMateriaAlumnoPage> createState() =>
      _DetalleMateriaAlumnoPageState();
}

class _DetalleMateriaAlumnoPageState extends State<DetalleMateriaAlumnoPage> {
  Map<String, dynamic>? notas;
  List<Map<String, dynamic>> asistencias = [];
  List<Map<String, dynamic>> participaciones = [];
  bool loading = true;

  @override
  void initState() {
    super.initState();
    _cargarDatos();
  }

  Future<void> _cargarDatos() async {
    final provider = Provider.of<AlumnoProvider>(context, listen: false);
    final n = await provider.obtenerNotasDetalle(
      widget.materiaId,
      widget.gestionCursoId,
    );
    final a = await provider.obtenerAsistencias(
      widget.materiaId,
      widget.gestionCursoId,
    );
    final p = await provider.obtenerParticipaciones(
      widget.materiaId,
      widget.gestionCursoId,
    );
    setState(() {
      notas = n;
      asistencias = a ?? [];
      participaciones = p ?? [];
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        title: Text(
          widget.nombreMateria,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
      ),
      body:
          loading
              ? const Center(child: CircularProgressIndicator())
              : SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildResumenAcademico(),
                    const SizedBox(height: 16),
                    _buildNotasDetalle(),
                    const SizedBox(height: 16),
                    _buildAsistencias(),
                    const SizedBox(height: 16),
                    _buildParticipaciones(),
                  ],
                ),
              ),
    );
  }

  Widget _buildResumenAcademico() {
    final notaFinal = notas?['nota_final']?.toString() ?? '0';
    final notaNum = double.tryParse(notaFinal) ?? 0.0;

    // Calcular asistencias
    final totalClases = asistencias.length;
    final clasesAsistidas =
        asistencias.where((a) => a['asistio'] == true).length;
    final totalParticipaciones = participaciones.length;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 24,
                height: 24,
                decoration: const BoxDecoration(
                  color: Color(0xFF4285F4),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.assessment,
                  color: Colors.white,
                  size: 14,
                ),
              ),
              const SizedBox(width: 8),
              const Text(
                'Resumen Académico',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildResumenCard(
                  notaFinal,
                  'Promedio',
                  _getColorForNota(notaNum),
                  _getStatusForNota(notaNum),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildResumenCard(
                  clasesAsistidas.toString(),
                  'Asistencias',
                  const Color(0xFF34A853),
                  'Registradas',
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _buildResumenCard(
                  totalParticipaciones.toString(),
                  'Participaciones',
                  const Color(0xFFFBBC04),
                  'Registradas',
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildResumenCard(
                  totalClases.toString(),
                  'Total Clases',
                  const Color(0xFF9AA0A6),
                  'Registradas',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildResumenCard(
    String value,
    String label,
    Color color,
    String status,
  ) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            value,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            status,
            style: TextStyle(
              fontSize: 10,
              color: color,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Color _getColorForNota(double nota) {
    if (nota >= 60) return const Color(0xFF34A853);
    if (nota >= 50) return const Color(0xFFFBBC04);
    return const Color(0xFFEA4335);
  }

  String _getStatusForNota(double nota) {
    if (nota >= 60) return 'Aprobado';
    if (nota >= 50) return 'En Riesgo';
    return 'Reprobado';
  }

  Widget _buildNotasDetalle() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Notas por Dimensión',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 16),
          if (notas != null) ...[
            _buildNotaItem('SER', notas!['ser']?.toString() ?? 'N/A'),
            _buildNotaItem('SABER', notas!['saber']?.toString() ?? 'N/A'),
            _buildNotaItem('HACER', notas!['hacer']?.toString() ?? 'N/A'),
            _buildNotaItem('DECIDIR', notas!['decidir']?.toString() ?? 'N/A'),
          ],
        ],
      ),
    );
  }

  Widget _buildNotaItem(String dimension, String nota) {
    final notaNum = double.tryParse(nota) ?? 0.0;
    final color = _getColorForNota(notaNum);

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: const Color(0xFFF8F9FA),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            dimension,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Colors.black87,
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              nota,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: color,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAsistencias() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Asistencias',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 16),
          if (asistencias.isEmpty)
            const Center(
              child: Padding(
                padding: EdgeInsets.all(20),
                child: Text(
                  'No hay registros de asistencia',
                  style: TextStyle(color: Colors.grey, fontSize: 14),
                ),
              ),
            )
          else
            ...asistencias.take(5).map((asistencia) {
              final asistio = asistencia['asistio'] == true;
              return Container(
                margin: const EdgeInsets.only(bottom: 8),
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFFF8F9FA),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      asistencia['fecha']?.toString() ?? 'Fecha no disponible',
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.black87,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color:
                            asistio
                                ? const Color(0xFF34A853).withOpacity(0.1)
                                : const Color(0xFFEA4335).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        asistio ? 'Presente' : 'Ausente',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color:
                              asistio
                                  ? const Color(0xFF34A853)
                                  : const Color(0xFFEA4335),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }),
          if (asistencias.length > 5)
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Center(
                child: Text(
                  'y ${asistencias.length - 5} más...',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildParticipaciones() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Participaciones',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 16),
          if (participaciones.isEmpty)
            const Center(
              child: Padding(
                padding: EdgeInsets.all(20),
                child: Text(
                  'No hay participaciones registradas',
                  style: TextStyle(color: Colors.grey, fontSize: 14),
                ),
              ),
            )
          else
            ...participaciones.take(3).map((participacion) {
              return Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFFF8F9FA),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      participacion['descripcion']?.toString() ??
                          'Sin descripción',
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      participacion['fecha']?.toString() ??
                          'Fecha no disponible',
                      style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                    ),
                  ],
                ),
              );
            }),
          if (participaciones.length > 3)
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Center(
                child: Text(
                  'y ${participaciones.length - 3} más...',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
