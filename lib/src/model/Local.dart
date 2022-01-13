import 'package:inventario_nm/src/persist/dbhelper.dart';

import 'Produto_Contagem.dart';

enum TipoLocal{
  Geral,
  Deposito,
  Loja,
  Asteca,
  AstecaObsoleto
}

class Local{
  int? _id_local;
  TipoLocal? _tipoLocal;
  int? _id_contagem;
  List<Produto_Contagem>? _listaProdutos = [];

  Local([this._id_contagem,this._tipoLocal]){

}

  Local.fromMap(Map map){
    id_local = map[DbHelper.idLocalCollumn];
    tipoLocal = TipoLocal.values[map[DbHelper.tipoLocalCollumn]];
    id_contagem = map[DbHelper.idContagemCollumn];
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {
      DbHelper.tipoLocalCollumn: tipoLocal!.index,
      DbHelper.idContagemCollumn: id_contagem
    };
    if (id_local != null) map[DbHelper.idLocalCollumn] = id_local;

    return map;
  }

  int? get id_local => _id_local;

  set id_local(int? value) {
    _id_local = value;
  }

  TipoLocal? get tipoLocal => _tipoLocal;

  set tipoLocal(TipoLocal? value) {
    _tipoLocal = value;
  }

  List<Produto_Contagem>? get listaProdutos => _listaProdutos;

  set listaProdutos(List<Produto_Contagem>? value) {
    _listaProdutos = value;
  }

  int? get id_contagem => _id_contagem;

  set id_contagem(int? value) {
    _id_contagem = value;
  }
}