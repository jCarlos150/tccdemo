import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';

class  DatabaseHelper {
  static final _databaseName = "ExemploDb.db";
  static final _databaseVersion = 1; 

  static final table = "Dispenser";
  static final table2 = "Relatorio";

  // Tabela Dispenser

  

  static final columnIDd = 'idD';
  static final columnMarca = '_marca ';
  static final columnLote = 'lote';
  static final columndataF = 'dataF';
  static final columndataV = 'dataV';
  static final columnVolume =  'volume';
  static final columnDTroca = 'dataDeTroca';
  static final columnDRecarga = 'dataDeRecarga';
  static final columnCodigoQr =  'CodigoQR';

  // Tabela de Relatorios 

  static final columnIdR = 'idr';
  static final columnVal = 'validade';
  static final colunmNr = 'ndeRecargas';
  static final colunmdiasDeUso = 'diasDeUso';


   DatabaseHelper._privateConstructor();
  static final  DatabaseHelper instance =  DatabaseHelper._privateConstructor();
  
  static Database _database;

   // instancia o db na primeira vez que for acessado
  Future<Database> get database async{
    if(_database != null) return _database;
    _database = await _initDatabase();
    return _database;
  }

  // abre o banco se ele não existe

  _initDatabase() async{
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, _databaseName);
    return await openDatabase(path,
        version: _databaseVersion,
        onCreate: _onCreate);
  }

  // Codigo sql para criar o banco de dados e a tablea

  Future _onCreate(Database db, int version) async{
    await db.execute('''
          CREATE TABLE $table (
            $columnIDd INTEGER PRIMARY KEY AUTOINCREMENT,
            $columnMarca TEXT NOT NULL,
            $columnLote INTEGER NOT NULL,
            $columndataF TEXT NOT NULL,
            $columndataV TEXT NOT NULL,
            $columnVolume REAL NOT NULL,
            $columnDTroca TEXT NOT NULL,
            $columnDRecarga TEXT NOT NULL,
            $columnCodigoQr INTEGER NOT NUll

          ); 
          CREATE TABLE $table2 (
            $columnIdR INTEGER PRIMARY KEY AUTOINCREMENT,
            $columnVal TEXT NOT NULL,
            $colunmNr  INTEGER,
            $colunmdiasDeUso INTEGER,
            FOREIGN KEY($columnIdR) REFERENCES $columnIdR($columnIDd)
           );

          ''');

          // métodos Helper
  //----------------------------------------------------
  // Insere uma linha no banco de dados onde cada chave 
  // no Map é um nome de coluna e o valor é o valor da coluna. 
  // O valor de retorno é o id da linha inserida.
  Future<int> insert(Map<String, dynamic> row , ptable) async {
    Database db = await instance.database;
    return await db.insert(ptable, row);
  }
  // Todas as linhas são retornadas como uma lista de mapas, onde cada mapa é
  // uma lista de valores-chave de colunas.
  Future<List<Map<String, dynamic>>> queryAllRows(ptable) async {
    Database db = await instance.database;
    return await db.query(ptable);
  }
  // Todos os métodos : inserir, consultar, atualizar e excluir, 
  // também podem ser feitos usando  comandos SQL brutos. 
  // Esse método usa uma consulta bruta para fornecer a contagem de linhas.
  Future<int> queryRowCount(ptable) async {
    Database db = await instance.database;
    return Sqflite.firstIntValue(await db.rawQuery('SELECT COUNT(*) FROM $ptable'));
  }
  // Assumimos aqui que a coluna id no mapa está definida. Os outros
  // valores das colunas serão usados para atualizar a linha.
  Future<int> update(Map<String, dynamic> row ,ptable ,pid) async {
    Database db = await instance.database;
    int id = row[pid];
    return await db.update(ptable, row, where: '$pid = ?', whereArgs: [id]);
  }
  // Exclui a linha especificada pelo id. O número de linhas afetadas é
  // retornada. Isso deve ser igual a 1, contanto que a linha exista.
  Future<int> delete(int id ,ptable ,pid) async {
    Database db = await instance.database;
    return await db.delete(ptable, where: '$pid = ?', whereArgs: [id]);
  }
}



  
  }






  
