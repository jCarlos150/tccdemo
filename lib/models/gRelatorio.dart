class gRelatorio  {
 

 int _idr;
 String _validade;
 int _numeroDeRecargas;
 int _diasDeUso;

 gRelatorio( this._validade , 
  this._numeroDeRecargas,
  this._diasDeUso , 
 );

 gRelatorio.map(dynamic obj){
      this._idr = obj['idr'];
      this._validade= obj['validade'];
      this._numeroDeRecargas=  obj['numeroDeRecargas'];
      this._diasDeUso = obj['diasDeUso']; 
 }

    int get idr => _idr;
    String get valdade => _validade;
    String get numeroDeRecargas => numeroDeRecargas;
    int get diasDeUso => _diasDeUso;



    Map<String , dynamic> toMap(){
      var mapa = new Map<String , dynamic>();

     
      mapa['validade'] = _validade;
      mapa['numeroDeRecargas'] = _numeroDeRecargas  ;
      mapa['diasDeUso'] = _diasDeUso;
     


      if(idr != null){
         mapa['idr'] = _idr;
      }

      return mapa;
      
    }

    gRelatorio.fromMap(Map<String ,dynamic> mapa){
      this._idr = mapa['idr'];
      this._validade= mapa['validade'];
      this._numeroDeRecargas=  mapa['numeroDeRecargas'];
      this._diasDeUso = mapa['diasDeUso']; 
    }
    
 






}