import 'dart:async';
import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';
import 'package:noticias/models/noticia.dart';
import 'package:path/path.dart' as Path;

part 'mis_noticias_event.dart';
part 'mis_noticias_state.dart';

class MisNoticiasBloc extends Bloc<MisNoticiasEvent, MisNoticiasState> {
  List<Noticia> _noticiasList;
  File _choosenImage;
  List<Noticia> get getNoticiasList => _noticiasList;

  MisNoticiasBloc() : super(MisNoticiasInitial());

  @override
  Stream<MisNoticiasState> mapEventToState(
    MisNoticiasEvent event,
  ) async* {
    if (event is CrearNoticiaEvent) {
      try {
        // String imageUrl = await _uploadPicture(_choosenImage);
        await _saveNoticia(
          event.title,
          event.description,
          event.author,
          event.source,
          event.imageUrl,
        );
        yield MisNoticiasCreadaState();
      } catch (e) {}
    } else if (event is LeerMisNoticiasEvent) {
      try {
        await _getAllNoticias();
      } catch (e) {
        yield MisNoticiasErrorState(errorMsg: "No se pudo cargar noticia: $e");
      }
    } else if (event is CargarImagenEvent) {
      _choosenImage = await _chooseImage(event.takePictureFromCamera);
      yield ImagenCargadaState(imagen: _choosenImage);
    } else if (event is SubirImagenEvent) {
      String urlImagen = await _uploadPicture(event.file);
      yield SubirNoticiaState(urlImagen: urlImagen);
    }
  }

  // subir imagen al bucket de almacenamiento
  Future<String> _uploadPicture(File image) async {
    String imagePath = image.path;
    // referencia al storage de firebase
    StorageReference reference = FirebaseStorage.instance
        .ref()
        .child("noticias/imagenes/${Path.basename(imagePath)}");

    // subir el archivo a firebase
    StorageUploadTask uploadTask = reference.putFile(image);
    await uploadTask.onComplete;

    // recuperar la url del archivo que acabamos de subir
    dynamic imageURL = await reference.getDownloadURL();
    return imageURL;
  }

  Future<File> _chooseImage(bool fromCamera) async {
    final picker = ImagePicker();
    final PickedFile chooseImage = await picker.getImage(
      source: (fromCamera) ? ImageSource.camera : ImageSource.gallery,
      maxHeight: 720,
      maxWidth: 720,
      imageQuality: 85,
    );
    return File(chooseImage.path);
  }

  Future _getAllNoticias() async {
    // recuperar lista de docs guardados en Cloud firestore
    // mapear a objeto de dart (Apunte)
    // agregar cada ojeto a una lista

    var misNoticias =
        await FirebaseFirestore.instance.collection("noticias").get();

    _noticiasList = misNoticias.docs
        .map(
          (elemento) => Noticia(
            title: elemento["title"],
            description: elemento["description"],
            author: elemento["author"],
            source: elemento["source"],
            urlToImage: elemento["urlToImage"],
            publishedAt: elemento["publishedAt"],
          ),
        )
        .toList();
  }

  // guardar en CloudFirestore
  Future _saveNoticia(
    String title,
    String description,
    String autor,
    String fuente,
    String imageUrl,
  ) async {
    // Crea un doc en la collection de apuntes
    await FirebaseFirestore.instance.collection("noticias").doc().set({
      "title": title,
      "description": description,
      "author": autor,
      "source": fuente,
      "urlToImage": imageUrl,
      "publishedAt": DateTime.now().toString(),
    });
    // FirebaseDatabase.instance.reference().child("MisNoticias");
  }
}
