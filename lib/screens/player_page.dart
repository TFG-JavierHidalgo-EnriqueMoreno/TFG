import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:my_app/screens/select_page.dart';
import 'package:my_app/routes/custom_route.dart';
import 'package:my_app/services/firebase_service.dart';
import 'package:timer_count_down/timer_controller.dart';
import 'package:timer_count_down/timer_count_down.dart';
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

  @override
  void dispose() {
    super.dispose();
    _controller.pause();
  }

  final CountdownController _controller =
      new CountdownController(autoStart: true);
  String _player1 = "";
  String _player2 = "";

  bool loaded = false;
  late Map<String, List<dynamic>> players;
  bool x2 = false;

  int timer = 60;

  confirmX2(BuildContext context) {
    globals.userLoggedIn.tokens = globals.userLoggedIn.getTokens - 1;
    updateUserTokens();
    x2 = true;
    Navigator.pop(context);
  }

  confirmReload(BuildContext context) async {
    globals.userLoggedIn.tokens = globals.userLoggedIn.getTokens - 1;
    updateUserTokens();
    Map<String, List<dynamic>> newPlayers = await getRandomPlayers();
    players = newPlayers;
    Navigator.pop(context);
    setState(() {});
  }

  powerUpx2(BuildContext context) {
    showDialog(
        context: context,
        builder: (BuildContext context) => AlertDialog(
                title: const Text('Descripción del PowerUp'),
                actions: <Widget>[
                  Column(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(left: 8.0, bottom: 8.0),
                        child: Text(
                            "Este PowerUp doblará los puntos que consigas o pierdas en este partido."),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "El coste de esta acción es de 1 ",
                            style: TextStyle(fontWeight: FontWeight.w600),
                          ),
                          Icon(Icons.diamond_outlined),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("Tienes ${globals.userLoggedIn.tokens}"),
                          Icon(Icons.diamond_outlined),
                        ],
                      ),
                      Row(
                        children: [
                          TextButton(
                            onPressed: () {
                              confirmX2(context);
                              setState(() {});
                            },
                            child: const Text('Aceptar'),
                          ),
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text('Cancelar'),
                          ),
                        ],
                      ),
                    ],
                  )
                ]));
  }

  powerUpReload(BuildContext context) {
    showDialog(
        context: context,
        builder: (BuildContext context) => AlertDialog(
                title: const Text('Descripción del PowerUp'),
                actions: <Widget>[
                  Column(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(left: 8.0, bottom: 8.0),
                        child: Text(
                            "Este PowerUp generará un set de jugadores aleatorio completamente nuevo."),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "El coste de esta acción es de 1",
                            style: TextStyle(fontWeight: FontWeight.w600),
                          ),
                          Icon(Icons.diamond_outlined),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("Tienes ${globals.userLoggedIn.tokens}"),
                          Icon(Icons.diamond_outlined),
                        ],
                      ),
                      Row(
                        children: [
                          TextButton(
                            onPressed: () => confirmReload(context),
                            child: const Text('Aceptar'),
                          ),
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text('Cancelar'),
                          ),
                        ],
                      ),
                    ],
                  )
                ]));
  }

  String _printDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return "$twoDigitMinutes:$twoDigitSeconds";
  }

  @override
  Widget build(BuildContext context) {
    const appTitle = 'Tus jugadores para este partido';
    const floatingbutton = null;

    return MaterialApp(
      title: appTitle,
      home: Scaffold(
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
                  if (loaded != true) {
                    players = snapshot.data!;
                  }
                  loaded = true;
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
                          children: <Widget>[
                            Countdown(
                              seconds: timer,
                              build: (BuildContext context, double time) {
                                timer = time.round();
                                return Text(
                                    "Tiempo restante de partido: ${_printDuration(Duration(seconds: time.round()))}");
                              },
                              interval: Duration(milliseconds: 100),
                              onFinished: () {
                                print('Timer is done!');
                              },
                            ),
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
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Visibility(
                            visible: globals.userLoggedIn.tokens >= 1,
                            child: Row(
                              children: [
                                FloatingActionButton.extended(
                                  heroTag: "btn1",
                                  onPressed: () {
                                    powerUpx2(context);
                                  },
                                  backgroundColor:
                                      Color.fromARGB(255, 42, 89, 218),
                                  label: const Text(
                                    "x2",
                                    style: TextStyle(fontSize: 16),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 8.0),
                                  child: FloatingActionButton.extended(
                                    heroTag: "btn2",
                                    onPressed: () {
                                      powerUpReload(context);
                                    },
                                    backgroundColor:
                                        Color.fromARGB(255, 42, 89, 218),
                                    label: const Icon(Icons.replay),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              FloatingActionButton.extended(
                                heroTag: "btn3",
                                onPressed: () {
                                  Navigator.of(context).pushReplacement(
                                      MaterialPageRoute(
                                          builder: (context) => SelectPage(
                                              p: players,
                                              x2: x2,
                                              timer: timer)));
                                },
                                backgroundColor: const Color(0xFF4CAF50),
                                label: const Text("Continuar"),
                              ),
                            ],
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

goToHome(BuildContext context) {
  Navigator.of(context).pushReplacement(
    FadePageRoute(
      builder: (context) => const HomePage(),
    ),
  );
}
