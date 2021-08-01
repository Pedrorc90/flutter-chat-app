

import 'dart:convert';
import 'package:chat_flutter/global/environment.dart';
import 'package:chat_flutter/models/login_response.dart';
import 'package:chat_flutter/models/register_response.dart';
import 'package:chat_flutter/models/usuario.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
class AuthService with ChangeNotifier {

  late Usuario usuario;
  bool _autenticando = false;

  // Create storage
  final _storage = new FlutterSecureStorage();

  bool get autenticando => this._autenticando;
  set autenticando(bool valor) {
    this._autenticando = valor;
    notifyListeners();
  }

  // Getters del token de forma estatica
  static Future getToken() async {
    final _storage = new FlutterSecureStorage();
    return await _storage.read(key: 'token');
  }

  static Future deleteToken() async {
    final _storage = new FlutterSecureStorage();
    await _storage.delete(key: 'token');
    
  }

  Future<bool> login( String email, String password) async {

    this.autenticando = true;


    final data = {
      'email': email,
      'password': password
    };


     final resp = await http.post('${ Environment.apiUrl }/login', 
        body: jsonEncode(data),
        headers: {'Content-Type': 'application/json'}
     );

     this.autenticando = false;

     if ( resp.statusCode == 200 ) {
       final loginResponse = loginResponseFromJson(resp.body);
       this.usuario = loginResponse.usuario;

        //TODO: Guardar token en lugar seguro
        await this._guardarToken(loginResponse.token);

       return true;
     } else {
       return false;
     }
  }

  Future register( String name, String email, String password) async {
    this.autenticando = true;

    final data = {
      'nombre': name,
      'email': email,
      'password': password
    };

    final resp = await http.post('${ Environment.apiUrl }/login/new', 
        body: jsonEncode(data),
        headers: {'Content-Type': 'application/json'}
     );
     this.autenticando = false;

    if ( resp.statusCode == 200 ) {
       final registerResponse = registerResponseFromJson(resp.body);
       this.usuario = registerResponse.usuario;

        //TODO: Guardar token en lugar seguro
        await this._guardarToken(registerResponse.token);

       return true;
     } else {
        final respBody = jsonDecode(resp.body);
       return respBody['msg'];
     }
   }


   Future<bool> isLoggedIn() async {
     final token = await this._storage.read(key: 'token');


     final resp = await http.get('${ Environment.apiUrl }/login/renew', 
        headers: {'Content-Type': 'application/json', 'x-token': token.toString()}
     );
    if ( resp.statusCode == 200 ) {
       final registerResponse = registerResponseFromJson(resp.body);
       this.usuario = registerResponse.usuario;

        //TODO: Guardar token en lugar seguro
        await this._guardarToken(registerResponse.token);

       return true;
     } else {
        this.logout();
        return false;
     }
   }

  Future _guardarToken(String token) async {
    // Write value 
    return await _storage.write(key: 'token', value: token);
  }

  Future logout() async {
    // Delete value 
    await _storage.delete(key: 'token');
  } 

}