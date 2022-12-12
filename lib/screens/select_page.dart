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

List<String> lista = ["pepe", "manuel", "quique", "juan"];

class SelectPage extends StatelessWidget {
  const SelectPage({super.key});

  @override
  Widget build(BuildContext context) {
    const appTitle = 'Seleccion de jugadores';

    return MaterialApp(
      title: appTitle,
      home: Scaffold(
        drawer: _getDrawer(context),
        appBar: AppBar(
          title: const Text(appTitle),
        ),
        body: const SelectPageForm(),
      ),
    );
  }
}

class SelectPageForm extends StatefulWidget {
  const SelectPageForm({super.key});

  @override
  SelectPageFormState createState() {
    return SelectPageFormState();
  }
}

class SelectPageFormState extends State<SelectPageForm> {
  // Create a global key that uniquely identifies the Form widget
  // and allows validation of the form.
  //
  // Note: This is a `GlobalKey<FormState>`,
  // not a GlobalKey<MyCustomFormState>.
  final _formKey = GlobalKey<FormState>();

  bool _obscureText = true;
  String _password = "";

  void _toggle() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Build a Form widget using the _formKey created above.

    return Scaffold(
      body: Stack(children: <Widget>[
        Row(
          children: [
            ElevatedButton(
                onPressed: () => showDialog<String>(
                      context: context,
                      builder: (BuildContext context) => AlertDialog(
                        title: const Text('Selecciona jugador'),
                        actions: <Widget>[
                          SizedBox(
                            height: 500,
                            width: 500,
                            child: ListView.builder(
                                itemCount: lista.length,
                                itemBuilder: (context, index) {
                                  return Card(
                                    child: Text(lista[index]),
                                  );
                                }),
                          ),
                        ],
                      ),
                    ),
                child: const Icon(Icons.add)),
            ElevatedButton(
                onPressed: () => showDialog<String>(
                      context: context,
                      builder: (BuildContext context) => AlertDialog(
                        title: const Text('Selecciona jugador'),
                        actions: <Widget>[
                          SizedBox(
                            height: 500,
                            width: 500,
                            child: ListView.builder(
                                itemCount: lista.length,
                                itemBuilder: (context, index) {
                                  return Card(
                                    child: Text(lista[index]),
                                  );
                                }),
                          ),
                        ],
                      ),
                    ),
                child: const Icon(Icons.add)),
            ElevatedButton(
                onPressed: () => showDialog<String>(
                      context: context,
                      builder: (BuildContext context) => AlertDialog(
                        title: const Text('Selecciona jugador'),
                        actions: <Widget>[
                          SizedBox(
                            height: 500,
                            width: 500,
                            child: ListView.builder(
                                itemCount: lista.length,
                                itemBuilder: (context, index) {
                                  return Card(
                                    child: Text(lista[index]),
                                  );
                                }),
                          ),
                        ],
                      ),
                    ),
                child: const Icon(Icons.add)),
          ],
        ),
      ]),
    );

    // return Scaffold(
    //     body: Container(
    //   child: ElevatedButton(
    //     onPressed: () => showDialog<String>(
    //       context: context,
    //       builder: (BuildContext context) => AlertDialog(
    //         title: const Text('Selecciona jugador'),
    //         actions: <Widget>[
    //           SizedBox(
    //             height: 500,
    //             width: 500,
    //             child: ListView.builder(
    //                 itemCount: lista.length,
    //                 itemBuilder: (context, index) {
    //                   return Card(
    //                     child: Text(lista[index]),
    //                   );
    //                 }),
    //           )

    //           // ListView.builder(
    //           //     itemCount: lista.length,
    //           //     itemBuilder: (context, index) {
    //           //       return Card(child: Text(lista[index]));
    //           //     }),
    //         ],
    //       ),
    //     ),
    //     child: const Icon(Icons.add),
    //   ),
    // ));
  }
}

Widget _getDrawer(BuildContext context) {
  var accountEmail = Text("EMAIL");
  var accountName = Text("USUARIO");
  var accountPicture = Icon(FontAwesomeIcons.userLarge);
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
