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

  final _formKey = GlobalKey<FormState>();

  bool _obscureText = true;
  String _password = "";
  List<String> list = <String>['4-4-2', '4-3-3', '5-3-2', '5-4-1'];
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

  bool loaded = false;

  void _assignPlayers(Map<String, List<dynamic>> cp) {
    inspect(cp);
    g = cp["PT"];
    d = cp["DF"];
    m = cp["MC"];
    f = cp["DL"];
    inspect(g);
  }

  void _toggle() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  void _changeButton(BuildContext context, bool changed, int key) {
    Navigator.pop(context, 'Confirmar');
    if (changed == true && _selected[key] == false) {
      setState(() {
        _selected.update(key, (value) => !value);
        _allSelected = !(_selected.values.any((element) => element == false));
      });
    }
  }

  select(int key, Map<int, bool> selected, BuildContext context,
      List<dynamic>? l) {
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
                itemCount: l!.length,
                itemBuilder: ((context, index) {
                  return Container(
                    child: TextButton(
                        style: TextButton.styleFrom(primary: Colors.black),
                        onPressed: () => _changeButton(context, true, key),
                        child: Container(
                          constraints: BoxConstraints(
                            maxHeight: double.infinity,
                          ),
                          decoration: BoxDecoration(
                              color: Colors.amber,
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
                                    child: Text(l[index]["name"],
                                        style: TextStyle(fontSize: 20)),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Text(
                                        l[index]["price"].toString() + "M",
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
                                      backgroundColor: l[index]["shooting"] < 35
                                          ? Colors.red
                                          : l[index]["shooting"] < 70
                                              ? Colors.yellow
                                              : Colors.green,
                                      child: Center(
                                        child: Text(
                                            l[index]["shooting"].toString(),
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
                                      backgroundColor: l[index]["speed"] < 35
                                          ? Colors.red
                                          : l[index]["speed"] < 70
                                              ? Colors.yellow
                                              : Colors.green,
                                      child: Center(
                                        child: Text(
                                            l[index]["speed"].toString(),
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
                                      backgroundColor: l[index]["strength"] < 35
                                          ? Colors.red
                                          : l[index]["strength"] < 70
                                              ? Colors.yellow
                                              : Colors.green,
                                      child: Center(
                                        child: Text(
                                            l[index]["strength"].toString(),
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
                                      backgroundColor: l[index]["passing"] < 35
                                          ? Colors.red
                                          : l[index]["passing"] < 70
                                              ? Colors.yellow
                                              : Colors.green,
                                      child: Center(
                                        child: Text(
                                            l[index]["passing"].toString(),
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
                                          l[index]["dribbling"] < 35
                                              ? Colors.red
                                              : l[index]["dribbling"] < 70
                                                  ? Colors.yellow
                                                  : Colors.green,
                                      child: Center(
                                        child: Text(
                                            l[index]["dribbling"].toString(),
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
                                      backgroundColor: l[index]["defense"] < 35
                                          ? Colors.red
                                          : l[index]["defense"] < 70
                                              ? Colors.yellow
                                              : Colors.green,
                                      child: Center(
                                        child: Text(
                                            l[index]["defense"].toString(),
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
                                      backgroundColor: l[index]["rating"] < 35
                                          ? Colors.red
                                          : l[index]["rating"] < 70
                                              ? Colors.yellow
                                              : Colors.green,
                                      child: Center(
                                        child: Text(
                                            l[index]["rating"].toString(),
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
            Padding(
              padding: const EdgeInsets.only(top: 75.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          Column(
                            children: <Widget>[
                              ElevatedButton(
                                  onPressed: () => {
                                        select(0, _selected, context, f),
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
                                      : Icon(Icons.add))
                            ],
                          ),
                          Column(
                            children: <Widget>[
                              ElevatedButton(
                                  onPressed: () => {
                                        select(1, _selected, context, f),
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
                                      : Icon(Icons.add))
                            ],
                          ),
                        ]),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.only(bottom: 60.0),
                            child: Column(
                              children: <Widget>[
                                ElevatedButton(
                                    onPressed: () => {
                                          select(2, _selected, context, m),
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
                                        : Icon(Icons.add))
                              ],
                            ),
                          ),
                          Column(
                            children: <Widget>[
                              ElevatedButton(
                                  onPressed: () => {
                                        select(3, _selected, context, m),
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
                                      : Icon(Icons.add))
                            ],
                          ),
                          Column(
                            children: <Widget>[
                              ElevatedButton(
                                  onPressed: () => {
                                        select(4, _selected, context, m),
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
                                      : Icon(Icons.add))
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 60.0),
                            child: Column(
                              children: <Widget>[
                                ElevatedButton(
                                    onPressed: () => {
                                          select(5, _selected, context, m),
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
                                        : Icon(Icons.add))
                              ],
                            ),
                          ),
                        ]),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.only(bottom: 60.0),
                            child: Column(
                              children: <Widget>[
                                ElevatedButton(
                                    onPressed: () => {
                                          select(6, _selected, context, d),
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
                                        : Icon(Icons.add))
                              ],
                            ),
                          ),
                          Column(
                            children: <Widget>[
                              ElevatedButton(
                                  onPressed: () => {
                                        select(7, _selected, context, d),
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
                                      : Icon(Icons.add))
                            ],
                          ),
                          Column(
                            children: <Widget>[
                              ElevatedButton(
                                  onPressed: () => {
                                        select(8, _selected, context, d),
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
                                      : Icon(Icons.add))
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 60.0),
                            child: Column(
                              children: <Widget>[
                                ElevatedButton(
                                    onPressed: () => {
                                          select(9, _selected, context, d),
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
                                        : Icon(Icons.add))
                              ],
                            ),
                          ),
                        ]),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 30.0),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: <Widget>[
                          Column(
                            children: <Widget>[
                              ElevatedButton(
                                  onPressed: () => {
                                        select(10, _selected, context, g),
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
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(left: 260.0),
                                    child: _allSelected == true
                                        ? ElevatedButton(
                                            onPressed: () {
                                              confirm(context);
                                              setState(() {});
                                            },
                                            child: Text('Confirmar'))
                                        : Padding(
                                            padding: const EdgeInsets.only(
                                                top: 49.0),
                                            child: Visibility(
                                              child: ElevatedButton(
                                                onPressed: () {},
                                                child: Text(''),
                                              ),
                                              visible: false,
                                            ),
                                          ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ]),
                  ),
                ],
              ),
            ),
          ],
        )),
      ),
    );
  }
}

// getPlayersByPosition() {
//   Future<Map<String, List>> randomPlayers = getRandomPlayers();
//   randomPlayers.then((value) {
//   })
// }

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

confirm(BuildContext context) {
  Lineup lineup = Lineup();
  lineup.newLineup("4-4-2", "5-3-2");
  saveGame(3, 2, lineup);
  calcElo(true);
  Navigator.of(context).pushReplacement(
    FadePageRoute(
      builder: (context) => const ResultPage(),
    ),
  );
}
