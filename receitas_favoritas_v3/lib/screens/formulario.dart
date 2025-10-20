import 'package:flutter/material.dart';

import '../models/models.dart';

class FormularioReceitaPage extends StatefulWidget {
  final Categoria? categoriaInicial;

  const FormularioReceitaPage({super.key, this.categoriaInicial});

  @override
  State<FormularioReceitaPage> createState() => _FormularioReceitaPageState();
}

class _FormularioReceitaPageState extends State<FormularioReceitaPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _tituloCtrl;
  late TextEditingController _descricaoCtrl;
  late TextEditingController _tempoCtrl;
  late TextEditingController _imagemCtrl;
  late Categoria _categoria;
  final List<TextEditingController> _ingredientesCtrl = [];
  final List<TextEditingController> _preparoCtrl = [];

  @override
  void initState() {
    super.initState();
    _tituloCtrl = TextEditingController();
    _descricaoCtrl = TextEditingController();
    _tempoCtrl = TextEditingController();
    _imagemCtrl = TextEditingController();
    _categoria = widget.categoriaInicial ?? Categoria.doces;

    _ingredientesCtrl.add(TextEditingController());
    _preparoCtrl.add(TextEditingController());
  }

  @override
  void dispose() {
    _tituloCtrl.dispose();
    _descricaoCtrl.dispose();
    _tempoCtrl.dispose();
    _imagemCtrl.dispose();
    for (final c in _ingredientesCtrl) {
      c.dispose();
    }
    for (final c in _preparoCtrl) {
      c.dispose();
    }
    super.dispose();
  }

  String? _validarCampoObrigatorio(String? value) {
    if (value == null || value
        .trim()
        .isEmpty) {
      return 'Campo obrigatório';
    }
    return null;
  }

  String? _validarTempo(String? value) {
    if (value == null || value
        .trim()
        .isEmpty) {
      return 'Campo obrigatório';
    }
    final tempo = int.tryParse(value);
    if (tempo == null || tempo <= 0) {
      return 'Informe um tempo válido (maior que zero)';
    }
    return null;
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

      if (ingredientes.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Adicione pelo menos um ingrediente'),
            backgroundColor: Colors.orange,
          ),
        );
        return;
      }

      if (preparo.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Adicione pelo menos um passo do preparo'),
            backgroundColor: Colors.orange,
          ),
        );
        return;
      }

      final receita = Receita(
        id: DateTime
            .now()
            .millisecondsSinceEpoch
            .toString(),
        titulo: _tituloCtrl.text.trim(),
        descricaoBreve: _descricaoCtrl.text.trim(),
        tempoPreparo: int.parse(_tempoCtrl.text.trim()),
        ingredientes: ingredientes,
        preparo: preparo,
        categoria: _categoria,
        imagem: _imagemCtrl.text
            .trim()
            .isEmpty ? null : _imagemCtrl.text.trim(),
      );

      Navigator.pop(context, receita);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Nova Receita'),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            TextFormField(
              controller: _tituloCtrl,
              decoration: const InputDecoration(
                labelText: 'Nome da receita *',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.title),
              ),
              validator: _validarCampoObrigatorio,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _descricaoCtrl,
              decoration: const InputDecoration(
                labelText: 'Descrição curta *',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.description),
              ),
              maxLines: 2,
              validator: _validarCampoObrigatorio,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _tempoCtrl,
              decoration: const InputDecoration(
                labelText: 'Tempo de preparo (minutos) *',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.access_time),
              ),
              keyboardType: TextInputType.number,
              validator: _validarTempo,
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<Categoria>(
              value: _categoria,
              decoration: const InputDecoration(
                labelText: 'Categoria *',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.category),
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
                prefixIcon: Icon(Icons.image),
              ),
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Ingredientes',
                  style: Theme
                      .of(context)
                      .textTheme
                      .titleLarge
                      ?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.add_circle),
                  color: Theme
                      .of(context)
                      .colorScheme
                      .primary,
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
                Text(
                  'Modo de Preparo',
                  style: Theme
                      .of(context)
                      .textTheme
                      .titleLarge
                      ?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.add_circle),
                  color: Theme
                      .of(context)
                      .colorScheme
                      .primary,
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
            FilledButton.icon(
              onPressed: _salvar,
              icon: const Icon(Icons.save),
              label: const Text('Adicionar Receita'),
              style: FilledButton.styleFrom(
                padding: const EdgeInsets.all(16),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              '* Campos obrigatórios',
              style: Theme
                  .of(context)
                  .textTheme
                  .bodySmall
                  ?.copyWith(
                color: Colors.grey,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
