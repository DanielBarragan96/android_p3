part of 'mis_noticias_bloc.dart';

abstract class MisNoticiasState extends Equatable {
  const MisNoticiasState();

  @override
  List<Object> get props => [];
}

class MisNoticiasInitial extends MisNoticiasState {}

class NoticiasDescargadasState extends MisNoticiasState {}

class NoticiasErrorState extends MisNoticiasState {
  final String errorMsg;

  NoticiasErrorState({@required this.errorMsg});
}

class NoticiasCreadaState extends MisNoticiasState {}

class ImagenCargadaState extends MisNoticiasState {
  final File imagen;

  ImagenCargadaState({@required this.imagen});
}
