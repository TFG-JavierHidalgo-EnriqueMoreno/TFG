import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:my_app/entities/EditData.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:my_app/entities/user.dart';
import 'dart:async';
import 'package:my_app/routes/custom_route.dart';
import 'home_page.dart';
import 'package:my_app/entities/globals.dart' as globals;

import 'login_page.dart';

class ResultPage extends StatelessWidget {
  const ResultPage({super.key});

  @override
  Widget build(BuildContext context) {
    const appTitle = 'Resultado del partido';

    return MaterialApp(
      title: appTitle,
      home: Scaffold(
        drawer: _getDrawer(context),
        appBar: AppBar(
          title: const Text(appTitle),
        ),
        body: const ResultPageForm(),
      ),
    );
  }
}

class ResultPageForm extends StatefulWidget {
  const ResultPageForm({super.key});

  @override
  ResultPageFormState createState() {
    return ResultPageFormState();
  }
}

class ResultPageFormState extends State<ResultPageForm> {
  // Create a global key that uniquely identifies the Form widget
  // and allows validation of the form.
  //
  // Note: This is a `GlobalKey<FormState>`,
  // not a GlobalKey<MyCustomFormState>.
  final _formKey = GlobalKey<FormState>();

  bool _obscureText = true;
  String _password = "";

  @override
  Widget build(BuildContext context) {
    return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: const Icon(
                      Icons.account_circle,
                      size: 48.0,
                    ),
                  ),
                  const Text(
                    "3",
                    style: TextStyle(
                      fontSize: 50.0,
                    ),
                  ),
                  const Text(
                    "-",
                    style: TextStyle(
                      fontSize: 50.0,
                    ),
                  ),
                  const Text(
                    "3",
                    style: TextStyle(
                      fontSize: 50.0,
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: const Icon(
                      Icons.account_circle,
                      size: 48.0,
                    ),
                  ),
                ]),
          ),
          const Padding(
            padding: EdgeInsets.all(10.0),
            child: Center(
              child: Text(
                "Resultado",
                style: TextStyle(
                  fontSize: 35.0,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  const Text(
                    "100",
                  ),
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 100.0),
                    child: const Text("Ataque"),
                  ),
                  const Text("100")
                ]),
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  const Text("200"),
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 98.0),
                    child: const Text("Técnico"),
                  ),
                  const Text("200")
                ]),
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  const Text("300"),
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 100.0),
                    child: const Text("Táctico"),
                  ),
                  const Text("300")
                ]),
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  const Text("400"),
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 97.0),
                    child: const Text("Defensa"),
                  ),
                  const Text("400")
                ]),
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  const Text("400"),
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 88.0),
                    child: const Text("Creatividad"),
                  ),
                  const Text("400")
                ]),
          ),
          const Padding(
            padding: EdgeInsets.all(10.0),
            child: Center(
              child: Text(
                "Vista general de atributos",
                style: TextStyle(
                  fontSize: 25.0,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: const <Widget>[
                  Text("Grafica"),
                ]),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: const <Widget>[
                  Padding(
                    padding: EdgeInsets.only(right: 10),
                    child: ElevatedButton(
                        onPressed: getUser, child: Text("Volver a jugar")),
                  ),
                  ElevatedButton(onPressed: getUser, child: Text("Inicio"))
                ]),
          )
        ]);
  }
}

Widget _getDrawer(BuildContext context) {
  var accountEmail = const Text("EMAIL");
  var accountName = const Text("USUARIO");
  var accountPicture = const Icon(FontAwesomeIcons.userLarge);
  return Drawer(
    child: ListView(
      children: <Widget>[
        UserAccountsDrawerHeader(
            accountName: accountName,
            accountEmail: accountEmail,
            currentAccountPicture: accountPicture),
        ListTile(
            title: const Text("Inicio"),
            leading: const Icon(Icons.home),
            onTap: () => showHome(context)),
        ListTile(
            title: const Text("Jugar Partido"),
            leading: const Icon(Icons.play_arrow),
            onTap: () => showHome(context)),
        ListTile(
            title: const Text("Historial"),
            leading: const Icon(Icons.history),
            onTap: () => showHome(context)),
        ListTile(
            title: const Text("Cerrar Sesion"),
            leading: const Icon(Icons.logout),
            onTap: () => logout(context)),
      ],
    ),
  );
}

showHome(BuildContext context) {
  Navigator.of(context).pushReplacement(
    FadePageRoute(
      builder: (context) => const HomePage(),
    ),
  );
}

logout(BuildContext context) {
  globals.isLoggedIn = false;
  debugPrint('logged in: ${globals.isLoggedIn}');
  Navigator.of(context).pushReplacement(
    FadePageRoute(
      builder: (context) => const LoginScreen(),
    ),
  );
}

getUser() {
  if (globals.isLoggedIn) {
    return "ESTA EN TRUE";
  } else {
    return "ESTA EN FALSE";
  }
}

deleteUser(BuildContext context) {
  showDialog<String>(
    context: context,
    barrierColor: Colors.transparent,
    builder: (BuildContext context) => AlertDialog(
      title: const Text('Eliminar usuario'),
      content: const Text('Usuario eliminado'),
      actions: <Widget>[
        TextButton(
          onPressed: () => afterDeleteUser(context),
          child: const Text('Confirmar'),
        ),
      ],
    ),
  ).then((val) {
    afterDeleteUser(context);
  });
}

afterDeleteUser(BuildContext context) {
  globals.isLoggedIn = false;
  debugPrint('logged in: ${globals.isLoggedIn}');
  Navigator.of(context).pushReplacement(
    FadePageRoute(
      builder: (context) => const LoginScreen(),
    ),
  );
}

changeButton(
    int key, Map<int, bool> selected, BuildContext context, bool changed) {
  Navigator.pop(context, 'Confirmar');
  changed = true;
}

select(int key, Map<int, bool> selected, BuildContext context, bool changed) {
  showDialog<String>(
    context: context,
    barrierColor: Colors.transparent,
    builder: (BuildContext context) => AlertDialog(
      title: const Text('Eliminar usuario'),
      content: const Text('Usuario eliminado'),
      actions: <Widget>[
        TextButton(
          onPressed: () => changeButton(key, selected, context, changed),
          child: const Text('Confirmar'),
        ),
      ],
    ),
  );
}
