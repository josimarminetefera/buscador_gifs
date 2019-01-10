import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  String _pesquisar;
  int _offset = 0;

  //buscar a lista de gifs primeiro ela obtem os dados e retorna os dados no futuro
  Future<Map> _buscarGifs() async{
    //resposta da api
    http.Response resposta;
    //dois tipos de respostas uma para pesquisas outra quando o app é aberto
    if(_pesquisar == null){
      resposta = await http.get("https://api.giphy.com/v1/gifs/trending?api_key=2J3gTy0ZNV1h6tj6GkyMFJE2OXArbmLr&limit=20&rating=G");
    }else{
      resposta = await http.get("https://api.giphy.com/v1/gifs/search?api_key=2J3gTy0ZNV1h6tj6GkyMFJE2OXArbmLr&q=$_pesquisar&limit=20&offset=$_offset&rating=G&lang=pt");
    }
    return json.decode(resposta.body);
  }

  //primeirafunção executada
  @override
  void initState() {
    super.initState();
    _buscarGifs().then(
        (mapa){
          print(mapa);
        }
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Image.network("https://developers.giphy.com/static/img/dev-logo-lg.7404c00322a8.gif"),
        centerTitle: true,
      ),
      backgroundColor: Colors.black,
      body: Column(
        children: <Widget>[

          Padding(
            padding: EdgeInsets.all(10.0),
            child: TextField(
              decoration: InputDecoration(
                  labelText: "Pesquise Aqui",
                  labelStyle: TextStyle(color: Colors.white),
                  border: OutlineInputBorder()
              ),
              style: TextStyle(color: Colors.white, fontSize: 18.0),
              textAlign: TextAlign.center,
            ),
          ),

          Expanded(
            child: FutureBuilder(//para aguardar carregar as imagens
              future: _buscarGifs(),
              builder: (context, snapshot){
                if(
                  snapshot.connectionState == ConnectionState.waiting || //esperando
                  snapshot.connectionState == ConnectionState.none
                ){
                  return Container(
                    height: 200.0,
                    width: 200.0,
                    alignment: Alignment.center,
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white), //irá rodar uma animação somente com a cor branca sempre parada
                      strokeWidth: 5.0, //largura da linha que fica rodando
                    ),
                  );
                }else{
                  if(snapshot.hasError){
                    return Container();
                  }else{
                    _criarGifTabela(context, snapshot);
                  }
                }
              },
            ),
          )

        ],
      ),
    );
  }

  //retorna toda a minha tabela de gifs
  Widget _criarGifTabela(BuildContext context, AsyncSnapshot snapshot){

  }

}
