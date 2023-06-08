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
    _controller.pause();
    super.dispose();
  }

  final CountdownController _controller =
      new CountdownController(autoStart: true);
  String _player1 = "";
  String _player2 = "";

  bool loaded = false;
  late Map<String, List<dynamic>> players;
  bool x2 = false;

  int timer = 300;

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

    return MaterialApp(
      title: appTitle,
      home: Scaffold(
          appBar: AppBar(
            backgroundColor: const Color(0xFF4CAF50),
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
                                if (timer <= 60) {
                                  return Text(
                                      "Tiempo restante de partido: ${_printDuration(Duration(seconds: time.round()))}",
                                      style: TextStyle(
                                          color: Colors.orange, fontSize: 16));
                                } else if (timer <= 10) {
                                  return Text(
                                      "Tiempo restante de partido: ${_printDuration(Duration(seconds: time.round()))}",
                                      style: TextStyle(
                                          color: Colors.red, fontSize: 16));
                                } else {
                                  return Text(
                                    "Tiempo restante de partido: ${_printDuration(Duration(seconds: time.round()))}",
                                    style: TextStyle(
                                        color: Colors.green.shade800,
                                        fontSize: 16),
                                  );
                                }
                              },
                              interval: Duration(milliseconds: 100),
                              onFinished: () {
                                deleteGame();
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      duration: Duration(seconds: 3),
                                      backgroundColor:
                                          Color.fromARGB(255, 209, 67, 67),
                                      content: Text(
                                          'Ningun jugador ha completado el partido. Partida cancelada')),
                                );
                                goToHome(context);
                              },
                            ),
                          ]),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 16.0, left: 16.0),
                      child: Text("Porteros",
                          style: TextStyle(
                              fontSize: 24, fontWeight: FontWeight.w600)),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          top: 16.0, left: 16.0, right: 16.0),
                      child: Container(
                        height: 400,
                        child: ListView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: players["PT"]!.length,
                          itemBuilder: ((context, index) {
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 16.0),
                              child: Container(
                                child: Container(
                                  constraints: BoxConstraints(
                                    maxHeight: double.infinity,
                                  ),
                                  decoration: BoxDecoration(
                                      color: players["PT"]![index]
                                                  ["category"] ==
                                              'Gold'
                                          ? Color.fromARGB(255, 240, 203, 82)
                                          : players["PT"]![index]["category"] ==
                                                  'Silver'
                                              ? const Color(0xffc0c0c0)
                                              : Color.fromARGB(
                                                  255, 179, 107, 36),
                                      border: Border.all(
                                          color: Colors.black, width: 1.0)),
                                  child: Column(
                                    children: <Widget>[
                                      Row(
                                        children: [
                                          Padding(
                                            padding: EdgeInsets.all(8.0),
                                            child: Icon(Icons.account_circle,
                                                size: 20),
                                          ),
                                          Padding(
                                            padding: EdgeInsets.all(8.0),
                                            child: Text(
                                                players["PT"]![index]["name"],
                                                style: TextStyle(fontSize: 20)),
                                          ),
                                          Padding(
                                            padding: EdgeInsets.all(8.0),
                                            child: Text(
                                                players["PT"]![index]["price"]
                                                        .toString() +
                                                    "M",
                                                style: TextStyle(fontSize: 20)),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          Padding(
                                            padding: EdgeInsets.all(8.0),
                                            child: CircleAvatar(
                                              radius: 11.5,
                                              backgroundColor:
                                                  players["PT"]![index]
                                                              ["shooting"] <
                                                          35
                                                      ? Colors.red
                                                      : players["PT"]![index]
                                                                  ["shooting"] <
                                                              70
                                                          ? Colors.yellow
                                                          : Colors.green,
                                              child: Center(
                                                child: Text(
                                                    players["PT"]![index]
                                                            ["shooting"]
                                                        .toString(),
                                                    style: const TextStyle(
                                                        fontSize: 13,
                                                        color: Colors.black)),
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding: EdgeInsets.all(8.0),
                                            child: CircleAvatar(
                                              radius: 11.5,
                                              backgroundColor:
                                                  players["PT"]![index]
                                                              ["speed"] <
                                                          35
                                                      ? Colors.red
                                                      : players["PT"]![index]
                                                                  ["speed"] <
                                                              70
                                                          ? Colors.yellow
                                                          : Colors.green,
                                              child: Center(
                                                child: Text(
                                                    players["PT"]![index]
                                                            ["speed"]
                                                        .toString(),
                                                    style: const TextStyle(
                                                        fontSize: 13,
                                                        color: Colors.black)),
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding: EdgeInsets.all(8.0),
                                            child: CircleAvatar(
                                              radius: 11.5,
                                              backgroundColor:
                                                  players["PT"]![index]
                                                              ["strength"] <
                                                          35
                                                      ? Colors.red
                                                      : players["PT"]![index]
                                                                  ["strength"] <
                                                              70
                                                          ? Colors.yellow
                                                          : Colors.green,
                                              child: Center(
                                                child: Text(
                                                    players["PT"]![index]
                                                            ["strength"]
                                                        .toString(),
                                                    style: const TextStyle(
                                                        fontSize: 13,
                                                        color: Colors.black)),
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding: EdgeInsets.all(8.0),
                                            child: CircleAvatar(
                                              radius: 11.5,
                                              backgroundColor:
                                                  players["PT"]![index]
                                                              ["passing"] <
                                                          35
                                                      ? Colors.red
                                                      : players["PT"]![index]
                                                                  ["passing"] <
                                                              70
                                                          ? Colors.yellow
                                                          : Colors.green,
                                              child: Center(
                                                child: Text(
                                                    players["PT"]![index]
                                                            ["passing"]
                                                        .toString(),
                                                    style: const TextStyle(
                                                        fontSize: 13,
                                                        color: Colors.black)),
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding: EdgeInsets.all(8.0),
                                            child: CircleAvatar(
                                              radius: 11.5,
                                              backgroundColor: players["PT"]![
                                                          index]["dribbling"] <
                                                      35
                                                  ? Colors.red
                                                  : players["PT"]![index]
                                                              ["dribbling"] <
                                                          70
                                                      ? Colors.yellow
                                                      : Colors.green,
                                              child: Center(
                                                child: Text(
                                                    players["PT"]![index]
                                                            ["dribbling"]
                                                        .toString(),
                                                    style: const TextStyle(
                                                        fontSize: 13,
                                                        color: Colors.black)),
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding: EdgeInsets.all(8.0),
                                            child: CircleAvatar(
                                              radius: 11.5,
                                              backgroundColor:
                                                  players["PT"]![index]
                                                              ["defense"] <
                                                          35
                                                      ? Colors.red
                                                      : players["PT"]![index]
                                                                  ["defense"] <
                                                              70
                                                          ? Colors.yellow
                                                          : Colors.green,
                                              child: Center(
                                                child: Text(
                                                    players["PT"]![index]
                                                            ["defense"]
                                                        .toString(),
                                                    style: const TextStyle(
                                                        fontSize: 13,
                                                        color: Colors.black)),
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding: EdgeInsets.all(8.0),
                                            child: CircleAvatar(
                                              radius: 11.5,
                                              backgroundColor:
                                                  players["PT"]![index]
                                                              ["rating"] <
                                                          35
                                                      ? Colors.red
                                                      : players["PT"]![index]
                                                                  ["rating"] <
                                                              70
                                                          ? Colors.yellow
                                                          : Colors.green,
                                              child: Center(
                                                child: Text(
                                                    players["PT"]![index]
                                                            ["rating"]
                                                        .toString(),
                                                    style: const TextStyle(
                                                        fontSize: 13,
                                                        color: Colors.black)),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        children: const [
                                          Padding(
                                            padding: EdgeInsets.all(8.0),
                                            child: Text("SHO",
                                                style: TextStyle(
                                                    fontSize: 12,
                                                    color: Colors.black)),
                                          ),
                                          Padding(
                                            padding: EdgeInsets.all(8.0),
                                            child: Text("PAC",
                                                style: TextStyle(
                                                    fontSize: 12,
                                                    color: Colors.black)),
                                          ),
                                          Padding(
                                            padding: EdgeInsets.all(8.0),
                                            child: Text("PHY",
                                                style: TextStyle(
                                                    fontSize: 12,
                                                    color: Colors.black)),
                                          ),
                                          Padding(
                                            padding: EdgeInsets.all(8.0),
                                            child: Text("PAS",
                                                style: TextStyle(
                                                    fontSize: 12,
                                                    color: Colors.black)),
                                          ),
                                          Padding(
                                            padding: EdgeInsets.all(8.0),
                                            child: Text("DRI",
                                                style: TextStyle(
                                                    fontSize: 12,
                                                    color: Colors.black)),
                                          ),
                                          Padding(
                                            padding: EdgeInsets.all(8.0),
                                            child: Text("DEF",
                                                style: TextStyle(
                                                    fontSize: 12,
                                                    color: Colors.black)),
                                          ),
                                          Padding(
                                            padding: EdgeInsets.all(8.0),
                                            child: Text("TOT",
                                                style: TextStyle(
                                                    fontSize: 12,
                                                    color: Colors.black)),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          }),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 16.0),
                      child: Text("Defensas",
                          style: TextStyle(
                              fontSize: 24, fontWeight: FontWeight.w600)),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          top: 16.0, left: 16.0, right: 16),
                      child: Container(
                        height: 1375,
                        child: ListView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: players["DF"]!.length,
                          itemBuilder: ((context, index) {
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 16.0),
                              child: Container(
                                child: Container(
                                  constraints: BoxConstraints(
                                    maxHeight: double.infinity,
                                  ),
                                  decoration: BoxDecoration(
                                      color: players["DF"]![index]
                                                  ["category"] ==
                                              'Gold'
                                          ? Color.fromARGB(255, 240, 203, 82)
                                          : players["DF"]![index]["category"] ==
                                                  'Silver'
                                              ? const Color(0xffc0c0c0)
                                              : Color.fromARGB(
                                                  255, 179, 107, 36),
                                      border: Border.all(
                                          color: Colors.black, width: 1.0)),
                                  child: Column(
                                    children: <Widget>[
                                      Row(
                                        children: [
                                          Padding(
                                            padding: EdgeInsets.all(8.0),
                                            child: Icon(Icons.account_circle,
                                                size: 20),
                                          ),
                                          Padding(
                                            padding: EdgeInsets.all(8.0),
                                            child: Text(
                                                players["DF"]![index]["name"],
                                                style: TextStyle(fontSize: 20)),
                                          ),
                                          Padding(
                                            padding: EdgeInsets.all(8.0),
                                            child: Text(
                                                players["DF"]![index]["price"]
                                                        .toString() +
                                                    "M",
                                                style: TextStyle(fontSize: 20)),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          Padding(
                                            padding: EdgeInsets.all(8.0),
                                            child: CircleAvatar(
                                              radius: 11.5,
                                              backgroundColor:
                                                  players["DF"]![index]
                                                              ["shooting"] <
                                                          35
                                                      ? Colors.red
                                                      : players["DF"]![index]
                                                                  ["shooting"] <
                                                              70
                                                          ? Colors.yellow
                                                          : Colors.green,
                                              child: Center(
                                                child: Text(
                                                    players["DF"]![index]
                                                            ["shooting"]
                                                        .toString(),
                                                    style: const TextStyle(
                                                        fontSize: 13,
                                                        color: Colors.black)),
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding: EdgeInsets.all(8.0),
                                            child: CircleAvatar(
                                              radius: 11.5,
                                              backgroundColor:
                                                  players["DF"]![index]
                                                              ["speed"] <
                                                          35
                                                      ? Colors.red
                                                      : players["DF"]![index]
                                                                  ["speed"] <
                                                              70
                                                          ? Colors.yellow
                                                          : Colors.green,
                                              child: Center(
                                                child: Text(
                                                    players["DF"]![index]
                                                            ["speed"]
                                                        .toString(),
                                                    style: const TextStyle(
                                                        fontSize: 13,
                                                        color: Colors.black)),
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding: EdgeInsets.all(8.0),
                                            child: CircleAvatar(
                                              radius: 11.5,
                                              backgroundColor:
                                                  players["DF"]![index]
                                                              ["strength"] <
                                                          35
                                                      ? Colors.red
                                                      : players["DF"]![index]
                                                                  ["strength"] <
                                                              70
                                                          ? Colors.yellow
                                                          : Colors.green,
                                              child: Center(
                                                child: Text(
                                                    players["DF"]![index]
                                                            ["strength"]
                                                        .toString(),
                                                    style: const TextStyle(
                                                        fontSize: 13,
                                                        color: Colors.black)),
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding: EdgeInsets.all(8.0),
                                            child: CircleAvatar(
                                              radius: 11.5,
                                              backgroundColor:
                                                  players["DF"]![index]
                                                              ["passing"] <
                                                          35
                                                      ? Colors.red
                                                      : players["DF"]![index]
                                                                  ["passing"] <
                                                              70
                                                          ? Colors.yellow
                                                          : Colors.green,
                                              child: Center(
                                                child: Text(
                                                    players["DF"]![index]
                                                            ["passing"]
                                                        .toString(),
                                                    style: const TextStyle(
                                                        fontSize: 13,
                                                        color: Colors.black)),
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding: EdgeInsets.all(8.0),
                                            child: CircleAvatar(
                                              radius: 11.5,
                                              backgroundColor: players["DF"]![
                                                          index]["dribbling"] <
                                                      35
                                                  ? Colors.red
                                                  : players["DF"]![index]
                                                              ["dribbling"] <
                                                          70
                                                      ? Colors.yellow
                                                      : Colors.green,
                                              child: Center(
                                                child: Text(
                                                    players["DF"]![index]
                                                            ["dribbling"]
                                                        .toString(),
                                                    style: const TextStyle(
                                                        fontSize: 13,
                                                        color: Colors.black)),
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding: EdgeInsets.all(8.0),
                                            child: CircleAvatar(
                                              radius: 11.5,
                                              backgroundColor:
                                                  players["DF"]![index]
                                                              ["defense"] <
                                                          35
                                                      ? Colors.red
                                                      : players["DF"]![index]
                                                                  ["defense"] <
                                                              70
                                                          ? Colors.yellow
                                                          : Colors.green,
                                              child: Center(
                                                child: Text(
                                                    players["DF"]![index]
                                                            ["defense"]
                                                        .toString(),
                                                    style: const TextStyle(
                                                        fontSize: 13,
                                                        color: Colors.black)),
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding: EdgeInsets.all(8.0),
                                            child: CircleAvatar(
                                              radius: 11.5,
                                              backgroundColor:
                                                  players["DF"]![index]
                                                              ["rating"] <
                                                          35
                                                      ? Colors.red
                                                      : players["DF"]![index]
                                                                  ["rating"] <
                                                              70
                                                          ? Colors.yellow
                                                          : Colors.green,
                                              child: Center(
                                                child: Text(
                                                    players["DF"]![index]
                                                            ["rating"]
                                                        .toString(),
                                                    style: const TextStyle(
                                                        fontSize: 13,
                                                        color: Colors.black)),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        children: const [
                                          Padding(
                                            padding: EdgeInsets.all(8.0),
                                            child: Text("SHO",
                                                style: TextStyle(
                                                    fontSize: 12,
                                                    color: Colors.black)),
                                          ),
                                          Padding(
                                            padding: EdgeInsets.all(8.0),
                                            child: Text("PAC",
                                                style: TextStyle(
                                                    fontSize: 12,
                                                    color: Colors.black)),
                                          ),
                                          Padding(
                                            padding: EdgeInsets.all(8.0),
                                            child: Text("PHY",
                                                style: TextStyle(
                                                    fontSize: 12,
                                                    color: Colors.black)),
                                          ),
                                          Padding(
                                            padding: EdgeInsets.all(8.0),
                                            child: Text("PAS",
                                                style: TextStyle(
                                                    fontSize: 12,
                                                    color: Colors.black)),
                                          ),
                                          Padding(
                                            padding: EdgeInsets.all(8.0),
                                            child: Text("DRI",
                                                style: TextStyle(
                                                    fontSize: 12,
                                                    color: Colors.black)),
                                          ),
                                          Padding(
                                            padding: EdgeInsets.all(8.0),
                                            child: Text("DEF",
                                                style: TextStyle(
                                                    fontSize: 12,
                                                    color: Colors.black)),
                                          ),
                                          Padding(
                                            padding: EdgeInsets.all(8.0),
                                            child: Text("TOT",
                                                style: TextStyle(
                                                    fontSize: 12,
                                                    color: Colors.black)),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          }),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 16.0, left: 16.0),
                      child: Text("Mediocampistas",
                          style: TextStyle(
                              fontSize: 24, fontWeight: FontWeight.w600)),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          top: 16.0, left: 16.0, right: 16.0),
                      child: Container(
                        height: 1500,
                        child: ListView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: players["MC"]!.length,
                          itemBuilder: ((context, index) {
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 16.0),
                              child: Container(
                                child: Container(
                                  constraints: BoxConstraints(
                                    maxHeight: double.infinity,
                                  ),
                                  decoration: BoxDecoration(
                                      color: players["MC"]![index]
                                                  ["category"] ==
                                              'Gold'
                                          ? Color.fromARGB(255, 240, 203, 82)
                                          : players["MC"]![index]["category"] ==
                                                  'Silver'
                                              ? const Color(0xffc0c0c0)
                                              : Color.fromARGB(
                                                  255, 179, 107, 36),
                                      border: Border.all(
                                          color: Colors.black, width: 1.0)),
                                  child: Column(
                                    children: <Widget>[
                                      Row(
                                        children: [
                                          Padding(
                                            padding: EdgeInsets.all(8.0),
                                            child: Icon(Icons.account_circle,
                                                size: 20),
                                          ),
                                          Padding(
                                            padding: EdgeInsets.all(8.0),
                                            child: Text(
                                                players["MC"]![index]["name"],
                                                style: TextStyle(fontSize: 20)),
                                          ),
                                          Padding(
                                            padding: EdgeInsets.all(8.0),
                                            child: Text(
                                                players["MC"]![index]["price"]
                                                        .toString() +
                                                    "M",
                                                style: TextStyle(fontSize: 20)),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          Padding(
                                            padding: EdgeInsets.all(8.0),
                                            child: CircleAvatar(
                                              radius: 11.5,
                                              backgroundColor:
                                                  players["MC"]![index]
                                                              ["shooting"] <
                                                          35
                                                      ? Colors.red
                                                      : players["MC"]![index]
                                                                  ["shooting"] <
                                                              70
                                                          ? Colors.yellow
                                                          : Colors.green,
                                              child: Center(
                                                child: Text(
                                                    players["MC"]![index]
                                                            ["shooting"]
                                                        .toString(),
                                                    style: const TextStyle(
                                                        fontSize: 13,
                                                        color: Colors.black)),
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding: EdgeInsets.all(8.0),
                                            child: CircleAvatar(
                                              radius: 11.5,
                                              backgroundColor:
                                                  players["MC"]![index]
                                                              ["speed"] <
                                                          35
                                                      ? Colors.red
                                                      : players["MC"]![index]
                                                                  ["speed"] <
                                                              70
                                                          ? Colors.yellow
                                                          : Colors.green,
                                              child: Center(
                                                child: Text(
                                                    players["MC"]![index]
                                                            ["speed"]
                                                        .toString(),
                                                    style: const TextStyle(
                                                        fontSize: 13,
                                                        color: Colors.black)),
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding: EdgeInsets.all(8.0),
                                            child: CircleAvatar(
                                              radius: 11.5,
                                              backgroundColor:
                                                  players["MC"]![index]
                                                              ["strength"] <
                                                          35
                                                      ? Colors.red
                                                      : players["MC"]![index]
                                                                  ["strength"] <
                                                              70
                                                          ? Colors.yellow
                                                          : Colors.green,
                                              child: Center(
                                                child: Text(
                                                    players["MC"]![index]
                                                            ["strength"]
                                                        .toString(),
                                                    style: const TextStyle(
                                                        fontSize: 13,
                                                        color: Colors.black)),
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding: EdgeInsets.all(8.0),
                                            child: CircleAvatar(
                                              radius: 11.5,
                                              backgroundColor:
                                                  players["MC"]![index]
                                                              ["passing"] <
                                                          35
                                                      ? Colors.red
                                                      : players["MC"]![index]
                                                                  ["passing"] <
                                                              70
                                                          ? Colors.yellow
                                                          : Colors.green,
                                              child: Center(
                                                child: Text(
                                                    players["MC"]![index]
                                                            ["passing"]
                                                        .toString(),
                                                    style: const TextStyle(
                                                        fontSize: 13,
                                                        color: Colors.black)),
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding: EdgeInsets.all(8.0),
                                            child: CircleAvatar(
                                              radius: 11.5,
                                              backgroundColor: players["MC"]![
                                                          index]["dribbling"] <
                                                      35
                                                  ? Colors.red
                                                  : players["MC"]![index]
                                                              ["dribbling"] <
                                                          70
                                                      ? Colors.yellow
                                                      : Colors.green,
                                              child: Center(
                                                child: Text(
                                                    players["MC"]![index]
                                                            ["dribbling"]
                                                        .toString(),
                                                    style: const TextStyle(
                                                        fontSize: 13,
                                                        color: Colors.black)),
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding: EdgeInsets.all(8.0),
                                            child: CircleAvatar(
                                              radius: 11.5,
                                              backgroundColor:
                                                  players["MC"]![index]
                                                              ["defense"] <
                                                          35
                                                      ? Colors.red
                                                      : players["MC"]![index]
                                                                  ["defense"] <
                                                              70
                                                          ? Colors.yellow
                                                          : Colors.green,
                                              child: Center(
                                                child: Text(
                                                    players["MC"]![index]
                                                            ["defense"]
                                                        .toString(),
                                                    style: const TextStyle(
                                                        fontSize: 13,
                                                        color: Colors.black)),
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding: EdgeInsets.all(8.0),
                                            child: CircleAvatar(
                                              radius: 11.5,
                                              backgroundColor:
                                                  players["MC"]![index]
                                                              ["rating"] <
                                                          35
                                                      ? Colors.red
                                                      : players["MC"]![index]
                                                                  ["rating"] <
                                                              70
                                                          ? Colors.yellow
                                                          : Colors.green,
                                              child: Center(
                                                child: Text(
                                                    players["MC"]![index]
                                                            ["rating"]
                                                        .toString(),
                                                    style: const TextStyle(
                                                        fontSize: 13,
                                                        color: Colors.black)),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        children: const [
                                          Padding(
                                            padding: EdgeInsets.all(8.0),
                                            child: Text("SHO",
                                                style: TextStyle(
                                                    fontSize: 12,
                                                    color: Colors.black)),
                                          ),
                                          Padding(
                                            padding: EdgeInsets.all(8.0),
                                            child: Text("PAC",
                                                style: TextStyle(
                                                    fontSize: 12,
                                                    color: Colors.black)),
                                          ),
                                          Padding(
                                            padding: EdgeInsets.all(8.0),
                                            child: Text("PHY",
                                                style: TextStyle(
                                                    fontSize: 12,
                                                    color: Colors.black)),
                                          ),
                                          Padding(
                                            padding: EdgeInsets.all(8.0),
                                            child: Text("PAS",
                                                style: TextStyle(
                                                    fontSize: 12,
                                                    color: Colors.black)),
                                          ),
                                          Padding(
                                            padding: EdgeInsets.all(8.0),
                                            child: Text("DRI",
                                                style: TextStyle(
                                                    fontSize: 12,
                                                    color: Colors.black)),
                                          ),
                                          Padding(
                                            padding: EdgeInsets.all(8.0),
                                            child: Text("DEF",
                                                style: TextStyle(
                                                    fontSize: 12,
                                                    color: Colors.black)),
                                          ),
                                          Padding(
                                            padding: EdgeInsets.all(8.0),
                                            child: Text("TOT",
                                                style: TextStyle(
                                                    fontSize: 12,
                                                    color: Colors.black)),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          }),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 16.0, left: 16.0),
                      child: Text("Delanteros",
                          style: TextStyle(
                              fontSize: 24, fontWeight: FontWeight.w600)),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          top: 16.0, left: 16.0, right: 16.0),
                      child: Container(
                        height: 1150,
                        child: ListView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: players["DL"]!.length,
                          itemBuilder: ((context, index) {
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 16.0),
                              child: Container(
                                child: Container(
                                  constraints: BoxConstraints(
                                    maxHeight: double.infinity,
                                  ),
                                  decoration: BoxDecoration(
                                      color: players["DL"]![index]
                                                  ["category"] ==
                                              'Gold'
                                          ? Color.fromARGB(255, 240, 203, 82)
                                          : players["DL"]![index]["category"] ==
                                                  'Silver'
                                              ? const Color(0xffc0c0c0)
                                              : Color.fromARGB(
                                                  255, 179, 107, 36),
                                      border: Border.all(
                                          color: Colors.black, width: 1.0)),
                                  child: Column(
                                    children: <Widget>[
                                      Row(
                                        children: [
                                          Padding(
                                            padding: EdgeInsets.all(8.0),
                                            child: Icon(Icons.account_circle,
                                                size: 20),
                                          ),
                                          Padding(
                                            padding: EdgeInsets.all(8.0),
                                            child: Text(
                                                players["DL"]![index]["name"],
                                                style: TextStyle(fontSize: 20)),
                                          ),
                                          Padding(
                                            padding: EdgeInsets.all(8.0),
                                            child: Text(
                                                players["DL"]![index]["price"]
                                                        .toString() +
                                                    "M",
                                                style: TextStyle(fontSize: 20)),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          Padding(
                                            padding: EdgeInsets.all(8.0),
                                            child: CircleAvatar(
                                              radius: 11.5,
                                              backgroundColor:
                                                  players["DL"]![index]
                                                              ["shooting"] <
                                                          35
                                                      ? Colors.red
                                                      : players["DL"]![index]
                                                                  ["shooting"] <
                                                              70
                                                          ? Colors.yellow
                                                          : Colors.green,
                                              child: Center(
                                                child: Text(
                                                    players["DL"]![index]
                                                            ["shooting"]
                                                        .toString(),
                                                    style: const TextStyle(
                                                        fontSize: 13,
                                                        color: Colors.black)),
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding: EdgeInsets.all(8.0),
                                            child: CircleAvatar(
                                              radius: 11.5,
                                              backgroundColor:
                                                  players["DL"]![index]
                                                              ["speed"] <
                                                          35
                                                      ? Colors.red
                                                      : players["DL"]![index]
                                                                  ["speed"] <
                                                              70
                                                          ? Colors.yellow
                                                          : Colors.green,
                                              child: Center(
                                                child: Text(
                                                    players["DL"]![index]
                                                            ["speed"]
                                                        .toString(),
                                                    style: const TextStyle(
                                                        fontSize: 13,
                                                        color: Colors.black)),
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding: EdgeInsets.all(8.0),
                                            child: CircleAvatar(
                                              radius: 11.5,
                                              backgroundColor:
                                                  players["DL"]![index]
                                                              ["strength"] <
                                                          35
                                                      ? Colors.red
                                                      : players["DL"]![index]
                                                                  ["strength"] <
                                                              70
                                                          ? Colors.yellow
                                                          : Colors.green,
                                              child: Center(
                                                child: Text(
                                                    players["DL"]![index]
                                                            ["strength"]
                                                        .toString(),
                                                    style: const TextStyle(
                                                        fontSize: 13,
                                                        color: Colors.black)),
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding: EdgeInsets.all(8.0),
                                            child: CircleAvatar(
                                              radius: 11.5,
                                              backgroundColor:
                                                  players["DL"]![index]
                                                              ["passing"] <
                                                          35
                                                      ? Colors.red
                                                      : players["DL"]![index]
                                                                  ["passing"] <
                                                              70
                                                          ? Colors.yellow
                                                          : Colors.green,
                                              child: Center(
                                                child: Text(
                                                    players["DL"]![index]
                                                            ["passing"]
                                                        .toString(),
                                                    style: const TextStyle(
                                                        fontSize: 13,
                                                        color: Colors.black)),
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding: EdgeInsets.all(8.0),
                                            child: CircleAvatar(
                                              radius: 11.5,
                                              backgroundColor: players["DL"]![
                                                          index]["dribbling"] <
                                                      35
                                                  ? Colors.red
                                                  : players["DL"]![index]
                                                              ["dribbling"] <
                                                          70
                                                      ? Colors.yellow
                                                      : Colors.green,
                                              child: Center(
                                                child: Text(
                                                    players["DL"]![index]
                                                            ["dribbling"]
                                                        .toString(),
                                                    style: const TextStyle(
                                                        fontSize: 13,
                                                        color: Colors.black)),
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding: EdgeInsets.all(8.0),
                                            child: CircleAvatar(
                                              radius: 11.5,
                                              backgroundColor:
                                                  players["DL"]![index]
                                                              ["defense"] <
                                                          35
                                                      ? Colors.red
                                                      : players["DL"]![index]
                                                                  ["defense"] <
                                                              70
                                                          ? Colors.yellow
                                                          : Colors.green,
                                              child: Center(
                                                child: Text(
                                                    players["DL"]![index]
                                                            ["defense"]
                                                        .toString(),
                                                    style: const TextStyle(
                                                        fontSize: 13,
                                                        color: Colors.black)),
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding: EdgeInsets.all(8.0),
                                            child: CircleAvatar(
                                              radius: 11.5,
                                              backgroundColor:
                                                  players["DL"]![index]
                                                              ["rating"] <
                                                          35
                                                      ? Colors.red
                                                      : players["DL"]![index]
                                                                  ["rating"] <
                                                              70
                                                          ? Colors.yellow
                                                          : Colors.green,
                                              child: Center(
                                                child: Text(
                                                    players["DL"]![index]
                                                            ["rating"]
                                                        .toString(),
                                                    style: const TextStyle(
                                                        fontSize: 13,
                                                        color: Colors.black)),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        children: const [
                                          Padding(
                                            padding: EdgeInsets.all(8.0),
                                            child: Text("SHO",
                                                style: TextStyle(
                                                    fontSize: 12,
                                                    color: Colors.black)),
                                          ),
                                          Padding(
                                            padding: EdgeInsets.all(8.0),
                                            child: Text("PAC",
                                                style: TextStyle(
                                                    fontSize: 12,
                                                    color: Colors.black)),
                                          ),
                                          Padding(
                                            padding: EdgeInsets.all(8.0),
                                            child: Text("PHY",
                                                style: TextStyle(
                                                    fontSize: 12,
                                                    color: Colors.black)),
                                          ),
                                          Padding(
                                            padding: EdgeInsets.all(8.0),
                                            child: Text("PAS",
                                                style: TextStyle(
                                                    fontSize: 12,
                                                    color: Colors.black)),
                                          ),
                                          Padding(
                                            padding: EdgeInsets.all(8.0),
                                            child: Text("DRI",
                                                style: TextStyle(
                                                    fontSize: 12,
                                                    color: Colors.black)),
                                          ),
                                          Padding(
                                            padding: EdgeInsets.all(8.0),
                                            child: Text("DEF",
                                                style: TextStyle(
                                                    fontSize: 12,
                                                    color: Colors.black)),
                                          ),
                                          Padding(
                                            padding: EdgeInsets.all(8.0),
                                            child: Text("TOT",
                                                style: TextStyle(
                                                    fontSize: 12,
                                                    color: Colors.black)),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          }),
                        ),
                      ),
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
                                Visibility(
                                  visible: x2 == false,
                                  child: FloatingActionButton.extended(
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
                    Center(
                        child: Text(
                      'Partida encontrada',
                      style: TextStyle(
                          fontSize: 30, color: const Color(0xFF4CAF50)),
                    )),
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Text('${_player1}', style: TextStyle(fontSize: 20)),
                            Text(' VS ',
                                style: TextStyle(
                                    fontSize: 20,
                                    color: const Color(0xFF4CAF50))),
                            Text(
                              '${_player2}',
                              style: TextStyle(fontSize: 20),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ];
                }

                if (loaded == true) {
                  return SingleChildScrollView(
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.max,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: children),
                  );
                } else {
                  return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: children);
                }
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
