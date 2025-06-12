import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../providers/padre_provider.dart';
import './dashboard_padre_page.dart';
import './padre_materias_hijo_page.dart';

class PadreMainPage extends StatefulWidget {
  const PadreMainPage({super.key});

  @override
  State<PadreMainPage> createState() => _PadreMainPageState();
}

class _PadreMainPageState extends State<PadreMainPage> {
  int _selectedIndex = 0;
  int? _alumnoId;
  int? _gestionId;

  final List<Map<String, dynamic>> gestiones = [
    {'id': 1, 'nombre': '1-2024'},
    {'id': 2, 'nombre': '2-2024'},
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final provider = Provider.of<PadreProvider>(context, listen: false);
      await provider.cargarHijos();
      if (provider.hijos.isNotEmpty) {
        setState(() {
          _alumnoId = provider.hijos.first['id'];
          _gestionId = gestiones.first['id'];
        });
      }
    });
  }

  void _onDropdownChanged() {
    // Forzar la actualización de las páginas cuando cambien los dropdowns
    setState(() {
      // Solo necesitamos setState para reconstruir las páginas
    });
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final padreProvider = Provider.of<PadreProvider>(context);

    // Reconstruir las páginas cada vez que cambien los IDs
    final pages = [
      if (_alumnoId != null && _gestionId != null)
        DashboardPadrePage(
          key: ValueKey(
            'dashboard_${_alumnoId}_$_gestionId',
          ), // Key única para forzar reconstrucción
          alumnoId: _alumnoId!,
          gestionId: _gestionId!,
        )
      else
        const Center(child: CircularProgressIndicator()),
      if (_alumnoId != null && _gestionId != null)
        DetalleMateriasHijoPage(
          key: ValueKey(
            'materias_${_alumnoId}_$_gestionId',
          ), // Key única para forzar reconstrucción
          alumnoId: _alumnoId!,
          gestionId: _gestionId!,
        )
      else
        const Center(child: CircularProgressIndicator()),
    ];

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text(
          'Aula Inteligente - Padre',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await authProvider.logout();
              if (!context.mounted) return;
              Navigator.pushNamedAndRemoveUntil(context, '/', (_) => false);
            },
          ),
        ],
        bottom:
            padreProvider.hijos.isEmpty
                ? PreferredSize(
                  preferredSize: const Size.fromHeight(1.0),
                  child: Container(color: Colors.grey[200], height: 1.0),
                )
                : PreferredSize(
                  preferredSize: const Size.fromHeight(160),
                  child: Container(
                    color: Colors.white,
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.grey[50],
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Colors.grey[200]!),
                          ),
                          child: DropdownButtonFormField<int>(
                            value: _alumnoId,
                            decoration: const InputDecoration(
                              labelText: 'Seleccionar hijo',
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 12,
                              ),
                            ),
                            items:
                                padreProvider.hijos.map((hijo) {
                                  return DropdownMenuItem<int>(
                                    value: hijo['id'],
                                    child: Text(
                                      '${hijo['nombre']} ${hijo['apellidos']}',
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  );
                                }).toList(),
                            onChanged: (value) {
                              setState(() {
                                _alumnoId = value;
                              });
                              _onDropdownChanged(); // Actualizar páginas
                            },
                          ),
                        ),
                        const SizedBox(height: 12),
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.grey[50],
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Colors.grey[200]!),
                          ),
                          child: DropdownButtonFormField<int>(
                            value: _gestionId,
                            decoration: const InputDecoration(
                              labelText: 'Seleccionar gestión',
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 12,
                              ),
                            ),
                            items:
                                gestiones.map((g) {
                                  return DropdownMenuItem<int>(
                                    value: g['id'],
                                    child: Text(
                                      g['nombre'],
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  );
                                }).toList(),
                            onChanged: (value) {
                              setState(() {
                                _gestionId = value;
                              });
                              _onDropdownChanged(); // Actualizar páginas
                            },
                          ),
                        ),
                        const SizedBox(height: 8),
                        Container(height: 1, color: Colors.grey[200]),
                      ],
                    ),
                  ),
                ),
      ),
      body: pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (i) => setState(() => _selectedIndex = i),
        backgroundColor: Colors.white,
        selectedItemColor: Colors.blue[700],
        unselectedItemColor: Colors.grey[600],
        type: BottomNavigationBarType.fixed,
        elevation: 8,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard),
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.book), label: 'Materias'),
        ],
      ),
    );
  }
}
