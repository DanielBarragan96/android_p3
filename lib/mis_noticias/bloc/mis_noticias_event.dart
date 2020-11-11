part of 'mis_noticias_bloc.dart';

abstract class MisNoticiasEvent extends Equatable {
  const MisNoticiasEvent();

  @override
  List<Object> get props => [];
}

class CrearNoticiaEvent extends MisNoticiasEvent {
  final String title;
  final String description;
  final String autor;
  final String fuente;

  CrearNoticiaEvent({
    @required this.title,
    @required this.description,
    @required this.autor,
    @required this.fuente,
  });

  @override
  List<Object> get props => [title, description, autor, fuente];
}

class LeerMisNoticiasEvent extends MisNoticiasEvent {
  @override
  List<Object> get props => [];
}

class CargarImagenEvent extends MisNoticiasEvent {
  final bool takePictureFromCamera;

  CargarImagenEvent({@required this.takePictureFromCamera});
  @override
  List<Object> get props => [takePictureFromCamera];
}

class SubirImagenEvent extends MisNoticiasEvent {
  final File file;

  SubirImagenEvent({@required this.file});
  @override
  List<Object> get props => [file];
}
