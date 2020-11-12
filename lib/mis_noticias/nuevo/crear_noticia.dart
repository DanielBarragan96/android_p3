import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:noticias/mis_noticias/bloc/mis_noticias_bloc.dart';

class CrearNoticia extends StatefulWidget {
  final MisNoticiasBloc misNoticiasBloc;
  CrearNoticia({Key key, @required this.misNoticiasBloc}) : super(key: key);

  @override
  _CrearNoticiaState createState() => _CrearNoticiaState();
}
// TODO: Formulario para crear noticias
// tomar fotos de camara o de galeria

TextEditingController _authorController = TextEditingController();
TextEditingController _titleController = TextEditingController();
TextEditingController _descriptionController = TextEditingController();
File _choosenImage;
bool _loading = false;

class _CrearNoticiaState extends State<CrearNoticia> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocProvider(
        create: (context) {
          return widget.misNoticiasBloc;
        },
        child: BlocConsumer<MisNoticiasBloc, MisNoticiasState>(
          listener: (context, state) {
            if (state is MisNoticiasCreadaState) {
              _showSnackbar(context, "La noticia fue creada");
            } else if (state is MisNoticiasErrorState) {
              _showSnackbar(context, "Error al crear la noticia");
            }
          },
          builder: (context, state) {
            if (state is ImagenCargadaState) {
              _choosenImage = state.imagen;
            } else if (state is SubirNoticiaState) {
              String title = _titleController.text;
              String author = _authorController.text;
              String description = _descriptionController.text;
              String source = "None";

              widget.misNoticiasBloc.add(
                CrearNoticiaEvent(
                  author: author,
                  description: description,
                  source: source,
                  title: title,
                  imageUrl: state.urlImagen,
                ),
              );
            } else if (state is MisNoticiasCreadaState) {
              _loading = false;
              if (state.uploaded)
                _clearNoticiasWidget();
              else
                _showSnackbar(context, "No se pudo crear la noticia");
            }
            return _createNewsForm();
          },
        ),
      ),
    );
  }

  Widget _createNewsForm() {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            GestureDetector(
              behavior: HitTestBehavior.translucent,
              child: _choosenImage != null
                  ? Image.file(
                      _choosenImage,
                      width: 150,
                      height: 150,
                    )
                  : Container(
                      height: 150,
                      width: 150,
                      child: Placeholder(
                        fallbackHeight: 150,
                        fallbackWidth: 150,
                      ),
                    ),
              onTap: () {
                widget.misNoticiasBloc
                    .add(CargarImagenEvent(takePictureFromCamera: true));
              },
            ),
            SizedBox(height: 20),
            Center(child: _loading ? CircularProgressIndicator() : Container()),
            SizedBox(height: 20),
            TextField(
              controller: _titleController,
              decoration: InputDecoration(
                hintText: "Título de la noticia",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            SizedBox(height: 12),
            TextField(
              controller: _authorController,
              decoration: InputDecoration(
                hintText: "Autor de la noticia",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            SizedBox(height: 12),
            TextField(
              controller: _descriptionController,
              maxLines: 5,
              decoration: InputDecoration(
                hintText: "Descripción de la noticia",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            SizedBox(height: 24),
            Row(
              children: <Widget>[
                Expanded(
                  child: RaisedButton(
                    child: Text("Guardar"),
                    onPressed: () {
                      setState(() {
                        _loading = true;
                      });
                      String title = _titleController.text;
                      String author = _authorController.text;
                      String description = _descriptionController.text;

                      if (title == "") {
                        _showSnackbar(context, "Falta título");
                      } else if (author == "") {
                        _showSnackbar(context, "Falta autor");
                      } else if (description == "") {
                        _showSnackbar(context, "Falta descripción");
                      } else if (_choosenImage == null) {
                        _showSnackbar(context, "Falta imagen");
                      } else {
                        widget.misNoticiasBloc
                            .add(SubirImagenEvent(file: _choosenImage));
                      }
                    },
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showSnackbar(BuildContext context, String msg) {
    Scaffold.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text("$msg"),
        ),
      );
  }

  void _clearNoticiasWidget() {
    //TODO borrar campos de crear noticia
  }
}
