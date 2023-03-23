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
import 'package:my_app/screens/selectRival_page.dart';
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
        if (dropdownValue == '4-4-2') {
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
        } else if (dropdownValue == '4-3-3') {
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
            case 3:
            case 4:
            case 5:
              mc = lpc;
              break;
            case 0:
            case 1:
            case 2:
              fc = lpc;
              break;
            default:
          }
        } else {
          switch (key) {
            case 10:
              gc = lpc;
              break;
            case 5:
            case 6:
            case 7:
            case 8:
            case 9:
              dc = lpc;
              break;
            case 2:
            case 3:
            case 4:
              mc = lpc;
              break;
            case 0:
            case 1:
              fc = lpc;
              break;
            default:
          }
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

  select_captain(BuildContext context) {
    showDialog<String>(
      context: context,
      barrierColor: Colors.transparent,
      builder: (BuildContext context) => AlertDialog(
        title: const Text('Selecciona Capitán'),
        //content: const Text('Usuario eliminado'),
        actions: <Widget>[
          SingleChildScrollView(
            child: Container(
              height: 300,
              width: 300,
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: _selectedPlayers.length,
                itemBuilder: ((context, index) {
                  if (_selectedPlayers[index]["name"] != null) {
                    return Container(
                      child: TextButton(
                          style: TextButton.styleFrom(primary: Colors.black),
                          onPressed: () => _changeCaptain(context, index),
                          child: Container(
                            constraints: BoxConstraints(
                              maxHeight: double.infinity,
                            ),
                            decoration: BoxDecoration(
                                color: _selectedPlayers[index]["category"] ==
                                        'Gold'
                                    ? Color.fromARGB(255, 240, 203, 82)
                                    : _selectedPlayers[index]["category"] ==
                                            'Silver'
                                        ? const Color(0xffc0c0c0)
                                        : Color.fromARGB(255, 179, 107, 36),
                                border: Border.all(
                                    color: Colors.black, width: 1.0)),
                            child: Column(
                              children: <Widget>[
                                Row(
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.all(8.0),
                                      child:
                                          Icon(Icons.account_circle, size: 20),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.all(8.0),
                                      child: Text(
                                          _selectedPlayers[index]["name"],
                                          style: TextStyle(fontSize: 20)),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.all(8.0),
                                      child: Text(
                                          _selectedPlayers[index]["price"]
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
                                        backgroundColor: _selectedPlayers[index]
                                                    ["shooting"] <
                                                35
                                            ? Colors.red
                                            : _selectedPlayers[index]
                                                        ["shooting"] <
                                                    70
                                                ? Colors.yellow
                                                : Colors.green,
                                        child: Center(
                                          child: Text(
                                              _selectedPlayers[index]
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
                                        backgroundColor: _selectedPlayers[index]
                                                    ["speed"] <
                                                35
                                            ? Colors.red
                                            : _selectedPlayers[index]["speed"] <
                                                    70
                                                ? Colors.yellow
                                                : Colors.green,
                                        child: Center(
                                          child: Text(
                                              _selectedPlayers[index]["speed"]
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
                                        backgroundColor: _selectedPlayers[index]
                                                    ["strength"] <
                                                35
                                            ? Colors.red
                                            : _selectedPlayers[index]
                                                        ["strength"] <
                                                    70
                                                ? Colors.yellow
                                                : Colors.green,
                                        child: Center(
                                          child: Text(
                                              _selectedPlayers[index]
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
                                        backgroundColor: _selectedPlayers[index]
                                                    ["passing"] <
                                                35
                                            ? Colors.red
                                            : _selectedPlayers[index]
                                                        ["passing"] <
                                                    70
                                                ? Colors.yellow
                                                : Colors.green,
                                        child: Center(
                                          child: Text(
                                              _selectedPlayers[index]["passing"]
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
                                        backgroundColor: _selectedPlayers[index]
                                                    ["dribbling"] <
                                                35
                                            ? Colors.red
                                            : _selectedPlayers[index]
                                                        ["dribbling"] <
                                                    70
                                                ? Colors.yellow
                                                : Colors.green,
                                        child: Center(
                                          child: Text(
                                              _selectedPlayers[index]
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
                                        backgroundColor: _selectedPlayers[index]
                                                    ["defense"] <
                                                35
                                            ? Colors.red
                                            : _selectedPlayers[index]
                                                        ["defense"] <
                                                    70
                                                ? Colors.yellow
                                                : Colors.green,
                                        child: Center(
                                          child: Text(
                                              _selectedPlayers[index]["defense"]
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
                                        backgroundColor: _selectedPlayers[index]
                                                    ["rating"] <
                                                35
                                            ? Colors.red
                                            : _selectedPlayers[index]
                                                        ["rating"] <
                                                    70
                                                ? Colors.yellow
                                                : Colors.green,
                                        child: Center(
                                          child: Text(
                                              _selectedPlayers[index]["rating"]
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
                          )),
                    );
                  } else {
                    return Visibility(
                      child: ElevatedButton(
                        onPressed: () {},
                        child: Text(''),
                      ),
                      visible: false,
                    );
                  }
                }),
              ),
            ),
          ),
        ],
      ),
    );
  }

  checkPlayerPositions() {
    switch (dropdownValue) {
      case "4-4-2":
        if (_selected[2] == true) {
          if (_selectedPlayers[2]['position'] != 'MC') {
            teamValue = teamValue + _selectedPlayers[2]["price"] as int;
            fc?.add(_selectedPlayers[2]);
            fc?.sort((b, a) => a['price'].compareTo(b['price']));
            _selectedPlayers[2] = {};
            _selected[2] = false;
            _allSelected = false;
          }
        }
        if (_selected[5] == true) {
          if (_selectedPlayers[5]['position'] != 'MC') {
            teamValue = teamValue + _selectedPlayers[5]["price"] as int;
            dc?.add(_selectedPlayers[5]);
            dc?.sort((b, a) => a['price'].compareTo(b['price']));
            _selectedPlayers[5] = {};
            _selected[5] = false;
            _allSelected = false;
          }
        }
        break;
      case "4-3-3":
        if (_selected[2] == true) {
          if (_selectedPlayers[2]['position'] != 'DL') {
            teamValue = teamValue + _selectedPlayers[2]["price"] as int;
            mc?.add(_selectedPlayers[2]);
            mc?.sort((b, a) => a['price'].compareTo(b['price']));
            _selectedPlayers[2] = {};
            _selected[2] = false;
            _allSelected = false;
          }
        }
        if (_selected[5] == true) {
          if (_selectedPlayers[5]['position'] != 'MC') {
            teamValue = teamValue + _selectedPlayers[5]["price"] as int;
            dc?.add(_selectedPlayers[5]);
            dc?.sort((b, a) => a['price'].compareTo(b['price']));
            _selectedPlayers[5] = {};
            _selected[5] = false;
            _allSelected = false;
          }
        }
        break;
      case "5-3-2":
        if (_selected[2] == true) {
          if (_selectedPlayers[2]['position'] != 'MC') {
            teamValue = teamValue + _selectedPlayers[2]["price"] as int;
            fc?.add(_selectedPlayers[2]);
            fc?.sort((b, a) => a['price'].compareTo(b['price']));
            _selectedPlayers[2] = {};
            _selected[2] = false;
            _allSelected = false;
          }
        }
        if (_selected[5] == true) {
          if (_selectedPlayers[5]['position'] != 'DF') {
            teamValue = teamValue + _selectedPlayers[5]["price"] as int;
            mc?.add(_selectedPlayers[5]);
            mc?.sort((b, a) => a['price'].compareTo(b['price']));
            _selectedPlayers[5] = {};
            _selected[5] = false;
            _allSelected = false;
          }
        }
        break;
      default:
    }
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
                            checkPlayerPositions();
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
                            child: Text(
                                _selectedPlayers[0]["name"] != null &&
                                        _selectedPlayers[0]["captain"] == true
                                    ? "${_selectedPlayers[0]["name"]} (C)"
                                    : _selectedPlayers[0]["name"] ?? "",
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
                            child: Text(
                                _selectedPlayers[1]["name"] != null &&
                                        _selectedPlayers[1]["captain"] == true
                                    ? "${_selectedPlayers[1]["name"]} (C)"
                                    : _selectedPlayers[1]["name"] ?? "",
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
                  ? MediaQuery.of(context).size.height - 667
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
                                  dropdownValue == "4-3-3"
                                      ? select(2, _selected, context, f, fc)
                                      : select(2, _selected, context, m, mc),
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
                            child: Text(
                                _selectedPlayers[2]["name"] != null &&
                                        _selectedPlayers[2]["captain"] == true
                                    ? "${_selectedPlayers[2]["name"]} (C)"
                                    : _selectedPlayers[2]["name"] ?? "",
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
                            child: Text(
                                _selectedPlayers[3]["name"] != null &&
                                        _selectedPlayers[3]["captain"] == true
                                    ? "${_selectedPlayers[3]["name"]} (C)"
                                    : _selectedPlayers[3]["name"] ?? "",
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
                            child: Text(
                                _selectedPlayers[4]["name"] != null &&
                                        _selectedPlayers[4]["captain"] == true
                                    ? "${_selectedPlayers[4]["name"]} (C)"
                                    : _selectedPlayers[4]["name"] ?? "",
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
                                  dropdownValue == '5-3-2'
                                      ? select(5, _selected, context, d, dc)
                                      : select(5, _selected, context, m, mc),
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
                            child: Text(
                                _selectedPlayers[5]["name"] != null &&
                                        _selectedPlayers[5]["captain"] == true
                                    ? "${_selectedPlayers[5]["name"]} (C)"
                                    : _selectedPlayers[5]["name"] ?? "",
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
                            child: Text(
                                _selectedPlayers[6]["name"] != null &&
                                        _selectedPlayers[6]["captain"] == true
                                    ? "${_selectedPlayers[6]["name"]} (C)"
                                    : _selectedPlayers[6]["name"] ?? "",
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
                            child: Text(
                                _selectedPlayers[7]["name"] != null &&
                                        _selectedPlayers[7]["captain"] == true
                                    ? "${_selectedPlayers[7]["name"]} (C)"
                                    : _selectedPlayers[7]["name"] ?? "",
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
                            child: Text(
                                _selectedPlayers[8]["name"] != null &&
                                        _selectedPlayers[8]["captain"] == true
                                    ? "${_selectedPlayers[8]["name"]} (C)"
                                    : _selectedPlayers[8]["name"] ?? "",
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
                            child: Text(
                                _selectedPlayers[9]["name"] != null &&
                                        _selectedPlayers[9]["captain"] == true
                                    ? "${_selectedPlayers[9]["name"]} (C)"
                                    : _selectedPlayers[9]["name"] ?? "",
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
                            child: Text(
                                _selectedPlayers[10]["name"] != null &&
                                        _selectedPlayers[10]["captain"] == true
                                    ? "${_selectedPlayers[10]["name"]} (C)"
                                    : _selectedPlayers[10]["name"] ?? "",
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
                        confirm(context, _selectedPlayers, dropdownValue);
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
            Positioned(
              top: MediaQuery.of(context).size.height - 150,
              right: (MediaQuery.of(context).size.width) - 130,
              child: _selected.entries.any((element) => element.value == true)
                  ? ElevatedButton(
                      onPressed: () {
                        select_captain(context);
                        setState(() {});
                      },
                      child: Text('Elegir capitán'))
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

  _changeCaptain(BuildContext context, int index) {
    Navigator.pop(context, 'Confirmar');
    setState(() {
      _selectedPlayers.forEach((key, value) {
        _selectedPlayers[key]["captain"] = false;
      });
      _selectedPlayers[index]["captain"] = true;
    });
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

confirm(BuildContext context, Map<int, dynamic> selectedPlayers, String dropdownValue) {
  saveUserPlayer(selectedPlayers);
  readyPlayer();
  Timer? t;
  var player2Players = [];
  var otherPlayerLineup = "";
  t = Timer.periodic(Duration(milliseconds: 500), (Timer t) async {
    if (await checkOtherPlayerStatus() == "ready") {
      Timer(Duration(seconds: 3), (() async {
        player2Players = await getPlayer2Players();
      }));
      Timer(Duration(seconds: 4), (() async {
        otherPlayerLineup = await getOtherPlayerLineup(player2Players);
      }));
      Timer(Duration(seconds: 5), (() async {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => SelectRivalPage(
                  selectedLineup: dropdownValue,
                  selectedPlayers: selectedPlayers,
                  playersOthers: player2Players,
                  lineup: otherPlayerLineup,
                )));
      }));

      t.cancel();
    }
  });
  

}

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
