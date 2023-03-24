import 'dart:async';
import 'dart:core';
import 'dart:developer';
import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:my_app/entities/lineup.dart';
import 'package:my_app/screens/result_page.dart';
import 'package:my_app/routes/custom_route.dart';
import 'package:my_app/services/api_service.dart';
import 'package:my_app/services/firebase_service.dart';
import 'home_page.dart';

import 'package:my_app/entities/globals.dart' as globals;

class SelectRivalPage extends StatefulWidget {
  final Map<int, dynamic> selectedPlayers;
  final String selectedLineup;
  final List<dynamic> playersOthers;
  final String lineup;

  const SelectRivalPage(
      {super.key,
      required this.selectedLineup,
      required this.selectedPlayers,
      required this.playersOthers,
      required this.lineup});

  @override
  SelectRivalPageState createState() {
    return SelectRivalPageState();
  }
}

class SelectRivalPageState extends State<SelectRivalPage> {
  @override
  void initState() {
    super.initState();

    po = widget.playersOthers;

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

    l = widget.lineup;
    sp = widget.selectedPlayers;
    sl = widget.selectedLineup;
  }

  List<dynamic> po = [];
  String l = "";
  List<dynamic> dl = [];
  List<dynamic> df = [];
  List<dynamic> mc = [];
  List<dynamic> pt = [];
  List<dynamic> cp = [];
  Map<int, dynamic> sp = {};
  String sl = "";

  @override
  Widget build(BuildContext context) {
    const appTitle = 'Selecciona oponente';
    return MaterialApp(
      title: appTitle,
      home: Scaffold(
        drawer: _getDrawer(context),
        appBar: AppBar(
          title: const Text(appTitle),
        ),
        body: Scaffold(
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
            Positioned(
              bottom: MediaQuery.of(context).size.height - 260,
              left: l == "4-3-3"
                  ? (MediaQuery.of(context).size.width) - 385
                  : (MediaQuery.of(context).size.width) - 335,
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
              bottom: MediaQuery.of(context).size.height - 260,
              left: l == "4-3-3"
                  ? (MediaQuery.of(context).size.width) - 270
                  : (MediaQuery.of(context).size.width) - 210,
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
              top: l == "4-3-3"
                  ? MediaQuery.of(context).size.height - 667
                  : MediaQuery.of(context).size.height - 560,
              left: l == "4-3-3"
                  ? (MediaQuery.of(context).size.width) - 155
                  : (MediaQuery.of(context).size.width) - 420,
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
              top: l == "4-3-3"
                  ? MediaQuery.of(context).size.height - 560
                  : MediaQuery.of(context).size.height - 490,
              left: l == "4-3-3"
                  ? (MediaQuery.of(context).size.width) - 420
                  : l == "5-3-2"
                      ? (MediaQuery.of(context).size.width) - 270
                      : (MediaQuery.of(context).size.width) - 335,
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
              top: l == "5-3-2"
                  ? MediaQuery.of(context).size.height - 560
                  : MediaQuery.of(context).size.height - 490,
              left: l == "4-3-3"
                  ? (MediaQuery.of(context).size.width) - 270
                  : l == "5-3-2"
                      ? (MediaQuery.of(context).size.width) - 125
                      : (MediaQuery.of(context).size.width) - 210,
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
              top: l == "5-3-2"
                  ? MediaQuery.of(context).size.height - 450
                  : MediaQuery.of(context).size.height - 560,
              left: (MediaQuery.of(context).size.width) - 125,
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
              top: l == "5-3-2"
                  ? MediaQuery.of(context).size.height - 450
                  : MediaQuery.of(context).size.height - 370,
              left: (MediaQuery.of(context).size.width) - 420,
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
              top: l == "5-3-2"
                  ? MediaQuery.of(context).size.height - 350
                  : MediaQuery.of(context).size.height - 300,
              left: l == "5-3-2"
                  ? (MediaQuery.of(context).size.width) - 380
                  : (MediaQuery.of(context).size.width) - 335,
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
              top: MediaQuery.of(context).size.height - 300,
              left: l == "5-3-2"
                  ? (MediaQuery.of(context).size.width / 2) - 75
                  : (MediaQuery.of(context).size.width) - 210,
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
              top: l == "5-3-2"
                  ? MediaQuery.of(context).size.height - 350
                  : MediaQuery.of(context).size.height - 370,
              left: l == "5-3-2"
                  ? (MediaQuery.of(context).size.width) - 165
                  : (MediaQuery.of(context).size.width) - 125,
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
              top: MediaQuery.of(context).size.height - 200,
              left: (MediaQuery.of(context).size.width / 2) - 75,
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
            Positioned(
                top: MediaQuery.of(context).size.height - 150,
                left: (MediaQuery.of(context).size.width) - 110,
                child: ElevatedButton(
                    onPressed: () {
                      confirmOpponent(context, sp, cp, l, sl);
                      setState(() {});
                    },
                    child: Text('Confirmar'))),
          ],
        )),
      ),
    );
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

  selectOpponent(int i) {
    cp.forEach((element) {
      element["opponent"] = false;
    });
    cp[i]["opponent"] = true;
    setState(() {});
  }
}

confirmOpponent(BuildContext context, Map<int, dynamic> selectedPlayers,
    List<dynamic> cp, String otherLineup, String selectedLineup) {
  Map<int, dynamic> otherPlayers = {};
  for (var i = 0; i < cp.length; i++) {
    otherPlayers.putIfAbsent(i, () => cp[i]);
  }
  updateOpponent(otherPlayers);
  confirmedPlayer();
  Timer? t;
  t = Timer.periodic(Duration(milliseconds: 500), (Timer t) async {
    if (await checkOtherPlayerStatus() == "confirmed") {
      var player2 = await getPlayer2();
      Lineup lineup = Lineup();
      lineup.newLineup(selectedLineup, otherLineup);
      Map<String, String> otherPlayerCO = await getOtherPlayerCO();
      Map<String, int?> player1Points =
          calcPointsPlayer1(selectedPlayers, otherPlayerCO);
      Map<String, int?> player2Points =
          calcPointsPlayer2(otherPlayers, otherPlayerCO);
      Map<String, int> gameResult = calcResult(player1Points, player2Points);
      saveGame(gameResult["player1Goals"], gameResult["player2Goals"]);
      calcElo(gameResult["player1Goals"]! > gameResult["player2Goals"]!
          ? true
          : false);
      Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => ResultPage(
              player1Points: player1Points,
              player2Points: player2Points,
              gameResult: gameResult,
              player2: player2)));
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
      if (value["bd_id"] == otherPlayerCO["opponent"]) {
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
      if (value["bd_id"] == otherPlayerCO["opponent"]) {
        strength = strength! + value["strength"] / 2 as int?;
        shooting = shooting! + value["shooting"] / 2 as int?;
        speed = speed! + value["speed"] / 2 as int?;
        dribbling = dribbling! + value["dribbling"] / 2 as int?;
        defense = defense! + value["defense"] / 2 as int?;
        passing = passing! + value["passing"] / 2 as int?;
        rating = rating! + value["rating"] / 2 as int?;
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
    "rating": (rating! / 11).round()
  };
}

calcPointsPlayer2(
    Map<int, dynamic> selectedPlayers, Map<String, String> otherPlayerCO) {
  int? strength = 0;
  int? shooting = 0;
  int? speed = 0;
  int? dribbling = 0;
  int? defense = 0;
  int? passing = 0;
  int? rating = 0;
  selectedPlayers.forEach((key, value) {
    if (value["opponent"] == true) {
      if (value["bd_id"] == otherPlayerCO["captain"]) {
        strength = strength! + value["strength"] as int?;
        shooting = shooting! + value["shooting"] as int?;
        speed = speed! + value["speed"] as int?;
        dribbling = dribbling! + value["dribbling"] as int?;
        defense = defense! + value["defense"] as int?;
        passing = passing! + value["passing"] as int?;
        rating = rating! + value["rating"] as int?;
      } else {
        strength = strength! + value["strength"] / 2 as int?;
        shooting = shooting! + value["shooting"] / 2 as int?;
        speed = speed! + value["speed"] / 2 as int?;
        dribbling = dribbling! + value["dribbling"] / 2 as int?;
        defense = defense! + value["defense"] / 2 as int?;
        passing = passing! + value["passing"] / 2 as int?;
        rating = rating! + value["rating"] / 2 as int?;
      }
    } else {
      if (value["bd_id"] == otherPlayerCO["captain"]) {
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
    }
  });

  return {
    "strength": strength,
    "shooting": shooting,
    "speed": speed,
    "dribbling": dribbling,
    "defense": defense,
    "passing": passing,
    "rating": (rating! / 11).round()
  };
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
