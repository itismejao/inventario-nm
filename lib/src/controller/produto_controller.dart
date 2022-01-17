import 'dart:io';

import 'package:hive/hive.dart';
import 'package:inventario_nm/src/model/Produto.dart';
import 'package:inventario_nm/src/persist/produto_helper.dart';

class ProdutoController{

  static getProduto([String? bip]) async {
    ProdutoHelper helper = ProdutoHelper();
    Produto? produto;

    if (bip!.length != 13) {
      produto = await helper.getProdutoID(int.parse(bip));
    } else
      produto = await helper.getProdutoEan(bip);

    return produto;
  }

  static Future salvarProduto(Produto produto) async {
    final box = Hive.box<Produto>('Produto');
    box.put(produto.id_produto, produto);
    print(box.length);
    //ProdutoHelper helper = ProdutoHelper();
    //await helper.salvarProduto(produto);
  }

}