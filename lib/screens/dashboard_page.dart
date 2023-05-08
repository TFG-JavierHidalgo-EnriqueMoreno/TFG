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

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
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
                future: getUserStatistics(),
                builder: (BuildContext context,
                    AsyncSnapshot<Map<String, dynamic>> snapshot) {
                  if (snapshot.hasData) {
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        Row(
                          children: [
                            Text(
                              "Total de partidos: ",
                              style: TextStyle(fontSize: 20),
                            ),
                            Text(
                              "${snapshot.data!["nGames"]}",
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.w600),
                            )
                          ],
                        ),
                        Row(
                          children: [
                            Text(
                              "Total de victorias: ",
                              style: TextStyle(fontSize: 20),
                            ),
                            Text("${snapshot.data!["nVictory"]}",
                                style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.w600))
                          ],
                        ),
                        Row(
                          children: [
                            Text(
                              "Porcentaje de victorias: ",
                              style: TextStyle(fontSize: 20),
                            ),
                            Text("${snapshot.data!["averageVictory"]} %",
                                style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.w600))
                          ],
                        ),
                        Row(
                          children: [
                            Text(
                              "Goles totales: ",
                              style: TextStyle(fontSize: 20),
                            ),
                            Text("${snapshot.data!["nGoals"]}",
                                style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.w600))
                          ],
                        ),
                        Row(
                          children: [
                            Text(
                              "Media de goles por partido: ",
                              style: TextStyle(fontSize: 20),
                            ),
                            Text("${snapshot.data!["averageGoals"]}",
                                style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.w600))
                          ],
                        ),
                        Row(
                          children: [
                            Text(
                              "Alineación preferida: ",
                              style: TextStyle(fontSize: 20),
                            ),
                            Text("${snapshot.data!["favoriteLineUp"]}",
                                style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.w600))
                          ],
                        ),
                        Row(
                          children: [
                            Text(
                              "Estilo de juego: ",
                              style: TextStyle(fontSize: 20),
                            ),
                            Text("${snapshot.data!["styleGame"]}",
                                style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.w600))
                          ],
                        ),
                      ],
                    );
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
        title: const Text("Estadísticas"),
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
            title: const Text("Logros"),
            leading: const Icon(Icons.auto_stories_sharp),
            onTap: () => achievement(context)),
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
