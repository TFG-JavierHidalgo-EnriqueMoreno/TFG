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

class GameEventPage extends StatefulWidget {
  final Map<String, int?> player1Points;
  final Map<String, int?> player2Points;
  final Map<String, int> gameResult;
  final dynamic player2;
  final Map<int, dynamic> players;

  const GameEventPage(
      {super.key,
      required this.players,
      required this.player1Points,
      required this.player2Points,
      required this.gameResult,
      required this.player2});

  @override
  GameEventPageState createState() {
    return GameEventPageState();
  }
}

class GameEventPageState extends State<GameEventPage> {
  // Create a global key that uniquely identifies the Form widget
  // and allows validation of the form.
  //
  // Note: This is a `GlobalKey<FormState>`,
  // not a GlobalKey<MyCustomFormState>.
  @override
  void initState() {
    super.initState();
    _players = widget.players;
    _player1Points = widget.player1Points;
    _player2Points = widget.player2Points;
    _gameResult = widget.gameResult;
    _player2 = widget.player2;
  }

  Map<String, int?> _player1Points = {};
  Map<String, int?> _player2Points = {};
  Map<String, int> _gameResult = {};
  dynamic _player2 = "";
  Map<int, dynamic> _players = {};
  final _formKey = GlobalKey<FormState>();

  bool _obscureText = true;
  String _password = "";

  @override
  Widget build(BuildContext context) {
    const appTitle = 'Registro del partido';

    return MaterialApp(
        title: appTitle,
        home: Scaffold(
          drawer: _getDrawer(context),
          appBar: AppBar(
            title: const Text(appTitle),
          ),
          body: Container(
            child: FutureBuilder<List<Map<int, String>>>(
              future: getRandomEvents(_player1Points, _players),
              builder: (BuildContext context,
                  AsyncSnapshot<List<Map<int, String>>> snapshot) {
                List<Widget> children;
                if (snapshot.hasData) {
                  children = <Widget>[
                    ListView.builder(
                        itemCount: snapshot.data!.length,
                        itemBuilder: ((context, index) {
                          return Text("${snapshot.data![index].values.first}");
                        }))
                  ];
                } else if (snapshot.hasError) {
                  children = <Widget>[
                    const Icon(
                      Icons.error_outline,
                      color: Colors.red,
                      size: 60,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 16),
                      child: Text('Error: ${snapshot.error}'),
                    ),
                  ];
                } else {
                  children = <Widget>[
                    Center(child: Text('Simulando partido...')),
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.only(top: 16.0),
                        child: CircularProgressIndicator(),
                      ),
                    ),
                  ];
                }
                return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: children);
              },
            ),
          ),
        ));
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
}
