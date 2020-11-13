import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:noticias/noticias/bloc/noticias_bloc.dart';
import 'package:noticias/noticias/item_noticia.dart';

class Buscar extends StatefulWidget {
  Buscar({Key key}) : super(key: key);

  @override
  _BuscarState createState() => _BuscarState();
}

class _BuscarState extends State<Buscar> {
  NoticiasBloc bloc = NoticiasBloc();
  TextEditingController _searxhController = TextEditingController();
  FocusNode focusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Buscar noticias'),
        ),
        body: BlocProvider(
          create: (context) => bloc..add(SearchNewsEvent(search: "")),
          child: BlocConsumer<NoticiasBloc, NoticiasState>(
            listener: (context, state) {
              //
            },
            builder: (context, state) {
              if (state is SearchSuccessState && state.searchList.length > 0) {
                return getSearchNoticias(state);
              } else
                return sinResultados();
            },
          ),
        ),
      ),
    );
  }

  Widget sinResultados() {
    return SingleChildScrollView(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: TextField(
              focusNode: focusNode,
              onSubmitted: (search) {
                // print(search);
                bloc..add(SearchNewsEvent(search: search));
              },
              controller: _searxhController,
              decoration: InputDecoration(
                hintText: "Busqueda",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
          SizedBox(height: 150),
          Center(
            child: Text("No hay resultados"),
          )
        ],
      ),
    );
  }

  Widget getSearchNoticias(SearchSuccessState state) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: TextField(
            focusNode: focusNode,
            onSubmitted: (search) {
              // print(search);
              if (search != "") bloc..add(SearchNewsEvent(search: search));
            },
            controller: _searxhController,
            decoration: InputDecoration(
              hintText: "Busqueda",
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: state.searchList.length,
            itemBuilder: (BuildContext context, int index) {
              return ItemNoticia(noticia: state.searchList[index]);
            },
          ),
        ),
      ],
    );
  }
}
