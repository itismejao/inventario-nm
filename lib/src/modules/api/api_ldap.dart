import 'dart:io';

import 'package:flutter/material.dart';
import 'package:inventario_nm/src/shared/config/app_config.dart';
import 'package:inventario_nm/src/modules/api/util_token.dart';
import 'package:http/http.dart' as http;

class ApiLdap {
  String? body;
  int? statusCode;
  bool? error;

  ApiLdap({this.body = '', this.statusCode = 0, this.error = false});

  static AppConfig appConfig = AppConfig();

  var _baseUrl = appConfig.baseUrl;

  String _token = '';

  Future postRequest({@required String? urlSegment, var options}) async {
    var url = Uri.parse(_baseUrl + urlSegment!);

    error = false;

    try {
      _token = await getStringToken('user.token');

      await http
          .post(url,
              headers: {
                HttpHeaders.contentTypeHeader: 'application/json',
                HttpHeaders.authorizationHeader: "Basic $_token",
              },
              body: options['body'])
          .timeout(const Duration(seconds: 60))
          .then((response) =>
              {statusCode = response.statusCode, body = response.body});
    } catch (e) {
      error = true;
    }
  }
}
