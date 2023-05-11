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

class SearchingPage extends StatefulWidget {
  const SearchingPage({super.key});

  @override
  SearchingPageState createState() {
    return SearchingPageState();
  }
}

class SearchingPageState extends State<SearchingPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _page(context),
    );
  }

  @override
  void initState() {
    super.initState();
    BuildContext c = context;
    _player2.addListener(() {
      goToPlayerPage2(c, _player2.value, redirected);
      redirected = true;
    } );
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

  bool redirected = false;
  late Timer timer;
  bool loaded = false;
  late Map<String, List<dynamic>> players;
  static bool isPlaying = false;
  ValueNotifier<String> _player2 = ValueNotifier<String>('');

  checkForGame(BuildContext context, bool isPlaying) {
    Timer.periodic(Duration(milliseconds: 500), (Timer t) async {
      isPlaying = await checkPlayerStatus() == "playing";
      if (isPlaying) {
        var player2 = await getPlayer2();
        _player2.value = player2.data()["username"];
        t.cancel();
      }
    });
  }

  Widget _page(BuildContext context) {
    return Container(
      child: FutureBuilder<Map<String, List<dynamic>>>(
        future: searchGame(),
        builder: (BuildContext context,
            AsyncSnapshot<Map<String, List<dynamic>>> snapshot) {
          List<Widget> children;
          if (snapshot.hasData) {
            if (snapshot.data!.isEmpty) {
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

goToPlayerPage2(BuildContext context, String player2, bool redirected) {
  if (player2 != '' && redirected == false) {
    SchedulerBinding.instance.addPostFrameCallback((_) {
      Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) => PlayerPage(
                player1: globals.userLoggedIn.username,
                player2: player2,
              )));
    });
  }
}
