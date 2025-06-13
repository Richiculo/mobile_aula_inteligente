import 'package:flutter/widgets.dart';
import '../services/alumno_services.dart';

class AlumnoProvider with ChangeNotifier {
  final AlumnoServices _alumnoServices = AlumnoServices();

  List<Map<String, dynamic>> _alumnos = [];
  bool _loading = false;

  List<Map<String, dynamic>> get alumnos => _alumnos;
  bool get isLoading => _loading;

  int? _materiaIdActual;
  int? _gestionCursoIdActual;

  List<Map<String, dynamic>> _materias = [];
  List<Map<String, dynamic>> get materias => _materias;

  List<Map<String, dynamic>> _prediccionNotas = [];
  List<Map<String, dynamic>> get prediccionNotas => _prediccionNotas;

  int? _gestionSeleccionada;

  int? get gestionSeleccionada => _gestionSeleccionada;

  void setGestionSeleccionada(int? id) {
    _gestionSeleccionada = id;
    notifyListeners();
  }

  void setContextoNota({required int materiaId, required int gestionCursoId}) {
    _materiaIdActual = materiaId;
    _gestionCursoIdActual = gestionCursoId;
  }

  Future<void> cargarAlumnos(int mgcId) async {
    assert(_gestionSeleccionada != null, 'Falta gestión seleccionada');
    _loading = true;
    notifyListeners();

    final data = await _alumnoServices.getAlumnosPorMateria(mgcId);
    if (data != null) {
      for (var alumno in data) {
        if (_materiaIdActual != null && _gestionCursoIdActual != null) {
          final nota = await _alumnoServices.getNotaAlumno(
            alumnoId: alumno['id'],
            materiaId: _materiaIdActual!,
            gestionCursoId: _gestionCursoIdActual!,
            gestionId: _gestionSeleccionada!,
          );

          if (nota != null) {
            alumno['nota_final'] = nota['nota_final'];
            alumno['ser'] = nota['ser'];
            alumno['saber'] = nota['saber'];
            alumno['hacer'] = nota['hacer'];
            alumno['decidir'] = nota['decidir'];
          }
        }
      }

      _alumnos = data;
    }

    _loading = false;
    notifyListeners();
  }

  Future<bool> calificarAlumno({
    required int alumnoId,
    required int materiaId,
    required int gestionCursoId,
    double? ser,
    double? saber,
    double? hacer,
    double? decidir,
    double? notaFinal,
  }) async {
    _loading = true;
    notifyListeners();

    final success = await _alumnoServices.calificarAlumno(
      alumnoId: alumnoId,
      materiaId: materiaId,
      gestionCursoId: gestionCursoId,
      ser: ser,
      saber: saber,
      hacer: hacer,
      decidir: decidir,
      notaFinal: notaFinal,
    );

    _loading = false;
    notifyListeners();

    return success;
  }

  Future<bool> registrarAsistencia({
    required int alumnoId,
    required int materiaId,
    required int gestionCursoId,
    required DateTime fecha,
    required bool asistio,
  }) async {
    return await _alumnoServices.registrarAsistencia(
      alumnoId: alumnoId,
      materiaId: materiaId,
      gestionCursoId: gestionCursoId,
      fecha: fecha,
      asistio: asistio,
    );
  }

  Future<bool> registrarParticipacion({
    required int alumnoId,
    required int materiaId,
    required int gestionCursoId,
    required DateTime fecha,
    required String descripcion,
  }) async {
    return await _alumnoServices.registrarParticipacion(
      alumnoId: alumnoId,
      materiaId: materiaId,
      gestionCursoId: gestionCursoId,
      fecha: fecha,
      descripcion: descripcion,
    );
  }

  Future<Map<String, dynamic>?> obtenerNotaDeAlumno({
    required int alumnoId,
    required int materiaId,
    required int gestionCursoId,
    required int gestionId,
  }) async {
    return await _alumnoServices.getNotaAlumno(
      alumnoId: alumnoId,
      materiaId: materiaId,
      gestionCursoId: gestionCursoId,
      gestionId: gestionId,
    );
  }

  Future<void> cargarMisMaterias(int gestionId) async {
    _loading = true;
    notifyListeners();

    final data = await _alumnoServices.getMisMaterias(gestionId);
    if (data != null) {
      _materias = data;
    }
    _loading = false;
    notifyListeners();
  }

  Future<Map<String, dynamic>?> obtenerNotasDetalle(
    int materiaId,
    int gestionCursoId,
  ) {
    return _alumnoServices.getNotasDetalle(materiaId, gestionCursoId);
  }

  Future<List<Map<String, dynamic>>?> obtenerAsistencias(
    int materiaId,
    int gestionCursoId,
  ) {
    return _alumnoServices.getAsistencias(materiaId, gestionCursoId);
  }

  Future<List<Map<String, dynamic>>?> obtenerParticipaciones(
    int materiaId,
    int gestionCursoId,
  ) {
    return _alumnoServices.getParticipaciones(materiaId, gestionCursoId);
  }

  Map<String, dynamic>? _resumenDashboard;
  Map<String, dynamic>? get resumenDashboard => _resumenDashboard;

  Future<void> cargarResumenDashboard() async {
    if (_gestionSeleccionada == null) return;

    final data = await _alumnoServices.getResumenDashboard(
      _gestionSeleccionada!,
    );
    if (data != null) {
      _resumenDashboard = data;
      notifyListeners();
    }
  }

  Future<void> cargarPrediccionRendimiento(int gestionId) async {
    _loading = true;
    notifyListeners();
    final data = await _alumnoServices.getPrediccionRendimiento(gestionId);
    if (data != null) {
      _prediccionNotas = data;
    }
    _loading = false;
    notifyListeners();
  }

  Future<bool> registrarAsistenciaConQr(String qrData) async {
    return await _alumnoServices.registrarAsistenciaConQr(qrData);
  }
}
