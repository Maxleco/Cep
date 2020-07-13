import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Consumo de Serviço Web',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomeWidget(),
    );
  }
}

class HomeWidget extends StatefulWidget {
  @override
  _HomeWidgetState createState() => _HomeWidgetState();
}

class _HomeWidgetState extends State<HomeWidget> {
  TextEditingController _controllerTextCep = TextEditingController();
  String _texts = "";

  void _recuperarCep() async {
    String cep = _controllerTextCep.text;
    String url = "https://viacep.com.br/ws/$cep/json/";

    http.Response response;
    response = await http.get(url);

    if (response.statusCode != 200) {
      setState(() {
        _texts = "Not Found";
        return;
      });
    } else {
      Map<String, dynamic> result = json.decode(response.body);
      String cepe = result["cep"];
      String log = result["logradouro"];
      String bairro = result["bairro"];

      setState(() {
        _texts = cepe + "\n" + bairro + "\n" + log;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Consumo de Serviço Web"),
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.all(16.0),
              child: TextField(
                controller: _controllerTextCep,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: "CEP",
                ),
              ),
            ),
            RaisedButton(
              onPressed: _recuperarCep,
              child: Text("RECUPERAR"),
            ),
            Padding(
              padding: EdgeInsets.only(top: 64.0),
              child: Text(
                _texts,
                style: TextStyle(
                  fontSize: 25,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
