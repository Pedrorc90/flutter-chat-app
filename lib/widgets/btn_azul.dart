import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class BotonAzul extends StatelessWidget {

  final String text;
  final Function onPressed;

  const BotonAzul({Key? key, required this.text, required this.onPressed}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        child: Container(
          width: double.infinity,
          height: 55,
          child: Center(
              child: Text(this.text,
                  style: TextStyle(color: Colors.white, fontSize: 18))),
          color: Colors.blue,
        ),
        onPressed: () {
            this.onPressed();
        }
                  
        );
  }
}
