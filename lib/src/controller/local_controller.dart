import 'package:inventario_nm/src/model/Local.dart';
import 'package:inventario_nm/src/persist/local_helper.dart';

class LocalController{

  static salvarLocais(int? id_contagem) async{
    Local local;
    LocalHelper helper = LocalHelper();
    local = new Local(id_contagem,TipoLocal.Geral);
    await helper.salvarLocal(local);
    local = new Local(id_contagem,TipoLocal.Loja);
    await helper.salvarLocal(local);
    local = new Local(id_contagem,TipoLocal.Deposito);
    await helper.salvarLocal(local);
    local = new Local(id_contagem,TipoLocal.Asteca);
    await helper.salvarLocal(local);
    local = new Local(id_contagem,TipoLocal.AstecaObsoleto);
    await helper.salvarLocal(local);
    List<Local> listaLocais = [];
    listaLocais = await helper.getAllLocal(id_contagem);
    return listaLocais; //Retornar lista de locais para instanciar na Contagem
  }

  static getLocal(int? id_contagem, [TipoLocal? tipo]) async{
    LocalHelper helper = LocalHelper();
    List<Local> listaLocal = [];
    if (tipo == null)
      listaLocal = await helper.getAllLocal(id_contagem);
    else
      listaLocal = await helper.getAllLocal(id_contagem, tipo.index);
    return listaLocal;
  }

}