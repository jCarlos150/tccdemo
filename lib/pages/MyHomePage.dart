import 'dart:async';
import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:tccdemo/models/dispenser.dart';
import 'package:tccdemo/pages/SegundaTela.dart';
import 'package:tccdemo/pages/cadastro.dart';
import 'package:tccdemo/pages/leitura.dart';
import 'package:tccdemo/pages/listar.dart';
import 'package:shared_preferences/shared_preferences.dart';



class HomePage extends StatefulWidget {
  const HomePage({Key key}) : super(key: key);

  

  @override
  _HomePageState createState() => _HomePageState();
}




class _HomePageState extends State<HomePage> {

  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

  List<Dispenser> items;
  var db = Firestore.instance;
  StreamSubscription<QuerySnapshot> dispenserIns;


  @override
  void initState() {
    super.initState();
    var initializationSettingnsAndroid = new 
   AndroidInitializationSettings('mipmap/ic_launcher');
   var initializationSettingnsIOS = new
   IOSInitializationSettings();
  var initializationSettings = new InitializationSettings(initializationSettingnsAndroid, initializationSettingnsIOS);
 flutterLocalNotificationsPlugin = new FlutterLocalNotificationsPlugin();
  flutterLocalNotificationsPlugin.initialize(initializationSettings,onSelectNotification: selectNotification );


items = List();
dispenserIns?.cancel();

dispenserIns = db.collection("dispenser").snapshots().
listen((snapshot){
  final List<Dispenser> produtos = snapshot.documents.map(
    (documentSnapshot) => Dispenser.fromMap(
      documentSnapshot
    ),
  ).toList();
    
    setState(() {
      this.items = produtos;
    });

});

  }
   


Future selectNotification(String payload) async {
    if (payload != null) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String stringValue = prefs.getString('data');
      print("entrou aqui");
      var androidPlatformChannelSpecifics =
    AndroidNotificationDetails('repeating channel id',
        'repeating channel name', 'repeating description');
var iOSPlatformChannelSpecifics =
    IOSNotificationDetails();
var platformChannelSpecifics = NotificationDetails(
    androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
await flutterLocalNotificationsPlugin.periodicallyShow(0, 'Há dispenses vencendo',
    payload, RepeatInterval.Hourly  , platformChannelSpecifics);
    }

}



int calcularVencimento (DateTime data){
  DateTime atual = new DateTime.now();

  int diaspravencer = ((data.year - atual.year) * 365 ) + ((data.month - atual.month) * 30) + (data.day - atual.day);


  return diaspravencer;
  
}


void notificacoes(){

int qv = 0;
int v = 0;
compararDatas(Dispenser a ){
  if(calcularVencimento(a.dataV)<=7){
   qv++;
   if (calcularVencimento(a.dataV)<=0){
     v++;
   }

  }
 
  
}

  items.forEach( (d) => compararDatas(d));
  selectNotification("Há "+qv.toString()+" dispenser prestes a vencer. Vencidos: "+v.toString());
}


  
  
  @override
  Widget build(BuildContext context) {
    //selectNotification("Teste");
    notificacoes();
    return DefaultTabController(
      length: 3,
      child: Scaffold(
         appBar: AppBar(
        bottom: TabBar(
          tabs: <Widget>[
            Tab(icon: Icon(Icons.plus_one)),
            Tab(icon: Icon(Icons.camera_alt)),
            Tab(icon: Icon(Icons.notification_important))
          ],
        ),
        title: Text(
          "Sistema de Controle de Dispenser",
          style: TextStyle(
            fontSize: 15,
          )    
        ),
        centerTitle: true,
    
      ) ,
      body:TabBarView(
            children: [
            new Container(
              child: new Formulario(""),
            ),

            new Container(
              color: Colors.white10,
              child: LeituraQR(),
            ),
            new Container(
              color: Colors.white,
              child: Listar(),
            ), 
           ],
          ),
      ),
     
    );
  }
}