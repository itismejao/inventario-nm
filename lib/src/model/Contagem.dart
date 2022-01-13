import 'package:inventario_nm/src/model/Local.dart';
import 'package:inventario_nm/src/persist/dbhelper.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum StatusContagem {
  Criado,
  Iniciado,
  Pendente,
  Finalizar,
  Encerrado,
  Cancelado
}

class Contagem {
  int? _id_contagem;
  int? _id_filial;
  int? _id_funcionario;
  String? _nome_funcionario;
  DateTime? _data_cria;
  DateTime? _data_termino;
  DateTime? _data_inicia;
  StatusContagem? _status;
  String? _observacoes;
  List<Local>? _listaLocais = [];
  TipoLocal? localSelecionado;

  Contagem([this._id_filial, this._observacoes]) {
    this._data_cria = DateTime.now();
    this._status = StatusContagem.Criado;
    getUser();
  }

  getUser() async {
    String senha = '';
    await SharedPreferences.getInstance().then((prefs) {
      this.id_funcionario = int.parse(prefs.getString('user.uid') ?? "");
      this.nome_funcionario = prefs.getString('user.name') ?? "";
      senha = prefs.getString('senha') ?? "";
    });
    return [id_funcionario.toString(), senha.toString()];
  }

  Contagem.fromMap(Map map) {
    id_contagem = map[DbHelper.idContagemCollumn];
    id_filial = map[DbHelper.idFilialCollumn];
    id_funcionario = map[DbHelper.idFuncionarioCollumn];
    nome_funcionario = map[DbHelper.nomeFuncionarioCollumn];
    data_cria = DateTime.parse(map[DbHelper.dataCriaCollumn]);
    data_inicia = DbHelper.dataIniciaCollumn.length > 0
        ? null
        : DateTime.parse(map[DbHelper.dataIniciaCollumn]);
    data_termino = DbHelper.dataIniciaCollumn.length > 0
        ? null
        : DateTime.parse(map[DbHelper.dataTerminoCollumn]);
    status = StatusContagem.values[map[DbHelper.statusContagemCollumn]];
    observacoes = map[DbHelper.observacoesCollumn];
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {
      DbHelper.idFilialCollumn: id_filial,
      DbHelper.idFuncionarioCollumn: id_funcionario,
      DbHelper.nomeFuncionarioCollumn: nome_funcionario,
      DbHelper.dataCriaCollumn: data_cria.toString(),
      DbHelper.statusContagemCollumn: status!.index,
      DbHelper.observacoesCollumn: observacoes
    };
    if (id_contagem != null) map[DbHelper.idContagemCollumn] = id_contagem;
    if (data_inicia != null) map[DbHelper.dataIniciaCollumn] = data_inicia;
    if (data_termino != null) map[DbHelper.dataTerminoCollumn] = data_termino;
    return map;
  }

  int? get id_contagem => _id_contagem;

  set id_contagem(int? value) {
    _id_contagem = value;
  }

  int? get id_filial => _id_filial;

  set id_filial(int? value) {
    _id_filial = value;
  }

  int? get id_funcionario => _id_funcionario;

  set id_funcionario(int? value) {
    _id_funcionario = value;
  }

  DateTime? get data_cria => _data_cria;

  set data_cria(DateTime? value) {
    _data_cria = value;
  }

  DateTime? get data_termino => _data_termino;

  set data_termino(DateTime? value) {
    _data_termino = value;
  }

  DateTime? get data_inicia => _data_inicia;

  set data_inicia(DateTime? value) {
    _data_inicia = value;
  }

  StatusContagem? get status => _status;

  set status(StatusContagem? value) {
    _status = value;
  }

  String? get observacoes => _observacoes;

  set observacoes(String? value) {
    _observacoes = value;
  }

  List<Local>? get listaLocais => _listaLocais;

  set listaLocais(List<Local>? value) {
    _listaLocais = value;
  }

  String? get nome_funcionario => _nome_funcionario;

  set nome_funcionario(String? value) {
    _nome_funcionario = value;
  }
}
