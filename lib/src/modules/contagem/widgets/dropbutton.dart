import 'package:flutter/material.dart';
import 'package:inventario_nm/src/controller/contagem_controller.dart';
import 'package:inventario_nm/src/controller/local_controller.dart';
import 'package:inventario_nm/src/model/Contagem.dart';
import 'package:inventario_nm/src/model/Local.dart';
import 'package:inventario_nm/src/shared/config/app_config.dart';

class DropButtonContagem extends StatefulWidget {
  DropButtonContagem(this.contagem);
  Contagem? contagem;
  @override
  _DropButtonContagemState createState() => _DropButtonContagemState();
}

class _DropButtonContagemState extends State<DropButtonContagem> {
  String dropdownValue = TipoLocal.Geral.toString();

  //late TipoLocal tipoLocal;

  Local local = Local();

  late Contagem? _contagem;

  @override
  void initState() {
    _contagem = widget.contagem;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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
          dropdownValue = newValue!;
          _contagem!.localSelecionado = TipoLocal.values.firstWhere((element) => element.toString() == newValue);

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
