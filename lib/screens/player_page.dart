import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:my_app/screens/select_page.dart';
import 'package:my_app/routes/custom_route.dart';
import 'package:my_app/services/firebase_service.dart';
import 'home_page.dart';

import 'package:my_app/entities/globals.dart' as globals;

class PlayerPage extends StatelessWidget {
  const PlayerPage({super.key});

  @override
  Widget build(BuildContext context) {
    const appTitle = 'Jugadores';

    return MaterialApp(
      title: appTitle,
      home: Scaffold(
        drawer: _getDrawer(context),
        appBar: AppBar(
          title: const Text(appTitle),
        ),
        body: const PlayerPageForm(),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            // Add your onPressed code here!
          },
          backgroundColor: const Color(0xFF4CAF50),
          label: const Text("Continuar"),
        ),
      ),
    );
  }
}

class PlayerPageForm extends StatefulWidget {
  const PlayerPageForm({super.key});

  @override
  PlayerPageFormState createState() {
    return PlayerPageFormState();
  }
}

class PlayerPageFormState extends State<PlayerPageForm> {
  // Create a global key that uniquely identifies the Form widget
  // and allows validation of the form.
  //
  // Note: This is a `GlobalKey<FormState>`,
  // not a GlobalKey<MyCustomFormState>.

  bool loaded = false;
  late Map<String, List<dynamic>> players;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: FutureBuilder<Map<String, List<dynamic>>>(
        future: getRandomPlayers(),
        builder: (BuildContext context,
            AsyncSnapshot<Map<String, List<dynamic>>> snapshot) {
          List<Widget> children;
          if (snapshot.hasData) {
            players = snapshot.data!;
            inspect(players);
            children = <Widget>[
              Container(
                height: 50.0,
                decoration: const BoxDecoration(
                    border: Border(
                        bottom: BorderSide(color: Colors.black, width: 1.0))),
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
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    const Text("Porteros"),
                    Card(
                        child: ListView.builder(
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      itemCount: players["PT"]!.length,
                      itemBuilder: ((context, index) {
                        return Container(
                          child: Text('${players["PT"]![index]["name"]}'),
                        );
                      }),
                    ))
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 16.0, left: 16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    const Text("Defensas"),

                    //Lista
                    //ListView.builder(itemBuilder: itemBuilder),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 16.0, left: 16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    const Text("Centrocampista"),

                    //Lista
                    //ListView.builder(itemBuilder: itemBuilder),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 16.0, left: 16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    const Text("Delanteros"),

                    //Lista
                    //ListView.builder(itemBuilder: itemBuilder),
                  ],
                ),
              ),
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
            children = const <Widget>[
              SizedBox(
                width: 60,
                height: 60,
                child: CircularProgressIndicator(),
              ),
              Padding(
                padding: EdgeInsets.only(top: 16),
                child: Text('Awaiting result...'),
              ),
            ];
          }

          return Column(
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: children);
        },
      ),
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

playAgain(BuildContext context) {
  Navigator.of(context).pushReplacement(
    FadePageRoute(
      builder: (context) => const SelectPage(),
    ),
  );
}
