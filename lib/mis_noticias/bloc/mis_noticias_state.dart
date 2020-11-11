part of 'mis_noticias_bloc.dart';

abstract class MisNoticiasState extends Equatable {
  const MisNoticiasState();

  @override
  List<Object> get props => [];
}

class MisNoticiasInitial extends MisNoticiasState {}

class NoticiasDescargadasState extends MisNoticiasState {}

class MisNoticiasErrorState extends MisNoticiasState {
  final String errorMsg;

  MisNoticiasErrorState({@required this.errorMsg});
}

class MisNoticiasCreadaState extends MisNoticiasState {}

class ImagenCargadaState extends MisNoticiasState {
  final File imagen;

  ImagenCargadaState({@required this.imagen});
}

class SubirNoticiaState extends MisNoticiasState {
  final String urlImagen;

  SubirNoticiaState({@required this.urlImagen});
}
