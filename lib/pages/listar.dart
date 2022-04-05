import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
//import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:printing/printing.dart';
import 'package:tccdemo/models/dispenser.dart';

import 'package:pdf/widgets.dart' as pw;

class Listar extends StatefulWidget {
  @override
  _ListarState createState() => _ListarState();
}

class _ListarState extends State<Listar> {
  List<Dispenser> items;

  var db = Firestore.instance;

// final FirebaseMessaging _messaging = FirebaseMessaging();

  StreamSubscription<QuerySnapshot> dispenserInscricao;

  // Trabalhar assicronicamente

  @override
  void initState() {
    super.initState();

    //_messaging.getToken().then((token){
    // print("Este é o "+token);
    // });

    items = List();
    dispenserInscricao?.cancel();

    dispenserInscricao =
        db.collection("dispenser").snapshots().listen((snapshot) {
      final List<Dispenser> produtos = snapshot.documents
          .map(
            (documentSnapshot) => Dispenser.fromMap(documentSnapshot),
          )
          .toList();

      setState(() {
        this.items = produtos;
      });
    });

    // obter a coleção
  }

  @override
  void dispose() {
    // Cancelar a inscrição
    // Somente se produtoInscrição for not null

    dispenserInscricao?.cancel();
    super.dispose();
  }

  int calcularVencimento(DateTime data) {
    DateTime atual = new DateTime.now();

    int diaspravencer = ((data.year - atual.year) * 365) +
        ((data.month - atual.month) * 30) +
        (data.day - atual.day);

    return diaspravencer;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
                stream: getListaProdutos(),
                builder: (context, snapshot) {
                  switch (snapshot.connectionState) {
                    case ConnectionState.none:
                    case ConnectionState.waiting:
                      return Center(child: CircularProgressIndicator());
                    default:
                      List<DocumentSnapshot> documentos =
                          snapshot.data.documents;

                      void wridePdf() {
                        Dispenser maisRecarga;
                        Dispenser maisUsado;
                        Dispenser maisPertoDeVencer;
                        Dispenser mua;
                        Dispenser mus;
                        var numeroDeTrocas;
                        var numeroDeRecagargas;
                        var maiorR = 0;
                        var ms = 0;
                        var mv = 10000;
                        var a = 0;
                        var s = 0;
                        var ua = 0;
                        var us = 0;
                        var tr = 0;
                        var mxa = 0;
                        var mxs = 0;
                        //List<Dispenser> maisAlcoo;
                        //List<Dispenser> maisSabonete;
                        for (var item in items) {
                          if (item.numeroDeRecargas > maiorR) {
                            maiorR = item.numeroDeRecargas;
                            maisRecarga = item;
                          }
                          if (item.diasDeUso > ms) {
                            ms = item.diasDeUso;
                            maisUsado = item;
                          }
                          if (item.diasPravencer < mv) {
                            mv = item.diasPravencer;
                            maisPertoDeVencer = item;
                          }
                          a = item.alcool + a;
                          s = item.sabonete;
                          if (item.alcool > ua) {
                            ua = item.alcool;
                            mua = item;
                          }
                          if (item.sabonete > us) {
                            us = item.sabonete;
                            mus = item;
                          }
                          tr = tr + item.numeroDeRecargas;
                          mxa = mxa + item.alcool;
                          mxs = mxs + item.sabonete;
                        }
                        DateTime data = DateTime.now();

                        final pdf = pw.Document();

                        pdf.addPage(
                          pw.MultiPage(
                              pageFormat: PdfPageFormat.a4,
                              margin: pw.EdgeInsets.all(32),
                              build: (pw.Context context) {
                                return <pw.Widget>[
                                  pw.Center(
                                    child: pw.Text(
                                        "Relatório geral " + data.toString(),
                                        style: pw.TextStyle(
                                            fontSize: 18,
                                            fontStyle: pw.FontStyle.normal,
                                            fontWeight: pw.FontWeight.bold)),
                                  ),
                                  pw.SizedBox(
                                    height: 100,
                                  ),
                                  pw.Container(
                                    child: pw.Column(
                                        crossAxisAlignment:
                                            pw.CrossAxisAlignment.start,
                                        children: <pw.Widget>[
                                          pw.Text(
                                              "Dipsenser que fez mais recargas : " +
                                                  maisRecarga.marca +
                                                  "/" +
                                                  maisRecarga.local +
                                                  " Quantidade de Recargas: " +
                                                  maisRecarga.numeroDeRecargas
                                                      .toString(),
                                              style: pw.TextStyle(
                                                  fontSize: 11,
                                                  fontStyle:
                                                      pw.FontStyle.normal,
                                                  fontWeight:
                                                      pw.FontWeight.bold)),
                                          pw.Text(
                                              "Quantidade de recargas com álcool: " +
                                                  mxa.toString(),
                                              style: pw.TextStyle(
                                                  fontSize: 11,
                                                  fontStyle:
                                                      pw.FontStyle.normal,
                                                  fontWeight:
                                                      pw.FontWeight.bold)),
                                          pw.Text(
                                              "Dispenser  com mais recargas com álcool: " +
                                                  mua.marca +
                                                  "/" +
                                                  mua.local +
                                                  " Quantidade: " +
                                                  mua.alcool.toString(),
                                              style: pw.TextStyle(
                                                  fontSize: 11,
                                                  fontStyle:
                                                      pw.FontStyle.normal,
                                                  fontWeight:
                                                      pw.FontWeight.bold)),
                                          pw.Text(
                                              "Quantidade de recargas com sabonete: " +
                                                  mxs.toString(),
                                              style: pw.TextStyle(
                                                  fontSize: 11,
                                                  fontStyle:
                                                      pw.FontStyle.normal,
                                                  fontWeight:
                                                      pw.FontWeight.bold)),
                                          pw.Text(
                                              "Dispenser  com mais recargas com sabonete: " +
                                                  mus.marca +
                                                  "/" +
                                                  mus.local +
                                                  " Quantidade: " +
                                                  mus.sabonete.toString(),
                                              style: pw.TextStyle(
                                                  fontSize: 11,
                                                  fontStyle:
                                                      pw.FontStyle.normal,
                                                  fontWeight:
                                                      pw.FontWeight.bold)),
                                          pw.Text(
                                              "Dipsenser mais usado : " +
                                                  maisUsado.marca +
                                                  "/" +
                                                  maisUsado.local +
                                                  " Quantidade de Dias: " +
                                                  maisUsado.diasDeUso
                                                      .toString(),
                                              style: pw.TextStyle(
                                                  fontSize: 11,
                                                  fontStyle:
                                                      pw.FontStyle.normal,
                                                  fontWeight:
                                                      pw.FontWeight.bold)),
                                          pw.Text(
                                              "Dipenser mais próximo ao vencimento " +
                                                  maisPertoDeVencer.marca +
                                                  "/" +
                                                  maisPertoDeVencer.local +
                                                  "  Dias para vencer: " +
                                                  maisPertoDeVencer
                                                      .diasPravencer
                                                      .toString(),
                                              style: pw.TextStyle(
                                                  fontSize: 11,
                                                  fontStyle:
                                                      pw.FontStyle.normal,
                                                  fontWeight:
                                                      pw.FontWeight.bold)),
                                          pw.Text(
                                              "Quantidades Total De Recargas Feitas :" +
                                                  tr.toString(),
                                              style: pw.TextStyle(
                                                  fontSize: 11,
                                                  fontStyle:
                                                      pw.FontStyle.normal,
                                                  fontWeight:
                                                      pw.FontWeight.bold)),
                                          pw.SizedBox(
                                            height: 35,
                                          ),
                                          pw.Row(children: <pw.Widget>[
                                            pw.Text("Uso maior dos seneantes:",
                                                style: pw.TextStyle(
                                                  fontSize: 11,
                                                  fontStyle:
                                                      pw.FontStyle.normal,
                                                )),
                                            pw.Text(" Maior uso de álcool",
                                                style: pw.TextStyle(
                                                    fontSize: 11,
                                                    fontStyle:
                                                        pw.FontStyle.normal,
                                                    color: PdfColor(
                                                        0.227, 0.64, 0.40))),
                                            pw.Text(
                                                "  Maior uso de sabonete líquido",
                                                style: pw.TextStyle(
                                                    fontSize: 11,
                                                    fontStyle:
                                                        pw.FontStyle.normal)),
                                          ]),
                                        ]),
                                  ),
                                  pw.ListView.builder(
                                      itemCount: items.length,
                                      itemBuilder: (context, index) {
                                        return pw.Container(
                                          child: pw.Column(
                                              crossAxisAlignment:
                                                  pw.CrossAxisAlignment.start,
                                              children: <pw.Widget>[
                                                // coluna de alcool
                                                pw.Row(children: <pw.Widget>[
                                                  pw.Text(
                                                      items[index].alcool >
                                                              items[index]
                                                                  .sabonete
                                                          ? items[index].marca +
                                                              "/" +
                                                              items[index]
                                                                  .local +
                                                              " Recargas " +
                                                              items[index]
                                                                  .alcool
                                                                  .toString()
                                                          : "",
                                                      style: pw.TextStyle(
                                                          fontSize: 9,
                                                          fontStyle: pw
                                                              .FontStyle.normal,
                                                          color: PdfColor(0.227,
                                                              0.64, 0.40))),
                                                  pw.Text(
                                                      items[index].alcool <
                                                              items[index]
                                                                  .sabonete
                                                          ? items[index].marca +
                                                              "/" +
                                                              items[index]
                                                                  .local +
                                                              " Recargas " +
                                                              items[index]
                                                                  .sabonete
                                                                  .toString()
                                                          : "",
                                                      style: pw.TextStyle(
                                                          fontSize: 9,
                                                          fontStyle: pw
                                                              .FontStyle
                                                              .normal)),
                                                ])
                                              ]),
                                        );
                                      })
                                ];
                              }),
                        );
                        Printing.sharePdf(
                            bytes: pdf.save(), filename: 'Teste.pdf');
                      }

                      return Column(
                        children: <Widget>[
                          Card(
                            color: Colors.white,
                            elevation: 19,
                            child: Container(
                              height: 50,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Text(
                                    "Gerar Relatório",
                                    style: TextStyle(
                                        color: Colors.blue,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 25),
                                  ),
                                  SizedBox(
                                    width: 30,
                                  ),
                                  IconButton(
                                    icon: Icon(
                                      Icons.assignment,
                                      size: 30,
                                    ),
                                    onPressed: wridePdf,
                                    color: Colors.blue,
                                  )
                                ],
                              ),
                            ),
                          ),
                          Expanded(
                            child: ListView.builder(
                                itemCount: items.length,
                                padding: EdgeInsets.all(8),
                                itemBuilder: (context, index) {
                                  return Container(
                                    height: 80,
                                    color: Colors.blue.shade50,
                                    child: Card(
                                      color: Colors.blue.shade50,
                                      elevation: 20,
                                      child: Container(
                                        height: 100,
                                        child: Column(
                                          children: <Widget>[
                                            Text(
                                              items[index].marca +
                                                  "/" +
                                                  items[index].local,
                                              style: TextStyle(
                                                  color: Colors.blue,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            Row(
                                              children: <Widget>[
                                                Icon(
                                                  Icons.event,
                                                  color: Colors.blue,
                                                ),
                                                Text(
                                                  "Data de Vencimento " +
                                                      items[index]
                                                          .dataV
                                                          .toString()
                                                          .substring(0, 11),
                                                  style: TextStyle(
                                                      color: Colors.blue),
                                                )
                                              ],
                                            ),
                                            Row(
                                              children: <Widget>[
                                                Icon(
                                                  Icons.error_outline,
                                                  color: calcularVencimento(
                                                              items[index]
                                                                  .dataV) <
                                                          0
                                                      ? Colors.red
                                                      : Colors.blue,
                                                ),
                                                Padding(
                                                  padding: EdgeInsets.fromLTRB(
                                                      0, 5, 0, 2),
                                                  child:
                                                      calcularVencimento(
                                                                  items[index]
                                                                      .dataV) <=
                                                              0
                                                          ? Text(
                                                              "Venceu há " +
                                                                  (calcularVencimento(
                                                                              items[index].dataV) *
                                                                          -1)
                                                                      .toString() +
                                                                  " Dias !",
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .red),
                                                            )
                                                          : Text(
                                                              "Faltam " +
                                                                  calcularVencimento(
                                                                          items[index]
                                                                              .dataV)
                                                                      .toString() +
                                                                  " Dias para vencer!",
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .blue),
                                                            ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  );
                                }),
                          ),
                        ],
                      );
                  }
                }),
          ),
        ],
      ),
    );
  }

  Stream<QuerySnapshot> getListaProdutos() {
    return Firestore.instance.collection('dispenser').snapshots();
  }

  void _deletaProduto(
      BuildContext context, DocumentSnapshot doc, int position) async {
    db.collection('dispenser').document(doc.documentID).delete();

    setState(() {
      items.removeAt(position);
    });
  }
}
