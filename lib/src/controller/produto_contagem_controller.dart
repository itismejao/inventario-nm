import 'package:inventario_nm/src/model/Local.dart';
import 'package:inventario_nm/src/model/Produto_Contagem.dart';
import 'package:inventario_nm/src/persist/produto_contagem_helper.dart';

class ProdutoContagemController {
  static getProdutosContagem(Local local) async {
    ProdutoContagemHelper helper = ProdutoContagemHelper();
    List<Produto_Contagem> listaProdutosContagem = [];

    if (local.tipoLocal == TipoLocal.Geral)
      listaProdutosContagem = await helper.getAllProdutoContagemGeral(local.id_contagem); //Todos Produtos da Contagem
    else
      listaProdutosContagem = await helper.getAllProdutoContagem(local.id_local); //Produtos do local especifico

    return listaProdutosContagem;
  }

  static salvarProdutoContagem(Produto_Contagem produtoContagem) async {
    ProdutoContagemHelper helper = ProdutoContagemHelper();
    Produto_Contagem produto;
    produto = await helper.salvarProdutoContagem(produtoContagem);
    return produto; //Retornar Produto para ser instanciado na lista de Produtos no objeto Local
  }

  static alterarQuantidade(Produto_Contagem produtoContagem) async {
    ProdutoContagemHelper helper = ProdutoContagemHelper();
    await helper.updateProdutoContagem(produtoContagem);
  }

  static deletarQuantidade(Produto_Contagem produtoContagem) async {
    ProdutoContagemHelper helper = ProdutoContagemHelper();
    await helper.deleteProdutoContagem(produtoContagem);
  }
}
