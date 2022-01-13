import 'package:flutter/material.dart';
import 'package:inventario_nm/src/controller/contagem_controller.dart';
import 'package:inventario_nm/src/model/Contagem.dart';
import 'package:intl/intl.dart';
import 'package:inventario_nm/src/modules/contagem/contagem.dart';
import 'package:inventario_nm/src/modules/home/widgets/showDialog.dart';
import 'package:inventario_nm/src/shared/config/app_config.dart';

import '../home_page.dart';

class CardAndamento {
  CardAndamento({
    required this.expandedValue,
    required this.headerValue,
    this.isExpanded = false,
  });

  String? expandedValue;
  String? headerValue;
  bool isExpanded;
}

class ExpandedListAndamento extends StatefulWidget {
  //ExpandedListAndamento({Key? key,}) : super(key: key);

  int? statusContagem;
  String? titulo;
  ExpandedListAndamento(/*this.titulo,*/ int qualTituloInt, this.statusContagem) {
    if (qualTituloInt == 0) {
      _ExpandedListAndamentoState _expandedListAndamentoState = _ExpandedListAndamentoState(qualTitulo: 0);
    }
    if (qualTituloInt == 1) {
      _ExpandedListAndamentoState _expandedListAndamentoState = _ExpandedListAndamentoState(qualTitulo: 1);
    }
  }

  @override
  State<ExpandedListAndamento> createState() => _ExpandedListAndamentoState();
}

class _ExpandedListAndamentoState extends State<ExpandedListAndamento> {
  static String? _titulo;
  int? statusContagem;
  _ExpandedListAndamentoState({int? qualTitulo}) {
    if (qualTitulo == 0) {
      _titulo = 'Em Andamento';
    }
    if (qualTitulo == 1) {
      _titulo = 'Finalizados';
    }
  }

  final AppConfig _appConfig = AppConfig();

  @override
  void initState() {
    statusContagem = widget.statusContagem;
    print(statusContagem);
  }

  List<CardAndamento> cards = <CardAndamento>[
    CardAndamento(
      headerValue: _titulo,
      expandedValue: "Aqui vem os abertos para Contagem",
      isExpanded: true,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        child: _buildPanel(),
      ),
    );
  }

  Widget _buildPanel() {
    return ExpansionPanelList(
      animationDuration: const Duration(milliseconds: 500),
      // Animação ao expandir
      expandedHeaderPadding: const EdgeInsets.all(10),
      // padding no titulo
      elevation: 0,
      // Retira sombra dos cards
      expansionCallback: (int index, bool isExpanded) {
        setState(() {
          cards[index].isExpanded = !isExpanded;
        });
      },
      children: cards.map<ExpansionPanel>((CardAndamento card) {
        return ExpansionPanel(
          canTapOnHeader: true, // Permite clicar também no titulo para expandir
          headerBuilder: (BuildContext context, bool isExpanded) {
            return ListTile(
              title: Text(
                card.headerValue.toString(),
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20.0,
                ),
              ),
              shape: const Border(
                bottom: BorderSide(
                  color: Colors.black,
                  width: 0.5,
                ),
              ),
              visualDensity: VisualDensity.standard,
            );
          },
          body: listViewCard(),
          isExpanded: card.isExpanded,
        );
      }).toList(),
    );
  }

  Widget listViewCard() {
    return FutureBuilder(
        future: ContagemController.listaContagemPorStatus(statusContagem!),
        builder: (context, AsyncSnapshot snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
            case ConnectionState.none:
              return Container(
                width: 200,
                height: 200,
                alignment: Alignment.center,
                child: const CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
                  strokeWidth: 5,
                ),
              );
            default:
              if (snapshot.hasError) {
                print(snapshot.error);
                return Container();
              } else {
                return ListView.builder(
                    physics: const NeverScrollableScrollPhysics(), // Permite scroll dentro do ExpansionPanel
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    padding: const EdgeInsets.all(4),
                    itemCount: snapshot.data!.length,
                    reverse: true,
                    itemBuilder: (context, index) {         
                      return SingleChildScrollView(
                        child: Column(
                          children: [
                            Card(
                              margin: EdgeInsets.fromLTRB(0, 0, 0, 5),
                              elevation: 0,
                              child: Column(
                                children: [
                                  Container(
                                    padding: EdgeInsets.only(left: 10.0),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              children: [
                                                Text(
                                                  'ID Contagem: ',
                                                  style: Theme.of(context).textTheme.headline3,
                                                ),
                                                Text(
                                                  snapshot.data[index].id_contagem.toString(),
                                                  style: Theme.of(context).textTheme.subtitle1,
                                                ),
                                              ],
                                            ),
                                            Row(
                                              children: [
                                                Text(
                                                  'Filial: ',
                                                  style: Theme.of(context).textTheme.headline3,
                                                ),
                                                Text(
                                                  snapshot.data[index].id_filial.toString(),
                                                  style: Theme.of(context).textTheme.subtitle1,
                                                ),
                                              ],
                                            ),
                                            Row(
                                              children: [
                                                Text(
                                                  'Data Agendada: ',
                                                  style: Theme.of(context).textTheme.headline3,
                                                ),
                                                Text(
                                                  DateFormat('dd/MM/yyyy').format(snapshot.data[index].data_cria),
                                                  style: Theme.of(context).textTheme.subtitle1,
                                                ),
                                              ],
                                            ),
                                            snapshot.data[index].observacoes == ''
                                                ? SizedBox.shrink()
                                                : Row(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      Text(
                                                        'Observação: ',
                                                        style: Theme.of(context).textTheme.headline3,
                                                      ),
                                                      Container(
                                                        constraints: BoxConstraints(
                                                          maxWidth: 200,
                                                        ),
                                                        child: Column(
                                                          children: [
                                                            Text(
                                                              snapshot.data[index].observacoes.toString(),
                                                              overflow: TextOverflow.fade,
                                                              softWrap: false,
                                                              style: Theme.of(context).textTheme.subtitle1,
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                            Row(
                                              children: [
                                                Text(
                                                  'Status: ',
                                                  style: Theme.of(context).textTheme.headline3,
                                                ),
                                                Text(
                                                  snapshot.data[index].status.toString().split('.').last.toString(),
                                                  style: Theme.of(context).textTheme.subtitle1,
                                                ),
                                              ],
                                            ),
                                            snapshot.data[index].status == StatusContagem.Pendente
                                                ? Row(
                                                    children: [
                                                      Padding(padding: EdgeInsets.only(top: 30.0)),
                                                      Text(
                                                        'Inventário com divergências',
                                                        style: TextStyle(
                                                          color: _appConfig.colors['vermelho_padrao'],
                                                          fontWeight: FontWeight.bold,
                                                          fontSize: 16.0,
                                                        ),
                                                      ),
                                                    ],
                                                  )
                                                : SizedBox.shrink(),
                                          ],
                                        ),
                                        snapshot.data[index].status == StatusContagem.Finalizar
                                            ? IconButton(
                                                onPressed: () {
                                                  MyShowDialog(context, 'Deseja cancelar a contagem?',
                                                      contagem: snapshot.data[index], excluir: true);
                                                },
                                                icon: Icon(Icons.delete),
                                              )
                                            : SizedBox.shrink(),
                                        snapshot.data[index].status == StatusContagem.Encerrado
                                            ? IconButton(
                                                onPressed: () {
                                                  print(snapshot.data[index]);
                                                  MyShowDialog(context, 'Deseja visualizar a contagem?',
                                                      contagem: snapshot.data[index], view: true);
                                                },
                                                icon: Icon(Icons.remove_red_eye),
                                              )
                                            : SizedBox.shrink(),
                                      ],
                                    ),
                                  ),
                                  snapshot.data[index].status != StatusContagem.Encerrado
                                      ? Container(
                                          padding: const EdgeInsets.fromLTRB(10, 10, 10, 5),
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: <Widget>[
                                              SizedBox(
                                                width: MediaQuery.of(context).size.width * .6,
                                                child: ElevatedButton(
                                                  onPressed: () {
                                                    if (snapshot.data[index].status != StatusContagem.Finalizar) {
                                                      Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                          builder: (context) => ContagemAuditoria(snapshot.data[index]),
                                                        ),
                                                      );
                                                    }
                                                    if (snapshot.data[index].status != StatusContagem.Finalizar) {
                                                      setState(() {
                                                        snapshot.data[index].status = StatusContagem.Iniciado;
                                                        ContagemController.updateContagem(snapshot.data[index]);
                                                      });
                                                    } else if (snapshot.data[index].status == StatusContagem.Finalizar) {
                                                      MyShowDialog(context, "Deseja finalizar a contagem?",
                                                          contagem: snapshot.data[index]);
                                                    }
                                                  },
                                                  child: Text(
                                                    snapshot.data[index].status == StatusContagem.Criado
                                                        ? 'Iniciar Contagem'
                                                        : snapshot.data[index].status == StatusContagem.Iniciado
                                                            ? 'Continuar'
                                                            : snapshot.data[index].status == StatusContagem.Finalizar
                                                                ? 'Finalizar'
                                                                : snapshot.data[index].status == StatusContagem.Pendente
                                                                    ? 'Iniciar Recontagem'
                                                                    : 'Sem dados',
                                                    style: Theme.of(context).textTheme.button,
                                                  ),
                                                  style: ElevatedButton.styleFrom(
                                                    primary: snapshot.data[index].status == StatusContagem.Criado ||
                                                            snapshot.data[index].status == StatusContagem.Iniciado
                                                        ? _appConfig.colors['verde_padrao']
                                                        : _appConfig.colors['azul_padrao'],
                                                    elevation: 0,
                                                    shape: RoundedRectangleBorder(
                                                      borderRadius: BorderRadius.circular(30),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              snapshot.data[index].status == StatusContagem.Pendente
                                                  ? SizedBox.shrink()
                                                  : SizedBox(
                                                      width: MediaQuery.of(context).size.width * .3,
                                                      child: ElevatedButton(
                                                        onPressed: () {
                                                          if (snapshot.data[index].status == StatusContagem.Finalizar) {
                                                            Navigator.push(
                                                                context,
                                                                MaterialPageRoute(
                                                                    builder: (context) =>
                                                                        ContagemAuditoria(snapshot.data[index])));
                                                          }
                                                          snapshot.data[index].status == StatusContagem.Finalizar
                                                              ? setState(() {
                                                                  snapshot.data[index].status = StatusContagem.Iniciado;
                                                                  ContagemController.updateContagem(snapshot.data[index]);
                                                                })
                                                              : MyShowDialog(context, 'Deseja cancelar a contagem?',
                                                                  contagem: snapshot.data[index], excluir: true);
                                                        },
                                                        child: Text(
                                                          snapshot.data[index].status == StatusContagem.Finalizar
                                                              ? 'Continuar'
                                                              : 'Cancelar',
                                                          style: Theme.of(context).textTheme.button,
                                                        ),
                                                        style: ElevatedButton.styleFrom(
                                                          primary: snapshot.data[index].status == StatusContagem.Finalizar
                                                              ? _appConfig.colors['verde_padrao']
                                                              : _appConfig.colors['vermelho_padrao'],
                                                          elevation: 0,
                                                          shape: RoundedRectangleBorder(
                                                            borderRadius: BorderRadius.circular(30),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                            ],
                                          ),
                                        )
                                      : const Text(''),
                                ],
                              ),
                            ),
                            Divider(
                              color: _appConfig.colors['cinza_padrao'],
                              thickness: 2,
                              indent: 10,
                              endIndent: 10,
                            ),
                          ],
                        ),
                      );
                    });
              }
          }
        });
  }
}
