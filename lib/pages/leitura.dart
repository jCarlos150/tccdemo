

import 'package:barcode_scan/barcode_scan.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:tccdemo/models/dispenser.dart';
import 'package:tccdemo/pages/MyHomePage.dart';
import 'package:tccdemo/pages/TerceiraTela.dart';
import 'package:tccdemo/pages/listar.dart';
import 'package:tccdemo/ui/bdLeitura.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

class LeituraQR extends StatefulWidget {
  @override
  _LeituraQRState createState() => _LeituraQRState();
}

class _LeituraQRState extends State<LeituraQR> {
  String code = "";
  BDFire bd = new BDFire();
  

  ScanQrCode() async {
  try{
    final result = await BarcodeScanner.scan(); 
    // Método leitor do qrcode converte a imagem em uma string

    
    setState(() {
      code = result;
      lido = true;
    });

    
  }catch(e){
    print(e);
  }
}

var lido = false;


  @override
  void initState(){
    super.initState();
    
    Firestore.instance.collection('dispenser').document(code).snapshots();
    
    
  }

  
int calcularVencimento (DateTime data){
  DateTime atual = new DateTime.now();

  int diaspravencer = ((data.year - atual.year) * 365 ) + ((data.month - atual.month) * 30) + (data.day - atual.day);


  return diaspravencer;
  
}

int calcularDiasUtilizados(DateTime data){
  DateTime atual = new DateTime.now();

  int diasUtil = ( (atual.year - data.year )* 365) + ((atual.month - data.month) * 30) + (atual.day - data.day);

  return diasUtil;
}





void voltar(){
  setState(() {
    lido = false;
  });
}

 

  @override
  Widget build(BuildContext context) {
    if (lido == true ){
      return  StreamBuilder(
      stream: Firestore.instance.collection('dispenser').document(code).snapshots(), 
      // Faz um busca no bd com o a variavel que code gerado pela função de Scannear
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return new Center(
            child: CircularProgressIndicator(),
          );
        }
        
      
     try{
        this.bd.dispenser = new Dispenser.fromMap(snapshot.data);
     } catch(e){
         return Center(
           child: Text("Código Qr Inválido 1" ,style: TextStyle(color: Colors.red , fontSize: 41),)
          );
       }
        var pi  = '';
        
        DateTime datav = bd.dispenser.dataV ;


        print(datav);


        bd.AtualizarDados(bd.dispenser.id,  calcularDiasUtilizados(bd.dispenser.dataDeTroca) , calcularVencimento(bd.dispenser.dataV));
        
        //bd.dispenser.setdiasPravencer(calcularVencimento(datav));

        //bd.dispenser.setdiasDeUso(calcularDiasUtilizados(bd.dispenser.dataDeTroca));




        
       
        

        if(bd.dispenser.prdutoA == "Álcool em Gel" ){
          pi = 'imagens/ac.jpg';
        }
        else if (bd.dispenser.prdutoA == "Sabonete Líquido"){
          pi = 'imagens/sabonete.png' ;
        }

        void _showSnackBar(){
        final snackBar = SnackBar(
          duration: Duration(milliseconds: 500),
          backgroundColor: Colors.blue,
          
          content: Row(
            children: <Widget>[
              Icon(
                Icons.check_box,
                semanticLabel: "Registrado Com Sucesso",
              ),
              Text("Registrado Com Sucesso"),
            ],
          
        )); 
         Scaffold.of(context).showSnackBar(snackBar);
         
        
         } 

  String novoProduto = bd.dispenser.prdutoA;




  void atualzarRecarga(String produto){
          print(novoProduto);
          _showSnackBar();
          setState(() {
            bd.dispenser.setProdutoA(novoProduto);
            bd.AtualizarRecarga(bd.dispenser,novoProduto);
            bd.dispenser.setDataDeRecarga(DateTime.now());
          });
          
        }

void _simpleDialog() async { //Funcao de Escolha do refil
      switch (await showDialog(
          context: context,
          builder: (BuildContext context) {
            return SimpleDialog(
              title: const Text('Refil recarregado'),
              children: <Widget>[
                SimpleDialogOption(
                  onPressed: () {
                    Navigator.pop(context, "Álcool");
                  },
                  child: const Text('Álcool'),
                ),
                SimpleDialogOption(
                  onPressed: () {
                    Navigator.pop(context, "Sabonete");
                  },
                  child: const Text('Sabonete'),
                ),
              ],
            );
          })) {
        case "Álcool":
          novoProduto = "Álcool em Gel" ;
          atualzarRecarga(novoProduto);
          break;
        case "Sabonete":
          novoProduto  = "Sabonete Líquido";
          atualzarRecarga(novoProduto);
          break;
      }
    
    }

     final pdf = pw.Document();
     DateTime n = new DateTime.now();
     
      void writePdf(){
        // Método que criar um documento PDF em numa folha a4
        pdf.addPage(
          pw.MultiPage(
            pageFormat: PdfPageFormat.a4, 
            // Deterina o tipo de folha
            margin: pw.EdgeInsets.all(32), // Margin

            build: (pw.Context context){
              return <pw.Widget>  [
                pw.Header( //Cabeçalho
                  level: 4,
                  margin: pw.EdgeInsets.fromLTRB(40, 0, 40, 30),
                  child: pw.Text("Relatório Dispenser "+bd.dispenser.marca+"/"+bd.dispenser.lote+"/"+
                    bd.dispenser.local , style: pw.TextStyle(fontSize: 18, fontStyle: pw.FontStyle.normal),
                  ),
                ),
                pw.Paragraph( //Paragrafo
                  margin: pw.EdgeInsets.all(15),
                  text: n.toString(),
                ),

                 pw.Header(
                  level: 1,
                  child: pw.Text("Informações" , style: pw.TextStyle(fontSize: 14, fontStyle: pw.FontStyle.normal , fontWeight: pw.FontWeight.bold )),
                  
                ),
                
                
                  pw.Column(children: <pw.Widget>[
                    pw.Row(children: <pw.Widget> [
                        pw.Text("Marca:" ,style: pw.TextStyle( fontStyle: pw.FontStyle.normal , fontWeight: pw.FontWeight.bold )),
                        pw.Text(" " +bd.dispenser.marca),
                        
                    ]),
                     pw.Row(children: <pw.Widget> [
                        pw.Text("Lote:" ,style: pw.TextStyle( fontStyle: pw.FontStyle.normal , fontWeight: pw.FontWeight.bold)),
                        pw.Text(" " +bd.dispenser.lote),
                    ]),
                     pw.Row(children: <pw.Widget> [
                        pw.Text("Local:" ,style: pw.TextStyle( fontStyle: pw.FontStyle.normal , fontWeight: pw.FontWeight.bold)),
                        pw.Text(" " +bd.dispenser.local),
                    ]),
                     pw.Row(children: <pw.Widget> [
                        pw.Text("Volume:" ,style: pw.TextStyle( fontStyle: pw.FontStyle.normal, fontWeight: pw.FontWeight.bold)),
                        pw.Text(" " +bd.dispenser.volume.toString()),
                    ]),
                  ]),
                
                  pw.Header(
                  level: 1,
                  child: pw.Text("Historico de  Uso" , style: pw.TextStyle(fontSize: 14, fontStyle: pw.FontStyle.normal , fontWeight: pw.FontWeight.bold)),
                  
                ),

                pw.Column(children: <pw.Widget>[
                    pw.Row(children: <pw.Widget> [
                        pw.Text("Produto Armazenado :" ,style: pw.TextStyle( fontStyle: pw.FontStyle.normal , fontWeight: pw.FontWeight.bold )),
                        pw.Text(" " +bd.dispenser.prdutoA),
                        
                    ]),
                     pw.Row(children: <pw.Widget> [
                        pw.Text("Quantidade de Recargas" ,style: pw.TextStyle( fontStyle: pw.FontStyle.normal , fontWeight: pw.FontWeight.bold)),
                        pw.Text(" " +bd.dispenser.numeroDeRecargas.toString()),
                    ]),
                     pw.Row(children: <pw.Widget> [
                        pw.Text("Recargas referentes a Álcool :" ,style: pw.TextStyle( fontStyle: pw.FontStyle.normal , fontWeight: pw.FontWeight.bold)),
                        pw.Text(" " +bd.dispenser.alcool.toString()),
                    ]),
                    pw.Row(children: <pw.Widget> [
                        pw.Text("Recargas referentes a Sabonete Líquido :" ,style: pw.TextStyle( fontStyle: pw.FontStyle.normal , fontWeight: pw.FontWeight.bold)),
                        pw.Text(" " +bd.dispenser.sabonete.toString()),
                    ]),
                    pw.Row(children: <pw.Widget> [
                        pw.Text("Quantidades de rifis utilizados :" ,style: pw.TextStyle( fontStyle: pw.FontStyle.normal , fontWeight: pw.FontWeight.bold)),
                        pw.Text(" " +bd.dispenser.numeroDeRecargas.toString()),
                    ]),


                     pw.Row(children: <pw.Widget> [
                        pw.Text("Dias Utilizados:" ,style: pw.TextStyle( fontStyle: pw.FontStyle.normal, fontWeight: pw.FontWeight.bold)),
                        pw.Text(" " +bd.dispenser.diasDeUso.toString()),
                    ]),
                     
                  ]),
                
                pw.Header(
                  level: 1,
                  child: pw.Text("Datas" , style: pw.TextStyle(fontSize: 14, fontStyle: pw.FontStyle.normal , fontWeight: pw.FontWeight.bold)),
                ),

                 pw.Column(children: <pw.Widget>[
                    pw.Row(children: <pw.Widget> [
                        pw.Text("Ultima recarga :" ,style: pw.TextStyle( fontStyle: pw.FontStyle.normal , fontWeight: pw.FontWeight.bold )),
                        pw.Text(" " +bd.dispenser.dataDeRecarga.toString().substring(0,11)),
                        
                    ]),
                     pw.Row(children: <pw.Widget> [
                        pw.Text("Fabricação" ,style: pw.TextStyle( fontStyle: pw.FontStyle.normal , fontWeight: pw.FontWeight.bold)),
                        pw.Text(" " +bd.dispenser.dataf),
                    ]),
                     pw.Row(children: <pw.Widget> [
                        pw.Text("Vencimento :" ,style: pw.TextStyle( fontStyle: pw.FontStyle.normal , fontWeight: pw.FontWeight.bold)),
                        pw.Text(" " +bd.dispenser.dataV.toString().substring(0,11)),
                    ]),
                     pw.Row(children: <pw.Widget> [
                        pw.Text("Troca De Dispenser" ,style: pw.TextStyle( fontStyle: pw.FontStyle.normal, fontWeight: pw.FontWeight.bold)),
                        pw.Text(" " +bd.dispenser.dataDeTroca.toString().substring(0,11)),
                    ]),
                   
                  ]),
                

              ];
            }
           
          ),
        );
        String relatorio = bd.dispenser.marca+bd.dispenser.id; 
        Printing.sharePdf(bytes: pdf.save(), filename: '$relatorio.pdf');
        // Função que converti o pdf em bytes e compartilha com outras plataformas
        // Utiliza a biblioteca Printing
      }

  
        
        
      String diasV = bd.dispenser.diasPravencer.toString().replaceAll("-", "");

        


        return dadosDispenserWidget(pi, diasV, _simpleDialog ,writePdf );
      }
  );
    }
     

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Center(
          child: Text("Ler Qrcode" , 
          style: TextStyle(
            fontSize: 31,
            color: Colors.blue,
          ) ,),

        ),
        SizedBox(
          height: 5,
        ),
        Center(
          child: IconButton(
            icon: Icon(Icons.camera_alt),
            color: Colors.blue,
            splashColor: Colors.blueAccent,
            iconSize: 111,
            onPressed: () => ScanQrCode(),
          ),
        ),
        Center(  child: Text("", 
            style: TextStyle(
              fontSize: 24,
              color: Colors.blue
            ),
        ),),
      ],
    );
  }

  Column dadosDispenserWidget(String pi, String diasV, _simpleDialog ,writePdf ) {
    return new Column(
        children: <Widget>[
             Card(
               color: Colors.blue.shade50,
               child: Container(
                 padding: EdgeInsets.fromLTRB(81, 1, 81, 41),
                 child: Column(
                   children: <Widget>[
                     Image.asset(pi , height: 211, width: 211,),
                     Divider(),
                     Text(bd.dispenser.prdutoA , style: TextStyle( color:Colors.blue , fontSize: 21),),
                   ],
                 ),
               ),
             ),
             Expanded(child: ListView(
                children: <Widget>[
                  Column(
                    children: <Widget>[
                      Padding(padding:  EdgeInsets.all(11),
                        child: Row(
                        children: <Widget>[
                           Card(
                            color: Colors.blue.shade50,
                            child: Container(
                              height: 61 ,
                              width: 151,
                              child: Center(
                                child: Text( "Vencimento: "+bd.dispenser.dataV.toString().substring(0,11) 
                                ,style: TextStyle(color: Colors.blue , fontSize: 11)
                                ,),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 18,
                          ),
                           Card(
                            color: Colors.blue.shade50,
                            child: Container(
                              height: 61 ,
                              width: 151,
                              child: Center(
                                child: bd.dispenser.diasPravencer < 0 ? Text( "Venceu há $diasV dias!", style: TextStyle(color: Colors.red , fontSize: 11, ),) : 
                                Text("Dias para vencer: "+bd.dispenser.diasPravencer.toString() , style: TextStyle(color: Colors.blue , fontSize: 11,
                                ),),
                              ),
                            ),
                          ),
                        ],
                      ),
                      ),
                      Padding(padding: EdgeInsets.all(11),
                        child: Row(
                        children: <Widget>[
                           Card(
                            color: Colors.blue.shade50,
                            child: Container(
                              height: 61 ,
                              width: 151,
                              child: Center(
                                child: Text("Ultima recarga: "+bd.dispenser.dataDeRecarga.toString().substring(0,11), 
                                style: TextStyle(color: Colors.blue , fontSize: 11),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 18,
                          ),
                          Padding(padding: EdgeInsets.all(0),
                           child: Card(
                            color: Colors.blue.shade50,
                            child: Container(
                              height: 61 ,
                              width: 151,
                              child: Center(
                                child: Text("Marca :"+bd.dispenser.marca , style :TextStyle(color: Colors.blue , fontSize: 11))
                              ),
                            ),
                          ),
                          )
                        ],
                      ), 
                      ),
                      
                     Padding(padding: EdgeInsets.all(11),
                        child: Row(
                        children: <Widget>[
                           Card(
                            color: Colors.blue.shade50,
                            child: Container(
                              height: 61 ,
                              width: 151,
                              child: Center(
                                child: Text("Dias de Uso : "+bd.dispenser.diasDeUso.toString() ,style: TextStyle(color: Colors.blue , fontSize: 11),),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 18,
                          ),
                           Card(
                            color: Colors.blue.shade50,
                            child: Container(
                              height: 61 ,
                              width: 151,
                              child: Center(
                                child: Text("Volume :"+bd.dispenser.volume.toString() , style: TextStyle(color: Colors.blue, fontSize: 11), ),
                              ),
                            ),
                          ),
                          
                        ],
                      ), 
                      ) ,
                      Padding(padding: EdgeInsets.all(11),
                            child:  Row(
                        children: <Widget>[
                         Card(
                            color: Colors.blue,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20.0),
                            ),
                            child: Container(
                              height: 61 ,
                              width: 151,
                              child: Center(
                                child: RaisedButton( color: Colors.blue, elevation: 0, child: Text("Registrar recarga" ,style: TextStyle(color: Colors.white , fontSize: 11),) ,onPressed: _simpleDialog ),
                              ),
                            ),
                          ),
                         SizedBox(
                            width: 18,
                          ),
                           Card(
                            color: Colors.blue,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20.0),
                            ),
                            child: Container(
                              height: 61 ,
                              width: 151,
                              child: Center(
                                child: RaisedButton( color: Colors.blue, elevation: 0, 
                                child: Text("Trocar Dispenser" ,style: TextStyle(color: Colors.white , fontSize: 11),)
                                 ,onPressed: () {
                                   Navigator.push(context, MaterialPageRoute(builder: 
                                    (context) => TerceiraRota(bd.dispenser.id)
                                   ),);
                                 } ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      ),
                      Padding(padding: EdgeInsets.all(11),
                        child:  Row(
                        children: <Widget>[
                            Card(
                            color: Colors.blue,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20.0),
                            ),
                            child: Container(
                              height: 61 ,
                              width: 151,
                              child: Center(
                                child: RaisedButton( color: Colors.blue, elevation: 0, child: Text("Gerar Relatório" ,style: TextStyle(color: Colors.white , fontSize: 11),) ,onPressed: writePdf ),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 18,
                          ),
                          Card(
                            color: Colors.blue,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20.0),
                             ),

                            child: Container(
                              height: 61 ,
                              width: 151,
                              child: Center(
                                child:  RaisedButton( color: Colors.blue, elevation: 0, child: Text("Voltar" ,style: TextStyle(color: Colors.white , fontSize: 11),) ,onPressed: voltar ),
                              ),
                            ),
                          ),
                        ],
                      ) ,
                      ),

                     
                     
                    ],
                  )
                ],
             ) ),
             
        ],
      );
  }
  

}

