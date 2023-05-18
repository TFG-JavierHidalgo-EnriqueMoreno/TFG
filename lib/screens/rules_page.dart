import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:my_app/screens/home_page.dart';
import 'package:my_app/screens/login_page.dart';
import 'package:my_app/services/firebase_service.dart';
import '../routes/custom_route.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:my_app/entities/globals.dart' as globals;

class RulesPage extends StatefulWidget {
  const RulesPage({super.key});

  @override
  State<RulesPage> createState() => _RulesPageState();
}

class _RulesPageState extends State<RulesPage> {
  void initState() {
    super.initState();
    getGlobalRanking();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: DefaultTabController(
            length: 3,
            child: Scaffold(
              drawer: _getDrawer(context),
              appBar: AppBar(
                backgroundColor: const Color(0xFF4CAF50),
                bottom: TabBar(
                  indicatorColor: Colors.white,
                  tabs: [
                    Tab(text: "Ligas"),
                    Tab(text: "Partidos"),
                    Tab(text: "Resultado")
                  ],
                ),
                title: Text('Reglas'),
              ),
              body: TabBarView(
                children: [
                  SingleChildScrollView(
                      //controller: scrollController,
                      child: Column(children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(top: 16, left: 16, right: 16),
                      child: Text(
                        "Los usuarios serán emparejados en función de los puntos de liga que posean. Un usuario no puede ser emparejado con otros usuarios que tengan una diferencia de puntos con los suyos de 21 o mayor.",
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 16, left: 16, right: 16),
                      child: Text(
                        "Las distintas ligas presentes en el sistema son: BRONCE, PLATA, ORO, PLATINO, DIAMANTE y MAESTRO.",
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 16, left: 16, right: 16),
                      child: Text(
                        "En función de la liga en la que se encuentre el usuario, ganará o perderá más puntos por partido, así como variará el presupuesto que tenga para escoger su equipo.",
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                  ])),
                  SingleChildScrollView(
                      //controller: scrollController,
                      child: Column(children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(top: 16, left: 16, right: 16),
                      child: Text(
                        "Selección  de jugadores",
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.w600),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 16, left: 16, right: 16),
                      child: Text(
                        "Al usuario se le mostrarán once posibles posiciones para sus jugadores. Las posiciones estarán segmentadas entre DELANTERO, MEDIOCENTRO, DEFENSA y PORTERO, siendo variable la cantidad de cada una de las posiciones en función de la alineación escogida, excepto la del PORTERO, que siempre es uno. Tras pulsar en una posición cualquiera, al usuario se le mostrará un listado con los posibles jugadores a seleccionar, teniendo que escoger uno para cada posición hasta completar las once.",
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 16, left: 16, right: 16),
                      child: Text(
                        "Selección de alineación",
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.w600),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 16, left: 16, right: 16),
                      child: Text(
                        "El usuario podrá seleccionar un sistema de alineación de las posibles para el partido a disputar.",
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 16, left: 16, right: 16),
                      child: Text(
                        "Selección de capitán",
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.w600),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 16, left: 16, right: 16),
                      child: Text(
                        "El usuario, tras seleccionar mínimo un jugador, tendrá la opción de seleccionar un capitán. Dicho jugador escogido como capitán incrementa todos sus atributos por el doble de su valor.",
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 16, left: 16, right: 16),
                      child: Text(
                        "Selección de oponente",
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.w600),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 16, left: 16, right: 16),
                      child: Text(
                        "Una vez ambos usuarios han seleccionado sus alineaciones, pueden ver la alineación de su rival y seleccionar un oponente. Dicho jugador escogido como oponente reduce todos sus atributos por la mitad de su valor.",
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 16, left: 16, right: 16),
                      child: Text(
                        "Simulación de partido",
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.w600),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(16),
                      child: Text(
                        "Después de que ambos usuarios hayan confirmado sus oponentes, se generarán unos eventos aleatorios de modo que se simula un partido. Estos eventos pueden afectar positiva o negativamente a los puntos de los jugadores en función de su posición.",
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                  ])),
                  SingleChildScrollView(
                      child: Column(children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(top: 16, left: 16, right: 16),
                      child: Text(
                        "Tras la simulación del partido, se pasa a la obtención del resultado final, según la cual se le muestra al usuario una tabla con el resultado del partido y las puntuaciones de cada atributo obtenidas tanto para su equipo como para el del contrario.",
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 16, left: 16, right: 16),
                      child: Text(
                        "Los atributos a tener en cuenta para el resultado son: DEFENSA, REGATES, PASES, TIRO, VELOCIDAD, FUERZA y VALORACIÓN.",
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 16, left: 16, right: 16),
                      child: Text(
                        "El resultado del partido se calcula en función de la diferencia entre las distintas puntuaciones de ambos usuarios en cada ámbito, siendo victorioso el jugador que obtenga la mayor puntuación en el mayor número de atributos.",
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                  ])),
                ],
              ),
            )));
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
            title: const Text("Logros"),
            leading: const Icon(Icons.auto_stories_sharp),
            onTap: () => achievement(context)),
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
