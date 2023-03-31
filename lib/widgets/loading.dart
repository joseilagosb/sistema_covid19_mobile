import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class Loading extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
        color: Colors.yellowAccent,
        child:
            Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
          Container(
              child: SizedBox(
            height: 50,
            width: 50,
            child: CircularProgressIndicator(),
          )),
          SizedBox(width: 10),
          Container(child: Text('Cargando'))
        ]));
  }
}
