import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../routes/custom_route.dart';
import '../screens/home_page.dart';
import 'package:my_app/entities/globals.dart' as globals;

Widget _getDrawer(BuildContext context) {
  var accountEmail = Text(globals.userLoggedIn.email);
  var accountName = Text(globals.userLoggedIn.username);
  return Drawer(
    child: ListView(
      children: <Widget>[
        UserAccountsDrawerHeader(
            accountName: accountName, accountEmail: accountEmail),
        ListTile(
            title: const Text("Jugar Partido"),
            leading: const Icon(Icons.home),
            onTap: () => showHome(context)),
        ListTile(
            title: const Text("Editar Perfil"),
            leading: const Icon(Icons.home),
            onTap: () => showHome(context)),
        ListTile(
            title: const Text("Historial"),
            leading: const Icon(Icons.home),
            onTap: () => showHome(context)),
        ListTile(
            title: const Text("Cerrar Sesion"),
            leading: const Icon(Icons.home),
            onTap: () => showHome(context)),
      ],
    ),
  );
}

showHome(BuildContext context) {
  Navigator.of(context).pushReplacement(
    FadePageRoute(
      builder: (context) => const HomePage(),
    ),
  );
}
