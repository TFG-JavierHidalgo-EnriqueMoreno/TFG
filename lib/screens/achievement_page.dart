import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
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
      body: globals.isLoggedIn ? _page(context) : LoginScreen(),
      appBar: AppBar(
        title: const Text("Logros"),
      ),
      drawer: _getDrawer(context),
    );
  }
}

Widget _page(BuildContext context) {
  return Container(
    width: double.infinity,
    child: Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: Container(
            width: 350,
            height: 350,
            child: FutureBuilder<Map<String, dynamic>>(
              future: getUserAchievements(),
              builder: (BuildContext context,
                  AsyncSnapshot<Map<String, dynamic>> snapshot) {
                if (snapshot.hasData) {
                  return ListView.builder(
                      itemCount: snapshot.data!["achievements"].length,
                      itemBuilder: ((context, index) {
                        String id = snapshot.data!["achievements"][index].id;

                        var a = snapshot.data!["user_achievements"].firstWhere(
                            (element) =>
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
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
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
                                Text(
                                    "$progress/${snapshot.data!["achievements"][index].data()["goal"]}"),
                                Padding(
                                  padding: const EdgeInsets.only(left: 8.0),
                                  child: Text(
                                      "${snapshot.data!["achievements"][index].data()["reward"]}"),
                                ),
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
        ),
      ],
    ),
  );
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

showHome(BuildContext context) {
  resetPlayerState();
  Navigator.of(context).pushReplacement(
    FadePageRoute(
      builder: (context) => const AchievementPage(),
    ),
  );
}

showProfile(BuildContext context) {
  resetPlayerState();
  Navigator.of(context).pushReplacement(
    FadePageRoute(
      builder: (context) => const UserProfile(),
    ),
  );
}

playGame(BuildContext context) {
  Navigator.of(context).pushReplacement(
    FadePageRoute(
      builder: (context) => const SearchingPage(),
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
