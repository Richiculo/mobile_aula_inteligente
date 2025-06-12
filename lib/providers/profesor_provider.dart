import '../services/profesor_service.dart';
import 'package:flutter/widgets.dart';

class ProfesorProvider with ChangeNotifier {
  final ProfesorService _profesorService = ProfesorService();

  List<Map<String, dynamic>> _materias = [];
  bool _loading = false;

  List<Map<String, dynamic>> get materias => _materias;
  bool get isLoading => _loading;

  int? _gestionSeleccionada;

  int? get gestionSeleccionada => _gestionSeleccionada;

  Map<String, dynamic>? dashboardData;
  List<dynamic> rendimientoPredicho = [];

  String? _qrData;
  String? get qrData => _qrData;

  void setGestionSeleccionada(int? id) {
    _gestionSeleccionada = id;
    notifyListeners();
  }

  Future<void> cargarMaterias(gestionId) async {
    _loading = true;
    notifyListeners();

    final data = await _profesorService.getMateriasDocente(gestionId);
    if (data != null) {
      _materias = data;
    }

    _loading = false;
    notifyListeners();
  }

  Future<void> cargarDashboard({int? cursoId}) async {
    _loading = true;
    notifyListeners();

    dashboardData = await _profesorService.obtenerDashboardGeneral();

    if (gestionSeleccionada != null && cursoId != null) {
      rendimientoPredicho = await _profesorService.obtenerRendimientoPredicho(
        gestionSeleccionada!,
        cursoId,
      );
    }

    _loading = false;
    notifyListeners();
  }

  Future<void> cargarQrAsistencia({
    required int materiaId,
    required int gestionCursoId,
  }) async {
    _qrData = await _profesorService.generarQrAsistencia(
      materiaId: materiaId,
      gestionCursoId: gestionCursoId,
    );
    notifyListeners();
  }
}
