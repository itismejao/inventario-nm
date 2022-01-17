import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:inventario_nm/src/modules/api/api_produtos.dart';
import 'package:inventario_nm/src/modules/login/login_page.dart';
import 'package:inventario_nm/src/shared/config/app_config.dart';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:percent_indicator/percent_indicator.dart';

class DrawerInventario extends StatefulWidget {
  const DrawerInventario({Key? key}) : super(key: key);

  static double percentual = 0;
  static TextEditingController progresso = TextEditingController();
  static bool error = false;

  @override
  _DrawerInventarioState createState() => _DrawerInventarioState();
}

class _DrawerInventarioState extends State<DrawerInventario> {
  

  @override
  void initState() {
    _loadUserInfo();
    super.initState();
    if (ApiProdutos.controlador == null) {
      null;
    } else if (ApiProdutos.controlador == false) {
      _loading = true;
    } else {
      _loading = false;
    }
    
    DrawerInventario.progresso.addListener(() {
      if(mounted){
        setState(() {
          DrawerInventario.progresso.text = ApiProdutos.progresso.toString();
        });
      }
    });
  }

  bool _loading = false;

  String _userName = "";

  final boxatt = Hive.box('DataUltimaAtualizacao');


  

  _loadUserInfo() async {
    if (!mounted) {
      return;
    }

    await SharedPreferences.getInstance().then((prefs) {
      setState(() {
        _userName = prefs.getString('user.name') ?? "";
      });
    });
  }


  @override
  void dispose() {
    boxatt.close();
  }

  AppConfig _appConfig = AppConfig();

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Drawer(
        child: Scaffold(
          body: Container(
            child: Column(
              children: [
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height * 0.20,
                  color: _appConfig.colors['azul_padrao'],
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        margin: EdgeInsets.only(top: 20),
                        child: Image.asset(
                          'assets/images/v2-logo-novo-mundo.png',
                          scale: MediaQuery.of(context).size.width / 25.0,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 15.0),
                      ),
                      Text(
                        "Olá ${_userName.split(" ").first + ' ' + _userName.split(" ").last},\n Seja Bem Vindo!",
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 15.0,
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
                Column(
                  children: [
                    OutlinedButton(
                      onPressed: () async {
                        if (ApiProdutos.controlador == false) {
                          null;
                        } else {
                          if(mounted) {
                            setState(() {
                              _loading = true;
                            });
                          }
                          _loading = await ApiProdutos.getProducts(0, 10000);
                          boxatt.put(0, DateTime.now());
                          if(mounted){
                            setState(() {
                              _loading;
                            });
                          }
                        }
                      },
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          Align(
                            child: Icon(Icons.save_alt),
                            alignment: Alignment.centerLeft,
                          ),
                          Align(
                            child: Text('Atualizar Produtos'),
                            alignment: Alignment.center,
                          ),
                          Align(
                            child: _loading
                                ? SizedBox(
                                    height: 15.0,
                                    width: 15.0,
                                    child: CircularProgressIndicator(
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                          _appConfig.colors['azul_padrao']),
                                      strokeWidth: 3.0,
                                    ),
                                  )
                                : SizedBox.shrink(),
                            alignment: Alignment.centerRight,
                          ),
                        ],
                      ),
                      style: TextButton.styleFrom(
                        primary: Colors.black,
                        textStyle: TextStyle(fontSize: 16.0),
                      ),
                    ),
                    _loading ? 
                    Row(
                      mainAxisAlignment: ApiProdutos.cancelar || int.parse(DrawerInventario.progresso.text) == 8
                      ? 
                      MainAxisAlignment.center 
                      : 
                      MainAxisAlignment.spaceAround,
                      children: [
                        //Padding(padding: EdgeInsets.only(left: 5.0),),
                        int.parse(DrawerInventario.progresso.text) == 8 
                        ? 
                        Text("Finalizado", style: TextStyle(color:_appConfig.colors['verde_padrao']),) 
                        :
                        Text("Progresso: ${DrawerInventario.progresso.text}/7"),
                        int.parse(DrawerInventario.progresso.text) == 8 
                        ? 
                        SizedBox.shrink() 
                        :
                        ApiProdutos.cancelar == false   
                        ? 
                        IconButton(onPressed: () {
                          if(mounted) {
                            setState(() {
                              ApiProdutos.cancelar = true;
                            });
                          }
                        }, icon: Icon(Icons.close),)
                        : 
                        SizedBox.shrink(),
                      ],
                    )
                    :
                    SizedBox.shrink(),

                    DrawerInventario.error ? 
                    Text("Não foi possível conectar com a base de dados, verifique se você está em uma internet local (VPN/Wifi nmadim)", 
                    style: TextStyle(color: _appConfig.colors['vermelho_padrao']),textAlign: TextAlign.center) 
                    : SizedBox.shrink(),
                    Text("Data última att: ${boxatt.get(0)}")
                  ],
                ),
              ],
            ),
          ),
          bottomNavigationBar: Container(
            width: MediaQuery.of(context).size.width,
            height: 40.0,
            color: _appConfig.colors['azul_padrao'],
            padding: EdgeInsets.only(right: 15.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.pushReplacement(
                        context,
                        CupertinoPageRoute(
                            builder: (context) => const LoginPage()));
                  },
                  child: Row(
                    children: [
                      Text(
                        "Sair",
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                      Icon(Icons.logout, color: Colors.white)
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
