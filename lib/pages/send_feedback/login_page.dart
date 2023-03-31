import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();

  void initState() {
    super.initState();
  }

  bool _validateInput() {
    return false;
  }

  void _authenticate(BuildContext context) {
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text(
          "Abre tu cuenta",
          style: Theme.of(context).textTheme.titleLarge!.copyWith(
                fontSize: 16.0,
                fontWeight: FontWeight.w800,
              ),
        ),
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.black),
        leading: Tooltip(
          message: "Salir de la pantalla",
          child: IconButton(
            splashColor: Colors.grey,
            icon: Icon(Icons.close),
            onPressed: () => Navigator.of(context).maybePop(),
          ),
        ),
      ),
      body: Container(
        padding: const EdgeInsets.only(top: 40.0, left: 20.0, right: 20.0),
        height: double.infinity,
        child: ListView(
          children: <Widget>[
            const SizedBox(height: 10.0),
            const Center(
              child: FlutterLogo(
                size: 100.0,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Accede a los paneles de retroalimentación de la app para aportar según tu propia experiencia en las calles.',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 10),
            const Padding(
              padding: EdgeInsets.all(10),
              child: TextField(
                decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Tu correo electrónico',
                    hintText: 'Enter valid mail id as abc@gmail.com'),
              ),
            ),
            const Padding(
              padding: EdgeInsets.all(10),
              child: TextField(
                obscureText: true,
                decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Tu contraseña',
                    hintText: 'Enter your secure password'),
              ),
            ),
            Container(
              height: 50,
              width: 250,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.background,
                borderRadius: BorderRadius.circular(20),
              ),
              child: TextButton(
                onPressed: () {
                  _validateInput();
                  _authenticate(context);
                },
                child: Text(
                  'Conectarme',
                  style: Theme.of(context)
                      .textTheme
                      .titleLarge!
                      .copyWith(fontWeight: FontWeight.w800),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
