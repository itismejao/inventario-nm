import 'package:inventario_nm/src/model/Produto.dart';
import 'package:sqflite/sqflite.dart';

import 'dbhelper.dart';

class ProdutoHelper {
  DbHelper dbHelper = DbHelper();

  Future<Produto> salvarProduto(Produto produto) async {
    Database? dbInventario = await dbHelper.db;

    String query = "SELECT * FROM ${DbHelper.produtoSincronizadoTable} WHERE ${DbHelper.idProdutoCollumn} = ${produto.id_produto}";
      
    var result = await dbInventario?.rawQuery(query);

    //print("lengthhhh ${result!.length} ");

    if (result!.isEmpty) {
      await dbInventario!.insert(DbHelper.produtoSincronizadoTable, produto.toMap());
      //print('insert');
    } else {
      updateProduto(produto);
      //print('update');
    }

    return produto;
  }

  getAllProduto([String? ean]) async {
    Database? dbInventario = await dbHelper.db;
    String query = "SELECT * FROM ${DbHelper.produtoSincronizadoTable} ";
    ean != null ? query += "WHERE ${DbHelper.eanColumn} = $ean" : null;
    List listMap = await dbInventario!.rawQuery(query);
    //print(listMap.toString());
    List<Produto> listaProduto = [];
    for (Map m in listMap) {
      listaProduto.add(Produto.fromMap(m));
    }
    return listaProduto;
  }

  getProdutoEan(String ean) async {
    Database? dbInventario = await dbHelper.db;
    String query = "SELECT * FROM ${DbHelper.produtoSincronizadoTable} " + "WHERE ${DbHelper.eanColumn} = $ean";
    List listMap = await dbInventario!.rawQuery(query);
    Produto? produto;
    for (Map m in listMap) {
      produto = Produto.fromMap(m);
    }
    return produto;
  }

  getProdutoID(int id_produto) async {
    Database? dbInventario = await dbHelper.db;
    String query = "SELECT * FROM ${DbHelper.produtoSincronizadoTable} " + "WHERE ${DbHelper.idProdutoCollumn} = $id_produto";

    List listMap = await dbInventario!.rawQuery(query);
    Produto? produto;
    print(listMap);
    for (Map m in listMap) {
      produto = Produto.fromMap(m);
    }
    return produto;
  }

  deleteProduto(Produto produto) async {
    Database? dbInventario = await dbHelper.db;

    int result = await dbInventario!
        .delete(DbHelper.produtoSincronizadoTable, where: "${DbHelper.idProdutoContagem} = ?", whereArgs: [produto.id_produto]);

    return result;
  }

  updateProduto(Produto produto) async {
    Database? dbInventario = await dbHelper.db;

    int result = await dbInventario!.update(DbHelper.produtoSincronizadoTable, produto.toMap(),
        where: "${DbHelper.idProdutoCollumn} = ?", whereArgs: [produto.id_produto]);

    return result;
  }
}
