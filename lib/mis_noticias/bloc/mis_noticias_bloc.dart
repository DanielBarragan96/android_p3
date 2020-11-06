import 'dart:async';
import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as Path;

part 'mis_noticias_event.dart';
part 'mis_noticias_state.dart';

class MisNoticiasBloc extends Bloc<MisNoticiasEvent, MisNoticiasState> {
  MisNoticiasBloc() : super(MisNoticiasInitial());

  @override
  Stream<MisNoticiasState> mapEventToState(
    MisNoticiasEvent event,
  ) async* {
    if (event is CrearNoticiaEvent) {
      //
    } else if (event is LeerNoticiasEvent) {
      //
    } else if (event is CargarImagenEvent) {
      _chooseImage(event.takePictureFromCamera);
    }
  }

  Future<String> _uploadPicture(File image) async {
    String imagePath = image.path;
    // referencia al storage de firebase
    StorageReference reference = FirebaseStorage.instance
        .ref()
        .child("noticias/${Path.basename(imagePath)}");

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
}
