import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:tccdemo/models/dispenser.dart';
import 'package:tccdemo/models/gRelatorio.dart';


class BD{
  // Variavel estátia para não mudar

  static final BD _instance = new BD.internal();

  // Classe factory 

  factory BD() => _instance;

  // Construtor
  BD.internal();

  static final table = "dispenser";
  static final table2 = "relatorio";

  // Tabela Dispenser

  static final columnIDd = 'id';
  static final columnMarca = 'marca ';
  static final columnLote = 'lote';
  static final columndataF = 'dataF';
  static final columndataV = 'dataV';
  static final columnVolume =  'volume';
  static final columnDTroca = 'dataDeTroca';
  static final columnDRecarga = 'dataDeRecarga';
  static final columnCodigoQr =  'codigoQR';
  static final columnLocalocal = 'local';
  static final columnDiasPVencer = 'diasPravencer';
  static final columnProduto = 'produtoArmazenado';

  // Relatorio

  static final columnIdR = 'id';
  static final columnVal = 'validade';
  static final colunmNr = 'ndeRecargas';
  static final colunmdiasDeUso = 'diasDeUso';

  // Classe do Banco que será usada 
  static Database _db;

  // Inicia o banco de dados de forma assincrona

  Future<Database> get db async {
      if (_db != null){
        return _db;
      }
      _db = await initBd();
  }

  initBd() async {
    // Diretoriro nativo do android do io
    Directory documentoDiretorio = await getApplicationDocumentsDirectory();
     
    // juntar o diretorio com o banco de dados

    String caminho = join(
      documentoDiretorio.path , "bd_principal.db"
    );

    // abri o bd

    var nossoBD = await openDatabase(caminho, version:1 ,onCreate:_onCreate);

    return nossoBD;

  }

  void _onCreate(Database db, int version) async {
    await db.execute( "CREATE TABLE $table( $columnIDd INTEGER PRIMARY KEY AUTOINCREMENT ,"
            "$columnMarca TEXT NOT NULL,"
            "$columnLote INTEGER NOT NULL,"
            "$columndataF TEXT NOT NULL,"
            "$columndataV TEXT NOT NULL,"
            "$columnVolume REAL NOT NULL,"
            "$columnDTroca TEXT NOT NULL,"
            "$columnDRecarga TEXT NOT NULL,"
            "$columnCodigoQr INTEGER NOT NUll,"
            "$columnLocalocal TEXT NOT NULL,"
            "$columnDiasPVencer INTEGER NOT NULL,"
            "$columnProduto TEXT NOT NULL"
          ");"
          "CREATE TABLE $table2( $columnIdR INTEGER PRIMARY KEY AUTOINCREMENT, "
            "$columnVal TEXT NOT NULL,"
            "$colunmNr  INTEGER,"
            "$colunmdiasDeUso INTEGER"
          ");"  );
  }

  // Codigo para inserção

  Future<int> inserirDispenser(Dispenser dispenser) async{
    var bdDispenser = await db;

    int res = await bdDispenser.insert("dispenser", dispenser.toMap());

    return res;
  }

   Future<int> inserirRelatorio(gRelatorio grelatorio) async{
    var bdDispenser = await db;

    int res = await bdDispenser.insert("relatorio" , grelatorio.toMap());

    return res;
  }



  







  // buscar produtos
  Future<List> pegarUsuarios(String tabela) async {
    var bdCliente = await db;

    var res = await bdCliente.rawQuery("Select * From $tabela");


    return res.toList();


  }


  Future fechar() async {
    var bdCliente = await db;

    return bdCliente.close();
  } 
  




  
}