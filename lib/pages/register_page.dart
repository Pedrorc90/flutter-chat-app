import 'package:chat_flutter/services/socket_service.dart';
import 'package:flutter/material.dart';
import 'package:chat_flutter/helpers/mostrar_alerta.dart';
import 'package:chat_flutter/services/auth_service.dart';
import 'package:chat_flutter/widgets/btn_azul.dart';
import 'package:chat_flutter/widgets/custom_input.dart';
import 'package:chat_flutter/widgets/labels.dart';
import 'package:chat_flutter/widgets/logo.dart';
import 'package:provider/provider.dart';

class RegisterPage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffF2F2F2),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Container(
            height: MediaQuery.of(context).size.height,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Logo(titulo: 'Registro'),
                _Form(),
                Labels(ruta: 'login', titulo: '¿Ya tienes una cuenta?', subtitulo: 'Ingresa con tu cuenta!',),
                Text('Términos y condiciones de uso', style: TextStyle(fontWeight: FontWeight.w300))
              ]
            ),
          ),
        ),
      )
   );
  }
}




class _Form extends StatefulWidget {
  const _Form({ Key? key }) : super(key: key);

  @override
  __FormState createState() => __FormState();
}

class __FormState extends State<_Form> {

  final nameCtrl = TextEditingController();
  final emailCtrl = TextEditingController();
  final passCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);
    final socketService = Provider.of<SocketService>(context);
    return Container(
      margin: EdgeInsets.only(top: 40),
      padding: EdgeInsets.symmetric(horizontal: 50),
      child: Column(
        children: [

          CustomInput(
            icon: Icons.perm_identity,
            placeholder: 'Nombre',
            keyboardType: TextInputType.text,
            textController: nameCtrl,
          ),

          CustomInput(
            icon: Icons.mail_outline,
            placeholder: 'Correo',
            keyboardType: TextInputType.emailAddress,
            textController: emailCtrl,
          ),
          CustomInput(
            icon: Icons.lock_outline,
            placeholder: 'Contraseña',
          
            textController: passCtrl,
            isPassword: true,
          ),
          BotonAzul(text: 'Crear Cuenta', 
          onPressed: authService.autenticando ? ( ) { } : () async {

              FocusScope.of(context).unfocus();
            
              final registerOk = await authService.register(nameCtrl.text.trim(),emailCtrl.text.trim(), passCtrl.text.trim());

              if ( registerOk == true ) {
                socketService.connect();
                Navigator.pushReplacementNamed(context, 'usuarios');
              } else {
                mostrarAlerta(context, 'Registro Incorrecto', registerOk);
              }


          },)
        ],
      )
    );
  }
}


