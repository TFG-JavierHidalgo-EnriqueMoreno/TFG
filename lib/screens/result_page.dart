import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:my_app/screens/player_page.dart';
import 'package:my_app/screens/select_page.dart';
import 'package:my_app/routes/custom_route.dart';
import 'home_page.dart';

import 'package:my_app/entities/globals.dart' as globals;

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
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(right: 10),
                    child: ElevatedButton(
                        onPressed: () => playAgain(context),
                        child: Text("Volver a jugar")),
                  ),
                  ElevatedButton(
                      onPressed: () {
                        setState(() {});
                        goToHome(context);
                      },
                      child: Text("Inicio"))
                ]),
          )
        ]);
  }
}

Widget _getDrawer(BuildContext context) {
  var accountEmail = Text(globals.userLoggedIn.email);
  var accountName = Text(globals.userLoggedIn.username);
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
            title: const Text("Editar Perfil"),
            leading: const Icon(Icons.edit),
            onTap: () => showProfile(context)),
        ListTile(
            title: const Text("Jugar Partido"),
            leading: const Icon(Icons.play_arrow),
            onTap: () => playGame(context)),
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

goToHome(BuildContext context) {
  Navigator.of(context).pushReplacement(
    FadePageRoute(
      builder: (context) => const HomePage(),
    ),
  );
}

playAgain(BuildContext context) {
  Navigator.of(context).pushReplacement(
    FadePageRoute(
      builder: (context) => const PlayerPage(),
    ),
  );
}
