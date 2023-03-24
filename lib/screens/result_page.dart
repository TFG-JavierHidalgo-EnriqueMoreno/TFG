import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:my_app/screens/player_page.dart';
import 'package:my_app/screens/searching_page.dart';
import 'package:my_app/screens/select_page.dart';
import 'package:my_app/routes/custom_route.dart';
import 'package:my_app/services/firebase_service.dart';
import 'home_page.dart';

import 'package:my_app/entities/globals.dart' as globals;

class ResultPage extends StatefulWidget {
  final Map<String, int?> player1Points;
  final Map<String, int?> player2Points;
  final Map<String, int> gameResult;
  final dynamic player2;

  const ResultPage(
      {super.key,
      required this.player1Points,
      required this.player2Points,
      required this.gameResult,
      required this.player2});

  @override
  ResultPageState createState() {
    return ResultPageState();
  }
}

class ResultPageState extends State<ResultPage> {
  // Create a global key that uniquely identifies the Form widget
  // and allows validation of the form.
  //
  // Note: This is a `GlobalKey<FormState>`,
  // not a GlobalKey<MyCustomFormState>.
  @override
  void initState() {
    super.initState();
    _player1Points = widget.player1Points;
    _player2Points = widget.player2Points;
    _gameResult = widget.gameResult;
    _player2 = widget.player2;
    inspect(_player2);
  }

  Map<String, int?> _player1Points = {};
  Map<String, int?> _player2Points = {};
  Map<String, int> _gameResult = {};
  dynamic _player2 = "";

  final _formKey = GlobalKey<FormState>();

  bool _obscureText = true;
  String _password = "";

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
          body: Column(
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
                          child: Column(
                            children: [
                              const Icon(
                                Icons.account_circle,
                                size: 48.0,
                              ),
                              Text("${globals.userLoggedIn.getUsername}"),
                            ],
                          ),
                        ),
                        Text(
                          _gameResult["player1Goals"].toString(),
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
                        Text(
                          _gameResult["player2Goals"].toString(),
                          style: TextStyle(
                            fontSize: 50.0,
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.symmetric(horizontal: 20.0),
                          child: Column(
                            children: [
                              const Icon(
                                Icons.account_circle,
                                size: 48.0,
                              ),
                              //Text("${_player2["username"]}}"),
                            ],
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
                        Text(
                          _player1Points["shooting"].toString(),
                        ),
                        Container(
                          margin: const EdgeInsets.symmetric(horizontal: 110.0),
                          child: const Text("Tiro"),
                        ),
                        Text(_player2Points["shooting"].toString())
                      ]),
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          _player1Points["speed"].toString(),
                        ),
                        Container(
                          margin: const EdgeInsets.symmetric(horizontal: 92.0),
                          child: const Text("Velocidad"),
                        ),
                        Text(_player2Points["speed"].toString())
                      ]),
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          _player1Points["strength"].toString(),
                        ),
                        Container(
                          margin: const EdgeInsets.symmetric(horizontal: 102.0),
                          child: const Text("Fuerza"),
                        ),
                        Text(_player2Points["strength"].toString())
                      ]),
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          _player1Points["defense"].toString(),
                        ),
                        Container(
                          margin: const EdgeInsets.symmetric(horizontal: 97.0),
                          child: const Text("Defensa"),
                        ),
                        Text(_player2Points["defense"].toString())
                      ]),
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          _player1Points["dribbling"].toString(),
                        ),
                        Container(
                          margin: const EdgeInsets.symmetric(horizontal: 97.0),
                          child: const Text("Regates"),
                        ),
                        Text(_player2Points["dribbling"].toString())
                      ]),
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          _player1Points["passing"].toString(),
                        ),
                        Container(
                          margin: const EdgeInsets.symmetric(horizontal: 103.0),
                          child: const Text("Pases"),
                        ),
                        Text(_player2Points["passing"].toString())
                      ]),
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          _player1Points["rating"].toString(),
                        ),
                        Container(
                          margin: const EdgeInsets.symmetric(horizontal: 103.0),
                          child: const Text("Media"),
                        ),
                        Text(_player2Points["rating"].toString())
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
              ])),
    );
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
  resetPlayerState();
  Navigator.of(context).pushReplacement(
    FadePageRoute(
      builder: (context) => const HomePage(),
    ),
  );
}

playAgain(BuildContext context) {
  searchGame();
  Navigator.of(context).pushReplacement(
    FadePageRoute(
      builder: (context) => const SearchingPage(),
    ),
  );
}
