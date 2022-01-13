import 'package:flutter/material.dart';
import 'package:inventario_nm/src/controller/contagem_controller.dart';
import 'package:inventario_nm/src/model/Contagem.dart';
import 'package:inventario_nm/src/modules/home/home_page.dart';
import 'package:inventario_nm/src/shared/config/app_config.dart';

class FloatingButton extends StatelessWidget {
  AppConfig _appConfig = AppConfig();
  final _id_filial = TextEditingController();
  final _observacoes = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 50.0,
      height: 50.0,
      child: FittedBox(
        child: FloatingActionButton(
          onPressed: () => showDialog<Widget>(
            context: context,
            barrierDismissible: false,
            builder: (BuildContext context) => AlertDialog(
              title: Text(
                'Cadastrar Contagem',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              content: Container(
                width: 300.0,
                child: Form(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Divider(
                        color: Colors.grey,
                        height: 4.0,
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 15.0),
                      ),
                      TextFormField(
                        controller: _id_filial,
                        cursorColor: Theme.of(context).primaryColor,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                            hintText: "Digite o Centro de Custo",
                            labelText: 'Centro de Custo',
                            labelStyle: TextStyle(
                              color: Theme.of(context).primaryColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 13.0,
                            )),
                      ),
                      Padding(padding: EdgeInsets.only(top: 10.0)),
                      TextFormField(
                        controller: _observacoes,
                        cursorColor: Theme.of(context).primaryColor,
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                            hintText: "Digite a Observação",
                            labelText: 'Observação',
                            border: InputBorder.none,
                            labelStyle: TextStyle(
                              color: Theme.of(context).primaryColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 13.0,
                            )),
                      ),
                    ],
                  ),
                ),
              ),
              actions: <Widget>[
                ElevatedButton(
                  child: Text(
                    "Cancelar",
                    style: Theme.of(context).textTheme.button,
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(_appConfig.colors['vermelho_padrao']),
                  ),
                ),
                ElevatedButton(
                  child: Text(
                    "Salvar",
                    style: Theme.of(context).textTheme.button,
                  ),
                  onPressed: () {
                    if (_id_filial.text != null && _id_filial.text != '') {
                      ContagemController.salvarContagem((int.parse(_id_filial.text)), _observacoes.text);
                      //Navigator.of(context).pop();
                      Navigator.push(context, MaterialPageRoute(builder: (context) => HomePage()));
                    }
                  },
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(_appConfig.colors['verde_padrao']),
                  ),
                ),
              ],
            ),
          ),
          tooltip: 'Count',
          child: Icon(
            Icons.add,
            size: 40.0,
          ),
          backgroundColor: Theme.of(context).primaryColor,
        ),
      ),
    );
  }
}
