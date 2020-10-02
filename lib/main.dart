import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'file:///C:/Users/Lucas/AndroidStudioProjects/flutter_app_api/lib/componentes/componentes.dart';
import 'package:http/http.dart';


void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: MyApp(),
  ));
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with SingleTickerProviderStateMixin {
  AnimationController _controller;

  TextEditingController controladorCEP = TextEditingController();
  GlobalKey<FormState> cForm = GlobalKey<FormState>();

  String rua = "Rua";
  String complemento = "Complemento";
  String bairro = "Bairro";
  String cidade = "Cidade";
  String estado = "Estado";

  Function validaCep = ((value){
    if(value.isEmpty){
      return "Cep inválido";
    }
    return null;
  });

  @override
  void initState() {
    _controller = AnimationController(vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  clicouNoBotao() async{
    if(!cForm.currentState.validate())
      return;
    String url = "https://viacep.com.br/ws/${controladorCEP.text}/json/";
    Response resposta = await get(url);
    Map endereco = json.decode(resposta.body);
    complemento = endereco["complemento"];
    setState(() {
      rua = endereco["logradouro"]+" - "+complemento;
      bairro = endereco["localidade"];
      cidade = endereco["bairro"];
      estado = endereco["uf"];

    });

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Form(
          key: cForm,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                child: Image.asset(
                    "assets/imgs/logo.jpg",
                fit: BoxFit.contain,
                ),
                height: 200,
              ),
              Componentes.caixaDeTexto("CEP", "Digite o CEP", controladorCEP, validaCep, numero: true),
              Container(
                alignment: Alignment.center,
                height: 100,
                child: IconButton(
                  onPressed: clicouNoBotao,
                  icon: FaIcon(FontAwesomeIcons.globe, color: Colors.green, size: 50,),
                ),
              ),
              Componentes.rotulo(rua),
              Componentes.rotulo(bairro),
              Componentes.rotulo(cidade),
              Componentes.rotulo(estado),
            ],
          ),
        ),
      ),
    );
  }
}

