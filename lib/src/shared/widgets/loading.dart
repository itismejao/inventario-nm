import 'package:flutter/material.dart';
import 'package:inventario_nm/src/shared/config/app_config.dart';
import 'package:flutter/cupertino.dart';

AppConfig _appConfig = AppConfig();

Widget Loading() {
  return Container(
    color: _appConfig.colors['white'],
    child: Center(
        child: CircularProgressIndicator(
            backgroundColor: _appConfig.colors['azul_padrao'], color: _appConfig.colors['verde_padrao'], strokeWidth: 5.0,),
      ),
  );
}
