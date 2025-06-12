import 'package:flutter/material.dart';
import './dashboard_alumno_page.dart';
import './alumno_materias_page.dart';
import './escanear_qr_page.dart';
import '../providers/auth_provider.dart';
import 'package:provider/provider.dart';

class AlumnoMainPage extends StatefulWidget {
  const AlumnoMainPage({super.key});

  @override
  State<AlumnoMainPage> createState() => _AlumnoMainPageState();
}

class _AlumnoMainPageState extends State<AlumnoMainPage> {
  int _selectedIndex = 0;

  final List<Widget> _pages = const [
    DashboardAlumnoPage(),
    AlumnoMateriasPage(),
    EscanearQrPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Aula Inteligente'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              final authProvider = Provider.of<AuthProvider>(
                context,
                listen: false,
              );
              await authProvider.logout();

              if (!context.mounted) return;
              Navigator.pushNamedAndRemoveUntil(context, '/', (_) => false);
            },
          ),
        ],
      ),
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (i) => setState(() => _selectedIndex = i),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard),
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.book), label: 'Materias'),
          BottomNavigationBarItem(
            icon: Icon(Icons.qr_code_scanner),
            label: 'Asistencias',
          ),
        ],
      ),
    );
  }
}
