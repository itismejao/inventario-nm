import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:inventario_nm/src/controller/produto_contagem_controller.dart';
import 'package:inventario_nm/src/model/Contagem.dart';
import 'package:inventario_nm/src/model/Local.dart';
import 'package:inventario_nm/src/model/Produto_Contagem.dart';
import 'package:inventario_nm/src/persist/dbhelper.dart';

class ApiPrimeiraContagem {
  static enviaContagem(Contagem contagem) async {
    bool hasError = false;
    String urlApi = 'https://inventarionm-apih.novomundo.com.br/api/add';
    try {
      await http
          .post(Uri.parse(urlApi),
              headers: <String, String>{
                'Content-Type': 'application/json; charset=UTF-8',
              },
              body: await montarJson(contagem))
          .then((response) => {print(response.statusCode)});
    } catch (e) {
      print(e.toString());
      hasError = true;
    }
    return hasError;
  }

  static montarJson(Contagem contagem) async {
    Map<String, dynamic> jsonContagem = {};

    jsonContagem[DbHelper.idFilialCollumn] = contagem.id_filial;
    jsonContagem[DbHelper.idFuncionarioCollumn] = contagem.id_funcionario;
    jsonContagem["id_agrupador"] = contagem.id_contagem! + 999;
    jsonContagem[DbHelper.idInventarioCicCollumn] = null;
    jsonContagem["aplicacao"] = 2;

    List<Produto_Contagem> listaProdutosContagem = [];
    listaProdutosContagem = await ProdutoContagemController.getProdutosContagem(contagem.listaLocais![0]);

    jsonContagem.addAll({"produtos": jsonDecode(jsonEncode(listaProdutosContagem))});
    print(jsonEncode(jsonContagem));
    return jsonEncode(jsonContagem);
  }
}
