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

class Receita {
  final String id;
  final String titulo;
  final String descricaoBreve;
  final List<String> ingredientes;
  final List<String> preparo;
  final Categoria categoria;
  final String? imagem;

  const Receita({
    required this.id,
    required this.titulo,
    required this.descricaoBreve,
    required this.ingredientes,
    required this.preparo,
    required this.categoria,
    this.imagem,
  });

  Receita copyWith({
    String? id,
    String? titulo,
    String? descricaoBreve,
    List<String>? ingredientes,
    List<String>? preparo,
    Categoria? categoria,
    String? imagem,
  }) {
    return Receita(
      id: id ?? this.id,
      titulo: titulo ?? this.titulo,
      descricaoBreve: descricaoBreve ?? this.descricaoBreve,
      ingredientes: ingredientes ?? this.ingredientes,
      preparo: preparo ?? this.preparo,
      categoria: categoria ?? this.categoria,
      imagem: imagem ?? this.imagem,
    );
  }
}

final receitasIniciais = <Receita>[
  const Receita(
    id: 'd1',
    titulo: 'Banana Caramelizada',
    descricaoBreve: 'Sobremesa um pouco mais chata de se fazer',
    ingredientes: [
      '2 bananas maduras',
      '2 colheres (sopa) de açúcar',
      '1 colher (sopa) de manteiga',
      'Canela em pó a gosto',
    ],
    preparo: [
      'Derreta a manteiga numa frigideira.',
      'Polvilhe açúcar, adicione as bananas em rodelas.',
      'Deixe dourar e finalize com canela.',
    ],
    categoria: Categoria.doces,
  ),
  const Receita(
    id: 'd2',
    titulo: 'Mousse de Maracujá',
    descricaoBreve: 'Pode trocar pelo limão e fazer um mousse de limão.',
    ingredientes: [
      '1 lata de leite condensado',
      '1 lata de creme de leite',
      '200ml de suco concentrado de maracujá',
    ],
    preparo: [
      'Bata tudo no liquidificador até ficar homogêneo.',
      'Leve à geladeira por 2 horas.',
      'Decore com sementes de maracujá.',
    ],
    categoria: Categoria.doces,
  ),
  const Receita(
    id: 'd3',
    titulo: 'Cookies de Aveia e Mel',
    descricaoBreve: 'Docinho, saudável e rápido.',
    ingredientes: [
      '1 xícara de aveia em flocos',
      '2 colheres (sopa) de mel',
      '1 banana amassada',
      'Gotas de chocolate (opcional)',
    ],
    preparo: [
      'Misture tudo até formar uma massa.',
      'Modele bolinhas e achate em forma untada.',
      'Asse a 180°C por 15 min.',
    ],
    categoria: Categoria.doces,
  ),
  const Receita(
    id: 's1',
    titulo: 'Omelete de Queijo',
    descricaoBreve: 'Praticidade para sua dieta.',
    ingredientes: [
      '2 ovos',
      '1/2 xícara de queijo ralado',
      'Sal e pimenta',
      'Cheiro-verde (opcional)',
    ],
    preparo: [
      'Bata os ovos com temperos.',
      'Despeje na frigideira quente com um fio de óleo.',
      'Adicione o queijo e dobre ao meio.',
    ],
    categoria: Categoria.salgadas,
  ),
  const Receita(
    id: 's2',
    titulo: 'Sanduíche Natural',
    descricaoBreve: 'O famoso sanduíche fitness',
    ingredientes: [
      '2 fatias de pão integral',
      'Peito de frango desfiado',
      'Alface e tomate',
      'Maionese ou requeijão',
    ],
    preparo: [
      'Passe maionese no pão.',
      'Recheie com frango e vegetais.',
      'Sirva gelado ou levemente tostado.',
    ],
    categoria: Categoria.salgadas,
  ),
  const Receita(
    id: 's3',
    titulo: 'Arroz com linguiça',
    descricaoBreve: 'Arroz com linguiça e cebola',
    ingredientes: [
      '1 xícara de arroz',
      '1 linguiça calabresa em rodelas',
      '1/2 cebola picada',
      '2 xícaras de água',
      'Sal a gosto',
    ],
    preparo: [
      'Refogue cebola e linguiça.',
      'Adicione arroz, água e sal.',
      'Cozinhe na pressão por 5 minutos.',
    ],
    categoria: Categoria.salgadas,
  ),
  const Receita(
    id: 'b1',
    titulo: 'Vitamina de Morango',
    descricaoBreve: 'Uma das melhores opções',
    ingredientes: [
      '1 xícara de morangos',
      '200ml de leite gelado',
      '1 colher (sopa) de açúcar ou mel',
    ],
    preparo: [
      'Bata todos os ingredientes no liquidificador.',
      'Sirva gelado.',
    ],
    categoria: Categoria.bebidas,
  ),
  const Receita(
    id: 'b2',
    titulo: 'Chá Gelado de Limão',
    descricaoBreve: 'Chá refrescante e fácil de fazer.',
    ingredientes: [
      '2 sachês de chá-preto',
      '500ml de água quente',
      'Suco de 1 limão',
      'Açúcar a gosto',
      'Gelo',
    ],
    preparo: [
      'Faça o chá e deixe esfriar um pouco.',
      'Misture com limão e açúcar.',
      'Sirva com gelo.',
    ],
    categoria: Categoria.bebidas,
  ),
  const Receita(
    id: 'b3',
    titulo: 'Café Gelado',
    descricaoBreve: 'Café cremosos e gelado',
    ingredientes: [
      '1 xícara de café forte gelado',
      '1/2 xícara de leite',
      '2 colheres (sopa) de leite condensado',
      'Gelo',
    ],
    preparo: [
      'Bata café, leite e leite condensado no liquidificador.',
      'Sirva com gelo.',
    ],
    categoria: Categoria.bebidas,
  ),
];

