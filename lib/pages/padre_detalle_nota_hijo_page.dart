import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/padre_provider.dart';

class DetalleNotaHijoPage extends StatelessWidget {
  final int alumnoId;
  final int materiaId;
  final int gestionCursoId;
  final Map<String, dynamic> nota;

  const DetalleNotaHijoPage({
    super.key,
    required this.alumnoId,
    required this.materiaId,
    required this.gestionCursoId,
    required this.nota,
  });

  // Para dimensiones individuales (sobre 25 puntos)
  Color _getColorByGrade(double nota) {
    if (nota >= 21) return Colors.green[600]!; // 21-25 = Excelente
    if (nota >= 18) return Colors.blue[600]!; // 18-20 = Bueno
    if (nota >= 15) return Colors.orange[600]!; // 15-17 = Regular
    return Colors.red[600]!; // 0-14 = Necesita Mejorar
  }

  IconData _getIconByGrade(double nota) {
    if (nota >= 21) return Icons.star;
    if (nota >= 18) return Icons.thumb_up;
    if (nota >= 15) return Icons.remove_circle_outline;
    return Icons.warning;
  }

  String _getStatusText(double nota) {
    if (nota >= 21) return 'Excelente';
    if (nota >= 18) return 'Bueno';
    if (nota >= 15) return 'Regular';
    return 'Necesita Mejorar';
  }

  // Para nota final (sobre 100 puntos)
  Color _getColorByFinalGrade(double nota) {
    if (nota >= 85) return Colors.green[600]!; // 85-100 = Excelente
    if (nota >= 70) return Colors.blue[600]!; // 70-84 = Bueno
    if (nota >= 60) return Colors.orange[600]!; // 60-69 = Regular
    return Colors.red[600]!; // 0-59 = Necesita Mejorar
  }

  IconData _getIconByFinalGrade(double nota) {
    if (nota >= 85) return Icons.star;
    if (nota >= 70) return Icons.thumb_up;
    if (nota >= 60) return Icons.remove_circle_outline;
    return Icons.warning;
  }

  String _getStatusTextFinal(double nota) {
    if (nota >= 85) return 'Excelente';
    if (nota >= 70) return 'Bueno';
    if (nota >= 60) return 'Regular';
    return 'Necesita Mejorar';
  }

  Widget _buildNotaCard(String label, dynamic value) {
    final notaValue = (value ?? 0).toDouble();
    final color = _getColorByGrade(notaValue);
    final icon = _getIconByGrade(notaValue);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          // Icono y nota
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: color.withOpacity(0.3), width: 1),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, color: color, size: 20),
                const SizedBox(height: 2),
                Text(
                  notaValue.toStringAsFixed(0),
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),

          // Información de la dimensión
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 4),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: color.withOpacity(0.3), width: 1),
                  ),
                  child: Text(
                    _getStatusText(notaValue),
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: color,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Nota exacta
          Text(
            notaValue.toStringAsFixed(2),
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAsistenciaCard(Map<String, dynamic> asistencia) {
    final asistio = asistencia['asistio'] ?? false;
    final color = asistio ? Colors.green[600]! : Colors.red[600]!;
    final icon = asistio ? Icons.check_circle : Icons.cancel;

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.2), width: 1),
      ),
      child: Row(
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              asistencia['fecha'] ?? 'Sin fecha',
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              asistio ? 'Asistió' : 'Faltó',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: color,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildParticipacionCard(Map<String, dynamic> participacion) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.blue.withOpacity(0.2), width: 1),
      ),
      child: Row(
        children: [
          Icon(Icons.forum, color: Colors.blue[600], size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  participacion['fecha'] ?? 'Sin fecha',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  participacion['descripcion'] ?? 'Sin descripción',
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(String title, String subtitle, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(30),
            ),
            child: Icon(icon, size: 32, color: Colors.grey[400]),
          ),
          const SizedBox(height: 16),
          Text(
            title,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: TextStyle(fontSize: 12, color: Colors.grey[500]),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title, IconData icon, Color color) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(width: 8),
          Text(
            title,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget _buildNotaFinalSummary() {
    final notaFinal = (nota['nota_final'] ?? 0).toDouble();
    final color = _getColorByFinalGrade(notaFinal);
    final icon = _getIconByFinalGrade(notaFinal);
    final status = _getStatusTextFinal(notaFinal);

    return Container(
      margin: const EdgeInsets.only(bottom: 24),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 2,
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Icon(Icons.grade, color: Colors.blue[700], size: 24),
              const SizedBox(width: 8),
              const Text(
                'Nota Final',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: color.withOpacity(0.3), width: 2),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(icon, color: color, size: 28),
                    const SizedBox(height: 4),
                    Text(
                      notaFinal.toStringAsFixed(1),
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: color,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: color.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: color.withOpacity(0.3),
                          width: 1,
                        ),
                      ),
                      child: Text(
                        status,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: color,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Calificación: ${notaFinal.toStringAsFixed(2)}',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<PadreProvider>(context, listen: false);

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text('Detalle de Materia'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        elevation: 0,
      ),
      body: FutureBuilder(
        future: Future.wait([
          provider.obtenerAsistenciasHijo(alumnoId, materiaId, gestionCursoId),
          provider.obtenerParticipacionesHijo(
            alumnoId,
            materiaId,
            gestionCursoId,
          ),
        ]),
        builder: (_, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting ||
              provider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          final asistencias = provider.asistenciasHijo;
          final participaciones = provider.participacionesHijo;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Resumen de nota final
                _buildNotaFinalSummary(),

                // Dimensiones de evaluación
                _buildSectionHeader(
                  'Dimensiones de Evaluación',
                  Icons.assessment,
                  Colors.blue[700]!,
                ),
                _buildNotaCard('SER', nota['ser']),
                _buildNotaCard('SABER', nota['saber']),
                _buildNotaCard('HACER', nota['hacer']),
                _buildNotaCard('DECIDIR', nota['decidir']),

                const SizedBox(height: 24),

                // Asistencias
                _buildSectionHeader(
                  'Asistencias',
                  Icons.calendar_today,
                  Colors.green[700]!,
                ),
                if (asistencias.isEmpty)
                  _buildEmptyState(
                    'No hay asistencias',
                    'No se encontraron registros de asistencia para esta materia.',
                    Icons.calendar_today_outlined,
                  )
                else
                  Column(
                    children:
                        asistencias
                            .map<Widget>((a) => _buildAsistenciaCard(a))
                            .toList(),
                  ),

                const SizedBox(height: 24),

                // Participaciones
                _buildSectionHeader(
                  'Participaciones',
                  Icons.forum,
                  Colors.purple[700]!,
                ),
                if (participaciones.isEmpty)
                  _buildEmptyState(
                    'No hay participaciones',
                    'No se encontraron registros de participación para esta materia.',
                    Icons.forum_outlined,
                  )
                else
                  Column(
                    children:
                        participaciones
                            .map<Widget>((p) => _buildParticipacionCard(p))
                            .toList(),
                  ),

                const SizedBox(height: 16),
              ],
            ),
          );
        },
      ),
    );
  }
}
