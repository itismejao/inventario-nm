import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:inventario_nm/src/controller/local_controller.dart';
import 'package:inventario_nm/src/controller/produto_contagem_controller.dart';
import 'package:inventario_nm/src/controller/produto_controller.dart';
import 'package:inventario_nm/src/model/Contagem.dart';
import 'package:inventario_nm/src/model/Local.dart';
import 'package:inventario_nm/src/model/Produto.dart';
import 'package:inventario_nm/src/model/Produto_Contagem.dart';
import 'package:inventario_nm/src/modules/home/widgets/appbar.dart';
import 'package:inventario_nm/src/shared/config/app_config.dart';
import 'package:vibration/vibration.dart';

import 'package:input_with_keyboard_control/input_with_keyboard_control.dart';

class ContagemAuditoria extends StatefulWidget {
  Contagem? contagem;
  bool? view;

  ContagemAuditoria(this.contagem, {this.view});

  @override
  _ContagemAuditoriaState createState() => _ContagemAuditoriaState();
}

class _ContagemAuditoriaState extends State<ContagemAuditoria> {
  final TextEditingController _produtoController = TextEditingController();

  Contagem? contagem;

  Produto produto = Produto();

  Produto_Contagem produto_contagem = Produto_Contagem();

  FocusNode nextFocus = FocusNode();

  AppConfig _appConfig = AppConfig();

  final valor = TextEditingController();

  @override
  void initState() {
    contagem = widget.contagem;
    contagem!.localSelecionado = TipoLocal.Geral;
    buscaLocais();
    valor.text = '1';
    super.initState();
  }

  Future myDialog(String text) async {
    if (await Vibration.hasVibrator() ?? false) {
      Vibration.vibrate(duration: 1000);
    }
    return await showDialog<String>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        backgroundColor: _appConfig.colors['azul_padrao'],
        title: Text('Aviso', style: TextStyle(color: _appConfig.colors['white'])),
        content: Text(
          text,
          style: TextStyle(color: _appConfig.colors['white']),
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () => {
              Navigator.pop(context),
            },
            child: Text(
              'OK',
              style: TextStyle(color: _appConfig.colors['white']),
            ),
          ),
        ],
      ),
    );
  }

  alterarQuantidade(Produto_Contagem produto_contagem, String value) {
    produto_contagem.quantidade = int.parse(value);
    ProdutoContagemController.alterarQuantidade(produto_contagem);
  }

  buscaLocais() async {
    contagem!.listaLocais = await LocalController.getLocal(contagem!.id_contagem);
    if (contagem!.listaLocais!.isEmpty) {
      salvarLocais();
    } else {
      preencheListaProdutos(contagem!.listaLocais![0]);
    }
  }

  preencheListaProdutos(Local local) async {
    List<Produto_Contagem> list = await ProdutoContagemController.getProdutosContagem(local);
    setState(() {
      contagem!.listaLocais!.firstWhere((element) => element.tipoLocal == contagem!.localSelecionado).listaProdutos = list;
    });
  }

  salvarLocais() async {
    contagem!.listaLocais = await LocalController.salvarLocais(contagem!.id_contagem);
  }

  buscarProdutoBipado(String bip) async {
    if (await ProdutoController.getProduto(bip) == null) {
      myDialog('ID/EAN não encontrado!');
    } else {
      produto = await ProdutoController.getProduto(bip);

      Produto_Contagem? pr;

      if (contagem!.listaLocais!.isNotEmpty) {
        pr = contagem!.listaLocais!
            .firstWhere((element) => element.tipoLocal == contagem!.localSelecionado)
            .listaProdutos!
            .firstWhere((element) => element.idProduto == produto.id_produto, orElse: () => Produto_Contagem());
        print(pr.quantidade);
        pr.quantidade == null ? salvaProduto() : atualizaProduto(pr);
      }
    }
  }

  verificarMesmoProduto() async {
    if (_produtoController.text.length == 10) {
      await buscarProdutoBipado(_produtoController.text.substring(1, 6));
    } else {
      await buscarProdutoBipado(
          _produtoController.text.substring(0, 1) == 'b' ? _produtoController.text.substring(1) : _produtoController.text);
    }
  }

  salvaProduto() async {
    produto_contagem = new Produto_Contagem();

    produto_contagem.produto = produto;
    produto_contagem.idProduto = produto.id_produto;
    produto_contagem.data_registro_item = DateTime.now();
    produto_contagem.quantidade = 1;
    produto_contagem.status = StatusProduto.Aberto;
    produto_contagem.id_local =
        contagem!.listaLocais!.firstWhere((element) => element.tipoLocal == contagem!.localSelecionado).id_local;

    Produto_Contagem produto_contagem_salvo = new Produto_Contagem();

    produto_contagem_salvo = await ProdutoContagemController.salvarProdutoContagem(produto_contagem);

    setState(() {
      contagem!.listaLocais!
          .firstWhere((element) => element.tipoLocal == contagem!.localSelecionado)
          .listaProdutos
          ?.insert(0, produto_contagem_salvo);
    });
  }

  atualizaProduto(Produto_Contagem pr) {
    pr.quantidade = pr.quantidade! + 1;

    ProdutoContagemController.alterarQuantidade(pr);
  }

  Future<List<Produto_Contagem>?> retornaLista() async {
    return contagem!.listaLocais!.firstWhere((element) => element.tipoLocal == contagem!.localSelecionado).listaProdutos;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarInventario(
        'Prevenção de Perdas',
        widget.view == true ? 2 : 1,
        contagem: contagem,
      ),
      body: Column(
        children: [
          Container(
            child: Container(
              padding: const EdgeInsets.only(left: 10, right: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Filial: ' + contagem!.id_filial.toString(),
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  DropButtonLocal()
                ],
              ),
            ),
          ),
          const Divider(
            thickness: 2,
            color: Color(0xFFDFDFDF),
          ),
          widget.view == true
              ? Container()
              : Container(
                  margin: const EdgeInsets.all(20),
                  child: TextField(
                    controller: _produtoController,
                    autofocus: true,
                    focusNode: nextFocus,
                    keyboardType: TextInputType.number,
                    maxLength: 14,
                    decoration: InputDecoration(
                      labelText: 'Código Produto / EAN',
                      alignLabelWithHint: true,
                      suffixIcon: Padding(
                        padding: EdgeInsets.all(0.0),
                        child: IconButton(
                          onPressed: () {
                            if (FocusScope.of(context).hasFocus) {
                              FocusScope.of(context).unfocus();
                            } else {
                              FocusScope.of(context).requestFocus(nextFocus);
                            }
                          },
                          icon: Icon(
                            Icons.keyboard,
                          ),
                        ),
                      ),
                    ),
                    onSubmitted: (text) {
                      if (text.isEmpty || text == '') {
                        myDialog('Digite o EAN/Código');
                      } //else if () {}
                      else {
                        setState(() {
                          verificarMesmoProduto();
                          _produtoController.clear();
                        });
                      }
                      FocusScope.of(context).requestFocus(nextFocus);
                    },
                  ),
                ),
          widget.view == true ? Container() : Divider(thickness: 6),
          Expanded(
            child: FutureBuilder(
                future: retornaLista(),
                builder: (context, AsyncSnapshot snapshot) {
                  switch (snapshot.connectionState) {
                    case ConnectionState.waiting:
                    case ConnectionState.none:
                      return Container(
                        width: 200,
                        height: 200,
                        alignment: Alignment.center,
                        child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
                          strokeWidth: 5,
                        ),
                      );
                    default:
                      if (snapshot.hasError) {
                        print(snapshot.error);
                        return Container();
                      } else
                        return ListView.builder(
                          itemCount: snapshot.data!.length,
                          itemBuilder: (context, indice) {
                            return Container(
                              padding: EdgeInsets.only(left: 10.0, top: 5.0),
                              child: Column(
                                children: [
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'ID: ' + snapshot.data![indice].produto!.id_produto.toString(),
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 18.0,
                                              height: 1.0,
                                            ),
                                          ),
                                          Text(
                                            'EAN: ' + snapshot.data![indice].produto!.ean.toString(),
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 18.0,
                                              height: 1.0,
                                            ),
                                          ),
                                          // Text(
                                          //   snapshot.data![indice].produto!.nome.toString(),
                                          //   style: TextStyle(
                                          //     fontSize: 16.0,
                                          //     height: 1.0,
                                          //   ),
                                          // ),
                                          Container(
                                            constraints: BoxConstraints(
                                              maxWidth: 250,
                                            ),
                                            child: Column(
                                              children: [
                                                Text(
                                                  snapshot.data![indice].produto!.nome.toString(),
                                                  overflow: TextOverflow.fade,
                                                  // softWrap: false,
                                                  style: TextStyle(
                                                    fontSize: 16.0,
                                                    height: 1.0,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          // Text(produtos[indice].id_local.toString()),
                                          // Text("ID: 64943",
                                          //     style: TextStyle(fontWeight: FontWeight.bold)),
                                          // Text("EAN: 0123456789",
                                          //     style: TextStyle(fontWeight: FontWeight.bold)),
                                          // Text("CJ TACA VIDRO 6P P/AGUA SQUARE")
                                        ],
                                      ),
                                      Container(
                                        child: Row(
                                          children: [
                                            // Text("3X",
                                            //     style:
                                            //         TextStyle(fontWeight: FontWeight.bold)),
                                            // DropdownButton<String>(
                                            //   items: _valores.map((e) {
                                            //     return DropdownMenuItem<String>(child:
                                            //       va
                                            //     )
                                            //   })
                                            // ),
                                            SizedBox(
                                              width: 60.0,
                                              height: 40.0,
                                              child: TextFormField(
                                                initialValue: snapshot.data![indice].quantidade.toString().toUpperCase(),
                                                enabled: widget.view == true ? false : true,
                                                textAlign: TextAlign.center,
                                                textAlignVertical: TextAlignVertical.top,
                                                keyboardType: TextInputType.number,
                                                decoration: InputDecoration(
                                                  labelText: 'Qtd',
                                                  prefixText: 'X',
                                                  contentPadding: EdgeInsets.only(bottom: 5, left: 12),
                                                  enabledBorder: UnderlineInputBorder(
                                                    borderSide: BorderSide(
                                                      color: _appConfig.colors['azul_padrao'],
                                                    ),
                                                  ),
                                                  focusedBorder: UnderlineInputBorder(
                                                    borderSide: BorderSide(
                                                      color: _appConfig.colors['azul_padrao'],
                                                    ),
                                                  ),
                                                ),
                                                onFieldSubmitted: (value) {
                                                  setState(() {
                                                    alterarQuantidade(snapshot.data![indice], value);
                                                    FocusScope.of(context).requestFocus(nextFocus);
                                                  });
                                                },
                                              ),
                                            ),
                                            widget.view == true
                                                ? Container(
                                                    padding: EdgeInsets.all(5),
                                                  )
                                                : IconButton(
                                                    onPressed: () {
                                                      //produtos.removeAt(indice);
                                                      //setState(() {});
                                                      // MyShowDialog(context,
                                                      //     'Deseja excluir o produto ${snapshot.data![indice].produto!.nome.toString()}?',
                                                      //     produto_contagem: snapshot.data![indice]);

                                                      showDialog(
                                                        context: context,
                                                        builder: (BuildContext context) => AlertDialog(
                                                          shape: RoundedRectangleBorder(
                                                            borderRadius: BorderRadius.circular(
                                                              10,
                                                            ),
                                                          ),
                                                          contentPadding: EdgeInsets.fromLTRB(50, 20, 50, 10),
                                                          content: Text(
                                                            'Deseja excluir a contagem do produto: (${snapshot.data[indice].produto.id_produto}) - ${snapshot.data[indice].produto.nome}?',
                                                            textAlign: TextAlign.center,
                                                            style: TextStyle(
                                                              color: Colors.black,
                                                              fontWeight: FontWeight.bold,
                                                              fontSize: 20.0,
                                                            ),
                                                          ),
                                                          actions: [
                                                            Divider(
                                                              color: Colors.grey,
                                                              height: 4.0,
                                                            ),
                                                            Padding(
                                                              padding: EdgeInsets.only(top: 10.0),
                                                            ),
                                                            Row(
                                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                              children: [
                                                                SizedBox(
                                                                  width: MediaQuery.of(context).size.width * .35,
                                                                  child: ElevatedButton(
                                                                    onPressed: () {
                                                                      setState(() {
                                                                        ProdutoContagemController.deletarQuantidade(
                                                                            snapshot.data[indice]);
                                                                        snapshot.data.removeAt(indice);
                                                                        Navigator.pop(context);
                                                                      });
                                                                    },
                                                                    child: Text('Sim'),
                                                                    style: ElevatedButton.styleFrom(
                                                                      primary: _appConfig.colors['verde_padrao'],
                                                                      shape: RoundedRectangleBorder(
                                                                        borderRadius: BorderRadius.circular(30),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ),
                                                                SizedBox(
                                                                  width: MediaQuery.of(context).size.width * .35,
                                                                  child: ElevatedButton(
                                                                    onPressed: () {
                                                                      Navigator.pop(context);
                                                                    },
                                                                    child: Text('Não'),
                                                                    style: ElevatedButton.styleFrom(
                                                                      primary: _appConfig.colors['vermelho_padrao'],
                                                                      shape: RoundedRectangleBorder(
                                                                        borderRadius: BorderRadius.circular(30),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ],
                                                          elevation: 24.0,
                                                          backgroundColor: _appConfig.colors['white'],
                                                        ),
                                                      );
                                                    },
                                                    icon: Icon(Icons.delete))
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  Divider(thickness: 2, endIndent: 20),
                                ],
                              ),
                            );
                          },
                        );
                  }
                }),
          ),
        ],
      ),
      // bottomNavigationBar: BottomAppBar(
      //   child: Container(
      //     width: MediaQuery.of(context).size.width,
      //     height: MediaQuery.of(context).size.height / 20,
      //     color: _appConfig.colors['azul_padrao'],
      //     child: Row(
      //       crossAxisAlignment: CrossAxisAlignment.center,
      //       mainAxisAlignment: MainAxisAlignment.center,
      //       children: <Widget>[
      //         Text(
      //           'Produtos: ' + contagem!.listaLocais!.firstWhere((element) => element.tipoLocal == contagem!.localSelecionado).listaProdutos!.length.toString(),
      //           style: TextStyle(
      //             color: _appConfig.colors['white'],
      //           ),
      //         ),
      //         Text(
      //           ' - Qtd Total: ' + somaQtds(),
      //           style: TextStyle(
      //             color: _appConfig.colors['white'],
      //           ),
      //         )
      //       ],
      //     ),
      //   ),
      // ),
    );
  }

  String dropdownValue = TipoLocal.Geral.toString();

  somaQtds() {
    int? somaQtd = contagem!.listaLocais!
        .firstWhere((element) => element.tipoLocal == contagem!.localSelecionado)
        .listaProdutos!
        .fold(0, (previousValue, element) => previousValue! + element.quantidade!.toInt());
    return somaQtd.toString();
  }

  Widget DropButtonLocal() {
    return DropdownButton<String>(
      value: dropdownValue,
      elevation: 16,
      icon: const Icon(Icons.keyboard_arrow_down, color: Colors.black),
      style: const TextStyle(
        color: Colors.black,
        fontWeight: FontWeight.bold,
        fontSize: 17,
      ),
      underline: Container(
        height: 2,
        color: Colors.black,
      ),
      onChanged: (String? newValue) {
        setState(() {
          if (dropdownValue != newValue) {
            dropdownValue = newValue!;
            contagem!.localSelecionado = TipoLocal.values.firstWhere((element) => element.toString() == newValue);
            preencheListaProdutos(
                contagem!.listaLocais!.firstWhere((element) => element.tipoLocal == contagem!.localSelecionado));
          }
        });
      },
      items: <TipoLocal>[TipoLocal.Geral, TipoLocal.Loja, TipoLocal.Deposito, TipoLocal.Asteca, TipoLocal.AstecaObsoleto]
          .map<DropdownMenuItem<String>>((TipoLocal value) {
        return DropdownMenuItem<String>(
          value: value.toString(),
          child: Text(value.toString().split('.').last),
        );
      }).toList(),
    );
  }
}
