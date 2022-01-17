import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive/hive.dart';
import 'package:inventario_nm/src/model/Produto.dart';
import 'package:inventario_nm/src/modules/login/splash_sreen.dart';
import 'package:inventario_nm/src/persist/dbhelper.dart';
import 'package:inventario_nm/src/shared/config/app_config.dart';
import 'package:sqflite/sqflite.dart';
import 'package:hive_flutter/hive_flutter.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late AppConfig _appConfig;

  @override
  void initState() {
    _appConfig = AppConfig();
    super.initState();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    iniciarHive();


  }

  iniciarHive() async {
    WidgetsFlutterBinding.ensureInitialized();
    await Hive.initFlutter();
    Hive.registerAdapter(ProdutoAdapter());
    await Hive.openBox<Produto>('Produto');
    await Hive.openBox('DataUltimaAtualizacao');
  }

  testeBD() async {
    Map<String, dynamic> map = {'nome_produto': 'teste123', 'ean': '123456789'};

    DbHelper dbHelper = DbHelper();

    Database? dbContato = await dbHelper.db;

    dbContato!.insert('produto', map);

    List listMap = await dbContato.rawQuery("SELECT * FROM produto");

    print(listMap.toString());
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const SplashScreen(),
      title: _appConfig.title,
      theme: ThemeData(
        //primarySwatch: Colors.amber,
        hintColor: _appConfig.colors['azul_padrao'],
        primaryColor: _appConfig.colors['azul_padrao'],
        inputDecorationTheme: InputDecorationTheme(
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: _appConfig.colors['azul_padrao']),
          ),
          disabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: _appConfig.colors['azul_padrao']),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: _appConfig.colors['azul_padrao']),
          ),
          hintStyle: TextStyle(color: _appConfig.colors['azul_padrao']),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: TextButton.styleFrom(backgroundColor: _appConfig.colors['verde_padrao']),
        ),
        fontFamily: 'Mada',
        textTheme: TextTheme(
          headline1: TextStyle(
            fontSize: 20.0,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
          headline2: TextStyle(
            fontSize: 20.0,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
          headline3: TextStyle(
            fontSize: 18.0,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
          subtitle1: TextStyle(
            fontSize: 16.0,
            fontWeight: FontWeight.normal,
            color: Colors.black,
          ),
          button: TextStyle(
            fontSize: 16.0,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
