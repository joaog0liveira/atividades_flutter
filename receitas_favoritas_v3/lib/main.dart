import 'package:flutter/material.dart';
import 'package:receitas_favoritas_v3/screens/cadastro.dart';
import 'package:receitas_favoritas_v3/screens/home.dart';
import 'package:receitas_favoritas_v3/screens/login.dart';

void main() => runApp(const ReceitasApp());

class ReceitasApp extends StatelessWidget {
  const ReceitasApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Receitas',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorSchemeSeed: Colors.deepPurpleAccent,
        useMaterial3: true,
      ),
      home: const LoginPage(),
      routes: {
        '/cadastro': (_) => const CadastroPage(),
        '/home': (_) => const HomeScreen(),
      },
    );
  }
}
