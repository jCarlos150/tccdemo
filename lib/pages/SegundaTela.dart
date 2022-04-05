import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';
import 'dart:ui';


import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:share/share.dart';
import 'package:tccdemo/models/dispenser.dart';
import 'package:wc_flutter_share/wc_flutter_share.dart';

class SegundaRota extends StatefulWidget {

SegundaRota(String teste){
  this.teste = teste;
}
String teste;
  

  @override
  _SegundaRotaState createState() => _SegundaRotaState();
}




class _SegundaRotaState extends State<SegundaRota> {
   
  @override
  Widget build(BuildContext context) {
  
    return Scaffold(
      appBar: AppBar(
        title: Text("Salvo com sucesso "),
      ),
      body: Container(
          child: Column(
            children: <Widget>[
      Padding(padding: EdgeInsets.all(15),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text("QRCODE Gerado",
              style: TextStyle(
                color: Colors.blue,
                fontSize: 16
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(
              height: 16,
            ),
            QrImage( // Converte uma String em um Qrcode
              data: widget.teste, //String referente ao id do dispenser
              gapless: true, // evitar que o método gere buggs
              errorCorrectionLevel: QrErrorCorrectLevel.Q, // Corrigir os erros gerados na converão
              version: QrVersions.auto, // Verssão da Bibiloteca Qr, Que o método usa para gerar o code
              size: 300.0, // dimenções do qrcode gerado
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Padding(padding: EdgeInsets.all(11),
              child: IconButton(
              icon: Icon(Icons.share),
              splashColor: Colors.blueAccent,
              color: Colors.blue,
              iconSize: 51,
              onPressed: () { 
              _toQrImageData();
          },      
        ),
                  
                ),
                SizedBox(
                  width: 115,
                ),

               Padding(padding: EdgeInsets.all(11),
                    child: RaisedButton(
              onPressed: () { 
                Navigator.pop(context);
              },
              child: Text('Voltar'),
        ),
               
               ),
              ],
            ),
             
          ],
        ),
      )

        
            ],

          ),

      )
      
      
    );
  }

void _toQrImageData() async { 
  //Mátodo usado para converter o Qrcode em uma imagem png
  try {
    final image = await QrPainter(
      data: widget.teste, 
      // String que gere o Qrcode
      version: QrVersions.auto,
      gapless: true, 
      // Resolver bug
      emptyColor: Colors.white, 
      // atribuir a cor de background branca
      errorCorrectionLevel: QrErrorCorrectLevel.Q, 
      // atribuir a cor de forground preta
    ).toImage(300); 
    // temanho da imagem
    final a = await image.toByteData(format: ImageByteFormat.png);
    // método reposnsável por compartilhar a imagem
    // método que converte a imagem png em bytes para ser compartilhada
    await WcFlutterShare.share( 
          sharePopupTitle: 'share', // titulo que do arquivo
          fileName: 'share.png', 
          mimeType: 'image/png',
          bytesOfFile: a.buffer.asUint8List()); 
  } catch (e) {
    throw e;
  }
}
  
  
}