

import 'package:chat_flutter/global/environment.dart';
import 'package:chat_flutter/models/usuario.dart';
import 'package:chat_flutter/models/usuarios_response.dart';
import 'package:chat_flutter/services/auth_service.dart';
import 'package:http/http.dart' as http;
class UsuariosService {

  Future<List<Usuario>> getUsuarios() async{

    try {

      final response = await http.get('${ Environment.apiUrl }/usuarios', 
        headers: {
          'Content-Type': 'application/json',
          'x-token': await AuthService.getToken()
        }
      );

      final usuariosResponse = usuariosListaResponseFromJson(response.body);
      return usuariosResponse.usuarios;


    }catch (e) {
      return [];
    }
  }


}