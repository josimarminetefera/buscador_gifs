import 'dart:convert';

import 'package:buscador_gifs/page/gif_page.dart';
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
      resposta = await http.get("https://api.giphy.com/v1/gifs/search?api_key=2J3gTy0ZNV1h6tj6GkyMFJE2OXArbmLr&q=$_pesquisar&limit=19&offset=$_offset&rating=G&lang=pt");
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
              onSubmitted: (texto){
                setState(() {
                  _pesquisar = texto;
                  //reseta para mostrar os primeiros itens
                  _offset = 0;
                });
              },
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
                    return _criarGifTabela(context, snapshot);
                  }
                }
              },
            ),
          )

        ],
      ),
    );
  }

  int _buscarQuantidade(List dados){
    if(_pesquisar == null){
      //if eu não estiver pesquisando eu não vou mostrar a linha para mostrar mais
      return dados.length;
    }else{
      //um a mais para mostrar mais um quadrado vazio
      return dados.length + 1;
    }
  }

  //retorna toda a minha tabela de gifs
  Widget _criarGifTabela(BuildContext context, AsyncSnapshot snapshot){
    return GridView.builder(
      padding: EdgeInsets.all(10.0),//distancia na lateral
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2, //quantos itens ele pode ter na horizontal
        crossAxisSpacing: 10.0,//espassamento entre os itens na horizontal
        mainAxisSpacing: 10.0, //espaçamento na vertical
      ),//mostrar como os itens serao organizados
      itemCount: _buscarQuantidade(snapshot.data["data"]), //quantidade de itens que vou carregar aqui na minta tela
      itemBuilder: (context, index){
        //retorna o item que tenho que colocar em cada quadrado da grid
        if(_pesquisar == null || index < snapshot.data["data"].length){
          //nao estou pesquisando e não é o ultimo item
          //vou mostrar a minha imagem
          return GestureDetector( //pode clicar
            child: Image.network(
              snapshot.data["data"][index]["images"]["fixed_height"]["url"],
              height: 300.0,
              fit: BoxFit.cover,
            ),

            //passar para outra tela
            onTap: (){
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => GifPage(snapshot.data["data"][index]))
              );
            },

          );
        }else{
          //construo o quadrado com o mais itens
          return Container(
            child: GestureDetector(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center, //alinhamento no euxo principal
                children: <Widget>[
                  Icon(Icons.add, color: Colors.white, size: 70.0,),
                  Text("Carregar mais...", style: TextStyle(color: Colors.white, fontSize: 22.0),)
                ],
              ),
              onTap: (){
                setState(() {
                  _offset += 19;
                });
              },
            ),
          );
        }

      }
    );
  }

}
