import 'package:inventario_nm/src/model/Produto.dart';
import 'package:inventario_nm/src/persist/dbhelper.dart';

enum StatusProduto { Aberto, Contado, Postergado }

class Produto_Contagem {
  int? _idProdutoContagem;
  int? _idProduto;
  int? _id_inventario_cic;
  DateTime? _data_registro_item;
  int? _quantidade;
  StatusProduto? _status;
  int? _id_local;
  Produto? _produto;

  Produto_Contagem() {}

  Produto_Contagem.fromMap(Map map) {
    idProdutoContagem = map[DbHelper.idProdutoContagem];
    id_inventario_cic = map[DbHelper.idInventarioCicCollumn];
    data_registro_item = DateTime.parse(map[DbHelper.dataColumn]);
    quantidade = map[DbHelper.quantidadeCollumn];
    idProduto = map[DbHelper.idProdutoCollumn];
    id_local = map[DbHelper.idLocalCollumn];
    status = StatusProduto.values[map[DbHelper.statusProdutoCollumn]];
    produto = new Produto(idProduto, map[DbHelper.eanColumn], map[DbHelper.nomeProdutoCollumn]);
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {
      DbHelper.idProdutoContagem: idProdutoContagem,
      DbHelper.idInventarioCicCollumn: id_inventario_cic,
      DbHelper.dataColumn: data_registro_item.toString(),
      DbHelper.quantidadeCollumn: quantidade,
      DbHelper.idProdutoCollumn: idProduto,
      DbHelper.idLocalCollumn: id_local,
      DbHelper.statusProdutoCollumn: status!.index
    };
    return map;
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> map = {
      DbHelper.idProdutoCollumn: idProduto,
      DbHelper.eanColumn: produto?.ean,
      DbHelper.quantidadeCollumn: quantidade,
    };
    return map;
  }

  int? get idProduto => _idProduto;

  set idProduto(int? value) {
    _idProduto = value;
  }

  StatusProduto? get status => _status;

  set status(StatusProduto? value) {
    _status = value;
  }

  int? get quantidade => _quantidade;

  set quantidade(int? value) {
    _quantidade = value;
  }

  DateTime? get data_registro_item => _data_registro_item;

  set data_registro_item(DateTime? value) {
    _data_registro_item = value;
  }

  int? get id_inventario_cic => _id_inventario_cic;

  set id_inventario_cic(int? value) {
    _id_inventario_cic = value;
  }

  int? get id_local => _id_local;

  set id_local(int? value) {
    _id_local = value;
  }

  int? get idProdutoContagem => _idProdutoContagem;

  set idProdutoContagem(int? value) {
    _idProdutoContagem = value;
  }

  Produto? get produto => _produto;

  set produto(Produto? value) {
    _produto = value;
  }
}
