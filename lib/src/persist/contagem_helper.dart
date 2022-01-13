import 'package:inventario_nm/src/model/Contagem.dart';
import 'package:inventario_nm/src/persist/dbhelper.dart';
import 'package:sqflite/sqflite.dart';

class ContagemHelper {
  DbHelper dbHelper = DbHelper();

  Future<Contagem> salvarContagem(Contagem contagem) async {
    Database? dbInventario = await dbHelper.db;
    //List listMap = await dbInventario!.rawQuery("SELECT * FROM sqlite_master where type='table';");
    //print(listMap.toString());
    await dbInventario!.insert(DbHelper.contagemTable, contagem.toMap());

    //getAllContagens(StatusContagem.Criado);
    return contagem;
  }

  getAllContagens(int tipo) async {
    Database? dbInventario = await dbHelper.db;
    String query = "SELECT * FROM ${DbHelper.contagemTable} ";
    List<Contagem> listaContagem = [];
    if (tipo == 1) {
      //pendente - iniciado - criado
      query +=
          "WHERE ${DbHelper.statusContagemCollumn} in (${StatusContagem.Criado.index}, ${StatusContagem.Iniciado.index}, ${StatusContagem.Pendente.index}, ${StatusContagem.Finalizar.index});";
      List listMap = await dbInventario!.rawQuery(query);
      for (Map m in listMap) {
        listaContagem.add(Contagem.fromMap(m));
      }
    } else {
      //finalizado
      query +=
          "WHERE ${DbHelper.statusContagemCollumn} in (${StatusContagem.Encerrado.index});";
      List listMap = await dbInventario!.rawQuery(query);
      for (Map m in listMap) {
        listaContagem.add(Contagem.fromMap(m));
      }
    }

    return listaContagem;
  }

  deleteContagem(Contagem contagem) async {
    Database? dbInventario = await dbHelper.db;

    int result = await dbInventario!.delete(DbHelper.contagemTable,
        where: "${DbHelper.idContagemCollumn} = ?",
        whereArgs: [contagem.id_contagem]);

    return result;
  }

  updateContagem(Contagem contagem) async {
    Database? dbInventario = await dbHelper.db;

    int result = await dbInventario!.update(
        DbHelper.contagemTable, contagem.toMap(),
        where: "${DbHelper.idContagemCollumn} = ?",
        whereArgs: [contagem.id_contagem]);

    return result;
  }
}
