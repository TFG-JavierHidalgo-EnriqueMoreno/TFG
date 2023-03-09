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

class SelectPage extends StatefulWidget {
  final Map<String, List<dynamic>> p;

  const SelectPage({super.key, required this.p});

  @override
  SelectPageState createState() {
    return SelectPageState();
  }
}

class SelectPageState extends State<SelectPage> {
  // Create a global key that uniquely identifies the Form widget
  // and allows validation of the form.
  //
  // Note: This is a `GlobalKey<FormState>`,
  // not a GlobalKey<MyCustomFormState>.

  @override
  void initState() {
    super.initState();
    cp = widget.p;
    _assignPlayers(cp);
  }

  late Map<String, List<dynamic>> cp;

  List<dynamic>? g = [];
  List<dynamic>? d = [];
  List<dynamic>? m = [];
  List<dynamic>? f = [];
  List<dynamic>? gc = [];
  List<dynamic>? dc = [];
  List<dynamic>? mc = [];
  List<dynamic>? fc = [];
  int teamValue = globals.userLevel.getTeamValue;

  final _formKey = GlobalKey<FormState>();

  bool _obscureText = true;
  String _password = "";
  List<String> list = <String>['4-4-2', '4-3-3', '5-3-2'];
  String dropdownValue = '4-4-2';
  bool _allSelected = false;
  final Map<int, bool> _selected = {
    0: false,
    1: false,
    2: false,
    3: false,
    4: false,
    5: false,
    6: false,
    7: false,
    8: false,
    9: false,
    10: false
  };

  Map<int, dynamic> _selectedPlayers = {
    0: {},
    1: {},
    2: {},
    3: {},
    4: {},
    5: {},
    6: {},
    7: {},
    8: {},
    9: {},
    10: {},
  };

  bool loaded = false;

  void _assignPlayers(Map<String, List<dynamic>> cp) {
    g = cp["PT"];
    d = cp["DF"];
    m = cp["MC"];
    f = cp["DL"];
    gc = [...?g];
    dc = [...?d];
    mc = [...?m];
    fc = [...?f];
  }

  void _toggle() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  void _changeButton(BuildContext context, bool changed, int key,
      List<dynamic> lp, List<dynamic> lpc, int index) {
    Navigator.pop(context, 'Confirmar');
    if (changed == true) {
      setState(() {
        dynamic player = lpc[index];
        if (_selected[key] == false) {
          _selected.update(key, (value) => !value);
          teamValue = teamValue - player["price"] as int;
        } else {
          teamValue = teamValue + _selectedPlayers[key]["price"] as int;
          teamValue = teamValue - player["price"] as int;
        }
        _selectedPlayers.update(key, (value) => player);
        lpc = [...lp];
        List<int> indexSelected = [];
        _selectedPlayers.forEach((key, value) {
          if (lpc.contains(value)) {
            indexSelected.add(lpc.indexOf(value));
          }
        });

        _allSelected = !(_selected.values.any((element) => element == false));
        indexSelected.sort((b, a) => a.compareTo(b));
        for (var element in indexSelected) {
          lpc.removeAt(element);
        }
        switch (key) {
          case 10:
            gc = lpc;
            break;
          case 6:
          case 7:
          case 8:
          case 9:
            dc = lpc;
            break;
          case 2:
          case 3:
          case 4:
          case 5:
            mc = lpc;
            break;
          case 0:
          case 1:
            fc = lpc;
            break;
          default:
        }
      });
    }
  }

  select(int key, Map<int, bool> selected, BuildContext context,
      List<dynamic>? l, List<dynamic>? lc) {
    showDialog<String>(
      context: context,
      barrierColor: Colors.transparent,
      builder: (BuildContext context) => AlertDialog(
        title: const Text('Selecciona jugador'),
        //content: const Text('Usuario eliminado'),
        actions: <Widget>[
          SingleChildScrollView(
            child: Container(
              height: 300,
              width: 300,
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: lc!.length,
                itemBuilder: ((context, index) {
                  return Container(
                    child: TextButton(
                        style: TextButton.styleFrom(primary: Colors.black),
                        onPressed: () =>
                            _changeButton(context, true, key, l!, lc, index),
                        child: Container(
                          constraints: BoxConstraints(
                            maxHeight: double.infinity,
                          ),
                          decoration: BoxDecoration(
                              color: lc[index]["category"] == 'Gold'
                                  ? Color.fromARGB(255, 240, 203, 82)
                                  : lc[index]["category"] == 'Silver'
                                      ? const Color(0xffc0c0c0)
                                      : Color.fromARGB(255, 179, 107, 36),
                              border:
                                  Border.all(color: Colors.black, width: 1.0)),
                          child: Column(
                            children: <Widget>[
                              Row(
                                children: [
                                  Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Icon(Icons.account_circle, size: 20),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Text(lc[index]["name"],
                                        style: TextStyle(fontSize: 20)),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Text(
                                        lc[index]["price"].toString() + "M",
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
                                          lc[index]["shooting"] < 35
                                              ? Colors.red
                                              : lc[index]["shooting"] < 70
                                                  ? Colors.yellow
                                                  : Colors.green,
                                      child: Center(
                                        child: Text(
                                            lc[index]["shooting"].toString(),
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
                                      backgroundColor: lc[index]["speed"] < 35
                                          ? Colors.red
                                          : lc[index]["speed"] < 70
                                              ? Colors.yellow
                                              : Colors.green,
                                      child: Center(
                                        child: Text(
                                            lc[index]["speed"].toString(),
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
                                          lc[index]["strength"] < 35
                                              ? Colors.red
                                              : lc[index]["strength"] < 70
                                                  ? Colors.yellow
                                                  : Colors.green,
                                      child: Center(
                                        child: Text(
                                            lc[index]["strength"].toString(),
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
                                      backgroundColor: lc[index]["passing"] < 35
                                          ? Colors.red
                                          : lc[index]["passing"] < 70
                                              ? Colors.yellow
                                              : Colors.green,
                                      child: Center(
                                        child: Text(
                                            lc[index]["passing"].toString(),
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
                                          lc[index]["dribbling"] < 35
                                              ? Colors.red
                                              : lc[index]["dribbling"] < 70
                                                  ? Colors.yellow
                                                  : Colors.green,
                                      child: Center(
                                        child: Text(
                                            lc[index]["dribbling"].toString(),
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
                                      backgroundColor: lc[index]["defense"] < 35
                                          ? Colors.red
                                          : lc[index]["defense"] < 70
                                              ? Colors.yellow
                                              : Colors.green,
                                      child: Center(
                                        child: Text(
                                            lc[index]["defense"].toString(),
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
                                      backgroundColor: lc[index]["rating"] < 35
                                          ? Colors.red
                                          : lc[index]["rating"] < 70
                                              ? Colors.yellow
                                              : Colors.green,
                                      child: Center(
                                        child: Text(
                                            lc[index]["rating"].toString(),
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
                                            fontSize: 12, color: Colors.black)),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Text("PAC",
                                        style: TextStyle(
                                            fontSize: 12, color: Colors.black)),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Text("PHY",
                                        style: TextStyle(
                                            fontSize: 12, color: Colors.black)),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Text("PAS",
                                        style: TextStyle(
                                            fontSize: 12, color: Colors.black)),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Text("DRI",
                                        style: TextStyle(
                                            fontSize: 12, color: Colors.black)),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Text("DEF",
                                        style: TextStyle(
                                            fontSize: 12, color: Colors.black)),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Text("TOT",
                                        style: TextStyle(
                                            fontSize: 12, color: Colors.black)),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        )),
                  );
                }),
              ),
            ),
          ),
        ],
      ),
    );
  }

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
            Column(
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    Container(
                      height: 40,
                      padding: const EdgeInsets.all(10),
                      margin: const EdgeInsets.only(
                          left: 0.0, top: 30.0, right: 15.0, bottom: 0.0),
                      decoration: BoxDecoration(
                          color: Colors.white, // Background del seleccionable
                          borderRadius: BorderRadius.circular(10)),
                      child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                        alignment: AlignmentDirectional.topStart,
                        dropdownColor: Colors.white,
                        value: dropdownValue,
                        icon: const Icon(Icons.arrow_downward),
                        elevation: 0,
                        style: const TextStyle(color: Colors.black),
                        onChanged: (String? value) {
                          // This is called when the user selects an item.
                          setState(() {
                            dropdownValue = value!;
                          });
                        },
                        items:
                            list.map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Align(
                                alignment: Alignment.center,
                                child: Text(value)),
                          );
                        }).toList(),
                      )),
                    )
                  ],
                ),
              ],
            ),
            Positioned(
              top: 30,
              left: 10,
              child: Container(
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
                height: 40,
                child: Padding(
                  padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                  child: Center(
                    child: Text(
                      "Presupuesto: " + teamValue.toString() + " M",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          color: teamValue < 0
                              ? Colors.red
                              : teamValue < 100
                                  ? Colors.orange
                                  : Colors.green.shade800),
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: MediaQuery.of(context).size.height - 260,
              left: dropdownValue == "4-3-3"
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
                                  select(0, _selected, context, f, fc),
                                },
                            style: ElevatedButton.styleFrom(
                                side: const BorderSide(
                                  width: 2.5,
                                  color: Colors.white,
                                ),
                                shape: const CircleBorder(),
                                padding: const EdgeInsets.all(20),
                                backgroundColor: Colors.transparent),
                            child: _selected[0] == true
                                ? Icon(Icons.person)
                                : Icon(Icons.add)),
                        Center(
                          child: Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: Text(_selectedPlayers[0]["name"] ?? "",
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
              left: dropdownValue == "4-3-3"
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
                                  select(1, _selected, context, f, fc),
                                },
                            style: ElevatedButton.styleFrom(
                                side: const BorderSide(
                                  width: 2.5,
                                  color: Colors.white,
                                ),
                                shape: const CircleBorder(),
                                padding: const EdgeInsets.all(20),
                                backgroundColor: Colors.transparent),
                            child: _selected[1] == true
                                ? Icon(Icons.person)
                                : Icon(Icons.add)),
                        Center(
                          child: Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: Text(_selectedPlayers[1]["name"] ?? "",
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
              top: dropdownValue == "4-3-3"
                  ? MediaQuery.of(context).size.height - 668
                  : MediaQuery.of(context).size.height - 560,
              left: dropdownValue == "4-3-3"
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
                                  select(2, _selected, context, m, mc),
                                },
                            style: ElevatedButton.styleFrom(
                                side: const BorderSide(
                                  width: 2.5,
                                  color: Colors.white,
                                ),
                                shape: const CircleBorder(),
                                padding: const EdgeInsets.all(20),
                                backgroundColor: Colors.transparent),
                            child: _selected[2] == true
                                ? Icon(Icons.person)
                                : Icon(Icons.add)),
                        Center(
                          child: Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: Text(_selectedPlayers[2]["name"] ?? "",
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
              top: dropdownValue == "4-3-3"
                  ? MediaQuery.of(context).size.height - 560
                  : MediaQuery.of(context).size.height - 490,
              left: dropdownValue == "4-3-3"
                  ? (MediaQuery.of(context).size.width) - 420
                  : dropdownValue == "5-3-2"
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
                                  select(3, _selected, context, m, mc),
                                },
                            style: ElevatedButton.styleFrom(
                                side: const BorderSide(
                                  width: 2.5,
                                  color: Colors.white,
                                ),
                                shape: const CircleBorder(),
                                padding: const EdgeInsets.all(20),
                                backgroundColor: Colors.transparent),
                            child: _selected[3] == true
                                ? Icon(Icons.person)
                                : Icon(Icons.add)),
                        Center(
                          child: Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: Text(_selectedPlayers[3]["name"] ?? "",
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
              top: dropdownValue == "5-3-2"
                  ? MediaQuery.of(context).size.height - 560
                  : MediaQuery.of(context).size.height - 490,
              left: dropdownValue == "4-3-3"
                  ? (MediaQuery.of(context).size.width) - 270
                  : dropdownValue == "5-3-2"
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
                                  select(4, _selected, context, m, mc),
                                },
                            style: ElevatedButton.styleFrom(
                                side: const BorderSide(
                                  width: 2.5,
                                  color: Colors.white,
                                ),
                                shape: const CircleBorder(),
                                padding: const EdgeInsets.all(20),
                                backgroundColor: Colors.transparent),
                            child: _selected[4] == true
                                ? Icon(Icons.person)
                                : Icon(Icons.add)),
                        Center(
                          child: Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: Text(_selectedPlayers[4]["name"] ?? "",
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
              top: dropdownValue == "5-3-2"
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
                                  select(5, _selected, context, m, mc),
                                },
                            style: ElevatedButton.styleFrom(
                                side: const BorderSide(
                                  width: 2.5,
                                  color: Colors.white,
                                ),
                                shape: const CircleBorder(),
                                padding: const EdgeInsets.all(20),
                                backgroundColor: Colors.transparent),
                            child: _selected[5] == true
                                ? Icon(Icons.person)
                                : Icon(Icons.add)),
                        Center(
                          child: Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: Text(_selectedPlayers[5]["name"] ?? "",
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
              top: dropdownValue == "5-3-2"
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
                                  select(6, _selected, context, d, dc),
                                },
                            style: ElevatedButton.styleFrom(
                                side: const BorderSide(
                                  width: 2.5,
                                  color: Colors.white,
                                ),
                                shape: const CircleBorder(),
                                padding: const EdgeInsets.all(20),
                                backgroundColor: Colors.transparent),
                            child: _selected[6] == true
                                ? Icon(Icons.person)
                                : Icon(Icons.add)),
                        Center(
                          child: Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: Text(_selectedPlayers[6]["name"] ?? "",
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
              top: dropdownValue == "5-3-2"
                  ? MediaQuery.of(context).size.height - 350
                  : MediaQuery.of(context).size.height - 300,
              left: dropdownValue == "5-3-2"
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
                                  select(7, _selected, context, d, dc),
                                },
                            style: ElevatedButton.styleFrom(
                                side: const BorderSide(
                                  width: 2.5,
                                  color: Colors.white,
                                ),
                                shape: const CircleBorder(),
                                padding: const EdgeInsets.all(20),
                                backgroundColor: Colors.transparent),
                            child: _selected[7] == true
                                ? Icon(Icons.person)
                                : Icon(Icons.add)),
                        Center(
                          child: Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: Text(_selectedPlayers[7]["name"] ?? "",
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
              left: dropdownValue == "5-3-2"
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
                                  select(8, _selected, context, d, dc),
                                },
                            style: ElevatedButton.styleFrom(
                                side: const BorderSide(
                                  width: 2.5,
                                  color: Colors.white,
                                ),
                                shape: const CircleBorder(),
                                padding: const EdgeInsets.all(20),
                                backgroundColor: Colors.transparent),
                            child: _selected[8] == true
                                ? Icon(Icons.person)
                                : Icon(Icons.add)),
                        Center(
                          child: Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: Text(_selectedPlayers[8]["name"] ?? "",
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
              top: dropdownValue == "5-3-2"
                  ? MediaQuery.of(context).size.height - 350
                  : MediaQuery.of(context).size.height - 370,
              left: dropdownValue == "5-3-2"
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
                                  select(9, _selected, context, d, dc),
                                },
                            style: ElevatedButton.styleFrom(
                                side: const BorderSide(
                                  width: 2.5,
                                  color: Colors.white,
                                ),
                                shape: const CircleBorder(),
                                padding: const EdgeInsets.all(20),
                                backgroundColor: Colors.transparent),
                            child: _selected[9] == true
                                ? Icon(Icons.person)
                                : Icon(Icons.add)),
                        Center(
                          child: Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: Text(_selectedPlayers[9]["name"] ?? "",
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
                                  select(10, _selected, context, g, gc),
                                },
                            style: ElevatedButton.styleFrom(
                                side: const BorderSide(
                                  width: 2.5,
                                  color: Colors.white,
                                ),
                                shape: const CircleBorder(),
                                padding: const EdgeInsets.all(20),
                                backgroundColor: Colors.transparent),
                            child: _selected[10] == true
                                ? Icon(Icons.person)
                                : Icon(Icons.add)),
                        Center(
                          child: Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: Text(_selectedPlayers[10]["name"] ?? "",
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
              child: _allSelected == true && teamValue >= 0
                  ? ElevatedButton(
                      onPressed: () {
                        confirm(context, _selectedPlayers);
                        setState(() {});
                      },
                      child: Text('Confirmar'))
                  : Visibility(
                      child: ElevatedButton(
                        onPressed: () {},
                        child: Text(''),
                      ),
                      visible: false,
                    ),
            ),
          ],
        )),
      ),
    );
  }
}

// TODO: BOTON DE CONFIRMAR
// Row(
//   mainAxisAlignment: MainAxisAlignment.end,
//   children: [
//     Padding(
//       padding: const EdgeInsets.only(left: 260.0),
//       child: _allSelected == true
//           ? ElevatedButton(
//               onPressed: () {
//                 confirm(context);
//                 setState(() {});
//               },
//               child: Text('Confirmar'))
//           : Visibility(
//               child: ElevatedButton(
//                 onPressed: () {},
//                 child: Text(''),
//               ),
//               visible: false,
//             ),
//     ),
//   ],
// ),

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

confirm(BuildContext context, Map<int, dynamic> selectedPlayers) {
  readyPlayer();
  Lineup lineup = Lineup();
  lineup.newLineup("4-4-2", "5-3-2");
  saveUserPlayer(lineup, selectedPlayers);
  Timer? t;
  t = Timer.periodic(Duration(milliseconds: 500), (Timer t) async {
    if (await checkOtherPlayerStatus() == "ready") {
      var player2Players = getPlayer2Players();
      inspect(player2Players);
      t.cancel();
    }
  });
  // Map<String, int> player2Points = {
  //   "strength": 600,
  //   "shooting": 750,
  //   "speed": 770,
  //   "dribbling": 610,
  //   "defense": 780,
  //   "passing": 400,
  //   "rating": 80,
  // };
  // Map<String, int?> player1Points = calcPoints(selectedPlayers);
  // Map<String, int> gameResult = calcResult(player1Points, player2Points);
  // saveGame(gameResult["player1Goals"], gameResult["player2Goals"]);
  // calcElo(
  //     gameResult["player1Goals"]! > gameResult["player2Goals"]! ? true : false);
  // Navigator.of(context).push(MaterialPageRoute(
  //     builder: (context) => ResultPage(
  //         player1Points: player1Points,
  //         player2Points: player2Points,
  //         gameResult: gameResult)));
}

calcPoints(Map<int, dynamic> selectedPlayers) {
  int? strength = 0;
  int? shooting = 0;
  int? speed = 0;
  int? dribbling = 0;
  int? defense = 0;
  int? passing = 0;
  int? rating = 0;
  selectedPlayers.forEach((key, value) {
    strength = (strength! + value["strength"]) as int?;
    shooting = (shooting! + value["shooting"]) as int?;
    speed = (speed! + value["speed"]) as int?;
    dribbling = (dribbling! + value["dribbling"]) as int?;
    defense = (defense! + value["defense"]) as int?;
    passing = (passing! + value["passing"]) as int?;
    rating = (rating! + value["rating"]) as int?;
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

calcResult(Map<String, int?> player1Points, Map<String, int> player2Points) {
  int player1Goals = 0;
  int player2Goals = 0;
  player1Points.forEach((key, value) {
    if (value! > player2Points[key]!) {
      player1Goals++;
    } else {
      player2Goals++;
    }
  });
  return {
    "player1Goals": player1Goals,
    "player2Goals": player2Goals,
  };
}
