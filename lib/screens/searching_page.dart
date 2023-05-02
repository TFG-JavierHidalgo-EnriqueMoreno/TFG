import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/scheduler.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:my_app/screens/player_page.dart';
import 'package:my_app/screens/select_page.dart';
import 'package:my_app/routes/custom_route.dart';
import 'package:my_app/services/firebase_service.dart';
import 'home_page.dart';

import 'package:my_app/entities/globals.dart' as globals;

class SearchingPage extends StatelessWidget {
  const SearchingPage({super.key});

  @override
  Widget build(BuildContext context) {
    const appTitle = 'Jugadores';
    const floatingbutton = null;

    return MaterialApp(
      title: appTitle,
      home: Scaffold(
        // appBar: AppBar(
        //   title: const Text(appTitle),
        // ),
        body: const SearchingPageForm(),
      ),
    );
  }
}

class SearchingPageForm extends StatefulWidget {
  const SearchingPageForm({super.key});

  @override
  SearchingPageFormState createState() {
    return SearchingPageFormState();
  }
}

class SearchingPageFormState extends State<SearchingPageForm> {
  // Create a global key that uniquely identifies the Form widget
  // and allows validation of the form.
  //
  // Note: This is a `GlobalKey<FormState>`,
  // not a GlobalKey<MyCustomFormState>.

  @override
  void initState() {
    super.initState();
    var duration = Duration(seconds: 20);
    timer = Timer(duration, (() {
      if (!isPlaying) {
        resetPlayerState();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              backgroundColor: Color.fromARGB(255, 209, 67, 67),
              duration: Duration(seconds: 3),
              content: Text('No ha sido posible encontrar partido')),
        );
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => HomePage()));
      }
    }));

    setState(() {});
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  late Timer timer;
  bool loaded = false;
  late Map<String, List<dynamic>> players;
  static bool isPlaying = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: FutureBuilder<Map<String, List<dynamic>>>(
        future: searchGame(),
        builder: (BuildContext context,
            AsyncSnapshot<Map<String, List<dynamic>>> snapshot) {
          List<Widget> children;
          if (snapshot.hasData) {
            if (snapshot.data!.isEmpty) {
              // start15secTime(context, isPlaying, timer);
              checkForGame(context, isPlaying);
              children = <Widget>[
                Center(child: Text('Buscando partido...')),
                Center(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 16.0),
                    child: CircularProgressIndicator(),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 40.0),
                  child: FloatingActionButton.extended(
                    heroTag: "btn4",
                    onPressed: () {
                      resetPlayerState();
                      Navigator.of(context).pushReplacement(
                          MaterialPageRoute(builder: (context) => HomePage()));
                    },
                    backgroundColor: Color.fromARGB(255, 209, 67, 67),
                    label: const Text("Cancelar búsqueda"),
                  ),
                ),
              ];
            } else {
              players = snapshot.data!;
              isPlaying = true;
              children = <Widget>[];
              goToPlayerPage(context, players);
            }
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
            children = <Widget>[
              Center(child: Text('Buscando partido...')),
              Center(
                child: Padding(
                  padding: const EdgeInsets.only(top: 16.0),
                  child: CircularProgressIndicator(),
                ),
              ),
            ];
          }
          return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: children);
        },
      ),
    );
  }
}

goToHome(BuildContext context) {
  Navigator.of(context).pushReplacement(
    FadePageRoute(
      builder: (context) => const HomePage(),
    ),
  );
}

goToPlayerPage(BuildContext context, Map<String, List<dynamic>> players) {
  SchedulerBinding.instance.addPostFrameCallback((_) {
    Navigator.of(context).pushReplacement(MaterialPageRoute(
        builder: (context) => PlayerPage(
              player1: players["player1"]![0]["username"],
              player2: players["player2"]![0]["username"],
            )));
  });
}

checkForGame(BuildContext context, bool isPlaying) async {
  Timer? periodic;
  periodic = Timer.periodic(Duration(milliseconds: 500), (Timer t) async {
    isPlaying = await checkPlayerStatus() == "playing";
    if (isPlaying) {
      SearchingPageFormState.isPlaying = true;
      periodic!.cancel();
      Timer(Duration(seconds: 2), (() async {
        var player2 = await getPlayer2();
        // TODO: Fallo null check (context)
        Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (context) => PlayerPage(
                  player1: globals.userLoggedIn.username,
                  player2: player2.data()["username"],
                )));
      }));
    }
  });
}
