import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DbHelper {
  ///Tabela de Produtos (Sincronizado)
  static String produtoSincronizadoTable = "produto";
  static String idProdutoCollumn = "id_produto";
  static String nomeProdutoCollumn = "nome_produto";
  static String eanColumn = "ean";

  ///Tabela de Produtos da Contagem
  static String produtoTable = "produto_contagem";
  static String idProdutoContagem = "id_produto_contagem";
  static String idInventarioCicCollumn = "id_inventario_cic";
  static String dataColumn = "data_registro_item";
  static String quantidadeCollumn = "quantidade";
  static String statusProdutoCollumn = "status";

  ///Tabela de Contagem
  static String contagemTable = "contagem";
  static String idContagemCollumn = "id_contagem";
  static String idFilialCollumn = "id_filial";
  static String idFuncionarioCollumn = "id_funcionario";
  static String nomeFuncionarioCollumn = "nome_funcionario";
  static String dataCriaCollumn = "data_cria";
  static String dataIniciaCollumn = "data_inicia";
  static String dataTerminoCollumn = "data_termino";
  static String statusContagemCollumn = "status";
  static String observacoesCollumn = "observacoes";

  ///Tabela de Local
  static String localTable = "local";
  static String idLocalCollumn = "id_local";
  static String tipoLocalCollumn = "tipo_local";

  String createProduto = "CREATE TABLE $produtoSincronizadoTable(" +
      "$idProdutoCollumn INTEGER PRIMARY KEY, " +
      "$nomeProdutoCollumn TEXT NOT NULL, " +
      "$eanColumn TEXT NOT NULL );";

  String createProdutoContagemTable = "CREATE TABLE $produtoTable(" +
      "$idProdutoContagem INTEGER PRIMARY KEY, " +
      "$idProdutoCollumn INTEGER NOT NULL, " +
      "$idLocalCollumn INTEGER NOT NULL, " +
      "$idInventarioCicCollumn INTEGER, " +
      "$dataColumn TEXT NOT NULL, " +
      "$quantidadeCollumn INTEGER DEFAULT 1, " +
      "$statusProdutoCollumn INTEGER DEFAULT 0, " +
      "CONSTRAINT fk_locais FOREIGN KEY ($idLocalCollumn) REFERENCES $localTable($idLocalCollumn) ON DELETE CASCADE ON UPDATE NO ACTION," +
      "CONSTRAINT fk_produtos FOREIGN KEY ($idProdutoCollumn) REFERENCES $produtoSincronizadoTable($idProdutoCollumn) ON DELETE CASCADE ON UPDATE NO ACTION);";

  String createContagemTable = "CREATE TABLE $contagemTable(" +
      "$idContagemCollumn INTEGER PRIMARY KEY, " +
      "$idFilialCollumn INTEGER NOT NULL, " +
      "$idFuncionarioCollumn INTEGER NOT NULL, " +
      "$nomeFuncionarioCollumn TEXT NOT NULL, " +
      "$dataCriaCollumn TEXT NOT NULL, " +
      "$dataIniciaCollumn TEXT, " +
      "$dataTerminoCollumn TEXT, " +
      "$statusContagemCollumn INTEGER DEFAULT 0, " +
      "$observacoesCollumn TEXT);";

  String createLocalTable = "CREATE TABLE $localTable(" +
      "$idLocalCollumn INTEGER PRIMARY KEY, " +
      "$tipoLocalCollumn INTEGER DEFAULT 0, " +
      "$idContagemCollumn INTEGER NOT NULL, " +
      "CONSTRAINT fk_contagens FOREIGN KEY ($idContagemCollumn) REFERENCES $contagemTable($idContagemCollumn) ON DELETE CASCADE ON UPDATE NO ACTION);";

  // String createLocalProdutoTable = "CREATE TABLE $localProdutoTable(" +
  //     "$idProdutoContagem INTEGER, " +
  //     "$idLocalCollumn INTEGER, " +
  //     "PRIMARY KEY ($idProdutoContagem,$idLocalCollumn),"
  //     "FOREIGN KEY ($idProdutoContagem) REFERENCES $produtoTable($idProdutoContagem) ON DELETE CASCADE ON UPDATE NO ACTION, " +
  //     "FOREIGN KEY ($idLocalCollumn) REFERENCES $localTable($idLocalCollumn) ON DELETE CASCADE ON UPDATE NO ACTION); " ;

  static final DbHelper _instance = DbHelper.internal();

  factory DbHelper() => _instance;

  DbHelper.internal();

  Database? _db;

  Future<Database?> get db async {
    if (_db != null) {
      return _db;
    } else {
      _db = await initDb();
      return _db;
    }
  }

  Future<Database?> initDb() async {
    final databasesPath = await getDatabasesPath();
    final path = join(databasesPath, "inventario-nm.db");

    return await openDatabase(path, version: 1, onCreate: (Database db, int newerVersion) async {
      await createTables(db);
    }, onOpen: (Database db) async {
      await db.execute("PRAGMA foreign_keys=ON");
    });
  }

  Future closeDb() async {
    Database? dbInventario = await db;
    dbInventario!.close();
  }

  createTables(Database db) async {
    await db.execute(createProduto);
    await db.execute(createContagemTable);
    await db.execute(createLocalTable);
    await db.execute(createProdutoContagemTable);
  }
}
