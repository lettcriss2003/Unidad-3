import 'dart:convert';

import 'package:noticias/controls/Conexion.dart';
import 'package:noticias/controls/servicio_back/RespuestaGenerica.dart';
import 'package:noticias/controls/servicio_back/modelo/InicioSession.dart';
import 'package:http/http.dart' as http;
// no se llama a conexion, se encapsula datos sensibles 
class FacadeService {
  Conexion c = Conexion();
  Future<inicioSesionSW> inicioSesion (Map<String, String> mapa)async{
    Map<String, String> _header = {'Content-Type':'application/json'};

    final String _url = '${c.URL}login';
    final uri =Uri.parse(_url);
    inicioSesionSW isw = inicioSesionSW();
    try {
      final response = await http.post(uri, headers: _header, body: jsonEncode(mapa));
      // log para imprimir los datos 
      //log(response.body);
      if (response.statusCode != 200) {
        if (response.statusCode == 404) {
          isw.code = 404;
          isw.msg = "Error";
          isw.tag = "Recurso no encontrado";
          isw.datos = {};
        }else{
           Map<dynamic, dynamic> mapa = jsonDecode(response.body); 
          isw.code = mapa ['code'];
          isw.msg = mapa['msg'];
          isw.tag = mapa ['tag'];
          isw.datos = mapa ['datos'];
         //return _response(mapa ['code'], mapa['msg'], mapa ['datos']);
        }
        //log("Page not found");
      }else{
        Map<dynamic, dynamic> mapa = jsonDecode(response.body); 
          isw.code = mapa ['code'];
          isw.msg = mapa['msg'];
          isw.tag = mapa ['tag'];
          isw.datos = mapa ['datos'];
        //return _response(mapa ['code'], mapa['msg'], mapa ['datos']);
        //log(response.body);
      }
      //log(response.statusCode.toString());
      //return RespuestaGenerica();
      
    } catch (e) {
          isw.code = 500;
          isw.msg = "Error ";
          isw.tag = "Error inesperado";
          isw.datos = {};
      
      //return RespuestaGenerica();
    }
       return isw;
      
  }

  }
  Future<RespuestaGenerica> listarNoticiasTodo ()async{
  return await c.solicitudGet('noticias', false);
  }
