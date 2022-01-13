import 'package:inventario_nm/src/controller/produto_controller.dart';
import 'package:inventario_nm/src/model/Produto.dart';
import 'package:inventario_nm/src/persist/contagem_helper.dart';

import '../model/Contagem.dart';
import 'package:inventario_nm/src/modules/api/api_produtos.dart';

class ContagemController {
  static salvarContagem(int id_filial, String? observacoes) async {
    Contagem contagem = new Contagem(id_filial, observacoes);
    ContagemHelper? helper = ContagemHelper();
    await helper.salvarContagem(contagem);
    // popularProdutoTeste();
  }

  // static popularProdutoTeste() async{
  //   Produto produto1 = new Produto(1,'1234567890123','Notebook Acer');
  //   Produto produto2 = new Produto(2,'5554443322212','Geladeira Frost Free');
  //   Produto produto3 = new Produto(3,'5687544567456','Hot Wheels');
  //   await ProdutoController.salvarProduto(produto1);
  //   await ProdutoController.salvarProduto(produto2);
  //   await ProdutoController.salvarProduto(produto3);
  //   print("entrou");
  // }

  static updateContagem(Contagem contagem) async {
    ContagemHelper? helper = ContagemHelper();
    await helper.updateContagem(contagem);
  }

  static deleteContagem(Contagem contagem) async {
    ContagemHelper? helper = ContagemHelper();
    await helper.deleteContagem(contagem);
  }

  static listaContagemPorStatus(int tipo) async {
    ContagemHelper? helper = ContagemHelper();
    List<Contagem> listaContagens = [];
    listaContagens = await helper.getAllContagens(tipo);
    return listaContagens;
  }
}
