import 'package:flutter/material.dart';

class CrearNoticia extends StatefulWidget {
  CrearNoticia({Key key}) : super(key: key);

  @override
  _CrearNoticiaState createState() => _CrearNoticiaState();
}
// TODO: Formulario para crear noticias
// tomar fotos de camara o de galeria

class _CrearNoticiaState extends State<CrearNoticia> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text("Crear noticia"),
      ),
    );
  }
}
