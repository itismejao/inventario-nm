import 'package:flutter/material.dart';
import 'package:inventario_nm/src/controller/contagem_controller.dart';
import 'package:inventario_nm/src/model/Contagem.dart';
import 'package:inventario_nm/src/modules/home/home_page.dart';

class AppBarInventario extends StatelessWidget implements PreferredSizeWidget {
  final AppBar appBar = new AppBar();
  String titulo;
  int icone;
  Contagem? contagem;

  AppBarInventario(this.titulo, this.icone, {this.contagem});

  void _resetPage() {
    null;
  }

  getActions(int action, BuildContext context) {
    switch (action) {
      case 0:
        return SizedBox.shrink(); //IconButton(onPressed: _resetPage, icon: Icon(Icons.refresh));
      case 1:
        return IconButton(
            onPressed: () {
              contagem?.status = StatusContagem.Finalizar;
              ContagemController.updateContagem(contagem!);
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => HomePage(),
                  ));
              // MaterialPageRoute(
              //   builder: (context) => HomePage(),
              // );
            },
            icon: Icon(Icons.save));
      case 2:
        return Container();
    }
  }

  @override
  Size get preferredSize => new Size.fromHeight(appBar.preferredSize.height);

  @override
  Widget build(BuildContext context) {
    return PreferredSize(
      child: AppBar(
        title: Text(
          titulo,
          style: Theme.of(context).textTheme.headline1,
        ),
        backgroundColor: Theme.of(context).primaryColor,
        actions: [
          getActions(icone, context),
        ],
      ),
      preferredSize: Size.fromHeight(50.0),
    );
  }
}
