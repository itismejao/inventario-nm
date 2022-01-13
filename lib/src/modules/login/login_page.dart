import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:inventario_nm/src/modules/api/api_ldap.dart';
import 'package:inventario_nm/src/modules/home/home_page.dart';
import 'package:inventario_nm/src/shared/config/app_config.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:inventario_nm/src/shared/widgets/loading.dart';
import 'dart:convert';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key, this.errorCode}) : super(key: key);
  final int? errorCode;

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _passwordVisibility = false;
  bool _btnEnabled = false;
  bool _processing = false;

  late Widget currentWidget;

  late AppConfig _appConfig;

  TextEditingController _re = TextEditingController();
  TextEditingController _senha = TextEditingController();

  ScrollController _scrolController = ScrollController();

  @override
  void initState() {
    super.initState();
    _errorCode = widget.errorCode ?? 0;
    _clearOldCredentials();
    _re.addListener(_enableSubmit);
    _senha.addListener(_enableSubmit);
    _appConfig = AppConfig();
    // _re.text = '';
    // _senha.text = '';
  }

  void dispose() {
    super.dispose();
    _scrolController.dispose();
  }

  ApiLdap _apiLdap = ApiLdap();

  FocusNode nextFocus = new FocusNode();

  int? _errorCode;

  static const _messages = {
    0: 'Utilize seu RE e Senha do Vtrine para entrar no aplicativo',
    1: 'Credenciais inválidas, tente novamente',
    2: 'Acesso negado neste momento',
    3: 'Credenciais inválidas, tente novamente',
    4: 'Sessão expirada, faça login novamente',
    5: 'Sessão expirada, faça login novamente',
    6: 'Ocorreu uma falha, tente novamente',
    999: 'Não foi possível conectar, tente novamente'
  };

  @override
  Widget build(BuildContext context) {
    return currentWidget = (_processing == false) ? _login() : Loading();
  }

  Widget _login() {
    return Scaffold(
      body: SingleChildScrollView(
        controller: _scrolController,
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height / 3.2,
                color: _appConfig.colors['azul_padrao'],
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Image.asset(
                      'assets/icons/inventory.png',
                      scale: MediaQuery.of(context).size.width / 50,
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Inventário",
                          textAlign: TextAlign.left,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: _appConfig.colors['white'],
                            fontSize: MediaQuery.of(context).size.width / 11,
                          ),
                        ),
                        Image.asset(
                          'assets/images/v2-logo-novo-mundo.png',
                          scale: MediaQuery.of(context).size.width / 20,
                        ),
                      ],
                    )
                  ],
                ),
              ),
              Center(
                child: Container(
                    padding: const EdgeInsets.only(top: 20),
                    margin: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        Text(
                          _messages[_errorCode]!,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: _errorCode != 0 ? _appConfig.colors['vermelho_padrao'] : _appConfig.colors['azul_padrao'],
                              fontWeight: FontWeight.bold,
                              fontSize: 15.0),
                        ),
                        const Padding(
                          padding: EdgeInsets.only(bottom: 20.0),
                        ),
                        TextFormField(
                          keyboardType: TextInputType.number,
                          controller: _re,
                          decoration: InputDecoration(
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: _appConfig.colors['azul_padrao']),
                            ),
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: _appConfig.colors['azul_padrao']),
                            ),
                            icon: Icon(
                              Icons.person,
                              color: _appConfig.colors['azul_padrao'],
                            ),
                            labelText: "RE",
                            labelStyle: TextStyle(color: _appConfig.colors['azul_padrao'], fontWeight: FontWeight.bold),
                            border: const OutlineInputBorder(),
                          ),
                          cursorColor: _appConfig.colors['azul_padrao'],
                          style: TextStyle(
                            color: _appConfig.colors['azul_padrao'],
                            fontSize: 17.0,
                          ),
                          onFieldSubmitted: (value) {
                            FocusScope.of(context).requestFocus(nextFocus);
                          },
                        ),
                        const SizedBox(
                          height: 25,
                        ),
                        TextFormField(
                          focusNode: nextFocus,
                          controller: _senha,
                          obscureText: _passwordVisibility ? false : true,
                          decoration: InputDecoration(
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: _appConfig.colors['azul_padrao']),
                            ),
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: _appConfig.colors['azul_padrao']),
                            ),
                            icon: Icon(
                              Icons.lock,
                              color: _appConfig.colors['azul_padrao'],
                            ),
                            suffixIcon: IconButton(
                              onPressed: () {
                                setState(() {
                                  if (_passwordVisibility) {
                                    _passwordVisibility = false;
                                  } else {
                                    _passwordVisibility = true;
                                  }
                                });
                              },
                              icon: _passwordVisibility
                                  ? Icon(
                                      Icons.visibility,
                                      color: _appConfig.colors['azul_padrao'],
                                    )
                                  : Icon(
                                      Icons.visibility_off,
                                      color: _appConfig.colors['azul_padrao'],
                                    ),
                            ),
                            labelText: "Senha",
                            labelStyle: TextStyle(color: _appConfig.colors['azul_padrao'], fontWeight: FontWeight.bold),
                          ),
                          cursorColor: _appConfig.colors['azul_padrao'],
                          style: TextStyle(
                            color: _appConfig.colors['azul_padrao'],
                            fontSize: 17.0,
                          ),
                          onTap: () {
                            _scrolController.animateTo(_scrolController.position.maxScrollExtent,
                                duration: Duration(milliseconds: 1000), curve: Curves.ease);
                          },
                          onFieldSubmitted: (value) {
                            //_enableSubmit();
                            (_btnEnabled) ? _submit() : null;
                          },
                        ),
                        const SizedBox(
                          height: 40,
                        ),
                        SizedBox(
                          height: 64,
                          child: ElevatedButton(
                            child: Text(
                              "Entrar",
                              style: TextStyle(
                                color: _appConfig.colors['white'],
                                fontSize: 20.0,
                              ),
                            ),
                            onPressed: (_btnEnabled) ? _submit : null,
                          ),
                        ),
                      ],
                    )),
              )
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height / 20,
          color: _appConfig.colors['azul_padrao'],
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                'V.' + _appConfig.versaoApp,
                style: TextStyle(
                  color: _appConfig.colors['white'],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  void _enableSubmit() {
    setState(() {
      if (_re.text.isEmpty || _senha.text.isEmpty) {
        _btnEnabled = false;
      } else {
        _btnEnabled = true;
      }
    });
  }

  void _submit() {
    setState(() {
      _processing = true;
      _errorCode = 0;
    });
    _proccessForm();
  }

  _proccessForm() async {
    if (!mounted) return;

    var credentials = {'uid': _re.text, 'password': _senha.text};

    var options = {};

    options['body'] = json.encode(credentials);

    await _apiLdap.postRequest(urlSegment: '/auth/ldap/login', options: options).whenComplete(() {
      if (_apiLdap.error == false && _apiLdap.statusCode == 200) {
        try {
          var user = json.decode(_apiLdap.body!)['data'];

          _setLoggedUser(user).whenComplete(() {
            Navigator.pushReplacement(context, CupertinoPageRoute(builder: (context) => HomePage()));
          });
        } catch (e) {
          _errorCode = 999;
        }
      } else if (_apiLdap.statusCode == 401) {
        var data = json.decode(_apiLdap.body!);

        if (data.containsKey('code')) {
          _errorCode = data['code'];
        }
      } else {
        _errorCode = 999;
      }
    });
    setState(() {
      _processing = false;
    });
  }

  _clearOldCredentials() async {
    final prefs = await SharedPreferences.getInstance();

    prefs.remove('user.uid');
    prefs.remove('user.name');
    prefs.remove('user.email');
    prefs.remove('user.token');
    prefs.remove('user.menu');
    prefs.remove('apps');
  }

  Future _setLoggedUser(user) async {
    final prefs = await SharedPreferences.getInstance();

    prefs.setString('user.uid', user['uid']);
    prefs.setString('user.name', user['name']);
    prefs.setString('user.email', user['email']);
    prefs.setString('user.token', user['token']);
    prefs.setString('user.menu', json.encode(user['menu']));
    prefs.setString('apps', json.encode(user['apps']));
    prefs.setString('senha', _senha.toString());
  }
}
