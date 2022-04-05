import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tccdemo/models/dispenser.dart';

class BDFire {

Dispenser dispenser;

var db = Firestore.instance;


String teste = "";

void AtualizarRecarga (Dispenser dispenser , String pr){
   DateTime novaRecarga = DateTime.now();
   int a = dispenser.alcool;
   int s = dispenser.sabonete;
   if(pr == "Álcool em Gel"){
     a = a+1;
   }
   else if (pr == "Sabonete Líquido"){
     s=s+1;
   }
   int nc = dispenser.numeroDeRecargas + 1;
   db.collection("dispenser").
   document(dispenser.id).updateData(
     {
       "dataDeRecarga" : novaRecarga,
       "numeroDeRecargas" : nc,
       "alcool" : a,
       "sabonete":s,
       "produtoArmazenado":pr,
       
     }
   );


}

 void AtualizarDados(String id , int diasU , int diasV){
     db.collection("dispenser").document(id).updateData({
       "diasDeUso" : diasU,
       "diasPravencer" : diasV,
     });
   }

//void TrocarDispenser()



 void upDiasPRaVencer ()async{
   //diaspravencer = ((dv.year - df.year) * 365 ) + ((dv.month - df.month) * 30) + (dv.day - df.day);
   int novodia;
   QuerySnapshot resultado = await db.collection("dispenser").getDocuments();

      resultado.documents.forEach((d){
        d.reference.updateData({
            "diasPravencer" : novodia,
        }
        );
      });
 
 }


 

 scanner(String code) {
  //DocumentSnapshot resultado = await db.collection("dispenser")
  //.document(code).get();
  //this.dispenser= await new Dispenser.fromMap(resultado.data, resultado.documentID);
  //await db.collection('dispenser')
  //.document(code)
  //.get()
  //.then((DocumentSnapshot ds) {
  //print(ds.data);
  //this.dispenser = Dispenser.fromMap(ds.data, ds.documentID);
  // use ds as a snapshot
  // Delete para excluir
  Firestore.instance.collection('dispenser').document(code).snapshots();
    
  }
  
  
  void notfy () async {
    db.collection("dispenser").snapshots()
    .listen((resultado){
      resultado.documents.forEach((d){
        print(d.data);
      });
    });
    // Delete para excluir
  }

 // Widget build(BuildContext context) {
 // return new StreamBuilder(
//stream: Firestore.instance.collection('dispenser').document('TESTID1').snapshots(),
//builder: (context, snapshot) {
// if (!snapshot.hasData) {
//return new Text("Loading");
  //}
//var userDocument = snapshot.data;
//return new Text(userDocument["name"]);
// }
  //);



  
  }
  
  
  
  
  
  
  
  
  
  
  
 
