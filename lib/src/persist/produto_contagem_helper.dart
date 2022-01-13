import 'package:inventario_nm/src/model/Produto_Contagem.dart';
import 'package:sqflite/sqflite.dart';

import 'dbhelper.dart';

class ProdutoContagemHelper{

  DbHelper dbHelper = DbHelper();

  Future<Produto_Contagem> salvarProdutoContagem(Produto_Contagem produto_contagem) async{
    Database? dbInventario = await dbHelper.db;

    produto_contagem.idProdutoContagem = await dbInventario!.insert(DbHelper.produtoTable, produto_contagem.toMap());

    return produto_contagem;
  }

  getAllProdutoContagem(int? id_local) async{
    Database? dbInventario = await dbHelper.db;
    String query = "SELECT * FROM ${DbHelper.produtoTable} P ";
    query += "INNER JOIN ${DbHelper.produtoSincronizadoTable} PS ";
    query += "ON P.${DbHelper.idProdutoCollumn} = PS.${DbHelper.idProdutoCollumn} ";
    query += "WHERE ${DbHelper.idLocalCollumn} = $id_local";
    List listMap = await dbInventario!.rawQuery(query);
    //print(listMap.toString());
    List<Produto_Contagem> listaProdutoContagem = [];
    for(Map m in listMap){
      listaProdutoContagem.add(Produto_Contagem.fromMap(m));
    }
    return listaProdutoContagem;
  }

  getAllProdutoContagemGeral(int? id_contagem) async{
    Database? dbInventario = await dbHelper.db;
    String query = "SELECT * FROM ${DbHelper.produtoTable} P ";
    query += "INNER JOIN ${DbHelper.produtoSincronizadoTable} PS ";
    query += "ON P.${DbHelper.idProdutoCollumn} = PS.${DbHelper.idProdutoCollumn} ";
    query += "WHERE P.${DbHelper.idLocalCollumn} IN (SELECT ${DbHelper.idLocalCollumn} FROM ${DbHelper.localTable} WHERE ${DbHelper.idContagemCollumn} = $id_contagem )";
    List listMap = await dbInventario!.rawQuery(query);
    List<Produto_Contagem> listaProdutoContagem = [];
    for(Map m in listMap){
      listaProdutoContagem.add(Produto_Contagem.fromMap(m));
    }
    return listaProdutoContagem;
  }


  deleteProdutoContagem(Produto_Contagem produto_contagem) async {
    Database? dbInventario = await dbHelper.db;

    int result = await dbInventario!.delete(DbHelper.produtoTable,
        where: "${DbHelper.idProdutoContagem} = ?",
        whereArgs: [produto_contagem.idProdutoContagem]);

    return result;
  }

  updateProdutoContagem(Produto_Contagem produto_contagem) async {
    Database? dbInventario = await dbHelper.db;

    int result = await dbInventario!.update(
        DbHelper.produtoTable, produto_contagem.toMap(),
        where: "${DbHelper.idProdutoContagem} = ?",
        whereArgs: [produto_contagem.idProdutoContagem]);

    return result;
  }

}