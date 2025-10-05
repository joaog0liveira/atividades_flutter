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
  List<Receita> _receitas = List.from(receitasIniciais);

  void _onTabChange(int i) => setState(() => _abaAtual = i);

  void _adicionarReceita(Receita receita) {
    setState(() {
      _receitas.add(receita);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Receita adicionada com sucesso!')),
    );
  }

  void _editarReceita(Receita receitaAntiga, Receita receitaNova) {
    setState(() {
      final idx = _receitas.indexWhere((r) => r.id == receitaAntiga.id);
      if (idx != -1) {
        _receitas[idx] = receitaNova;
      }
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Receita atualizada com sucesso!')),
    );
  }

  void _removerReceita(Receita receita) {
    final idx = _receitas.indexOf(receita);
    setState(() {
      _receitas.remove(receita);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${receita.titulo} removida'),
        action: SnackBarAction(
          label: 'Desfazer',
          onPressed: () {
            setState(() {
              _receitas.insert(idx, receita);
            });
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final pages = [
      CategoriaPage(
        titulo: Categoria.doces.label,
        categoria: Categoria.doces,
        receitas: _receitas,
        onRemover: _removerReceita,
        onEditar: _editarReceita,
        key: const PageStorageKey('doces'),
      ),
      CategoriaPage(
        titulo: Categoria.salgadas.label,
        categoria: Categoria.salgadas,
        receitas: _receitas,
        onRemover: _removerReceita,
        onEditar: _editarReceita,
        key: const PageStorageKey('salgadas'),
      ),
      CategoriaPage(
        titulo: Categoria.bebidas.label,
        categoria: Categoria.bebidas,
        receitas: _receitas,
        onRemover: _removerReceita,
        onEditar: _editarReceita,
        key: const PageStorageKey('bebidas'),
      ),
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('Receitas Favoritas')),
      drawer: const AppDrawer(),
      body: IndexedStack(index: _abaAtual, children: pages),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final novaReceita = await Navigator.push<Receita>(
            context,
            MaterialPageRoute(
              builder: (_) => FormularioReceitaPage(
                categoriaInicial: Categoria.values[_abaAtual],
              ),
            ),
          );
          if (novaReceita != null) {
            _adicionarReceita(novaReceita);
          }
        },
        child: const Icon(Icons.add),
      ),
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
  final List<Receita> receitas;
  final Function(Receita) onRemover;
  final Function(Receita, Receita) onEditar;

  const CategoriaPage({
    super.key,
    required this.titulo,
    required this.categoria,
    required this.receitas,
    required this.onRemover,
    required this.onEditar,
  });

  @override
  Widget build(BuildContext context) {
    final lista = receitas.where((r) => r.categoria == categoria).toList();

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(titulo, style: Theme.of(context).textTheme.headlineMedium),
          const SizedBox(height: 12),
          if (lista.isEmpty)
            Center(
              child: Padding(
                padding: const EdgeInsets.all(32),
                child: Text(
                  'Nenhuma receita nesta categoria',
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              ),
            )
          else
            for (final r in lista) ...[
              Dismissible(
                key: Key(r.id),
                background: Container(
                  color: Colors.red,
                  alignment: Alignment.centerRight,
                  padding: const EdgeInsets.only(right: 20),
                  child: const Icon(Icons.delete, color: Colors.white),
                ),
                direction: DismissDirection.endToStart,
                onDismissed: (_) => onRemover(r),
                child: ReceitaCard(
                  receita: r,
                  onEditar: onEditar,
                ),
              ),
              const SizedBox(height: 8),
            ],
        ],
      ),
    );
  }
}

class ReceitaCard extends StatelessWidget {
  final Receita receita;
  final Function(Receita, Receita) onEditar;

  const ReceitaCard({
    super.key,
    required this.receita,
    required this.onEditar,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1,
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => Navigator.of(context).pushNamed(
          DetalhesReceitaPage.routeName,
          arguments: receita,
        ),
        onLongPress: () async {
          final receitaEditada = await Navigator.push<Receita>(
            context,
            MaterialPageRoute(
              builder: (_) => FormularioReceitaPage(
                receitaParaEditar: receita,
              ),
            ),
          );
          if (receitaEditada != null) {
            onEditar(receita, receitaEditada);
          }
        },
        child: Row(
          children: [
            Container(
              width: 96,
              height: 96,
              color: Theme.of(context).colorScheme.primary,
              alignment: Alignment.center,
              child: Icon(receita.categoria.icon, size: 36, color: Colors.white),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 4),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      receita.titulo,
                      style: Theme.of(context).textTheme.titleMedium,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 6),
                    Text(
                      receita.descricaoBreve,
                      style: Theme.of(context).textTheme.bodyMedium,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Icon(Icons.arrow_forward, size: 16),
                        const SizedBox(width: 4),
                        Text(
                          'ver detalhes',
                          style: Theme.of(context).textTheme.labelMedium,
                        ),
                        const Spacer(),
                        Icon(
                          Icons.edit,
                          size: 16,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          'manter pressionado',
                          style: Theme.of(context).textTheme.labelSmall,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 8),
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
                    CircleAvatar(
                      radius: 12,
                      child: Text('${idx + 1}', style: const TextStyle(fontSize: 12)),
                    ),
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

class FormularioReceitaPage extends StatefulWidget {
  final Receita? receitaParaEditar;
  final Categoria? categoriaInicial;

  const FormularioReceitaPage({
    super.key,
    this.receitaParaEditar,
    this.categoriaInicial,
  });

  @override
  State<FormularioReceitaPage> createState() => _FormularioReceitaPageState();
}

class _FormularioReceitaPageState extends State<FormularioReceitaPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _tituloCtrl;
  late TextEditingController _descricaoCtrl;
  late TextEditingController _imagemCtrl;
  late Categoria _categoria;
  final List<TextEditingController> _ingredientesCtrl = [];
  final List<TextEditingController> _preparoCtrl = [];

  @override
  void initState() {
    super.initState();
    final r = widget.receitaParaEditar;
    _tituloCtrl = TextEditingController(text: r?.titulo ?? '');
    _descricaoCtrl = TextEditingController(text: r?.descricaoBreve ?? '');
    _imagemCtrl = TextEditingController(text: r?.imagem ?? '');
    _categoria = r?.categoria ?? widget.categoriaInicial ?? Categoria.doces;

    if (r != null) {
      for (final ing in r.ingredientes) {
        _ingredientesCtrl.add(TextEditingController(text: ing));
      }
      for (final prep in r.preparo) {
        _preparoCtrl.add(TextEditingController(text: prep));
      }
    } else {
      _ingredientesCtrl.add(TextEditingController());
      _preparoCtrl.add(TextEditingController());
    }
  }

  @override
  void dispose() {
    _tituloCtrl.dispose();
    _descricaoCtrl.dispose();
    _imagemCtrl.dispose();
    for (final c in _ingredientesCtrl) {
      c.dispose();
    }
    for (final c in _preparoCtrl) {
      c.dispose();
    }
    super.dispose();
  }

  void _salvar() {
    if (_formKey.currentState!.validate()) {
      final ingredientes = _ingredientesCtrl
          .map((c) => c.text.trim())
          .where((t) => t.isNotEmpty)
          .toList();
      final preparo = _preparoCtrl
          .map((c) => c.text.trim())
          .where((t) => t.isNotEmpty)
          .toList();

      final receita = Receita(
        id: widget.receitaParaEditar?.id ?? DateTime.now().millisecondsSinceEpoch.toString(),
        titulo: _tituloCtrl.text.trim(),
        descricaoBreve: _descricaoCtrl.text.trim(),
        ingredientes: ingredientes,
        preparo: preparo,
        categoria: _categoria,
        imagem: _imagemCtrl.text.trim().isEmpty ? null : _imagemCtrl.text.trim(),
      );

      Navigator.pop(context, receita);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEdicao = widget.receitaParaEditar != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(isEdicao ? 'Editar Receita' : 'Nova Receita'),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            TextFormField(
              controller: _tituloCtrl,
              decoration: const InputDecoration(
                labelText: 'Título',
                border: OutlineInputBorder(),
              ),
              validator: (v) => v == null || v.trim().isEmpty ? 'Campo obrigatório' : null,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _descricaoCtrl,
              decoration: const InputDecoration(
                labelText: 'Descrição breve',
                border: OutlineInputBorder(),
              ),
              maxLines: 2,
              validator: (v) => v == null || v.trim().isEmpty ? 'Campo obrigatório' : null,
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<Categoria>(
              value: _categoria,
              decoration: const InputDecoration(
                labelText: 'Categoria',
                border: OutlineInputBorder(),
              ),
              items: Categoria.values.map((c) {
                return DropdownMenuItem(
                  value: c,
                  child: Row(
                    children: [
                      Icon(c.icon, size: 20),
                      const SizedBox(width: 8),
                      Text(c.label),
                    ],
                  ),
                );
              }).toList(),
              onChanged: (v) => setState(() => _categoria = v!),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _imagemCtrl,
              decoration: const InputDecoration(
                labelText: 'URL da imagem (opcional)',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Ingredientes', style: Theme.of(context).textTheme.titleLarge),
                IconButton(
                  icon: const Icon(Icons.add_circle),
                  onPressed: () {
                    setState(() {
                      _ingredientesCtrl.add(TextEditingController());
                    });
                  },
                ),
              ],
            ),
            const SizedBox(height: 8),
            for (int i = 0; i < _ingredientesCtrl.length; i++)
              Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _ingredientesCtrl[i],
                        decoration: InputDecoration(
                          labelText: 'Ingrediente ${i + 1}',
                          border: const OutlineInputBorder(),
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.remove_circle, color: Colors.red),
                      onPressed: _ingredientesCtrl.length > 1
                          ? () {
                        setState(() {
                          _ingredientesCtrl[i].dispose();
                          _ingredientesCtrl.removeAt(i);
                        });
                      }
                          : null,
                    ),
                  ],
                ),
              ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Modo de Preparo', style: Theme.of(context).textTheme.titleLarge),
                IconButton(
                  icon: const Icon(Icons.add_circle),
                  onPressed: () {
                    setState(() {
                      _preparoCtrl.add(TextEditingController());
                    });
                  },
                ),
              ],
            ),
            const SizedBox(height: 8),
            for (int i = 0; i < _preparoCtrl.length; i++)
              Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _preparoCtrl[i],
                        decoration: InputDecoration(
                          labelText: 'Passo ${i + 1}',
                          border: const OutlineInputBorder(),
                        ),
                        maxLines: 2,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.remove_circle, color: Colors.red),
                      onPressed: _preparoCtrl.length > 1
                          ? () {
                        setState(() {
                          _preparoCtrl[i].dispose();
                          _preparoCtrl.removeAt(i);
                        });
                      }
                          : null,
                    ),
                  ],
                ),
              ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: _salvar,
              icon: const Icon(Icons.save),
              label: Text(isEdicao ? 'Salvar Alterações' : 'Adicionar Receita'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.all(16),
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
              child: Icon(Icons.person, size: 40),
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
              'By: João Gabriel\n\n'
              'Funcionalidades:\n'
              '• Visualizar receitas por categoria\n'
              '• Adicionar novas receitas\n'
              '• Editar receitas (pressionar e segurar)\n'
              '• Remover receitas (deslizar para a esquerda)',
          style: Theme.of(context).textTheme.bodyLarge,
        ),
      ),
    );
  }
}
