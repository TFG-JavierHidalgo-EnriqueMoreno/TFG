import 'package:flutter/material.dart';
import 'package:my_app/screens/login_page.dart';
import 'package:my_app/screens/user_profile.dart';
import '../routes/custom_route.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:my_app/entities/globals.dart' as globals;

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: globals.isLoggedIn ? Center() : LoginScreen(),
      appBar: AppBar(
        title: const Text("BattleDraft"),
      ),
      drawer: _getDrawer(context),
    );
  }
}

Widget _getDrawer(BuildContext context) {
  var accountEmail = Text("EMAIL");
  var accountName = Text("USUARIO");
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
            onTap: () => showHome(context)),
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
  Navigator.of(context).pushReplacement(
    FadePageRoute(
      builder: (context) => const HomePage(),
    ),
  );
}

showProfile(BuildContext context) {
  Navigator.of(context).pushReplacement(
    FadePageRoute(
      builder: (context) => const UserProfile(),
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

// showLogin(BuildContext context) {
//   Navigator.of(context).pushReplacement(
//     FadePageRoute(
//       builder: (context) => const LoginScreen(),
//     ),
//   );
// }
