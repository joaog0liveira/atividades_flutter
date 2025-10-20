
import 'package:flutter/material.dart';

enum Categoria { doces, salgadas, bebidas }

extension CategoriaX on Categoria {
  IconData get icon => switch (this) {
    Categoria.doces => Icons.cookie_rounded,
    Categoria.salgadas => Icons.restaurant_menu_rounded,
    Categoria.bebidas => Icons.local_drink_rounded,
  };
  String get label => switch (this) {
    Categoria.doces => 'Doces',
    Categoria.salgadas => 'Salgadas',
    Categoria.bebidas => 'Bebidas',
  };
}

class Usuario {
  final String nome;
  final String email;
  final String senha;

  const Usuario({
    required this.nome,
    required this.email,
    required this.senha,
  });
}

class Receita {
  final String id;
  final String titulo;
  final String descricaoBreve;
  final int tempoPreparo;
  final List<String> ingredientes;
  final List<String> preparo;
  final Categoria categoria;
  final String? imagem;
  final bool isFavorita;

  const Receita({
    required this.id,
    required this.titulo,
    required this.descricaoBreve,
    required this.tempoPreparo,
    required this.ingredientes,
    required this.preparo,
    required this.categoria,
    this.imagem,
    this.isFavorita = false,
  });

  Receita copyWith({
    String? id,
    String? titulo,
    String? descricaoBreve,
    int? tempoPreparo,
    List<String>? ingredientes,
    List<String>? preparo,
    Categoria? categoria,
    String? imagem,
    bool? isFavorita,
  }) {
    return Receita(
      id: id ?? this.id,
      titulo: titulo ?? this.titulo,
      descricaoBreve: descricaoBreve ?? this.descricaoBreve,
      tempoPreparo: tempoPreparo ?? this.tempoPreparo,
      ingredientes: ingredientes ?? this.ingredientes,
      preparo: preparo ?? this.preparo,
      categoria: categoria ?? this.categoria,
      imagem: imagem ?? this.imagem,
      isFavorita: isFavorita ?? this.isFavorita,
    );
  }
}
