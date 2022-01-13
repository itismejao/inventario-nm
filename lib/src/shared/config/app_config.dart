import 'package:flutter/material.dart';

class AppConfig {
  final String title = 'Inventário Novo Mundo';
  final String baseUrl = _getValue('base_url');
  final colors = _getValue('colors');
  final String versaoApp = '1.0.0';

  static _getValue(key) {
    Map configs = {};

    configs['base_url'] = 'https://cockpit.novomundo.com.br/api';

    configs['colors'] = {
      'azul_padrao': const Color(0xFF040491),
      'white': const Color(0xFFFFFFFF),
      'verde_padrao': const Color(0xFF008D00),
      'vermelho_padrao': const Color(0xFFBA3424),
      'preto_fonte': const Color(0xFF000000),
      'cinza_padrao': const Color(0xFFDFDFDF)
    };

    return configs[key];
  }
}
