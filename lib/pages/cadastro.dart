import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:tccdemo/models/dispenser.dart';
import 'package:tccdemo/pages/SegundaTela.dart';

class Formulario extends StatefulWidget {
  @override
  _FormularioState createState() => _FormularioState();
  String idD;
  Formulario(String decisao) {
    this.idD = decisao;
  }
}

Dispenser dispenser;

class _FormularioState extends State<Formulario> {
  var db = Firestore.instance; // Banco de dados

  var ctr = new TextEditingController();

  var ctrl = new TextEditingController();

  DateTime df;

  DateTime dv;

  var diaspravencer;

  var ctrlcap = new TextEditingController();

  var ctrlocsl = new TextEditingController();

  String labelMarca = "";
  String labelLote = "";
  String labelDataF = "";
  String labelDataV = "";
  String labelVol = "";
  String labelloc = "";
  bool validador = false;
  int diasPraVencer;

  //void _inserir() async {
  //Map<String ,dynamic> row = {

  //}
  //}

// Listas de seleção
  static const menuItems = <String>[
    'Álcool em Gel',
    'Sabonete Líquido',
  ];
  final List<DropdownMenuItem<String>> _dropDownMenuItems = menuItems
      .map(
        (String value) => DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        ),
      )
      .toList();

  String _btn1SelectedVal = 'Álcool em Gel';

  void _zerar() {
    setState(() {
      ctr = new TextEditingController();
      ctrl = new TextEditingController();
      df = null;
      dv = null;
      diaspravencer = null;
      ctrlcap = new TextEditingController();
      ctrlocsl = new TextEditingController();
      labelMarca = "";
      labelLote = "";
      labelDataF = "";
      labelDataV = "";
      labelVol = "";
      labelloc = "";
      validador = false;
    });
  }

  void _show() {
    final snackBar = SnackBar(
      duration: Duration(milliseconds: 500),
      backgroundColor: Colors.blue,
      content: Row(
        children: <Widget>[
          Icon(
            Icons.check_box,
            semanticLabel: "Atualizado com sucesso",
          ),
          Text("Atualizado com sucesso"),
        ],
      ),
    );
    Scaffold.of(context).showSnackBar(snackBar);
  }

  //Valor do espaçamento
  double paddingv = 5;

  bool _validarData(DateTime d1, DateTime d2) {
    if (d1 == null || d2 == null) {
      return true;
    }

    if (d2.isAfter(d1)) {
      return true;
    }

    return false;
  }

  void salvar(
      String marca,
      String lote,
      String dataF,
      DateTime dataV,
      int volume,
      String produtoArmazenado,
      int codigoQr,
      String local,
      int diasPravencer) async {
    DateTime dateDeTroca = DateTime.now();
    int a = 0;
    int s = 0;

    if (widget.idD != "") {
      dispenser = new Dispenser(
          marca,
          lote,
          dataF,
          dataV,
          volume,
          produtoArmazenado,
          local,
          diasPravencer,
          dateDeTroca,
          dateDeTroca,
          0,
          1,
          0,
          0);

      int a = dispenser.alcool;
      int s = dispenser.sabonete;

      Firestore.instance
          .collection("dispenser")
          .document(widget.idD)
          .updateData({
        "alcool": a,
        "sabonete": s,
        "produtoArmazenado": dispenser.prdutoA,
        "dataDeRecarga": dispenser.dataDeRecarga,
        "dataDeTroca": dispenser.dataDeTroca,
        "dataF": dispenser.dataf,
        "dataV": dispenser.dataV,
        "diasDeUso": dispenser.diasDeUso,
        "diasPraVencer": dispenser.diasPravencer,
        "local": dispenser.local,
        "lote": dispenser.lote,
        "marca": dispenser.marca,
        "volume": dispenser.volume
      });
      _show();
      _zerar();
    } else {
      if (produtoArmazenado == "Álcool em Gel") {
        a = 1;
      } else if (produtoArmazenado == "Sabonete Líquido") {
        s = 1;
      }

      dispenser = new Dispenser(
          marca,
          lote,
          dataF,
          dataV,
          volume,
          produtoArmazenado,
          local,
          diasPravencer,
          dateDeTroca,
          dateDeTroca,
          0,
          1,
          a,
          s);

      DocumentReference docRef = await Firestore.instance
          .collection('dispenser')
          .add(dispenser.toMap());

      _zerar();
      getNavegador(docRef.documentID.toString());
    }
  }

  void getNavegador(String p) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => SegundaRota(p)),
    );
  }

  void validacao() {
    validador = true;

    if (ctr.text.toString() == "") {
      labelMarca = "Insira uma marca válido";
      validador = false;
    } else {
      labelMarca = "";
    }
    if (ctrl.text.toString() == "") {
      labelLote = "Insira um  volume válido";
      validador = false;
    } else {
      labelLote = "";
    }

    if (ctrlcap.text.toString() == "") {
      labelVol = "Insira um lote válido";
      validador = false;
    } else {
      labelVol = "";
    }

    if (ctrlocsl.text.toString() == "") {
      labelloc = "Insira um  local válido";
      validador = false;
    } else {
      labelloc = "";
    }

    if (!_validarData(df, dv)) {
      labelDataV = "Data de vencimento menor do que a fabricação";
      validador = false;
    } else if (dv == null || df == null) {
      labelDataV = "Preencha os dois campos da data";
      validador = false;
    } else if (dv.isBefore(DateTime.now())) {
      labelDataV = "Não é possível cadastrar dispenser vencido";
      validador = false;
    } else {
      labelDataV = "";
    }

    if (validador == false) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: <Widget>[
        Card(
          color: Colors.white,
          elevation: 10.0,
          child: Container(
            height: 30.0,
            child: Row(
              children: <Widget>[
                Expanded(
                  child: Text(
                    widget.idD == ""
                        ? 'Cadastrar Dispenser'
                        : 'Atualizar Dispenser',
                    style: TextStyle(
                      fontSize: 15,
                      color: Colors.blue,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.all(paddingv),
          child: TextFormField(
            // Método usado para gerar o formulario que caputura os dados do dispenser
            controller:
                ctr, // Variável controller , captura a informação inseida pelo usuario e armazena na variável
            decoration: InputDecoration(
              // atribui o label marca ao campo do formulario
              labelText: "Marca",
              helperText: labelMarca,
              helperStyle: TextStyle(color: Colors.red),
            ),

            keyboardType: TextInputType
                .text, // função que atribui o tipo texto ao campo que irar capturar os dados
          ),
        ),
        Padding(
          padding: EdgeInsets.all(paddingv),
          child: TextFormField(
            controller: ctrl,
            decoration: InputDecoration(
              labelText: "Lote",
              helperText: labelLote,
              helperStyle: TextStyle(color: Colors.red),
            ),
            keyboardType: TextInputType.text,
          ),
        ),
        Padding(
          //data
          padding: EdgeInsets.all(paddingv),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                children: <Widget>[
                  RaisedButton(
                      child: Text(
                        "Data De Fabricação ",
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                      color: Colors.blue,
                      onPressed: () {
                        showDatePicker(
                                context: context,
                                initialDate: df == null ? DateTime.now() : df,
                                firstDate: DateTime(2001),
                                lastDate: DateTime(2030))
                            .then((date) {
                          setState(() {
                            df = date;
                          });
                        });
                      }),
                  SizedBox(
                    width: 20,
                  ),
                  Text(
                    df == null
                        ? ''
                        : df.toString().replaceAll(" 00:00:00.000", " "),
                    style: TextStyle(
                      color: Colors.blue,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        Padding(
          padding: EdgeInsets.all(paddingv),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                children: <Widget>[
                  RaisedButton(
                      child: Text(
                        "Data De Vencimento",
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                      color: Colors.blue,
                      onPressed: () {
                        showDatePicker(
                                context: context,
                                initialDate: dv == null ? DateTime.now() : dv,
                                firstDate: DateTime(2001),
                                lastDate: DateTime(2030))
                            .then((date) {
                          setState(() {
                            dv = date;
                            // Gambiarra pra pegar os dias que faltam pra vencer
                            diaspravencer = ((dv.year - df.year) * 365) +
                                ((dv.month - df.month) * 30) +
                                (dv.day - df.day);
                          });
                        });
                      }),
                  SizedBox(
                    width: 20,
                  ),
                  Text(
                    dv == null
                        ? ''
                        : dv.toString().replaceAll(" 00:00:00.000", " "),
                    style: TextStyle(
                      color: Colors.blue,
                    ),
                  ),
                ],
              ),
              Text(
                labelDataV,
                style: TextStyle(color: Colors.red),
              ),
            ],
          ),
        ),
        Padding(
          padding: EdgeInsets.all(paddingv),
          child: TextFormField(
              controller: ctrlcap,
              decoration: InputDecoration(
                labelText: "Capacidade",
                helperText: labelVol,
                helperStyle: TextStyle(color: Colors.red),
              ),
              keyboardType: TextInputType.number),
        ),
        Padding(
          padding: EdgeInsets.all(paddingv),
          child: TextFormField(
            controller: ctrlocsl,
            decoration: InputDecoration(
              labelText: "Localização",
              helperText: labelloc,
              helperStyle: TextStyle(color: Colors.red),
            ),
            keyboardType: TextInputType.text,
          ),
        ),
        Padding(
          padding: EdgeInsets.all(paddingv),
          child: Column(
            children: <Widget>[
              ListTile(
                title: Text('Produto/Ar'),
                trailing: DropdownButton<String>(
                  // Lista de Seleção
                  value: _btn1SelectedVal,
                  onChanged: (String newValue) {
                    setState(() {
                      _btn1SelectedVal = newValue;
                    });
                  },
                  items: this._dropDownMenuItems,
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: EdgeInsets.all(paddingv),
          child: Column(
            children: <Widget>[
              FlatButton(
                color: Theme.of(context).primaryColor,
                child: Text(
                  "Salvar",
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
                onPressed: () {
                  validacao();
                  if (validador) {
                    int volume = int.parse(ctrlcap.text);
                    salvar(
                        ctr.text.toString(),
                        ctrl.text.toString(),
                        df.toString().replaceAll(" 00:00:00.000", " "),
                        dv,
                        volume,
                        _btn1SelectedVal,
                        1111,
                        ctrlocsl.text.toString(),
                        diaspravencer);
                  }
                },
              ),
            ],
          ),
        ),
      ],
    );
  }
}
