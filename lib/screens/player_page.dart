import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:my_app/screens/select_page.dart';
import 'package:my_app/routes/custom_route.dart';
import 'package:my_app/services/firebase_service.dart';
import 'home_page.dart';

import 'package:my_app/entities/globals.dart' as globals;

class PlayerPage extends StatefulWidget {
  final String player1;
  final String player2;
  const PlayerPage({super.key, required this.player1, required this.player2});

  @override
  PlayerPageState createState() {
    return PlayerPageState();
  }
}

class PlayerPageState extends State<PlayerPage> {
  // Create a global key that uniquely identifies the Form widget
  // and allows validation of the form.
  //
  // Note: This is a `GlobalKey<FormState>`,
  // not a GlobalKey<MyCustomFormState>.

  @override
  void initState() {
    super.initState();
    _player1 = widget.player1;
    _player2 = widget.player2;
  }

  String _player1 = "";
  String _player2 = "";

  bool loaded = false;
  late Map<String, List<dynamic>> players;

  @override
  Widget build(BuildContext context) {
    const appTitle = 'Jugadores';
    const floatingbutton = null;

    return MaterialApp(
      title: appTitle,
      home: Scaffold(
          drawer: _getDrawer(context),
          appBar: AppBar(
            title: const Text(appTitle),
          ),
          body: Container(
            child: FutureBuilder<Map<String, List<dynamic>>>(
              future: getRandomPlayers(),
              builder: (BuildContext context,
                  AsyncSnapshot<Map<String, List<dynamic>>> snapshot) {
                List<Widget> children;
                if (snapshot.hasData) {
                  loaded = true;
                  players = snapshot.data!;
                  children = <Widget>[
                    Container(
                      height: 50.0,
                      decoration: const BoxDecoration(
                          border: Border(
                              bottom:
                                  BorderSide(color: Colors.black, width: 1.0))),
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.max,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: const <Widget>[
                            Text(
                              "Tus jugadores para este partido",
                            )
                          ]),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 16.0, left: 16.0),
                      child: Container(
                          child: Card(
                        child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: players["PT"]!.length,
                          itemBuilder: ((context, index) {
                            return Container(
                              child: Text('${players["PT"]![index]["name"]}'),
                            );
                          }),
                        ),
                      )),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 16.0, left: 16.0),
                      child: Container(
                          child: Card(
                        child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: players["DF"]!.length,
                          itemBuilder: ((context, index) {
                            return Container(
                              child: Text('${players["DF"]![index]["name"]}'),
                            );
                          }),
                        ),
                      )),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 16.0, left: 16.0),
                      child: Container(
                          child: Card(
                        child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: players["MC"]!.length,
                          itemBuilder: ((context, index) {
                            return Container(
                              child: Text('${players["MC"]![index]["name"]}'),
                            );
                          }),
                        ),
                      )),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 16.0, left: 16.0),
                      child: Container(
                          child: Card(
                        child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: players["DL"]!.length,
                          itemBuilder: ((context, index) {
                            return Container(
                              child: Text('${players["DL"]![index]["name"]}'),
                            );
                          }),
                        ),
                      )),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          FloatingActionButton.extended(
                            onPressed: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) =>
                                      SelectPage(p: players)));
                            },
                            backgroundColor: const Color(0xFF4CAF50),
                            label: const Text("Continuar"),
                          ),
                        ],
                      ),
                    )
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
                    Center(child: Text('Partida encontrada')),
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Text('${_player1} vs ${_player2}'),
                      ),
                    ),
                  ];
                }

                return SingleChildScrollView(
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: children),
                );
              },
            ),
          )),
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
  Navigator.of(context).pushReplacement(
    FadePageRoute(
      builder: (context) => const HomePage(),
    ),
  );
}
