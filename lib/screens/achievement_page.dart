import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:my_app/screens/home_page.dart';
import 'package:my_app/screens/login_page.dart';
import 'package:my_app/screens/player_page.dart';
import 'package:my_app/screens/searching_page.dart';
import 'package:my_app/screens/select_page.dart';
import 'package:my_app/screens/user_profile.dart';
import 'package:my_app/services/firebase_service.dart';
import '../routes/custom_route.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:my_app/entities/globals.dart' as globals;

class AchievementPage extends StatefulWidget {
  const AchievementPage({super.key});

  @override
  State<AchievementPage> createState() => _AchievementPageState();
}

class _AchievementPageState extends State<AchievementPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        child: Column(
          children: [
            Container(
              width: 350,
              height: MediaQuery.of(context).size.height - 100,
              child: FutureBuilder<Map<String, dynamic>>(
                future: getUserAchievements(),
                builder: (BuildContext context,
                    AsyncSnapshot<Map<String, dynamic>> snapshot) {
                  if (snapshot.hasData) {
                    return ListView.builder(
                        itemCount: snapshot.data!["achievements"].length,
                        itemBuilder: ((context, index) {
                          String id = snapshot.data!["achievements"][index].id;
                          var a = snapshot.data!["user_achievements"]
                              .firstWhere((element) =>
                                  element.data()["achievement_id"] == id);
                          int progress = a.data()["progress"];
                          return Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: Container(
                              height: 80,
                              decoration: BoxDecoration(
                                  border: Border.all(
                                      color: progress ==
                                              snapshot.data!["achievements"]
                                                      [index]
                                                  .data()["goal"]
                                          ? Colors.green
                                          : Colors.white,
                                      width: 1.0)),
                              child: Row(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Container(
                                      width: 180,
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "${snapshot.data!["achievements"][index].data()["title"]}",
                                          ),
                                          Padding(
                                            padding:
                                                const EdgeInsets.only(top: 8.0),
                                            child: Text(
                                                "${snapshot.data!["achievements"][index].data()["description"]}"),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                  Text(
                                      "$progress/${snapshot.data!["achievements"][index].data()["goal"]}"),
                                  Padding(
                                    padding: EdgeInsets.only(left: 12.0),
                                    child: a.data()["claimed"] == true
                                        ? TextButton(
                                            onPressed: () {},
                                            child: Text(
                                              "Reclamado",
                                              style: TextStyle(
                                                  color: Color(0xFF4CAF50)),
                                            ),
                                          )
                                        : progress ==
                                                snapshot.data!["achievements"]
                                                        [index]
                                                    .data()["goal"]
                                            ? TextButton(
                                                onPressed: () {
                                                  ScaffoldMessenger.of(context)
                                                      .showSnackBar(
                                                    SnackBar(
                                                        backgroundColor:
                                                            Color(0xFF4CAF50),
                                                        duration: Duration(
                                                            seconds: 3),
                                                        content: Container(
                                                          height: 40,
                                                          child: Column(
                                                            children: [
                                                              Row(
                                                                children: [
                                                                  Text(
                                                                      "Logro reclamado con éxito. "),
                                                                ],
                                                              ),
                                                              Row(
                                                                children: [
                                                                  Text(
                                                                      "${snapshot.data!["achievements"][index].data()["reward"]} "),
                                                                  Icon(Icons
                                                                      .diamond_outlined),
                                                                  snapshot.data!["achievements"][index].data()[
                                                                              "reward"] ==
                                                                          1
                                                                      ? Text(
                                                                          " ha sido añadido a tu cuenta")
                                                                      : Text(
                                                                          " han sido añadidos a tu cuenta"),
                                                                ],
                                                              ),
                                                            ],
                                                          ),
                                                        )),
                                                  );
                                                  updateTokens(
                                                      snapshot
                                                          .data!["achievements"]
                                                              [index]
                                                          .data()["reward"],
                                                      a.id);
                                                  setState(() {});
                                                },
                                                child: Text("Reclamar"),
                                              )
                                            : Row(
                                                children: [
                                                  Text(
                                                      "${snapshot.data!["achievements"][index].data()["reward"]} "),
                                                  //Icon(Icons.diamond_outlined),
                                                ],
                                              ),
                                  ),
                                  if (a.data()["claimed"] == false &&
                                      progress !=
                                          snapshot.data!["achievements"][index]
                                              .data()["goal"])
                                    Icon(Icons.diamond_outlined)
                                ],
                              ),
                            ),
                          );
                        }));
                  } else {
                    return Center(child: CircularProgressIndicator());
                  }
                },
              ),
            ),
          ],
        ),
      ),
      appBar: AppBar(
        backgroundColor: const Color(0xFF4CAF50),
        title: const Text("Logros"),
      ),
      drawer: _getDrawer(context),
    );
  }
}

Widget _getDrawer(BuildContext context) {
  var accountEmail = Text(globals.userLoggedIn.email);
  var accountName = Text(globals.userLoggedIn.username);
  var accountPicture = Icon(FontAwesomeIcons.userLarge);
  return Drawer(
    child: ListView(
      children: <Widget>[
        UserAccountsDrawerHeader(
            decoration: BoxDecoration(
              color: const Color(0xFF4CAF50),
            ),
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
            title: const Text("Estadísticas"),
            leading: const Icon(Icons.query_stats),
            onTap: () => stats(context)),
        ListTile(
            title: const Text("Ranking Global"),
            leading: const Icon(Icons.star_rate),
            onTap: () => ranking(context)),
        ListTile(
            title: const Text("Terminos"),
            leading: const Icon(Icons.library_books),
            onTap: () => termsService(context)),
        ListTile(
            title: const Text("Reglas"),
            leading: const Icon(Icons.rule),
            onTap: () => showRules(context)),
        ListTile(
            title: const Text("Cerrar Sesion"),
            leading: const Icon(Icons.logout),
            onTap: () => logout(context)),
      ],
    ),
  );
}

logout(BuildContext context) {
  resetPlayerState();
  globals.isLoggedIn = false;
  Navigator.of(context).pushReplacement(
    FadePageRoute(
      builder: (context) => const LoginScreen(),
    ),
  );
}
