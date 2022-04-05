import 'package:flutter/material.dart';
import 'package:tccdemo/pages/cadastro.dart';

class TerceiraRota extends StatefulWidget {
  @override
  _TerceiraRotaState createState() => _TerceiraRotaState();
  String idD;
  TerceiraRota(String id){
    this.idD = id;
  }
}

class _TerceiraRotaState extends State<TerceiraRota> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(""),
      ),
      body: Container(
          child: Column(
            children: <Widget>[
              Expanded(child: new Formulario(widget.idD),),
          ],
        ),
      ),
    
    );
  
  }
}