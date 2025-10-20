import 'package:flutter/material.dart';

import '../models/db.dart';
import '../models/models.dart';
import 'detalhes.dart';
import 'formulario.dart';

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

  void _toggleFavorito(Receita receita) {
    setState(() {
      final idx = _receitas.indexOf(receita);
      _receitas[idx] = receita.copyWith(isFavorita: !receita.isFavorita);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          receita.isFavorita
              ? '${receita.titulo} removida dos favoritos'
              : '${receita.titulo} adicionada aos favoritos',
        ),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _logout() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Sair'),
        content: const Text('Deseja realmente sair?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            onPressed: () {
              BancoDeDados.usuarioLogado = null;
              Navigator.pushReplacementNamed(context, '/');
            },
            child: const Text('Sair'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final usuario = BancoDeDados.usuarioLogado;
    final pages = [
      CategoriaPage(
        categoria: Categoria.doces,
        receitas: _receitas,
        onRemover: _removerReceita,
        onToggleFavorito: _toggleFavorito,
        key: const PageStorageKey('doces'),
      ),
      CategoriaPage(
        categoria: Categoria.salgadas,
        receitas: _receitas,
        onRemover: _removerReceita,
        onToggleFavorito: _toggleFavorito,
        key: const PageStorageKey('salgadas'),
      ),
      CategoriaPage(
        categoria: Categoria.bebidas,
        receitas: _receitas,
        onRemover: _removerReceita,
        onToggleFavorito: _toggleFavorito,
        key: const PageStorageKey('bebidas'),
      ),
      FavoritosPage(
        receitas: _receitas,
        onRemover: _removerReceita,
        onToggleFavorito: _toggleFavorito,
        key: const PageStorageKey('favoritos'),
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Minhas Receitas'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: _logout,
            tooltip: 'Sair',
          ),
        ],
      ),
      drawer: Drawer(
        child: SafeArea(
          child: Column(
            children: [
              UserAccountsDrawerHeader(
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primaryContainer,
                ),
                currentAccountPicture: CircleAvatar(
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  child: Text(
                    usuario?.nome.substring(0, 1).toUpperCase() ?? 'U',
                    style: const TextStyle(fontSize: 32, color: Colors.white),
                  ),
                ),
                accountName: Text(
                  usuario?.nome ?? 'Usuário',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onPrimaryContainer,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                accountEmail: Text(
                  usuario?.email ?? '',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onPrimaryContainer,
                  ),
                ),
              ),
              ListTile(
                leading: const Icon(Icons.logout, color: Colors.red),
                title: const Text('Sair', style: TextStyle(color: Colors.red)),
                onTap: () {
                  Navigator.pop(context);
                  _logout();
                },
              ),
            ],
          ),
        ),
      ),
      body: IndexedStack(index: _abaAtual, children: pages),
      floatingActionButton: _abaAtual != 3 ? FloatingActionButton(
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
      ) : null,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _abaAtual,
        onTap: _onTabChange,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.cookie_outlined),
            label: 'Doces',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.restaurant_menu),
            label: 'Salgadas',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.local_drink_outlined),
            label: 'Bebidas',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite_outlined),
            activeIcon: Icon(Icons.favorite),
            label: 'Favoritos',
          ),
        ],
      ),
    );
  }
}

class CategoriaPage extends StatelessWidget {
  final Categoria categoria;
  final List<Receita> receitas;
  final Function(Receita) onRemover;
  final Function(Receita) onToggleFavorito;

  const CategoriaPage({
    super.key,
    required this.categoria,
    required this.receitas,
    required this.onRemover,
    required this.onToggleFavorito,
  });

  @override
  Widget build(BuildContext context) {
    final lista = receitas.where((r) => r.categoria == categoria).toList();

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(categoria.icon, size: 32),
              const SizedBox(width: 12),
              Text(
                categoria.label,
                style: Theme.of(context).textTheme.headlineMedium,
              ),
            ],
          ),
          const SizedBox(height: 16),
          if (lista.isEmpty)
            Center(
              child: Padding(
                padding: const EdgeInsets.all(48),
                child: Column(
                  children: [
                    Icon(
                      Icons.restaurant_outlined,
                      size: 64,
                      color: Colors.grey,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Nenhuma receita cadastrada',
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: Colors.grey,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Toque no botão + para adicionar',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
            )
          else
            for (final r in lista) ...[
              Dismissible(
                key: Key(r.id),
                background: Container(
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  alignment: Alignment.centerRight,
                  padding: const EdgeInsets.only(right: 20),
                  child: const Icon(Icons.delete, color: Colors.white),
                ),
                direction: DismissDirection.endToStart,
                onDismissed: (_) => onRemover(r),
                child: ReceitaCard(
                  receita: r,
                  onToggleFavorito: () => onToggleFavorito(r),
                ),
              ),
              const SizedBox(height: 12),
            ],
        ],
      ),
    );
  }
}

class FavoritosPage extends StatelessWidget {
  final List<Receita> receitas;
  final Function(Receita) onRemover;
  final Function(Receita) onToggleFavorito;

  const FavoritosPage({
    super.key,
    required this.receitas,
    required this.onRemover,
    required this.onToggleFavorito,
  });

  @override
  Widget build(BuildContext context) {
    final favoritas = receitas.where((r) => r.isFavorita).toList();

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.favorite, size: 32, color: Colors.red),
              const SizedBox(width: 12),
              Text(
                'Favoritos',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
            ],
          ),
          const SizedBox(height: 16),
          if (favoritas.isEmpty)
            Center(
              child: Padding(
                padding: const EdgeInsets.all(48),
                child: Column(
                  children: [
                    const Icon(
                      Icons.favorite_border,
                      size: 64,
                      color: Colors.grey,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Nenhuma receita favorita',
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: Colors.grey,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Toque no coração para adicionar favoritos',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Colors.grey,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            )
          else
            for (final r in favoritas) ...[
              Dismissible(
                key: Key('fav_${r.id}'),
                background: Container(
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  alignment: Alignment.centerRight,
                  padding: const EdgeInsets.only(right: 20),
                  child: const Icon(Icons.delete, color: Colors.white),
                ),
                direction: DismissDirection.endToStart,
                onDismissed: (_) => onRemover(r),
                child: ReceitaCard(
                  receita: r,
                  onToggleFavorito: () => onToggleFavorito(r),
                ),
              ),
              const SizedBox(height: 12),
            ],
        ],
      ),
    );
  }
}

class ReceitaCard extends StatelessWidget {
  final Receita receita;
  final VoidCallback onToggleFavorito;

  const ReceitaCard({
    super.key,
    required this.receita,
    required this.onToggleFavorito,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => DetalhesReceitaPage(receita: receita),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primaryContainer,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  receita.categoria.icon,
                  size: 32,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      receita.titulo,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      receita.descricaoBreve,
                      style: Theme.of(context).textTheme.bodyMedium,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(
                          Icons.access_time,
                          size: 16,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '${receita.tempoPreparo} min',
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Theme.of(context).colorScheme.primary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              IconButton(
                icon: Icon(
                  receita.isFavorita ? Icons.favorite : Icons.favorite_border,
                  color: receita.isFavorita ? Colors.red : Colors.grey,
                ),
                onPressed: onToggleFavorito,
                tooltip: receita.isFavorita
                    ? 'Remover dos favoritos'
                    : 'Adicionar aos favoritos',
              ),
              const SizedBox(width: 8),
              Icon(
                Icons.arrow_forward_ios,
                size: 16,
                color: Colors.grey,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
