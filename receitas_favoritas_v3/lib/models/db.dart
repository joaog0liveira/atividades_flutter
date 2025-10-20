import 'models.dart';

class BancoDeDados {
  static final List<Usuario> usuarios = [];
  static Usuario? usuarioLogado;
}

final receitasIniciais = <Receita>[
  const Receita(
    id: 'd1',
    titulo: 'Doce de Leite Talhado',
    descricaoBreve: 'Um clássico do interior goiano, cremoso e açucarado.',
    tempoPreparo: 60,
    ingredientes: [
      '2 litros de leite integral',
      '2 xícaras (chá) de açúcar',
      'Suco de 1 limão',
    ],
    preparo: [
      'Leve o leite ao fogo até ferver.',
      'Adicione o suco de limão para talhar o leite.',
      'Junte o açúcar e mexa até o soro reduzir e formar uma calda grossa.',
    ],
    categoria: Categoria.doces,
  ),
  const Receita(
    id: 'd2',
    titulo: 'Doce de Pequi',
    descricaoBreve: 'O sabor marcante do pequi em uma sobremesa tradicional.',
    tempoPreparo: 90,
    ingredientes: [
      '10 caroços de pequi',
      '2 xícaras (chá) de açúcar',
      '1 litro de água',
      'Canela em pau e cravo a gosto',
    ],
    preparo: [
      'Cozinhe os pequis na água até ficarem macios.',
      'Adicione o açúcar e os temperos.',
      'Deixe apurar até formar uma calda espessa e brilhante.',
    ],
    categoria: Categoria.doces,
  ),
  const Receita(
    id: 'd3',
    titulo: 'Pamonha',
    descricaoBreve: 'Feita com milho verde ralado e cozida na palha.',
    tempoPreparo: 90,
    ingredientes: [
      '12 espigas de milho verde',
      '1 xícara de açúcar',
      '1 pitada de sal',
      '1 xícara de leite',
      'Palhas de milho para enrolar',
    ],
    preparo: [
      'Rale o milho e misture com o leite, açúcar e sal.',
      'Coloque a massa nas palhas e feche bem.',
      'Cozinhe em água fervente por cerca de 40 minutos.',
    ],
    categoria: Categoria.doces,
  ),
  const Receita(
    id: 'd4',
    titulo: 'Arroz Doce com Coco',
    descricaoBreve: 'Versão goiana do arroz doce com leite de coco.',
    tempoPreparo: 40,
    ingredientes: [
      '1 xícara de arroz',
      '1 litro de leite',
      '1 vidro de leite de coco',
      '1 xícara de açúcar',
      'Canela em pó',
    ],
    preparo: [
      'Cozinhe o arroz no leite até amaciar.',
      'Adicione o leite de coco e o açúcar.',
      'Deixe engrossar e finalize com canela.',
    ],
    categoria: Categoria.doces,
  ),
  const Receita(
    id: 'd5',
    titulo: 'Doce de Mangaba',
    descricaoBreve: 'Fruta típica do cerrado transformada em doce delicioso.',
    tempoPreparo: 60,
    ingredientes: [
      '500g de mangaba',
      '2 xícaras de açúcar',
      '1/2 xícara de água',
      'Canela a gosto',
    ],
    preparo: [
      'Cozinhe a mangaba com água até amolecer.',
      'Acrescente o açúcar e a canela.',
      'Mexa até virar um doce encorpado.',
    ],
    categoria: Categoria.doces,
  ),

  const Receita(
    id: 's1',
    titulo: 'Empadão',
    descricaoBreve: 'O prato mais famoso de Goiás, recheado e irresistível.',
    tempoPreparo: 90,
    ingredientes: [
      '4 xícaras de farinha de trigo',
      '200g de manteiga',
      '2 ovos',
      'Sal a gosto',
      'Recheio: frango desfiado, queijo, linguiça, azeitona e palmito',
    ],
    preparo: [
      'Misture a farinha, manteiga, ovos e sal até formar a massa.',
      'Forre a forma, adicione o recheio e cubra com o restante da massa.',
      'Asse a 180°C por cerca de 45 minutos.',
    ],
    categoria: Categoria.salgadas,
  ),
  const Receita(
    id: 's2',
    titulo: 'Arroz com Pequi',
    descricaoBreve: 'A iguaria mais emblemática da culinária goiana.',
    tempoPreparo: 40,
    ingredientes: [
      '2 xícaras de arroz',
      '6 pequis inteiros',
      '1 cebola picada',
      '2 colheres (sopa) de óleo',
      'Sal a gosto',
    ],
    preparo: [
      'Frite a cebola no óleo até dourar.',
      'Adicione os pequis e refogue levemente.',
      'Junte o arroz, sal e água quente.',
      'Cozinhe até secar e os pequis soltarem sabor.',
    ],
    categoria: Categoria.salgadas,
  ),
  const Receita(
    id: 's3',
    titulo: 'Galinhada',
    descricaoBreve: 'Arroz cozido com frango e açafrão, típico das festas.',
    tempoPreparo: 60,
    ingredientes: [
      '1 frango em pedaços',
      '2 xícaras de arroz',
      '1 cebola e 2 dentes de alho picados',
      'Açafrão-da-terra, sal e pimenta a gosto',
      'Óleo e cheiro-verde',
    ],
    preparo: [
      'Tempere o frango e frite até dourar.',
      'Adicione alho, cebola e açafrão.',
      'Coloque o arroz e refogue.',
      'Cozinhe com água até secar e finalize com cheiro-verde.',
    ],
    categoria: Categoria.salgadas,
  ),
  const Receita(
    id: 's4',
    titulo: 'Feijão Tropeiro',
    descricaoBreve: 'Rico em proteínas e muito sabor, com torresmo e ovos.',
    tempoPreparo: 50,
    ingredientes: [
      '2 xícaras de feijão cozido',
      '1 xícara de farinha de mandioca',
      '100g de bacon',
      '2 ovos',
      'Cebola e alho a gosto',
      'Cheiro-verde e sal',
    ],
    preparo: [
      'Frite o bacon, junte cebola e alho.',
      'Adicione o feijão e mexa.',
      'Junte a farinha aos poucos e finalize com ovos mexidos e cheiro-verde.',
    ],
    categoria: Categoria.salgadas,
  ),
  const Receita(
    id: 's5',
    titulo: 'Peixe Frito com Molho de Pequi',
    descricaoBreve: 'Combinação perfeita do cerrado com o rio Araguaia.',
    tempoPreparo: 45,
    ingredientes: [
      '500g de filé de peixe (tucunaré ou tilápia)',
      'Suco de limão, sal e pimenta',
      'Farinha de trigo para empanar',
      'Molho: polpa de pequi, cebola e creme de leite',
    ],
    preparo: [
      'Tempere o peixe e frite até dourar.',
      'Para o molho, refogue a polpa de pequi e cebola.',
      'Junte o creme de leite e sirva sobre o peixe.',
    ],
    categoria: Categoria.salgadas,
  ),

  const Receita(
    id: 'b1',
    titulo: 'Suco de Cajá',
    descricaoBreve: 'Refrescante e azedinho, típico do cerrado.',
    tempoPreparo: 5,
    ingredientes: [
      ' polpa de 4 cajás',
      '500ml de água',
      'Açúcar a gosto',
      'Gelo',
    ],
    preparo: [
      'Bata tudo no liquidificador.',
      'Coe e sirva bem gelado.',
    ],
    categoria: Categoria.bebidas,
  ),
  const Receita(
    id: 'b2',
    titulo: 'Vitamina de Pequi',
    descricaoBreve: 'Bebida cremosa com o sabor único do pequi.',
    tempoPreparo: 10,
    ingredientes: [
      '2 polpas de pequi cozidas',
      '300ml de leite gelado',
      '1 colher (sopa) de mel',
    ],
    preparo: [
      'Bata todos os ingredientes até ficar homogêneo.',
      'Sirva imediatamente.',
    ],
    categoria: Categoria.bebidas,
  ),
  const Receita(
    id: 'b3',
    titulo: 'Caldo de Cana com Limão',
    descricaoBreve: 'Tradicional nas feiras e ruas de Goiás.',
    tempoPreparo: 5,
    ingredientes: [
      '500ml de caldo de cana fresco',
      'Suco de meio limão',
      'Gelo',
    ],
    preparo: [
      'Misture o suco de limão ao caldo de cana.',
      'Sirva gelado com bastante gelo.',
    ],
    categoria: Categoria.bebidas,
  ),
  const Receita(
    id: 'b4',
    titulo: 'Suco de Mangaba',
    descricaoBreve: 'Fruta típica do cerrado em forma de suco refrescante.',
    tempoPreparo: 5,
    ingredientes: [
      'Polpa de 3 mangabas',
      '400ml de água gelada',
      'Açúcar ou mel a gosto',
    ],
    preparo: [
      'Bata tudo no liquidificador.',
      'Coe e sirva com gelo.',
    ],
    categoria: Categoria.bebidas,
  ),
  const Receita(
    id: 'b5',
    titulo: 'Licor de Pequi',
    descricaoBreve: 'Bebida artesanal de sabor intenso, feita com pequi.',
    tempoPreparo: 4320,
    ingredientes: [
      '10 caroços de pequi',
      '500ml de cachaça boa',
      '1 xícara de açúcar',
    ],
    preparo: [
      'Deixe os pequis curtirem na cachaça por 3 dias.',
      'Coe e adicione o açúcar.',
      'Guarde em garrafa por mais alguns dias antes de servir.',
    ],
    categoria: Categoria.bebidas,
  ),
];
