import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'profesor_materias_page.dart';
import 'dashboard_profesor_page.dart';
import './qr_asistencia_page.dart';
import '../providers/profesor_provider.dart';

class ProfesorMainPage extends StatefulWidget {
  const ProfesorMainPage({super.key});

  @override
  State<ProfesorMainPage> createState() => _ProfesorMainPageState();
}

class _ProfesorMainPageState extends State<ProfesorMainPage> {
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = Provider.of<ProfesorProvider>(context, listen: false);
      provider.cargarMaterias(1); // Gestión por defecto
    });
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final profesorProvider = Provider.of<ProfesorProvider>(context);

    if (profesorProvider.materias.isEmpty) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final int materiaId = profesorProvider.materias.first['materia'];

    final List<Widget> _screens = [
      const ProfesorMateriasPage(),
      const DashboardProfesorPage(),
      QrAsistenciaPage(materiaId: materiaId),
    ];

    return Scaffold(
      body: _screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedItemColor: Colors.blueAccent,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.menu_book),
            label: 'Materias',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard),
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.qr_code_2),
            label: 'Asistencia',
          ),
        ],
      ),
    );
  }
}
