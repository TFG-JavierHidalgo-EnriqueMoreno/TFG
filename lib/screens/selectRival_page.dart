import 'dart:async';
import 'dart:core';
import 'dart:developer';
import 'dart:math';
import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:my_app/entities/lineup.dart';
import 'package:my_app/screens/game_event.dart';
import 'package:my_app/screens/result_page.dart';
import 'package:my_app/routes/custom_route.dart';
import 'package:my_app/services/api_service.dart';
import 'package:my_app/services/firebase_service.dart';
import 'package:timer_count_down/timer_controller.dart';
import 'package:timer_count_down/timer_count_down.dart';
import 'home_page.dart';

import 'package:my_app/entities/globals.dart' as globals;

class SelectRivalPage extends StatefulWidget {
  final Map<int, dynamic> selectedPlayers;
  final String selectedLineup;
  final bool x2;
  final int timer;

  const SelectRivalPage(
      {super.key,
      required this.selectedLineup,
      required this.selectedPlayers,
      required this.x2,
      required this.timer});

  @override
  SelectRivalPageState createState() {
    return SelectRivalPageState();
  }
}

class SelectRivalPageState extends State<SelectRivalPage> {

  @override
  void initState() {
    super.initState();
    sp = widget.selectedPlayers;
    sl = widget.selectedLineup;
    _x2 = widget.x2;
    _timer = widget.timer;
  }

  @override
  void dispose() {
    _controller.pause();
    super.dispose();
  }

  final CountdownController _controller =
      new CountdownController(autoStart: true);

  late int _timer;
  Map<int, dynamic> sp = {};
  String sl = "";
  late bool _x2;
  bool confirmed = false;
  List<dynamic> cp = [];
  String l = "";

  getOtherPlayerLineup(dynamic player2Players) {
    var lineup = "4-4-2";
    var df = 0;
    var dl = 0;
    for (var element in player2Players) {
      if (element["position"] == "DF") {
        df++;
      } else if (element["position"] == "DL") {
        dl++;
      }
    }
    if (df == 5) {
      lineup = "5-3-2";
    } else if (dl == 3) {
      lineup = "4-3-3";
    }
    return lineup;
  }

  Future<bool> _getPlayer2Players() async {
    List<dynamic> dl = [];
    List<dynamic> df = [];
    List<dynamic> mc = [];
    List<dynamic> pt = [];
    var po = await getPlayer2Players();
    await Future.delayed(const Duration(seconds: 5));
    po.forEach((element) {
      element["opponent"] = false;
      if (element["position"] == "DF") {
        df.add(element);
      } else if (element["position"] == "DL") {
        dl.add(element);
      } else if (element["position"] == "MC") {
        mc.add(element);
      } else {
        pt.add(element);
      }
    });
    cp.addAll(dl);
    cp.addAll(mc);
    cp.addAll(df);
    cp.addAll(pt);
    l = getOtherPlayerLineup(cp);
    await Future.delayed(const Duration(seconds: 5));
    return true;
  }

  String _printDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return "$twoDigitMinutes:$twoDigitSeconds";
  }

  @override
  Widget build(BuildContext context) {
    const appTitle = 'Selecciona oponente';
    return MaterialApp(
      title: appTitle,
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: const Color(0xFF4CAF50),
          title: const Text(appTitle),
        ),
        body: FutureBuilder<bool>(
            future: _getPlayer2Players(),
            builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
              if (snapshot.hasData) {
                return Scaffold(
                    body: Stack(
                  children: <Widget>[
                    Container(
                      decoration: const BoxDecoration(
                        image: DecorationImage(
                          image: ExactAssetImage("assets/images/field.png"),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    Countdown(
                      seconds: _timer,
                      build: (BuildContext context, double time) {
                        if (_timer <= 60) {
                          return Text(
                              "Tiempo restante de partido: ${_printDuration(Duration(seconds: time.round()))}",
                              style: TextStyle(
                                  color: Colors.orange, fontSize: 16));
                        } else if (_timer <= 10) {
                          return Text(
                              "Tiempo restante de partido: ${_printDuration(Duration(seconds: time.round()))}",
                              style:
                                  TextStyle(color: Colors.red, fontSize: 16));
                        } else {
                          return Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black,
                                        offset: Offset(0.0, 1.0), //(x,y)
                                        blurRadius: 6.0,
                                      ),
                                    ],
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(8.0),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      "Tiempo restante de partido: ${_printDuration(Duration(seconds: time.round()))}",
                                      style: TextStyle(
                                          color: Colors.green.shade800,
                                          fontSize: 16),
                                    ),
                                  ),
                                  height: 35,
                                ),
                              ],
                            ),
                          );
                        }
                      },
                      interval: Duration(milliseconds: 100),
                      onFinished: () async {
                        String playerStatus = await checkPlayerStatus();
                        String otherPlayerStatus =
                            await checkOtherPlayerStatus();
                        if (playerStatus == "confirmed" &&
                            otherPlayerStatus != "confirmed") {
                          var player2 = await getPlayer2();
                          Map<String, int> gameResult = {
                            "player1Goals": 3,
                            "player2Goals": 0
                          };
                          var p = calcPointsPlayer1NotConfirm(sp);
                          saveGameNotConfirm(p, l, gameResult);
                          Navigator.of(context)
                              .pushReplacement(MaterialPageRoute(
                                  builder: (context) => ResultPage(
                                        player1Points: const {},
                                        player2Points: const {},
                                        gameResult: gameResult,
                                        player2: player2,
                                      )));
                        }

                        if (otherPlayerStatus == 'confirmed' &&
                            playerStatus != "confirmed") {
                          var player2 = await getPlayer2();
                          Map<String, int> gameResult = {
                            "player1Goals": 0,
                            "player2Goals": 3
                          };
                          Navigator.of(context)
                              .pushReplacement(MaterialPageRoute(
                                  builder: (context) => ResultPage(
                                        player1Points: const {},
                                        player2Points: const {},
                                        gameResult: gameResult,
                                        player2: player2,
                                      )));
                        }

                        if (otherPlayerStatus != "confirmed" &&
                            playerStatus != "confirmed") {
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
                        }
                      },
                    ),
                    Positioned(
                      bottom: MediaQuery.of(context).size.height * 0.65,
                      left: l == "4-3-3"
                          ? (MediaQuery.of(context).size.width) * 0.05
                          : (MediaQuery.of(context).size.width) * 0.15,
                      child: Stack(
                        children: <Widget>[
                          SizedBox(
                            width: 150,
                            child: Column(
                              children: [
                                ElevatedButton(
                                    onPressed: () => {
                                          selectOpponent(0),
                                        },
                                    style: ElevatedButton.styleFrom(
                                        side: const BorderSide(
                                          width: 2.5,
                                          color: Colors.white,
                                        ),
                                        shape: const CircleBorder(),
                                        padding: const EdgeInsets.all(20),
                                        backgroundColor: Colors.transparent),
                                    child: Icon(Icons.person)),
                                Center(
                                  child: Padding(
                                    padding: const EdgeInsets.only(top: 8.0),
                                    child: Text(
                                        cp[0]["opponent"] == true
                                            ? "${cp[0]["name"]} (O)"
                                            : cp[0]["name"],
                                        style: const TextStyle(
                                            color: Colors.white70,
                                            fontWeight: FontWeight.bold)),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Positioned(
                      bottom: MediaQuery.of(context).size.height * 0.65,
                      left: l == "4-3-3"
                          ? (MediaQuery.of(context).size.width) * 0.31
                          : (MediaQuery.of(context).size.width) * 0.46,
                      child: Stack(
                        children: <Widget>[
                          SizedBox(
                            width: 150,
                            child: Column(
                              children: [
                                ElevatedButton(
                                    onPressed: () => {
                                          selectOpponent(1),
                                        },
                                    style: ElevatedButton.styleFrom(
                                        side: const BorderSide(
                                          width: 2.5,
                                          color: Colors.white,
                                        ),
                                        shape: const CircleBorder(),
                                        padding: const EdgeInsets.all(20),
                                        backgroundColor: Colors.transparent),
                                    child: Icon(Icons.person)),
                                Center(
                                  child: Padding(
                                    padding: const EdgeInsets.only(top: 8.0),
                                    child: Text(
                                        cp[1]["opponent"] == true
                                            ? "${cp[1]["name"]} (O)"
                                            : cp[1]["name"],
                                        style: const TextStyle(
                                            color: Colors.white70,
                                            fontWeight: FontWeight.bold)),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Positioned(
                      bottom: l == "4-3-3"
                          ? MediaQuery.of(context).size.height * 0.65
                          : MediaQuery.of(context).size.height * 0.53,
                      left: l == "4-3-3"
                          ? (MediaQuery.of(context).size.width) * 0.57
                          : -(MediaQuery.of(context).size.width * 0.05),
                      child: Stack(
                        children: <Widget>[
                          SizedBox(
                            width: 150,
                            child: Column(
                              children: [
                                ElevatedButton(
                                    onPressed: () => {
                                          selectOpponent(2),
                                        },
                                    style: ElevatedButton.styleFrom(
                                        side: const BorderSide(
                                          width: 2.5,
                                          color: Colors.white,
                                        ),
                                        shape: const CircleBorder(),
                                        padding: const EdgeInsets.all(20),
                                        backgroundColor: Colors.transparent),
                                    child: Icon(Icons.person)),
                                Center(
                                  child: Padding(
                                    padding: const EdgeInsets.only(top: 8.0),
                                    child: Text(
                                        cp[2]["opponent"] == true
                                            ? "${cp[2]["name"]} (O)"
                                            : cp[2]["name"],
                                        style: const TextStyle(
                                            color: Colors.white70,
                                            fontWeight: FontWeight.bold)),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Positioned(
                      bottom: l == "4-3-3"
                          ? MediaQuery.of(context).size.height * 0.53
                          : MediaQuery.of(context).size.height * 0.42,
                      left: l == "4-3-3"
                          ? -(MediaQuery.of(context).size.width * 0.02)
                          : l == "5-3-2"
                              ? (MediaQuery.of(context).size.width) * 0.31
                              : (MediaQuery.of(context).size.width) * 0.15,
                      child: Stack(
                        children: <Widget>[
                          SizedBox(
                            width: 150,
                            child: Column(
                              children: [
                                ElevatedButton(
                                    onPressed: () => {
                                          selectOpponent(3),
                                        },
                                    style: ElevatedButton.styleFrom(
                                        side: const BorderSide(
                                          width: 2.5,
                                          color: Colors.white,
                                        ),
                                        shape: const CircleBorder(),
                                        padding: const EdgeInsets.all(20),
                                        backgroundColor: Colors.transparent),
                                    child: Icon(Icons.person)),
                                Center(
                                  child: Padding(
                                    padding: const EdgeInsets.only(top: 8.0),
                                    child: Text(
                                        cp[3]["opponent"] == true
                                            ? "${cp[3]["name"]} (O)"
                                            : cp[3]["name"],
                                        style: const TextStyle(
                                            color: Colors.white70,
                                            fontWeight: FontWeight.bold)),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Positioned(
                      bottom: l == "5-3-2"
                          ? MediaQuery.of(context).size.height * 0.53
                          : MediaQuery.of(context).size.height * 0.42,
                      left: l == "4-3-3"
                          ? (MediaQuery.of(context).size.width) * 0.31
                          : l == "5-3-2"
                              ? (MediaQuery.of(context).size.width) * 0.65
                              : (MediaQuery.of(context).size.width) * 0.46,
                      child: Stack(
                        children: <Widget>[
                          SizedBox(
                            width: 150,
                            child: Column(
                              children: [
                                ElevatedButton(
                                    onPressed: () => {
                                          selectOpponent(4),
                                        },
                                    style: ElevatedButton.styleFrom(
                                        side: const BorderSide(
                                          width: 2.5,
                                          color: Colors.white,
                                        ),
                                        shape: const CircleBorder(),
                                        padding: const EdgeInsets.all(20),
                                        backgroundColor: Colors.transparent),
                                    child: Icon(Icons.person)),
                                Center(
                                  child: Padding(
                                    padding: const EdgeInsets.only(top: 8.0),
                                    child: Text(
                                        cp[4]["opponent"] == true
                                            ? "${cp[4]["name"]} (O)"
                                            : cp[4]["name"],
                                        style: const TextStyle(
                                            color: Colors.white70,
                                            fontWeight: FontWeight.bold)),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Positioned(
                      bottom: l == "5-3-2"
                          ? MediaQuery.of(context).size.height * 0.34
                          : MediaQuery.of(context).size.height * 0.53,
                      left: (MediaQuery.of(context).size.width) * 0.67,
                      child: Stack(
                        children: <Widget>[
                          SizedBox(
                            width: 150,
                            child: Column(
                              children: [
                                ElevatedButton(
                                    onPressed: () => {
                                          selectOpponent(5),
                                        },
                                    style: ElevatedButton.styleFrom(
                                        side: const BorderSide(
                                          width: 2.5,
                                          color: Colors.white,
                                        ),
                                        shape: const CircleBorder(),
                                        padding: const EdgeInsets.all(20),
                                        backgroundColor: Colors.transparent),
                                    child: Icon(Icons.person)),
                                Center(
                                  child: Padding(
                                    padding: const EdgeInsets.only(top: 8.0),
                                    child: Text(
                                        cp[5]["opponent"] == true
                                            ? "${cp[5]["name"]} (O)"
                                            : cp[5]["name"],
                                        style: const TextStyle(
                                            color: Colors.white70,
                                            fontWeight: FontWeight.bold)),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Positioned(
                      bottom: l == "5-3-2"
                          ? MediaQuery.of(context).size.height * 0.34
                          : MediaQuery.of(context).size.height * 0.27,
                      left: -(MediaQuery.of(context).size.width * 0.06),
                      child: Stack(
                        children: <Widget>[
                          SizedBox(
                            width: 150,
                            child: Column(
                              children: [
                                ElevatedButton(
                                    onPressed: () => {
                                          selectOpponent(6),
                                        },
                                    style: ElevatedButton.styleFrom(
                                        side: const BorderSide(
                                          width: 2.5,
                                          color: Colors.white,
                                        ),
                                        shape: const CircleBorder(),
                                        padding: const EdgeInsets.all(20),
                                        backgroundColor: Colors.transparent),
                                    child: Icon(Icons.person)),
                                Center(
                                  child: Padding(
                                    padding: const EdgeInsets.only(top: 8.0),
                                    child: Text(
                                        cp[6]["opponent"] == true
                                            ? "${cp[6]["name"]} (O)"
                                            : cp[6]["name"],
                                        style: const TextStyle(
                                            color: Colors.white70,
                                            fontWeight: FontWeight.bold)),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Positioned(
                      bottom: l == "5-3-2"
                          ? MediaQuery.of(context).size.height * 0.23
                          : MediaQuery.of(context).size.height * 0.175,
                      left: l == "5-3-2"
                          ? (MediaQuery.of(context).size.width) * 0.07
                          : (MediaQuery.of(context).size.width) * 0.15,
                      child: Stack(
                        children: <Widget>[
                          SizedBox(
                            width: 150,
                            child: Column(
                              children: [
                                ElevatedButton(
                                    onPressed: () => {
                                          selectOpponent(7),
                                        },
                                    style: ElevatedButton.styleFrom(
                                        side: const BorderSide(
                                          width: 2.5,
                                          color: Colors.white,
                                        ),
                                        shape: const CircleBorder(),
                                        padding: const EdgeInsets.all(20),
                                        backgroundColor: Colors.transparent),
                                    child: Icon(Icons.person)),
                                Center(
                                  child: Padding(
                                    padding: const EdgeInsets.only(top: 8.0),
                                    child: Text(
                                        cp[7]["opponent"] == true
                                            ? "${cp[7]["name"]} (O)"
                                            : cp[7]["name"],
                                        style: const TextStyle(
                                            color: Colors.white70,
                                            fontWeight: FontWeight.bold)),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Positioned(
                      bottom: l == "5-3-2"
                          ? MediaQuery.of(context).size.height * 0.23
                          : MediaQuery.of(context).size.height * 0.175,
                      left: l == "5-3-2"
                          ? (MediaQuery.of(context).size.width) * 0.54
                          : (MediaQuery.of(context).size.width) * 0.46,
                      child: Stack(
                        children: <Widget>[
                          SizedBox(
                            width: 150,
                            child: Column(
                              children: [
                                ElevatedButton(
                                    onPressed: () => {
                                          selectOpponent(8),
                                        },
                                    style: ElevatedButton.styleFrom(
                                        side: const BorderSide(
                                          width: 2.5,
                                          color: Colors.white,
                                        ),
                                        shape: const CircleBorder(),
                                        padding: const EdgeInsets.all(20),
                                        backgroundColor: Colors.transparent),
                                    child: Icon(Icons.person)),
                                Center(
                                  child: Padding(
                                    padding: const EdgeInsets.only(top: 8.0),
                                    child: Text(
                                        cp[8]["opponent"] == true
                                            ? "${cp[8]["name"]} (O)"
                                            : cp[8]["name"],
                                        style: const TextStyle(
                                            color: Colors.white70,
                                            fontWeight: FontWeight.bold)),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Positioned(
                      bottom: l == "5-3-2"
                          ? MediaQuery.of(context).size.height * 0.18
                          : MediaQuery.of(context).size.height * 0.27,
                      left: l == "5-3-2"
                          ? (MediaQuery.of(context).size.width) * 0.31
                          : (MediaQuery.of(context).size.width) * 0.67,
                      child: Stack(
                        children: <Widget>[
                          SizedBox(
                            width: 150,
                            child: Column(
                              children: [
                                ElevatedButton(
                                    onPressed: () => {
                                          selectOpponent(9),
                                        },
                                    style: ElevatedButton.styleFrom(
                                        side: const BorderSide(
                                          width: 2.5,
                                          color: Colors.white,
                                        ),
                                        shape: const CircleBorder(),
                                        padding: const EdgeInsets.all(20),
                                        backgroundColor: Colors.transparent),
                                    child: Icon(Icons.person)),
                                Center(
                                  child: Padding(
                                    padding: const EdgeInsets.only(top: 8.0),
                                    child: Text(
                                        cp[9]["opponent"] == true
                                            ? "${cp[9]["name"]} (O)"
                                            : cp[9]["name"],
                                        style: const TextStyle(
                                            color: Colors.white70,
                                            fontWeight: FontWeight.bold)),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Positioned(
                      bottom: MediaQuery.of(context).size.height * 0.03,
                      left: (MediaQuery.of(context).size.width) * 0.31,
                      child: Stack(
                        children: <Widget>[
                          SizedBox(
                            width: 150,
                            child: Column(
                              children: [
                                ElevatedButton(
                                    onPressed: () => {
                                          selectOpponent(10),
                                        },
                                    style: ElevatedButton.styleFrom(
                                        side: const BorderSide(
                                          width: 2.5,
                                          color: Colors.white,
                                        ),
                                        shape: const CircleBorder(),
                                        padding: const EdgeInsets.all(20),
                                        backgroundColor: Colors.transparent),
                                    child: Icon(Icons.person)),
                                Center(
                                  child: Padding(
                                    padding: const EdgeInsets.only(top: 8.0),
                                    child: Text(
                                        cp[10]["opponent"] == true
                                            ? "${cp[10]["name"]} (O)"
                                            : cp[10]["name"],
                                        style: const TextStyle(
                                            color: Colors.white70,
                                            fontWeight: FontWeight.bold)),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    confirmed == true
                        ? Positioned(
                            bottom: MediaQuery.of(context).size.height * 0.03,
                            left: (MediaQuery.of(context).size.width) * 0.65,
                            child: SizedBox(
                              height: MediaQuery.of(context).size.height * 0.06,
                              width: (MediaQuery.of(context).size.width) * 0.32,
                              child: Column(
                                children: [
                                  const Text(
                                    "Esperando al rival...",
                                    style: TextStyle(
                                        color: Colors.amber,
                                        fontWeight: FontWeight.w500),
                                  ),
                                  const SizedBox(height: 10),
                                  AnimatedContainer(),
                                  const SizedBox(height: 10),
                                ],
                              ),
                            ),
                          )
                        : Positioned(
                            bottom: MediaQuery.of(context).size.height * 0.03,
                            left: (MediaQuery.of(context).size.width) * 0.7,
                            child: Visibility(
                              visible: cp.any(
                                  (element) => element["opponent"] == true),
                              child: ElevatedButton(
                                  onPressed: () {
                                    confirmed = true;
                                    confirmOpponent(
                                        context, sp, cp, l, sl, _x2);
                                    setState(() {});
                                  },
                                  child: Text('Confirmar')),
                            )),
                  ],
                ));
              } else if (snapshot.hasError) {
                return Text('${snapshot.error}');
              } else {
                return Center(
                    child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom: 16.0),
                      child: Text('Obteniendo jugadores del rival...'),
                    ),
                    CircularProgressIndicator(),
                  ],
                ));
              }
            }),
      ),
    );
  }

  selectOpponent(int i) {
    cp.forEach((element) {
      element["opponent"] = false;
    });
    cp[i]["opponent"] = true;
    setState(() {});
  }
}

class AnimatedContainer extends StatefulWidget {
  const AnimatedContainer();

  @override
  _AnimatedContainer createState() => _AnimatedContainer();
}

class _AnimatedContainer extends State<AnimatedContainer>
    with TickerProviderStateMixin {
  late AnimationController animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    animationController = AnimationController(
      /// [AnimationController]s can be created with `vsync: this` because of
      /// [TickerProviderStateMixin].
      vsync: this,
      duration: const Duration(seconds: 2),
    )..addListener(() {
        setState(() {});
      });
    animationController.repeat();
  }

  @override
  Widget build(BuildContext context) {
    return LinearProgressIndicator(
      backgroundColor: Colors.white,
      color: Colors.amber,
      semanticsLabel: "Esperando al rival...",
      value: animationController.value,
    );
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }
}

confirmOpponent(
    BuildContext context,
    Map<int, dynamic> selectedPlayers,
    List<dynamic> cp,
    String otherLineup,
    String selectedLineup,
    bool x2) async {
  Map<int, dynamic> otherPlayers = {};
  for (var i = 0; i < cp.length; i++) {
    otherPlayers.putIfAbsent(i, () => cp[i]);
  }
  updateOpponent(otherPlayers);
  confirmedPlayer();
  Timer? t;
  Map<String, String> otherPlayerCO = {};
  t = Timer.periodic(Duration(milliseconds: 1000), (Timer t) async {
    if (await checkOtherPlayerStatus() == "confirmed") {
      var player2 = await getPlayer2();
      Timer(Duration(seconds: 3), (() async {
        otherPlayerCO = await getOtherPlayerCO();
        Map<String, int?> player1Points =
            calcPointsPlayer1(selectedPlayers, otherPlayerCO);
        Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (context) => GameEventPage(
                players: selectedPlayers,
                player1Points: player1Points,
                selectedLineup: selectedLineup,
                otherLineup: otherLineup,
                player2: player2,
                x2: x2)));
      }));

      t.cancel();
    }
  });
}

calcPointsPlayer1(
    Map<int, dynamic> selectedPlayers, Map<String, String> otherPlayerCO) {
  int? strength = 0;
  int? shooting = 0;
  int? speed = 0;
  int? dribbling = 0;
  int? defense = 0;
  int? passing = 0;
  int? rating = 0;

  selectedPlayers.forEach((key, value) {
    if (value["captain"] == true) {
      if (value["bd_id"] == otherPlayerCO["otherPlayerOpponent"]) {
        strength = strength! + value["strength"] as int?;
        shooting = shooting! + value["shooting"] as int?;
        speed = speed! + value["speed"] as int?;
        dribbling = dribbling! + value["dribbling"] as int?;
        defense = defense! + value["defense"] as int?;
        passing = passing! + value["passing"] as int?;
        rating = rating! + value["rating"] as int?;
      } else {
        strength = strength! + value["strength"] * 2 as int?;
        shooting = shooting! + value["shooting"] * 2 as int?;
        speed = speed! + value["speed"] * 2 as int?;
        dribbling = dribbling! + value["dribbling"] * 2 as int?;
        defense = defense! + value["defense"] * 2 as int?;
        passing = passing! + value["passing"] * 2 as int?;
        rating = rating! + value["rating"] * 2 as int?;
      }
    } else {
      if (value["bd_id"] == otherPlayerCO["otherPlayerOpponent"]) {
        strength = strength! + (value["strength"] / 2).round() as int?;
        shooting = shooting! + (value["shooting"] / 2).round() as int?;
        speed = speed! + (value["speed"] / 2).round() as int?;
        dribbling = dribbling! + (value["dribbling"] / 2).round() as int?;
        defense = defense! + (value["defense"] / 2).round() as int?;
        passing = passing! + (value["passing"] / 2).round() as int?;
        rating = rating! + (value["rating"] / 2).round() as int?;
      } else {
        strength = strength! + value["strength"] as int?;
        shooting = shooting! + value["shooting"] as int?;
        speed = speed! + value["speed"] as int?;
        dribbling = dribbling! + value["dribbling"] as int?;
        defense = defense! + value["defense"] as int?;
        passing = passing! + value["passing"] as int?;
        rating = rating! + value["rating"] as int?;
      }
    }
  });

  return {
    "strength": strength,
    "shooting": shooting,
    "speed": speed,
    "dribbling": dribbling,
    "defense": defense,
    "passing": passing,
    "rating": (rating! / 11).round(),
  };
}

calcPointsPlayer1NotConfirm(Map<int, dynamic> selectedPlayers) {
  int? strength = 0;
  int? shooting = 0;
  int? speed = 0;
  int? dribbling = 0;
  int? defense = 0;
  int? passing = 0;
  int? rating = 0;

  selectedPlayers.forEach((key, value) {
    if (value["captain"] == true) {
      strength = strength! + value["strength"] * 2 as int?;
      shooting = shooting! + value["shooting"] * 2 as int?;
      speed = speed! + value["speed"] * 2 as int?;
      dribbling = dribbling! + value["dribbling"] * 2 as int?;
      defense = defense! + value["defense"] * 2 as int?;
      passing = passing! + value["passing"] * 2 as int?;
      rating = rating! + value["rating"] * 2 as int?;
    } else {
      strength = strength! + value["strength"] as int?;
      shooting = shooting! + value["shooting"] as int?;
      speed = speed! + value["speed"] as int?;
      dribbling = dribbling! + value["dribbling"] as int?;
      defense = defense! + value["defense"] as int?;
      passing = passing! + value["passing"] as int?;
      rating = rating! + value["rating"] as int?;
    }
  });

  return {
    "strength": strength,
    "shooting": shooting,
    "speed": speed,
    "dribbling": dribbling,
    "defense": defense,
    "passing": passing,
    "rating": (rating! / 11).round(),
  };
}


// calcPointsPlayer2(
//     Map<int, dynamic> selectedPlayers, Map<String, String> otherPlayerCO) {
//   int? strength = 0;
//   int? shooting = 0;
//   int? speed = 0;
//   int? dribbling = 0;
//   int? defense = 0;
//   int? passing = 0;
//   int? rating = 0;

//   selectedPlayers.forEach((key, value) {
//     if (value["opponent"] == true) {
//       if (value["bd_id"] == otherPlayerCO["otherPlayerCaptain"]) {
//         strength = strength! + value["strength"] as int?;
//         shooting = shooting! + value["shooting"] as int?;
//         speed = speed! + value["speed"] as int?;
//         dribbling = dribbling! + value["dribbling"] as int?;
//         defense = defense! + value["defense"] as int?;
//         passing = passing! + value["passing"] as int?;
//         rating = rating! + value["rating"] as int?;
//       } else {
//         strength = strength! + (value["strength"] / 2).round() as int?;
//         shooting = shooting! + (value["shooting"] / 2).round() as int?;
//         speed = speed! + (value["speed"] / 2).round() as int?;
//         dribbling = dribbling! + (value["dribbling"] / 2).round() as int?;
//         defense = defense! + (value["defense"] / 2).round() as int?;
//         passing = passing! + (value["passing"] / 2).round() as int?;
//         rating = rating! + (value["rating"] / 2).round() as int?;
//       }
//     } else {
//       if (value["bd_id"] == otherPlayerCO["otherPlayerCaptain"]) {
//         strength = strength! + value["strength"] * 2 as int?;
//         shooting = shooting! + value["shooting"] * 2 as int?;
//         speed = speed! + value["speed"] * 2 as int?;
//         dribbling = dribbling! + value["dribbling"] * 2 as int?;
//         defense = defense! + value["defense"] * 2 as int?;
//         passing = passing! + value["passing"] * 2 as int?;
//         rating = rating! + value["rating"] * 2 as int?;
//       } else {
//         strength = strength! + value["strength"] as int?;
//         shooting = shooting! + value["shooting"] as int?;
//         speed = speed! + value["speed"] as int?;
//         dribbling = dribbling! + value["dribbling"] as int?;
//         defense = defense! + value["defense"] as int?;
//         passing = passing! + value["passing"] as int?;
//         rating = rating! + value["rating"] as int?;
//       }
//     }
//   });

//   return {
//     "strength": strength,
//     "shooting": shooting,
//     "speed": speed,
//     "dribbling": dribbling,
//     "defense": defense,
//     "passing": passing,
//     "rating": (rating! / 11).round()
//   };
// }


