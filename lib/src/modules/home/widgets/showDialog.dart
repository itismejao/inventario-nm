import 'package:flutter/material.dart';
import 'package:inventario_nm/src/controller/produto_contagem_controller.dart';
import 'package:inventario_nm/src/model/Contagem.dart';
import 'package:inventario_nm/src/model/Local.dart';
import 'package:inventario_nm/src/model/Produto_Contagem.dart';
import 'package:inventario_nm/src/modules/api/api_primeira_contagem.dart';
import 'package:inventario_nm/src/modules/contagem/contagem.dart';
import 'package:inventario_nm/src/shared/config/app_config.dart';
import 'package:inventario_nm/src/controller/contagem_controller.dart';
import 'package:inventario_nm/src/modules/home/home_page.dart';

// class MyShowDialog extends StatefulWidget {
//   // const testandoDialog({ Key? key }) : super(key: key);

//   MyShowDialog(context, this.titulo, {this.contagem, this.produto_contagem});

//   String titulo;
//   Contagem? contagem;
//   Produto_Contagem? produto_contagem;

//   @override
//   _MyShowDialogState createState() => _MyShowDialogState();
// }

// class _MyShowDialogState extends State<MyShowDialog> {
//   AppConfig _appConfig = AppConfig();
//   @override
//   build(BuildContext context) async {
//     return await showDialog(
//       context: context,
//       builder: (BuildContext context) => AlertDialog(
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(
//             10,
//           ),
//         ),
//         contentPadding: EdgeInsets.fromLTRB(50, 20, 50, 10),
//         content: Text(
//           widget.titulo.toString(),
//           textAlign: TextAlign.center,
//           style: TextStyle(
//             color: Colors.black,
//             fontWeight: FontWeight.bold,
//             fontSize: 20.0,
//           ),
//         ),
//         actions: [
//           Divider(
//             color: Colors.grey,
//             height: 4.0,
//           ),
//           Padding(
//             padding: EdgeInsets.only(top: 10.0),
//           ),
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               SizedBox(
//                 width: MediaQuery.of(context).size.width * .35,
//                 child: ElevatedButton(
//                   onPressed: () {
//                     if (widget.contagem != null) {
//                       if (widget.contagem!.status != StatusContagem.Finalizar) {
//                         ContagemController.deleteContagem(widget.contagem!);
//                         Navigator.pop(context);
//                         Navigator.push(context, MaterialPageRoute(builder: (context) => HomePage()));
//                       } else {
//                         widget.contagem!.status = StatusContagem.Encerrado;
//                         ContagemController.updateContagem(widget.contagem!);
//                         Navigator.pop(context);
//                         Navigator.push(context, MaterialPageRoute(builder: (context) => HomePage()));
//                       }
//                     } else {
//                       ProdutoContagemController.deletarQuantidade(widget.produto_contagem!);
//                       Navigator.pop(context);
//                     }
//                   },
//                   child: Text('Sim'),
//                   style: ElevatedButton.styleFrom(
//                     primary: _appConfig.colors['verde_padrao'],
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(30),
//                     ),
//                   ),
//                 ),
//               ),
//               SizedBox(
//                 width: MediaQuery.of(context).size.width * .35,
//                 child: ElevatedButton(
//                   onPressed: () {
//                     Navigator.pop(context);
//                   },
//                   child: Text('Não'),
//                   style: ElevatedButton.styleFrom(
//                     primary: _appConfig.colors['vermelho_padrao'],
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(30),
//                     ),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ],
//         elevation: 24.0,
//         backgroundColor: _appConfig.colors['white'],
//       ),
//     );
//   }
// }
  

Future MyShowDialog(context, String titulo,
  {Contagem? contagem, Produto_Contagem? produto_contagem, bool view = false, bool? excluir}) async {
  AppConfig _appConfig = AppConfig();

  bool hasError = false;

  return await showDialog(
    context: context,
    builder: (BuildContext context) => AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(
          10,
        ),
      ),
      contentPadding: EdgeInsets.fromLTRB(50, 20, 50, 10),
      content: Text(
        titulo.toString(),
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
                onPressed: () async {
                  if (contagem != null) {
                    if (excluir == true) {
                      ContagemController.deleteContagem(contagem);
                      Navigator.pop(context);
                      Navigator.push(context, MaterialPageRoute(builder: (context) => HomePage()));
                      print('if 1');
                    } else if (contagem.status == StatusContagem.Encerrado) {
                      Navigator.pop(context);
                      Navigator.push(context, MaterialPageRoute(builder: (context) => ContagemAuditoria(contagem, view: true)));
                      print('if 2');
                    } else {
                      
                      Local l = Local(contagem.id_contagem, TipoLocal.Geral);
                      contagem.listaLocais?.add(l);
                      hasError = await ApiPrimeiraContagem.enviaContagem(contagem);
                      //ApiPrimeiraContagem.montarJson(contagem);
                      if (hasError) {
                        Navigator.pop(context);
                        Navigator.push(context, MaterialPageRoute(builder: (context) => HomePage())); 
                        showDialog<String>(
                          context: context,
                          builder: (BuildContext context) => AlertDialog(
                            backgroundColor: _appConfig.colors['vermelho_padrao'],
                            title: Text('Aviso', style: TextStyle(color: _appConfig.colors['white'])),
                            content: Text(
                             "Erro ao conectar com o Vtrine, verifique sua conexão com a internet interna (VPN/Wifi nmadmin)",
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
                      }else {
                        contagem.status = StatusContagem.Encerrado;
                        ContagemController.updateContagem(contagem);
                        Navigator.pop(context);
                        Navigator.push(context, MaterialPageRoute(builder: (context) => HomePage()));  
                        print('if 3');
                      }
                    }
                  } else {
                    ProdutoContagemController.deletarQuantidade(produto_contagem!);
                    Navigator.pop(context);
                    print('if fora');
                  }
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
}
