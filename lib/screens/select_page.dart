import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:my_app/entities/EditData.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:my_app/entities/user.dart';
import 'dart:async';
import 'package:my_app/routes/custom_route.dart';
import 'home_page.dart';
import 'package:my_app/entities/globals.dart' as globals;

import 'login_page.dart';

List<String> lista = ["pepe", "manuel", "quique", "juan"];

class SelectPage extends StatelessWidget {
  const SelectPage({super.key});

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
        body: const SelectPageForm(),
      ),
    );
  }
}

class SelectPageForm extends StatefulWidget {
  const SelectPageForm({super.key});

  @override
  SelectPageFormState createState() {
    return SelectPageFormState();
  }
}

class SelectPageFormState extends State<SelectPageForm> {
  // Create a global key that uniquely identifies the Form widget
  // and allows validation of the form.
  //
  // Note: This is a `GlobalKey<FormState>`,
  // not a GlobalKey<MyCustomFormState>.
  final _formKey = GlobalKey<FormState>();

  bool _obscureText = true;
  String _password = "";
  List<String> list = <String>['4-4-2', '4-3-3', '5-3-2', '5-4-1'];
  String dropdownValue = '5-4-1';
  Map<int, bool> selected = {
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
    10: false,
    11: false
  };
  bool changed = false;

  void _toggle() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  @override
  Widget build(BuildContext context) {
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
                    items: list.map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Align(
                            alignment: Alignment.center, child: Text(value)),
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
                              onPressed: () async => {
                                    await select(0, selected, context, changed),
                                    setState(() {
                                      if (changed == true) {
                                        selected.update(0, (value) => !value);
                                      }
                                    })
                                  },
                              style: ElevatedButton.styleFrom(
                                  side: const BorderSide(
                                    width: 2.5,
                                    color: Colors.white,
                                  ),
                                  shape: const CircleBorder(),
                                  padding: const EdgeInsets.all(20),
                                  backgroundColor: Colors.transparent),
                              child: selected[0] == true
                                  ? Icon(Icons.abc)
                                  : Icon(Icons.add))
                        ],
                      ),
                      Column(
                        children: <Widget>[
                          ElevatedButton(
                              onPressed: getUser,
                              style: ElevatedButton.styleFrom(
                                  side: const BorderSide(
                                    width: 2.5,
                                    color: Colors.white,
                                  ),
                                  shape: const CircleBorder(),
                                  padding: const EdgeInsets.all(20),
                                  backgroundColor: Colors.transparent),
                              child: const Icon(Icons.add))
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
                                onPressed: getUser,
                                style: ElevatedButton.styleFrom(
                                    side: const BorderSide(
                                      width: 2.5,
                                      color: Colors.white,
                                    ),
                                    shape: const CircleBorder(),
                                    padding: const EdgeInsets.all(20),
                                    backgroundColor: Colors.transparent),
                                child: const Icon(Icons.add))
                          ],
                        ),
                      ),
                      Column(
                        children: <Widget>[
                          ElevatedButton(
                              onPressed: getUser,
                              style: ElevatedButton.styleFrom(
                                  side: const BorderSide(
                                    width: 2.5,
                                    color: Colors.white,
                                  ),
                                  shape: const CircleBorder(),
                                  padding: const EdgeInsets.all(20),
                                  backgroundColor: Colors.transparent),
                              child: const Icon(Icons.add))
                        ],
                      ),
                      Column(
                        children: <Widget>[
                          ElevatedButton(
                              onPressed: getUser,
                              style: ElevatedButton.styleFrom(
                                  side: const BorderSide(
                                    width: 2.5,
                                    color: Colors.white,
                                  ),
                                  shape: const CircleBorder(),
                                  padding: const EdgeInsets.all(20),
                                  backgroundColor: Colors.transparent),
                              child: const Icon(Icons.add))
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 60.0),
                        child: Column(
                          children: <Widget>[
                            ElevatedButton(
                                onPressed: getUser,
                                style: ElevatedButton.styleFrom(
                                    side: const BorderSide(
                                      width: 2.5,
                                      color: Colors.white,
                                    ),
                                    shape: const CircleBorder(),
                                    padding: const EdgeInsets.all(20),
                                    backgroundColor: Colors.transparent),
                                child: const Icon(Icons.add))
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
                                onPressed: getUser,
                                style: ElevatedButton.styleFrom(
                                    side: const BorderSide(
                                      width: 2.5,
                                      color: Colors.white,
                                    ),
                                    shape: const CircleBorder(),
                                    padding: const EdgeInsets.all(20),
                                    backgroundColor: Colors.transparent),
                                child: const Icon(Icons.add))
                          ],
                        ),
                      ),
                      Column(
                        children: <Widget>[
                          ElevatedButton(
                              onPressed: getUser,
                              style: ElevatedButton.styleFrom(
                                  side: const BorderSide(
                                    width: 2.5,
                                    color: Colors.white,
                                  ),
                                  shape: const CircleBorder(),
                                  padding: const EdgeInsets.all(20),
                                  backgroundColor: Colors.transparent),
                              child: const Icon(Icons.add))
                        ],
                      ),
                      Column(
                        children: <Widget>[
                          ElevatedButton(
                              onPressed: getUser,
                              style: ElevatedButton.styleFrom(
                                  side: const BorderSide(
                                    width: 2.5,
                                    color: Colors.white,
                                  ),
                                  shape: const CircleBorder(),
                                  padding: const EdgeInsets.all(20),
                                  backgroundColor: Colors.transparent),
                              child: const Icon(Icons.add))
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 60.0),
                        child: Column(
                          children: <Widget>[
                            ElevatedButton(
                                onPressed: getUser,
                                style: ElevatedButton.styleFrom(
                                    side: const BorderSide(
                                      width: 2.5,
                                      color: Colors.white,
                                    ),
                                    shape: const CircleBorder(),
                                    padding: const EdgeInsets.all(20),
                                    backgroundColor: Colors.transparent),
                                child: const Icon(Icons.add))
                          ],
                        ),
                      ),
                    ]),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: <Widget>[
                      Column(
                        children: <Widget>[
                          ElevatedButton(
                              onPressed: getUser,
                              style: ElevatedButton.styleFrom(
                                  side: const BorderSide(
                                    width: 2.5,
                                    color: Colors.white,
                                  ),
                                  shape: const CircleBorder(),
                                  padding: const EdgeInsets.all(20),
                                  backgroundColor: Colors.transparent),
                              child: const Icon(Icons.add))
                        ],
                      ),
                    ]),
              )
            ],
          ),
        )
      ],
    ));

    // return Scaffold(
    //     body: Container(
    //   child: ElevatedButton(
    //     onPressed: () => showDialog<String>(
    //       context: context,
    //       builder: (BuildContext context) => AlertDialog(
    //         title: const Text('Selecciona jugador'),
    //         actions: <Widget>[
    //           SizedBox(
    //             height: 500,
    //             width: 500,
    //             child: ListView.builder(
    //                 itemCount: lista.length,
    //                 itemBuilder: (context, index) {
    //                   return Card(
    //                     child: Text(lista[index]),
    //                   );
    //                 }),
    //           )

    //           // ListView.builder(
    //           //     itemCount: lista.length,
    //           //     itemBuilder: (context, index) {
    //           //       return Card(child: Text(lista[index]));
    //           //     }),
    //         ],
    //       ),
    //     ),
    //     child: const Icon(Icons.add),
    //   ),
    // ));
  }
}

Widget _getDrawer(BuildContext context) {
  var accountEmail = const Text("EMAIL");
  var accountName = const Text("USUARIO");
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


logout(BuildContext context) {
  globals.isLoggedIn = false;
  debugPrint('logged in: ${globals.isLoggedIn}');
  Navigator.of(context).pushReplacement(
    FadePageRoute(
      builder: (context) => const LoginScreen(),
    ),
  );
}

getUser() {
  if (globals.isLoggedIn) {
    return "ESTA EN TRUE";
  } else {
    return "ESTA EN FALSE";
  }
}

deleteUser(BuildContext context) {
  showDialog<String>(
    context: context,
    barrierColor: Colors.transparent,
    builder: (BuildContext context) => AlertDialog(
      title: const Text('Eliminar usuario'),
      content: const Text('Usuario eliminado'),
      actions: <Widget>[
        TextButton(
          onPressed: () => afterDeleteUser(context),
          child: const Text('Confirmar'),
        ),
      ],
    ),
  ).then((val) {
    afterDeleteUser(context);
  });
}

afterDeleteUser(BuildContext context) {
  globals.isLoggedIn = false;
  debugPrint('logged in: ${globals.isLoggedIn}');
  Navigator.of(context).pushReplacement(
    FadePageRoute(
      builder: (context) => const LoginScreen(),
    ),
  );
}

changeButton(int key, Map<int, bool> selected, BuildContext context, bool changed) {
  Navigator.pop(context, 'Confirmar');
  changed = true;
}

select(int key, Map<int, bool> selected, BuildContext context, bool changed) {
  showDialog<String>(
    context: context,
    barrierColor: Colors.transparent,
    builder: (BuildContext context) => AlertDialog(
      title: const Text('Eliminar usuario'),
      content: const Text('Usuario eliminado'),
      actions: <Widget>[
        TextButton(
          onPressed: () => changeButton(key, selected, context, changed),
          child: const Text('Confirmar'),
        ),
      ],
    ),
  );
}
