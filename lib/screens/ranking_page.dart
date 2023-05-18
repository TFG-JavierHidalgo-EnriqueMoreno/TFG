import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:my_app/screens/home_page.dart';
import 'package:my_app/screens/login_page.dart';
import 'package:my_app/services/firebase_service.dart';
import '../routes/custom_route.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:my_app/entities/globals.dart' as globals;

class RankingPage extends StatefulWidget {
  const RankingPage({super.key});

  @override
  State<RankingPage> createState() => _RankingPageState();
}

class _RankingPageState extends State<RankingPage> {
  void initState() {
    super.initState();
    getGlobalRanking();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: DefaultTabController(
        length: 2,
        child: FutureBuilder<Map<String, List<Map<String, int>>>>(
          future: getGlobalRanking(),
          builder: (BuildContext context,
              AsyncSnapshot<Map<String, List<Map<String, int>>>> snapshot) {
            if (snapshot.hasData) {
              inspect(snapshot.data!);
              return Scaffold(
                drawer: _getDrawer(context),
                appBar: AppBar(
                  bottom: TabBar(
                    tabs: [
                      Tab(text: 'Victorias'),
                      Tab(text: 'Puntuación'),
                    ],
                  ),
                  title: Text('Ranking global'),
                ),
                body: TabBarView(
                  children: [
                    DataTable(
                        columns: [
                          DataColumn(label: Text('Posición')),
                          DataColumn(label: Text('Nombre')),
                          DataColumn(label: Text('Victorias')),
                        ],
                        rows: List<DataRow>.generate(
                            snapshot.data!["nVictory"]!.length,
                            (index) => DataRow(cells: [
                                  DataCell(Text('${index + 1}')),
                                  DataCell(Text(
                                      '${snapshot.data!["nVictory"]![index].keys.first}')),
                                  DataCell(Text(
                                      '${snapshot.data!["nVictory"]![index].values.first}')),
                                ]))),
                    DataTable(
                        columns: [
                          DataColumn(label: Text('Posición')),
                          DataColumn(label: Text('Nombre')),
                          DataColumn(label: Text('Puntuación')),
                        ],
                        rows: List<DataRow>.generate(
                            snapshot.data!["elo"]!.length,
                            (index) => DataRow(cells: [
                                  DataCell(Text('${index + 1}')),
                                  DataCell(Text(
                                      '${snapshot.data!["elo"]![index].keys.first}')),
                                  DataCell(Text(
                                      '${snapshot.data!["elo"]![index].values.first}')),
                                ]))),
                  ],
                ),
              );
            } else {
              return Scaffold(body: Center(child: CircularProgressIndicator()));
            }
          },
        ),
      ),
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
            title: const Text("Estadísticas"),
            leading: const Icon(Icons.query_stats),
            onTap: () => stats(context)),
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
