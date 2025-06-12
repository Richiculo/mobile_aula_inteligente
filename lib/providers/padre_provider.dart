import 'package:flutter/material.dart';
import '../services/padre_service.dart';

class PadreProvider with ChangeNotifier {
  final PadreService _service = PadreService();

  Map<String, dynamic>? _dashboardData;
  Map<String, dynamic>? get dashboardData => _dashboardData;

  List<Map<String, dynamic>> _materiasHijo = [];
  List<Map<String, dynamic>> get materiasHijo => _materiasHijo;

  Map<String, dynamic>? _notaDetalle;
  Map<String, dynamic>? get notaDetalle => _notaDetalle;

  List<Map<String, dynamic>> _hijos = [];
  List<Map<String, dynamic>> get hijos => _hijos;

  List<Map<String, dynamic>> _asistenciasHijo = [];
  List<Map<String, dynamic>> get asistenciasHijo => _asistenciasHijo;

  List<Map<String, dynamic>> _participacionesHijo = [];
  List<Map<String, dynamic>> get participacionesHijo => _participacionesHijo;

  bool _loading = false;
  bool get isLoading => _loading;

  Future<void> cargarMateriasHijo(int alumnoId, int gestionId) async {
    _loading = true;
    notifyListeners();

    final data = await _service.getMateriasHijo(
      alumnoId: alumnoId,
      gestionId: gestionId,
    );

    if (data != null) {
      for (var materia in data) {
        final nota = await _service.getNotaHijo(
          alumnoId: alumnoId,
          materiaId: materia['materia_id'],
          gestionCursoId: materia['gestion_curso_id'],
        );

        if (nota != null) {
          materia['ser'] = nota['ser'];
          materia['saber'] = nota['saber'];
          materia['hacer'] = nota['hacer'];
          materia['decidir'] = nota['decidir'];
          materia['nota_final'] = nota['nota_final'];
        } else {
          materia['ser'] = null;
          materia['saber'] = null;
          materia['hacer'] = null;
          materia['decidir'] = null;
          materia['nota_final'] = null;
        }
      }

      _materiasHijo = data;
    }

    _loading = false;
    notifyListeners();
  }

  Future<void> cargarNotaHijo({
    required int alumnoId,
    required int materiaId,
    required int gestionCursoId,
  }) async {
    _notaDetalle = await _service.getNotaHijo(
      alumnoId: alumnoId,
      materiaId: materiaId,
      gestionCursoId: gestionCursoId,
    );
    notifyListeners();
  }

  Future<void> cargarHijos() async {
    _loading = true;
    notifyListeners();

    final data = await _service.getHijos();
    if (data != null) {
      _hijos = data;
    }

    _loading = false;
    notifyListeners();
  }

  Map<String, dynamic>? _dashboardResumen;
  List<Map<String, dynamic>> _prediccionNotas = [];

  Map<String, dynamic>? get dashboardResumen => _dashboardResumen;
  List<Map<String, dynamic>> get prediccionNotas => _prediccionNotas;

  Future<void> cargarResumenDashboard() async {
    final data = await _service.getResumenDashboardPadre();
    if (data != null) {
      _dashboardResumen = data;
      notifyListeners();
    }
  }

  Future<void> cargarPrediccionRendimiento(int alumnoId, int gestionId) async {
    final data = await _service.getPrediccionRendimientoPadre(
      alumnoId,
      gestionId,
    );
    if (data != null) {
      _prediccionNotas = data;
      notifyListeners();
    }
  }

  Future<void> obtenerAsistenciasHijo(
    int alumnoId,
    int materiaId,
    int gestionCursoId,
  ) async {
    final data = await _service.getAsistencias(
      alumnoId,
      materiaId,
      gestionCursoId,
    );
    if (data != null) _asistenciasHijo = data;
    notifyListeners();
  }

  Future<void> obtenerParticipacionesHijo(
    int alumnoId,
    int materiaId,
    int gestionCursoId,
  ) async {
    final data = await _service.getParticipaciones(
      alumnoId,
      materiaId,
      gestionCursoId,
    );
    if (data != null) _participacionesHijo = data;
    notifyListeners();
  }
}
