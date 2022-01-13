import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:inventario_nm/src/controller/contagem_controller.dart';
import 'package:inventario_nm/src/model/Contagem.dart';
import 'package:inventario_nm/src/modules/home/widgets/appbar.dart';
import 'package:inventario_nm/src/modules/home/widgets/drawer.dart';
import 'package:inventario_nm/src/modules/home/widgets/floatingButton.dart';
import 'package:inventario_nm/src/modules/home/widgets/panel_list_andamento.dart';
import 'package:inventario_nm/src/persist/dbhelper.dart';





class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with SingleTickerProviderStateMixin {

  @override
  void initState() {
    verificarExclusaoContagem();
    super.initState();
  }

  verificarExclusaoContagem() async {
    List<Contagem> contagens = await ContagemController.listaContagemPorStatus(1);
    DateTime data = DateTime.now().toUtc();

    for (Contagem c in contagens){
      if(c.data_cria!.toUtc().difference(data).inDays >= 3){
        ContagemController.deleteContagem(c);
        setState(() {
          
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const DrawerInventario(),
      appBar: AppBarInventario('Prevenção de Perdas', 0),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.only(top: 15.0),
          child: Column(
            children: [
              const Padding(
                padding: EdgeInsets.only(top: 10),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Conferência de Estoque',
                    style: Theme.of(context).textTheme.headline2,
                  ),
                ],
              ),
              const Padding(
                padding: EdgeInsets.only(top: 30),
              ),
              Container(
                child: Column(
                  children: [
                    FutureBuilder(
                      builder: (context, snapshot) => ExpandedListAndamento(0, 1),
                    ),
                    FutureBuilder(
                      builder: (context, snapshot) => ExpandedListAndamento(1, 0),
                    ),
                    Padding(padding: EdgeInsets.only(bottom: 70.0)),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingButton(),
    );
  }
}
