import 'dart:async';
import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart';
import 'package:noticias/models/noticia.dart';

import '../../secrets.dart';

part 'noticias_event.dart';
part 'noticias_state.dart';

class NoticiasBloc extends Bloc<NoticiasEvent, NoticiasState> {
  final _sportsLink =
      "https://newsapi.org/v2/top-headlines?country=mx&category=sports&$API_KEY";
  final _businessLink =
      "https://newsapi.org/v2/top-headlines?country=mx&category=business&$API_KEY";
  NoticiasBloc() : super(NoticiasInitial());

  @override
  Stream<NoticiasState> mapEventToState(
    NoticiasEvent event,
  ) async* {
    if (event is GetNewsEvent) {
      // yield lista de noticias al estado
      try {
        List<Noticia> soportsNews = await _requestSportNoticias();
        List<Noticia> businessNews = await _requestBusinessNoticias();

        yield NoticiasSuccessState(
          noticiasSportList: soportsNews,
          noticiasBusinessList: businessNews,
        );
      } catch (e) {
        yield NoticiasErrorState(message: "Error al cargar noticias: $e");
      }
    } else if (event is SearchNewsEvent) {
      try {
        List<Noticia> searchNews = await _requestSearchNoticias(event.search);
        yield SearchSuccessState(searchList: searchNews);
      } catch (e) {
        yield NoticiasErrorState(message: "No se encontraron noticias");
      }
    }
  }

  Future<List<Noticia>> _requestBusinessNoticias() async {
    Response response = await get(_businessLink);
    List<Noticia> _noticiasList = List();

    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body)["articles"];
      _noticiasList =
          ((data).map((element) => Noticia.fromJson(element))).toList();
    }
    return _noticiasList;
  }

  Future<List<Noticia>> _requestSportNoticias() async {
    Response response = await get(_sportsLink);
    List<Noticia> _noticiasList = List();

    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body)["articles"];
      _noticiasList =
          ((data).map((element) => Noticia.fromJson(element))).toList();
    }
    return _noticiasList;
  }

  Future<List<Noticia>> _requestSearchNoticias(String search) async {
    final _searchLink =
        "http://newsapi.org/v2/everything?from=2020-11-13&sortBy=popularity&$API_KEY&q=$search";

    Response response = await get(_searchLink);
    List<Noticia> _noticiasList = List();

    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body)["articles"];
      _noticiasList =
          ((data).map((element) => Noticia.fromJson(element))).toList();
    }
    return _noticiasList;
  }
}
