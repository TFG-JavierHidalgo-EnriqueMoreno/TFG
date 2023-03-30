import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:my_app/entities/lineup.dart';
import 'package:my_app/screens/player_page.dart';
import 'package:my_app/screens/result_page.dart';
import 'package:my_app/screens/searching_page.dart';
import 'package:my_app/screens/select_page.dart';
import 'package:my_app/routes/custom_route.dart';
import 'package:my_app/services/firebase_service.dart';
import 'home_page.dart';

import 'package:my_app/entities/globals.dart' as globals;

class GameEventPage extends StatefulWidget {
  final Map<String, int?> player1Points;
  final dynamic player2;
  final Map<int, dynamic> players;
  final String selectedLineup;
  final String otherLineup;

  const GameEventPage(
      {super.key,
      required this.players,
      required this.player1Points,
      required this.selectedLineup,
      required this.otherLineup,
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
    _player2 = widget.player2;
    _selectedLineup = widget.selectedLineup;
    _otherLineup = widget.otherLineup;
  }

  Map<String, int?> _player1Points = {};
  dynamic _player2 = "";
  Map<int, dynamic> _players = {};
  String _selectedLineup = "";
  String _otherLineup = "";
  final _formKey = GlobalKey<FormState>();

  bool _obscureText = true;
  String _password = "";

  _updatePlayer1Points(Map<String, dynamic> data) {
    _player1Points.update("strength", (value) => data["strength"]);
    _player1Points.update("shooting", (value) => data["shooting"]);
    _player1Points.update("speed", (value) => data["speed"]);
    _player1Points.update("dribbling", (value) => data["dribbling"]);
    _player1Points.update("defense", (value) => data["defense"]);
    _player1Points.update("passing", (value) => data["passing"]);
    _player1Points.update("rating", (value) => data["rating"]);
  }

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
            child: FutureBuilder<Map<String, dynamic>>(
              future: getRandomEvents(_player1Points, _players),
              builder: (BuildContext context,
                  AsyncSnapshot<Map<String, dynamic>> snapshot) {
                List<Widget> children;
                if (snapshot.hasData) {
                  _updatePlayer1Points(snapshot.data!);
                  children = <Widget>[
                    ListView.builder(
                        itemCount: snapshot.data!["hisOrdenado"].length,
                        itemBuilder: ((context, index) {
                          return Text(
                              "${snapshot.data!["hisOrdenado"][index].values.first}");
                        })),
                    ElevatedButton(
                        onPressed: () {
                          endGame(context, _player1Points, _selectedLineup,
                              _otherLineup, _player2);
                          setState(() {});
                        },
                        child: Text('Finalizar partido'))
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

endGame(BuildContext context, Map<String, int?> player1Points,
    String selectedLineup, String otherLineup, dynamic player2) async {
  Lineup lineup = Lineup();
  lineup.newLineup(selectedLineup, otherLineup);
  Map<String, int?> player2Points = await getPlayer2Points();
  Timer(Duration(seconds: 3), (() async {
    Map<String, int> gameResult = calcResult(player1Points, player2Points);
    saveGame(gameResult["player1Goals"], gameResult["player2Goals"], lineup);
    calcElo(gameResult["player1Goals"]! > gameResult["player2Goals"]!
        ? true
        : false);
    Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => ResultPage(
              player1Points: player1Points,
              player2Points: player2Points,
              gameResult: gameResult,
              player2: player2,
            )));
  }));
}

calcResult(Map<String, int?> player1Points, Map<String, int?> player2Points) {
  int player1Goals = 0;
  int player2Goals = 0;
  player1Points.forEach((key, value) {
    if (value! > player2Points[key]!) {
      player1Goals++;
    } else if (value < player2Points[key]!) {
      player2Goals++;
    }
  });
  return {
    "player1Goals": player1Goals,
    "player2Goals": player2Goals,
  };
}
