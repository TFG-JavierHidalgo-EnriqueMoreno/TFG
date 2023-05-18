import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:my_app/screens/achievement_page.dart';
import 'package:my_app/screens/dashboard_page.dart';
import 'package:my_app/screens/home_page.dart';
import 'package:my_app/screens/login_page.dart';
import 'package:my_app/screens/player_page.dart';
import 'package:my_app/screens/ranking_page.dart';
import 'package:my_app/screens/searching_page.dart';
import 'package:my_app/screens/select_page.dart';
import 'package:my_app/screens/user_profile.dart';
import 'package:my_app/services/firebase_service.dart';
import '../routes/custom_route.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:my_app/entities/globals.dart' as globals;

class TermsService extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(home: TermsServicePage());
  }
}

class TermsServicePage extends StatefulWidget {
  const TermsServicePage({super.key});

  @override
  State<TermsServicePage> createState() => _TermsServicePageState();
}

class _TermsServicePageState extends State<TermsServicePage> {
  ScrollController scrollController = ScrollController();
  bool showbtn = false;

  @override
  void initState() {
    scrollController.addListener(() {
      if (scrollController.position.atEdge) {
        bool isTop = scrollController.position.pixels == 0;
        if (isTop) {
          showbtn = false;
          setState(() {});
        } else {
          showbtn = true;
          setState(() {});
        }
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: AnimatedOpacity(
        duration: Duration(milliseconds: 500),
        opacity: showbtn ? 1.0 : 0.0,
        child: FloatingActionButton(
          heroTag: "btn_scrollUp",
          onPressed: () {
            scrollController.animateTo(0,
                duration: Duration(milliseconds: 500),
                curve: Curves.fastOutSlowIn);
          },
          child: Icon(Icons.arrow_upward),
          backgroundColor: Colors.green,
        ),
      ),
      body: SingleChildScrollView(
        controller: scrollController,
        child: Column(children: const <Widget>[
          Padding(
            padding: EdgeInsets.only(top: 16, left: 16),
            child: Text(
              "Términos de Servicio",
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.w600),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 16, left: 16, right: 16),
            child: Text(
              "BattleDraft le informa sobre su Política de Privacidad respecto del tratamiento y protección de los datos de carácter personal de los usuarios y clientes que puedan ser	recabados por la navegación o contratación de servicios a través de la aplicación de BattleDraft.",
              style: TextStyle(fontSize: 16),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 16, left: 16, right: 16),
            child: Text(
              "En este sentido, garantizamos el cumplimiento de la normativa vigente en materia de protección de datos personales, reflejada en la Ley Orgánica 3/2018, de 5 de diciembre, de Protección de Datos Personales y de Garantía de Derechos Digitales (LOPD GDD). Cumple también con el Reglamento (UE) 2016/679 del Parlamento Europeo y del Consejo de 27 de abril de 2016 relativo a la protección de las personas físicas (RGPD)",
              style: TextStyle(fontSize: 16),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 16, left: 16, right: 16),
            child: Text(
              "El uso de la aplicación implica la aceptación de esta Política de Privacidad.",
              style: TextStyle(fontSize: 16),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 16, left: 16, right: 16),
            child: Text(
              "Battledraft se compromete a cumplir el Principio de licitud, lealtad y transparencia: El Titular siempre requerirá el consentimiento para el tratamiento de tus datos personales que puede ser para uno o varios fines específicos sobre los que te informará previamente con absoluta transparencia. Con fines de realizar el registro evitando problemas de suplantación y duplicidad de cuentas. Estos datos serán conservados hasta que solicites su supresión.",
              style: TextStyle(fontSize: 16),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 16, left: 16, right: 16),
            child: Text(
              "Usted tiene derecho a que sus datos personales almacenados sean suprimidos de nuestra base de datos. Para ejercitar el derecho al olvido puede hacerlo desde la pestaña de edición de usuario o contactando con nuestro servicio vía correo electrónico a través del correo battledraft.tfg@gmail.com estableciendo como asunto 'Baja de usuario' y en el cuerpo del mensaje: nombre de usuario y motivo de la baja. Esta información que les pedimos es para detectar posibles mejoras, solo serán procesadas aquellas solicitudes cuyo remitente se encuentra en nuestros sistemas. Una vez enviado el proceso puede tardar entre 72 y 96 horas.",
              style: TextStyle(fontSize: 16),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 16, left: 16, right: 16),
            child: Text(
              "Para proteger sus datos personales, hemos tomado todas las precauciones razonables y seguido las mejores prácticas de la industria para evitar su pérdida, mal uso, acceso indebido, divulgación, alteración o destrucción de los mismos. La seguridad de tus datos está garantizada, ya que toman todas las medidas de seguridad necesarias para ello.",
              style: TextStyle(fontSize: 16),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 16, left: 16, right: 16),
            child: Text(
              "En caso de detectar algún fallo de seguridad se le comunicará de inmediato con el fin de que tome las medidas preventivas necesarias.",
              style: TextStyle(fontSize: 16),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 16, left: 16, right: 16, bottom: 60),
            child: Text(
              "Por último usted tiene derecho a solicitar el acceso a sus datos personales almacenados en nuestra base de datos. Para ejercitar este derecho tendrá que contactar con nuestro servicio vía correo electrónico a través del correo battledraft.tfg@gmail.com y solicitar la información que usted desee, proporcionandonos también su usuario y contraseña para verificar su identidad.",
              style: TextStyle(fontSize: 16),
            ),
          ),
        ]),
      ),
      appBar: AppBar(
        backgroundColor: const Color(0xFF4CAF50),
        title: const Text("BattleDraft"),
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

showHome(BuildContext context) {
  resetPlayerState();
  Navigator.of(context).pushReplacement(
    FadePageRoute(
      builder: (context) => const HomePage(),
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

ranking(BuildContext context) {
  Navigator.of(context).pushReplacement(
    FadePageRoute(
      builder: (context) => const RankingPage(),
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

achievement(BuildContext context) {
  resetPlayerState();
  Navigator.of(context).pushReplacement(
    FadePageRoute(
      builder: (context) => const AchievementPage(),
    ),
  );
}

stats(BuildContext context) {
  resetPlayerState();
  Navigator.of(context).pushReplacement(
    FadePageRoute(
      builder: (context) => const DashboardPage(),
    ),
  );
}
