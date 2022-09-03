

import 'dart:convert';

import 'package:buscador_de_gifs/services/http_client_model.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class HttpClienAdapt implements HttpClientModel{
  final result = http.Client();
  @override
  Future<Map> request({
    required String url, required String method,
     Map<String, dynamic>? body,
      Map? headers
     }) async {
    switch (method) {
      case "get":
      case "GET":
       Uri urls = Uri.parse(url);
       http.Response r = await result.get(urls);
       var rm = json.decode(r.body); 
       return rm;
      default:
      Map m ={"resul":"nada.."};
      return m;
    }
  }
}