import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';
import '../providers/padre_provider.dart';

class DashboardPadrePage extends StatefulWidget {
  final int alumnoId;
  final int gestionId;

  const DashboardPadrePage({
    super.key,
    required this.alumnoId,
    required this.gestionId,
  });

  @override
  State<DashboardPadrePage> createState() => _DashboardPadrePageState();
}

class _DashboardPadrePageState extends State<DashboardPadrePage> {
  @override
  void initState() {
    super.initState();
    _cargarDatos();
  }

  @override
  void didUpdateWidget(DashboardPadrePage oldWidget) {
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
      provider.cargarResumenDashboard();
      provider.cargarPrediccionRendimiento(widget.alumnoId, widget.gestionId);
    });
  }

  double _calcularPromedioReal(List<Map<String, dynamic>> predicciones) {
    if (predicciones.isEmpty) return 0.0;
    final total = predicciones.fold(
      0.0,
      (sum, m) => sum + (m['nota_final_real'] ?? 0.0),
    );
    return total / predicciones.length;
  }

  Widget _buildStatCard(
    String title,
    String value,
    IconData icon,
    Color color,
  ) {
    return Expanded(
      child: Container(
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
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: color, size: 28),
            const SizedBox(height: 8),
            Text(
              title,
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 4),
            Text(
              value,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGraficoNotaFinalComparada(List<Map<String, dynamic>> data) {
    if (data.isEmpty) {
      return Container(
        height: 200,
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
        child: const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.bar_chart, size: 48, color: Colors.grey),
              SizedBox(height: 16),
              Text(
                'No hay datos disponibles',
                style: TextStyle(color: Colors.grey, fontSize: 16),
              ),
            ],
          ),
        ),
      );
    }

    // Calculamos el ancho dinámico basado en la cantidad de materias
    final double chartWidth = (data.length * 80.0).clamp(
      400.0,
      double.infinity,
    );

    return Container(
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
              Icon(Icons.analytics, color: Colors.blue[700], size: 24),
              const SizedBox(width: 8),
              const Text(
                'Rendimiento: Real vs Predicho',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: 20),
          // Contenedor con scroll horizontal para el gráfico
          SizedBox(
            height: 400,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Container(
                width: chartWidth,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: BarChart(
                  BarChartData(
                    maxY: 100,
                    groupsSpace: 20,
                    barGroups:
                        data.asMap().entries.map((entry) {
                          final index = entry.key;
                          final item = entry.value;

                          final real =
                              (item['nota_final_real'] ?? 0).toDouble();
                          final predicho =
                              (item['nota_final_predicha'] ?? 0).toDouble();

                          return BarChartGroupData(
                            x: index,
                            barRods: [
                              BarChartRodData(
                                toY: real,
                                width: 20,
                                color: Colors.blue[600]!,
                                borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(6),
                                  topRight: Radius.circular(6),
                                ),
                              ),
                              BarChartRodData(
                                toY: predicho,
                                width: 20,
                                color: Colors.green[600]!,
                                borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(6),
                                  topRight: Radius.circular(6),
                                ),
                              ),
                            ],
                            barsSpace: 6,
                          );
                        }).toList(),
                    titlesData: FlTitlesData(
                      leftTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          reservedSize: 50,
                          interval: 10,
                          getTitlesWidget: (value, meta) {
                            return Padding(
                              padding: const EdgeInsets.only(right: 8),
                              child: Text(
                                value.toInt().toString(),
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          reservedSize: 80,
                          getTitlesWidget: (value, meta) {
                            final index = value.toInt();
                            if (index >= 0 && index < data.length) {
                              final materia = data[index]['materia'] ?? '';
                              return SideTitleWidget(
                                axisSide: meta.axisSide,
                                child: Padding(
                                  padding: const EdgeInsets.only(top: 8),
                                  child: Transform.rotate(
                                    angle: -0.3,
                                    child: Text(
                                      materia.length > 12
                                          ? '${materia.substring(0, 12)}...'
                                          : materia,
                                      style: const TextStyle(
                                        fontSize: 11,
                                        color: Colors.grey,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            }
                            return const SizedBox.shrink();
                          },
                        ),
                      ),
                      rightTitles: AxisTitles(
                        sideTitles: SideTitles(showTitles: false),
                      ),
                      topTitles: AxisTitles(
                        sideTitles: SideTitles(showTitles: false),
                      ),
                    ),
                    borderData: FlBorderData(
                      show: true,
                      border: Border(
                        left: BorderSide(color: Colors.grey[300]!, width: 1),
                        bottom: BorderSide(color: Colors.grey[300]!, width: 1),
                      ),
                    ),
                    gridData: FlGridData(
                      show: true,
                      drawVerticalLine: false,
                      horizontalInterval: 10,
                      getDrawingHorizontalLine: (value) {
                        return FlLine(
                          color: Colors.grey[200]!,
                          strokeWidth: 1,
                          dashArray: [5, 5],
                        );
                      },
                    ),
                    barTouchData: BarTouchData(
                      enabled: true,
                      touchTooltipData: BarTouchTooltipData(
                        tooltipBgColor: Colors.black87,
                        tooltipRoundedRadius: 8,
                        tooltipPadding: const EdgeInsets.all(8),
                        getTooltipItem: (group, groupIndex, rod, rodIndex) {
                          final materia = data[group.x]['materia'] ?? '';
                          final tipo = rodIndex == 0 ? 'Real' : 'Predicho';
                          final diferencia =
                              rodIndex == 0
                                  ? (data[group.x]['nota_final_real'] ?? 0)
                                          .toDouble() -
                                      (data[group.x]['nota_final_predicha'] ??
                                              0)
                                          .toDouble()
                                  : 0.0;

                          return BarTooltipItem(
                            '$materia\n$tipo: ${rod.toY.toStringAsFixed(1)}' +
                                (rodIndex == 0 && diferencia != 0
                                    ? '\nDif: ${diferencia > 0 ? "+" : ""}${diferencia.toStringAsFixed(1)}'
                                    : ''),
                            const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildLegendItem('Real', Colors.blue[600]!),
              const SizedBox(width: 24),
              _buildLegendItem('Predicho', Colors.green[600]!),
            ],
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.blue[50],
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.blue[200]!, width: 1),
            ),
            child: Row(
              children: [
                Icon(Icons.info_outline, color: Colors.blue[700], size: 16),
                const SizedBox(width: 8),
                const Expanded(
                  child: Text(
                    'Desliza horizontalmente para ver todas las materias',
                    style: TextStyle(fontSize: 12, color: Colors.black87),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLegendItem(String label, Color color) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 16,
          height: 16,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        const SizedBox(width: 6),
        Text(
          label,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<PadreProvider>(context);
    final resumen = provider.dashboardResumen;
    final predicciones = provider.prediccionNotas;

    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Cards de estadísticas
            Row(
              children: [
                _buildStatCard(
                  'Promedio\nGeneral',
                  predicciones.isNotEmpty
                      ? _calcularPromedioReal(predicciones).toStringAsFixed(1)
                      : resumen != null
                      ? '${resumen['promedio_general'] ?? 0}'
                      : '-',
                  Icons.grade,
                  Colors.orange[600]!,
                ),
                const SizedBox(width: 12),
                _buildStatCard(
                  'Total\nMaterias',
                  resumen != null ? '${resumen['total_materias'] ?? 0}' : '-',
                  Icons.book,
                  Colors.purple[600]!,
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                _buildStatCard(
                  'Total\nAsistencias',
                  resumen != null
                      ? '${resumen['total_asistencias'] ?? 0}'
                      : '-',
                  Icons.check_circle,
                  Colors.green[600]!,
                ),
                const SizedBox(width: 12),
                _buildStatCard(
                  'Total\nParticipaciones',
                  resumen != null
                      ? '${resumen['total_participaciones'] ?? 0}'
                      : '-',
                  Icons.forum,
                  Colors.blue[600]!,
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Gráfico de comparación
            _buildGraficoNotaFinalComparada(predicciones),
          ],
        ),
      ),
    );
  }
}
