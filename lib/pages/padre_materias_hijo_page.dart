import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/padre_provider.dart';
import './padre_detalle_nota_hijo_page.dart';

class DetalleMateriasHijoPage extends StatefulWidget {
  final int alumnoId;
  final int gestionId;

  const DetalleMateriasHijoPage({
    super.key,
    required this.alumnoId,
    required this.gestionId,
  });

  @override
  State<DetalleMateriasHijoPage> createState() =>
      _DetalleMateriasHijoPageState();
}

class _DetalleMateriasHijoPageState extends State<DetalleMateriasHijoPage> {
  @override
  void initState() {
    super.initState();
    _cargarDatos();
  }

  @override
  void didUpdateWidget(DetalleMateriasHijoPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Recargar datos si cambiaron los parámetros
    if (oldWidget.alumnoId != widget.alumnoId ||
        oldWidget.gestionId != widget.gestionId) {
      _cargarDatos();
    }
  }

  void _cargarDatos() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = Provider.of<PadreProvider>(context, listen: false);
      provider.cargarMateriasHijo(widget.alumnoId, widget.gestionId);
    });
  }

  Color _getColorByGrade(double nota) {
    if (nota >= 85) return Colors.green[600]!;
    if (nota >= 70) return Colors.blue[600]!;
    if (nota >= 60) return Colors.orange[600]!;
    return Colors.red[600]!;
  }

  IconData _getIconByGrade(double nota) {
    if (nota >= 85) return Icons.star;
    if (nota >= 70) return Icons.thumb_up;
    if (nota >= 60) return Icons.remove_circle_outline;
    return Icons.warning;
  }

  String _getStatusText(double nota) {
    if (nota >= 85) return 'Excelente';
    if (nota >= 70) return 'Bueno';
    if (nota >= 60) return 'Regular';
    return 'Necesita Mejorar';
  }

  Widget _buildMateriaCard(Map<String, dynamic> materia) {
    final notaFinal = (materia['nota_final'] ?? 0).toDouble();
    final color = _getColorByGrade(notaFinal);
    final icon = _getIconByGrade(notaFinal);
    final status = _getStatusText(notaFinal);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
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
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder:
                  (_) => DetalleNotaHijoPage(
                    alumnoId: widget.alumnoId,
                    materiaId: materia['materia_id'],
                    gestionCursoId: materia['gestion_curso_id'],
                    nota: {
                      'ser': materia['ser'],
                      'saber': materia['saber'],
                      'hacer': materia['hacer'],
                      'decidir': materia['decidir'],
                      'nota_final': materia['nota_final'],
                    },
                  ),
            ),
          );
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
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
                      notaFinal.toStringAsFixed(0),
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

              // Información de la materia
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      materia['materia_nombre'] ?? 'Sin nombre',
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
                        border: Border.all(
                          color: color.withOpacity(0.3),
                          width: 1,
                        ),
                      ),
                      child: Text(
                        status,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: color,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    // Dimensiones del saber
                    Wrap(
                      spacing: 4,
                      runSpacing: 4,
                      children: [
                        _buildDimensionChip('SER', materia['ser'] ?? 0),
                        _buildDimensionChip('SABER', materia['saber'] ?? 0),
                        _buildDimensionChip('HACER', materia['hacer'] ?? 0),
                        _buildDimensionChip('DECIDIR', materia['decidir'] ?? 0),
                      ],
                    ),
                  ],
                ),
              ),

              // Flecha indicadora
              Icon(Icons.arrow_forward_ios, color: Colors.grey[400], size: 16),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDimensionChip(String label, dynamic value) {
    final nota = (value ?? 0).toDouble();
    final color = _getColorByGrade(nota);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: color.withOpacity(0.2), width: 0.5),
      ),
      child: Text(
        '$label: ${nota.toStringAsFixed(0)}',
        style: TextStyle(
          fontSize: 9,
          fontWeight: FontWeight.w500,
          color: color,
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Container(
      padding: const EdgeInsets.all(32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(50),
            ),
            child: Icon(Icons.book_outlined, size: 64, color: Colors.grey[400]),
          ),
          const SizedBox(height: 24),
          Text(
            'No hay materias disponibles',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'No se encontraron materias para este estudiante en la gestión seleccionada.',
            style: TextStyle(fontSize: 14, color: Colors.grey[500]),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildStatsSummary(List<Map<String, dynamic>> materias) {
    if (materias.isEmpty) return const SizedBox.shrink();

    final promedio =
        materias.fold(
          0.0,
          (sum, m) => sum + ((m['nota_final'] ?? 0).toDouble()),
        ) /
        materias.length;
    final aprobadas =
        materias.where((m) => (m['nota_final'] ?? 0).toDouble() >= 60).length;
    final excelentes =
        materias.where((m) => (m['nota_final'] ?? 0).toDouble() >= 85).length;

    return Container(
      margin: const EdgeInsets.only(bottom: 20),
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.analytics_outlined, color: Colors.blue[700], size: 24),
              const SizedBox(width: 8),
              const Text(
                'Resumen Académico',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildStatItem(
                  'Promedio General',
                  promedio.toStringAsFixed(1),
                  Icons.grade,
                  _getColorByGrade(promedio),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildStatItem(
                  'Materias Aprobadas',
                  '$aprobadas/${materias.length}',
                  Icons.check_circle,
                  Colors.green[600]!,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildStatItem(
                  'Excelentes',
                  excelentes.toString(),
                  Icons.star,
                  Colors.amber[600]!,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(
    String title,
    String value,
    IconData icon,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.2), width: 1),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(height: 6),
          Text(
            title,
            style: TextStyle(
              fontSize: 11,
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 2),
          Text(
            value,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<PadreProvider>(context);
    final materias = provider.materiasHijo;

    return Scaffold(
      backgroundColor: Colors.grey[50],
      body:
          provider.isLoading
              ? const Center(child: CircularProgressIndicator())
              : materias.isEmpty
              ? _buildEmptyState()
              : SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Resumen estadístico
                    _buildStatsSummary(materias),

                    // Título de la sección
                    Row(
                      children: [
                        Icon(Icons.book, color: Colors.blue[700], size: 24),
                        const SizedBox(width: 8),
                        const Text(
                          'Materias',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const Spacer(),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.blue[50],
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: Colors.blue[200]!,
                              width: 1,
                            ),
                          ),
                          child: Text(
                            '${materias.length} materias',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.blue[700],
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // Lista de materias
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: materias.length,
                      itemBuilder: (context, index) {
                        return _buildMateriaCard(materias[index]);
                      },
                    ),

                    // Información adicional
                    if (materias.isNotEmpty) ...[
                      const SizedBox(height: 16),
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.blue[50],
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: Colors.blue[200]!,
                            width: 1,
                          ),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.info_outline,
                              color: Colors.blue[700],
                              size: 16,
                            ),
                            const SizedBox(width: 8),
                            const Expanded(
                              child: Text(
                                'Toca cualquier materia para ver el detalle completo de las calificaciones',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.black87,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ],
                ),
              ),
    );
  }
}
