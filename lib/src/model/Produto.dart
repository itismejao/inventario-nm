import 'package:hive/hive.dart';
import 'package:inventario_nm/src/persist/dbhelper.dart';

part 'Produto.g.dart';

@HiveType(typeId: 0)
class Produto extends HiveObject{

  @HiveField(0)
  int? _id_produto;

  @HiveField(1)
  String? _nome;

  @HiveField(2)
  String? _ean;

  Produto([this._id_produto,this._ean, this._nome]) {}

  Produto.fromMap(Map map){
    id_produto = map[DbHelper.idProdutoCollumn];
    nome = map[DbHelper.nomeProdutoCollumn];
    ean = map[DbHelper.eanColumn];
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {
      DbHelper.idProdutoCollumn: id_produto,
      DbHelper.nomeProdutoCollumn: nome,
      DbHelper.eanColumn: ean
    };
    return map;
  }

  int? get id_produto => _id_produto;

  set id_produto(int? value) {
    _id_produto = value;
  }

  String? get nome => _nome;

  String? get ean => _ean;

  set ean(String? value) {
    _ean = value;
  }

  set nome(String? value) {
    _nome = value;
  }
}