
import 'package:inventario_nm/src/model/Local.dart';
import 'package:sqflite/sqflite.dart';

import 'dbhelper.dart';

class LocalHelper{
  DbHelper dbHelper = DbHelper();

  Future<Local> salvarLocal(Local local) async{
    Database? dbInventario = await dbHelper.db;

    await dbInventario!.insert(DbHelper.localTable, local.toMap());

    return local;
  }

  getAllLocal(int? id_contagem, [int? tipo_local]) async{
    Database? dbInventario = await dbHelper.db;
    String query = "SELECT * FROM ${DbHelper.localTable} ";
    query += "WHERE ${DbHelper.idContagemCollumn} = $id_contagem ";
    tipo_local != null ? query += "AND ${DbHelper.tipoLocalCollumn} = $tipo_local " : null;
    List listMap = await dbInventario!.rawQuery(query);
    List<Local> listaLocal = [];
    for(Map m in listMap){
      listaLocal.add(Local.fromMap(m));
    }
    return listaLocal;
  }

  deleteLocal(Local local) async {
    Database? dbInventario = await dbHelper.db;

    int result = await dbInventario!.delete(DbHelper.localTable,
        where: "${DbHelper.idLocalCollumn} = ?",
        whereArgs: [local.id_local]);

    return result;
  }

  updateLocal(Local local) async {
    Database? dbInventario = await dbHelper.db;

    int result = await dbInventario!.update(
        DbHelper.localTable, local.toMap(),
        where: "${DbHelper.idLocalCollumn} = ?",
        whereArgs: [local.id_local]);

    return result;
  }



}