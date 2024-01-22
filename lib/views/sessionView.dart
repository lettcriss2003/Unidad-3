import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:noticias/controls/servicio_back/FacadeService.dart';
import 'package:noticias/controls/utiles/Utiles.dart';
//import 'package:noticias/controls/Conexion.dart';
import 'package:validators/validators.dart';

class SessionView extends StatefulWidget {
  const SessionView({Key? key}) : super(key: key);

  @override
  _SessionViewState createState() => _SessionViewState();
}

class _SessionViewState extends State<SessionView> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController correoCotrol = TextEditingController();
  final TextEditingController claveControl = TextEditingController();

  void _iniciar() {
    setState(() {
      // no se puede dejar el codigo sensible, son como restricciones 
      //Conexion c = Conexion();
      //c.solicitudGet("noticias", false);
      FacadeService servicio = FacadeService();
      if (_formKey.currentState!.validate()) {
        Map<String, String> mapa = {
          "correo": correoCotrol.text,
          "clave": claveControl.text
        };
        servicio.inicioSesion(mapa).then((value) async{
          if (value.code == 200) {
            //log(value.datos['token']);
            Utiles util = Utiles();
            util.saveValue('token', value.datos['token']);
            util.saveValue('usuario', value.datos['user']);
            final SnackBar msg =  SnackBar(content: const Text('BIENVENIDO ${value.datos['token']}'));
            ScaffoldMessenger.of(context).showSnackBar(msg);
          }else{
            final SnackBar msg =  SnackBar(content: Text( 'Error ${value.tag}'));
            ScaffoldMessenger.of(context).showSnackBar(msg);
          }
          log(value.code.toString());
        });
        log("OK");
      } else {
        log("ERROR");
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Scaffold(
        body: ListView(
          padding: const EdgeInsets.all(32),
          children: <Widget>[
            Container(
              alignment: Alignment.center,
              padding: const EdgeInsets.all(10),
              child: const Text(
                "NOTICIAS",
                style: TextStyle(
                    color: Colors.blue,
                    fontWeight: FontWeight.bold,
                    fontSize: 30),
              ),
            ),
            Container(
              alignment: Alignment.center,
              padding: const EdgeInsets.all(10),
              child: const Text(
                "La mejor app de noticias",
                style: TextStyle(color: Colors.blueGrey, fontSize: 20),
              ),
            ),
            Container(
              alignment: Alignment.center,
              padding: const EdgeInsets.all(10),
              child: const Text(
                "INICIO DE SESIÓN",
                style: TextStyle(
                    color: Colors.blueAccent,
                    fontWeight: FontWeight.bold,
                    fontSize: 20),
              ),
            ),
            Container(
              padding: const EdgeInsets.all(10),
              child: TextFormField(
                controller: correoCotrol,
                decoration: const InputDecoration(
                    labelText: 'Correo',
                    suffixIcon: Icon(Icons.alternate_email)),
                validator: (value) {
                  if (value!.isEmpty) {
                    return "Debe ingresar su correo";
                  }
                  if (!isEmail(value)) {
                    return "Debe ingresar un correo valido";
                  }
                },
              ),
            ),
            Container(
              padding: const EdgeInsets.all(10),
              child: TextFormField(
                decoration: const InputDecoration(
                    labelText: 'Clave', suffixIcon: Icon(Icons.key)),
                controller: claveControl,
                validator: (value) {
                  if (value!.isEmpty) {
                    return "Debe ingresar su clave";
                  }
                },
              ),
            ),
            Container(
              height: 50,
              padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
              child: ElevatedButton(
                  child: const Text("Inicio"), onPressed: _iniciar),
            ),
          ],
        ),
      ),
    );
  }
}
