import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../routes/custom_route.dart';
import '../screens/home_page.dart';

Widget _getDrawer(BuildContext context) {
  var accountEmail = Text("EMAIL");
  var accountName = Text("USUARIO");
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
