import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:noticias/mis_noticias/bloc/mis_noticias_bloc.dart';
import 'package:noticias/noticias/item_noticia.dart';

class MisNoticias extends StatelessWidget {
  final MisNoticiasBloc misNoticiasBloc = MisNoticiasBloc();

  MisNoticias({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Mis noticias'),
        ),
        body: BlocProvider(
          create: (context) => misNoticiasBloc..add(LeerMisNoticiasEvent()),
          child: BlocConsumer<MisNoticiasBloc, MisNoticiasState>(
            listener: (context, state) {
              //
            },
            builder: (context, state) {
              if (state is MisNoticiasMostrarState) {
                return getMisNoticias(state);
              } else
                return Center(
                  child: Text("No hay noticias disponibles"),
                );
            },
          ),
        ),
      ),
    );
  }

  Widget getMisNoticias(MisNoticiasMostrarState state) {
    return ListView.builder(
      itemCount: state.noticiasList.length,
      itemBuilder: (BuildContext context, int index) {
        return ItemNoticia(noticia: state.noticiasList[index]);
      },
    );
  }
}
