import 'package:flutter/material.dart';

class GifPage extends StatelessWidget {

  final Map _gifDados;

  GifPage(this._gifDados);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_gifDados["title"]),
        backgroundColor: Colors.black,
      ),
      backgroundColor: Colors.black,
      body: Center(
        child: Image.network(_gifDados["images"]["fixed_height"]["url"]),
      ),
    );
  }
}
