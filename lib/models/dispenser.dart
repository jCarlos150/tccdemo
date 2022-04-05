

import 'package:cloud_firestore/cloud_firestore.dart';

class Dispenser {
    String _id;
    String _marca;
    String _lote;
    String _dataF;
    DateTime _dataV;
    int _volume;
    DateTime _dataDeTroca;
    DateTime _dataDeRecarga;
    String _produtoArmazenado;
    String _local;
    int _diasPravencer;
    int _numeroDeRecargas;
    int _diasDeUso;
    int _alcool;
    int _sabonete;

    Dispenser(this._marca , this._lote ,this._dataF,
     this._dataV , this._volume , this._produtoArmazenado ,
      this._local, 
     this._diasPravencer , this._dataDeTroca , this._dataDeRecarga,this._diasDeUso ,this._numeroDeRecargas , this. _alcool , this._sabonete
    );

    Dispenser.map(dynamic obj){
      this._id = obj['id'];
      this._marca = obj['marca'];
      this._lote =  obj['lote'];
      this._dataF = obj['dataF']; 
      this._dataV  = obj['dataV'];
      this._volume = obj['volume'];
      this._produtoArmazenado = obj['produtoArmazenado'];
      this._dataDeTroca = obj['dataDeTroca'];
      this._dataDeRecarga = obj['dataDeRecarga'];
      this._local = obj['local'];
      this._diasPravencer = obj['diasPravencer'];
      this._diasDeUso = obj['diasDeUso'];
      this._numeroDeRecargas = obj['numeroDeRecargas'];
      this._alcool = obj['alcool'];
      this._sabonete = obj['sabonete'];
      

    }

    String get id => _id;
    String get marca => _marca;
    String get lote => _lote;
    String get dataf => _dataF;
    DateTime get dataV => _dataV;
    int get volume => _volume;
    String get prdutoA => _produtoArmazenado;
    DateTime get dataDeTroca => _dataDeTroca;
    DateTime get dataDeRecarga => _dataDeRecarga;
    String get local => _local;
    int get diasPravencer => _diasPravencer;
    int get diasDeUso => _diasDeUso;
    int get numeroDeRecargas => _numeroDeRecargas;
    int get alcool => _alcool;
    int get sabonete => _sabonete;



    Map<String , dynamic> toMap(){
      var mapa = new Map<String , dynamic>();

     
      mapa['marca'] = _marca;
      mapa['lote'] = _lote  ;
      mapa['dataF'] = _dataF;
      mapa['dataV'] = _dataV;
      mapa['volume'] = _volume;
      mapa['produtoArmazenado'] = _produtoArmazenado;
      mapa['dataDeTroca'] = _dataDeTroca;
      mapa['dataDeRecarga'] = _dataDeRecarga;
      mapa['local'] = _local;
      mapa['diasPravencer'] = _diasPravencer;
      mapa['diasDeUso'] = _diasDeUso;
      mapa['numeroDeRecargas'] = _numeroDeRecargas;
      mapa['alcool'] = _alcool;
      mapa['sabonete'] = _sabonete;


      if (_id != null){
         mapa['id'] = _id;
      }


      

      return mapa;
      
    }
    
    
   Dispenser.fromMap(DocumentSnapshot snapshot){
     // if (id==null){
      //  this._id = '';
     // } else{
       // this._id = id;
     // }


     
      DateTime dateV = snapshot.data['dataV'].toDate();
      DateTime dataT = snapshot.data['dataDeTroca'].toDate();
      DateTime dataR = snapshot.data['dataDeRecarga'].toDate();

      this._id = snapshot.documentID;
      this._marca = snapshot.data['marca'];
      this._lote =  snapshot.data['lote'];
      this._dataF = snapshot.data['dataF']; 
      this._dataV  = dateV; 
      this._volume = snapshot.data['volume'];
      this._produtoArmazenado = snapshot.data['produtoArmazenado'];
      this._dataDeTroca = dataT;
      this._dataDeRecarga = dataR;
      this._local = snapshot.data['local'];
      this._diasPravencer = snapshot.data['diasPravencer'];
      this._diasDeUso = snapshot.data['diasDeUso'];
      this._numeroDeRecargas  = snapshot.data['numeroDeRecargas'];
      this._alcool = snapshot.data['alcool'];
      this._sabonete = snapshot.data['sabonete'];
   }

   Dispenser.fromMapList(Map<String, dynamic> mapa , String id){
    

      DateTime dateV = mapa['dataV'].toDate();
      DateTime dataT = mapa['dataDeTroca'].toDate();
      DateTime dataR = mapa['dataDeRecarga'].toDate();


      this._id = mapa['id'];
      this._marca = mapa['marca'];
      this._lote =  mapa['lote'];
      this._dataF = mapa['dataF']; 
      this._dataV  = dateV;
      this._volume = mapa['volume'];
      this._produtoArmazenado = mapa['produtoArmazenado'];
      this._dataDeTroca = dataT;
      this._dataDeRecarga = dataR;
      this._local = mapa['local'];
      this._diasPravencer = mapa['diasPravencer'];
      this._diasDeUso = mapa['diasDeUso'];
      this._numeroDeRecargas  = mapa['numeroDeRecargas'];
      this._alcool  = mapa['alcool'];
      this._sabonete  = mapa['sabonete'];
      
   }

    void setdiasPravencer (int n){
      this._diasPravencer = n;
    }

    void setdiasDeUso (int n){
      this._diasDeUso = n;
    }
   
     void setDataDeRecarga(DateTime novaData){
       this._dataDeRecarga = novaData;
     }

     void setProdutoA(String proa){
       this._produtoArmazenado = proa;
     }

        
}




