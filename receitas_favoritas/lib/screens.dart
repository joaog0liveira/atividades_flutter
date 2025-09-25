import 'package:flutter/material.dart';

import 'models/models_data.dart';

class ReceitasApp extends StatelessWidget {
  const ReceitasApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Receitas',
      theme: ThemeData(
        colorSchemeSeed: Colors.deepPurpleAccent,
        useMaterial3: true,
      ),
      home: const HomeScreen(),
      routes: {
        SettingsPage.routeName: (_) => const SettingsPage(),
        AboutPage.routeName: (_) => const AboutPage(),
      },
      onGenerateRoute: (settings) {
        if (settings.name == DetalhesReceitaPage.routeName) {
          final r = settings.arguments as Receita;
          return MaterialPageRoute(
            builder: (_) => DetalhesReceitaPage(receita: r),
            settings: settings,
          );
        }
        return null;
      },
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _abaAtual = 0;
  void _onTabChange(int i) => setState(() => _abaAtual = i);

  @override
  Widget build(BuildContext context) {
    final pages = [
      CategoriaPage(titulo: Categoria.doces.label, categoria: Categoria.doces, key: const PageStorageKey('doces')),
      CategoriaPage(titulo: Categoria.salgadas.label, categoria: Categoria.salgadas, key: const PageStorageKey('salgadas')),
      CategoriaPage(titulo: Categoria.bebidas.label, categoria: Categoria.bebidas, key: const PageStorageKey('bebidas')),
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('Receitas Favoritas')),
      drawer: const AppDrawer(),
      body: IndexedStack(index: _abaAtual, children: pages),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _abaAtual,
        onTap: _onTabChange,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.cookie_outlined), label: 'Doces'),
          BottomNavigationBarItem(icon: Icon(Icons.restaurant_menu), label: 'Salgadas'),
          BottomNavigationBarItem(icon: Icon(Icons.local_drink_outlined), label: 'Bebidas'),
        ],
      ),
    );
  }
}

class CategoriaPage extends StatelessWidget {
  final String titulo;
  final Categoria categoria;
  const CategoriaPage({super.key, required this.titulo, required this.categoria});

  @override
  Widget build(BuildContext context) {
    final lista = receitas.where((r) => r.categoria == categoria).take(3).toList();

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(titulo, style: Theme.of(context).textTheme.headlineMedium),
          const SizedBox(height: 12),
          for (final r in lista) ...[
            ReceitaCard(receita: r),
            const SizedBox(height: 8),
          ],
        ],
      ),
    );
  }
}

class ReceitaCard extends StatelessWidget {
  final Receita receita;
  const ReceitaCard({super.key, required this.receita});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1,
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => Navigator.of(context).pushNamed(DetalhesReceitaPage.routeName, arguments: receita),
        child: Row(
          children: [
            Container(
              width: 96,
              height: 96,
              color: Theme.of(context).colorScheme.primary,
              alignment: Alignment.center,
              child: Icon(receita.categoria.icon, size: 36),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 4),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(receita.titulo, style: Theme.of(context).textTheme.titleMedium, maxLines: 1, overflow: TextOverflow.ellipsis),
                    const SizedBox(height: 6),
                    Text(receita.descricaoBreve, style: Theme.of(context).textTheme.bodyMedium, maxLines: 2, overflow: TextOverflow.ellipsis),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Icon(Icons.arrow_forward, size: 16),
                        const SizedBox(width: 4),
                        Text('ver detalhes', style: Theme.of(context).textTheme.labelMedium),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class DetalhesReceitaPage extends StatelessWidget {
  static const routeName = '/detalhes';
  final Receita receita;
  const DetalhesReceitaPage({super.key, required this.receita});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(receita.titulo)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (receita.imagem != null)
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(receita.imagem!, fit: BoxFit.cover),
              ),
            if (receita.imagem != null) const SizedBox(height: 16),
            Text(receita.descricaoBreve, style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 16),
            Text('Ingredientes', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 8),
            for (final i in receita.ingredientes)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [const Text('•  '), Expanded(child: Text(i))],
                ),
              ),
            const SizedBox(height: 16),
            Text('Modo de preparo', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 8),
            for (int idx = 0; idx < receita.preparo.length; idx++)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 6),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CircleAvatar(radius: 12, child: Text('${idx + 1}', style: const TextStyle(fontSize: 12))),
                    const SizedBox(width: 8),
                    Expanded(child: Text(receita.preparo[idx])),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Column(
            children: [
              DrawerHeader(
                decoration: BoxDecoration(color: Theme.of(context).colorScheme.primaryContainer),
                child: Align(
                  alignment: Alignment.bottomLeft,
                  child: Text('Menu', style: Theme.of(context).textTheme.headlineSmall),
                ),
              ),
              ListTile(
                leading: const Icon(Icons.settings),
                title: const Text('Configurações'),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.pushNamed(context, SettingsPage.routeName);
                },
              ),
              ListTile(
                leading: const Icon(Icons.info_outline),
                title: const Text('Sobre'),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.pushNamed(context, AboutPage.routeName);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class SettingsPage extends StatelessWidget {
  static const routeName = '/settings';
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Perfil')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const CircleAvatar(
              radius: 40,
              backgroundImage: AssetImage(
                  'assets/images/icon.jpg'
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'João Gabriel',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 24),

            ListTile(
              leading: const Icon(Icons.person_outline),
              title: const Text('Editar Perfil'),
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Editar perfil')),
                );
              },
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.logout, color: Colors.red),
              title: const Text('Sair'),
            ),
          ],
        ),
      ),
    );
  }
}

class AboutPage extends StatelessWidget {
  static const routeName = '/about';
  const AboutPage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Sobre')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Text(
          'App de Receitas Favoritas\n\n'
              'By: João Gabriel',
          style: Theme.of(context).textTheme.bodyLarge,
        ),
      ),
    );
  }
}
