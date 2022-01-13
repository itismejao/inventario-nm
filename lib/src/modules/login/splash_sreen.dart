

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:inventario_nm/src/modules/login/login_page.dart';
import 'package:inventario_nm/src/shared/config/app_config.dart';

class SplashScreen extends StatefulWidget  {
  const SplashScreen({ Key? key }) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

    late AppConfig _appConfig;

    @override
  void initState() {
    _appConfig = AppConfig();

    Timer(const Duration(seconds: 2), () {
      Navigator.of(context).pop();
      Navigator.push(context, MaterialPageRoute(builder: (context) => const LoginPage()));
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: _appConfig.colors['azul_padrao'],
      child: const Center(
        child: Image(image: AssetImage('assets/icons/inventory.png'), width: 250.0, height: 250.0,),
      ),
      
    );
  }
}