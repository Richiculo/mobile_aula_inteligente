import 'package:flutter/material.dart';
import 'package:mobile_aula_inteligente/pages/login_page.dart';
import 'package:provider/provider.dart';
import 'package:mobile_aula_inteligente/providers/auth_provider.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [ChangeNotifierProvider(create: (_) => AuthProvider())],
      child: MaterialApp(
        title: 'Aula Inteligente App',
        theme: ThemeData(primarySwatch: Colors.indigo, useMaterial3: true),
        home: LoginPage(),
      ),
    );
  }
}
