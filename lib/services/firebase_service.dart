import 'dart:convert';
import 'dart:developer';
import 'dart:ffi';

import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:my_app/entities/club.dart';
import 'package:my_app/entities/country.dart';
import 'package:my_app/entities/globals.dart' as globals;
import 'package:my_app/entities/league.dart';
import 'package:my_app/entities/level.dart';
import 'package:my_app/entities/lineup.dart';
import 'package:my_app/entities/player.dart';
import 'package:my_app/entities/user.dart';

FirebaseFirestore db = FirebaseFirestore.instance;

Future<List> getUsers() async {
  List users = [];

  CollectionReference cUsers = db.collection("users");
  QuerySnapshot q = await cUsers.get();
  for (int i = 0; i < q.docs.length; i++) {
    QuerySnapshot level = await db
        .collection("users")
        .doc(q.docs[i].id)
        .collection("level")
        .get();
    final u = {
      "uid": q.docs[i].id,
      "data": q.docs[i].data(),
      "level": level.docs[0].data()
    };

    users.add(u);
  }
  return users;
}

Future<void> saveUser(String? email, String? password, String? phone,
    String? username, String? name, String? surname) async {
  await db.collection("users").add({
    "email": email,
    "password": password,
    "phone": phone,
    "name": "$name $surname",
    "username": username,
    "elo": 0,
  }).then((value) => value.collection("level").add({
        "name": "Bronce",
        "min": 0,
        "max": 10,
        "next": "Plata",
        "previous": null,
        "victory": 3,
        "lose": 0
      }));
}

Future<void> calcElo(bool gameResult) async {
  Future<List> users = getUsers();

  User u = globals.userLoggedIn;

  List list = await users;

  var us = list.firstWhere((element) => element["data"]["email"] == u.email);
  if (gameResult) {
    if (us["level"]["name"] != "Maestro") {
      if (us["data"]["elo"] + us["level"]["victory"] > us["level"]["max"]) {
        QuerySnapshot level = await db
            .collection("users")
            .doc(us["uid"])
            .collection("level")
            .get();
        QuerySnapshot<Map<String, dynamic>> nextLevel = await db
            .collection("levels")
            .where("name", isEqualTo: us["level"]["next"])
            .get();
        String levelId = level.docs[0].id;
        await db
            .collection("users")
            .doc(us["uid"])
            .collection("level")
            .doc(levelId)
            .set({
          "name": us["level"]["next"],
          "min": nextLevel.docs[0].data()["min"],
          "max": nextLevel.docs[0].data()["max"],
          "next": nextLevel.docs[0].data()["next"],
          "previous": nextLevel.docs[0].data()["previous"],
          "victory": nextLevel.docs[0].data()["victory"],
          "lose": nextLevel.docs[0].data()["lose"],
        });
        globals.userLevel.name = us["level"]["next"];
      }
      await db.collection("users").doc(us["uid"]).set({
        "email": us["data"]["email"],
        "elo": us["data"]["elo"] + us["level"]["victory"],
        "name": us["data"]["name"],
        "password": us["data"]["password"],
        "username": us["data"]["username"],
        "phone": us["data"]["phone"]
      });

      globals.userLoggedIn.elo = us["data"]["elo"] + us["level"]["victory"];
    } else if (us["data"]["elo"] + us["level"]["victory"] >
        us["level"]["max"]) {
      await db.collection("users").doc(us["uid"]).set({
        "email": us["data"]["email"],
        "elo": 250,
        "name": us["data"]["name"],
        "password": us["data"]["password"],
        "username": us["data"]["username"],
        "phone": us["data"]["phone"]
      });

      globals.userLoggedIn.elo = 250;
    } else {
      await db.collection("users").doc(us["uid"]).set({
        "email": us["data"]["email"],
        "elo": us["data"]["elo"] + us["level"]["victory"],
        "name": us["data"]["name"],
        "password": us["data"]["password"],
        "username": us["data"]["username"],
        "phone": us["data"]["phone"]
      });

      globals.userLoggedIn.elo = us["data"]["elo"] + us["level"]["victory"];
    }
  } else {
    if (us["level"]["name"] != "Bronce") {
      if (us["data"]["elo"] - us["level"]["lose"] <= us["level"]["min"]) {
        QuerySnapshot level = await db
            .collection("users")
            .doc(us["uid"])
            .collection("level")
            .get();
        QuerySnapshot<Map<String, dynamic>> previousLevel = await db
            .collection("levels")
            .where("name", isEqualTo: us["level"]["previous"])
            .get();
        String levelId = level.docs[0].id;
        await db
            .collection("users")
            .doc(us["uid"])
            .collection("level")
            .doc(levelId)
            .set({
          "name": us["level"]["next"],
          "min": previousLevel.docs[0].data()["min"],
          "max": previousLevel.docs[0].data()["max"],
          "next": previousLevel.docs[0].data()["next"],
          "previous": previousLevel.docs[0].data()["previous"],
          "victory": previousLevel.docs[0].data()["victory"],
          "lose": previousLevel.docs[0].data()["lose"],
        });
        globals.userLevel.name = us["level"]["previous"];
      }
      await db.collection("users").doc(us["uid"]).set({
        "email": us["data"]["email"],
        "elo": us["data"]["elo"] - us["level"]["lose"],
        "name": us["data"]["name"],
        "password": us["data"]["password"],
        "username": us["data"]["username"],
        "phone": us["data"]["phone"]
      });

      globals.userLoggedIn.elo = us["data"]["elo"] - us["level"]["lose"];
    } else if (us["data"]["elo"] - us["level"]["lose"] <= us["level"]["min"]) {
      await db.collection("users").doc(us["uid"]).set({
        "email": us["data"]["email"],
        "elo": 0,
        "name": us["data"]["name"],
        "password": us["data"]["password"],
        "username": us["data"]["username"],
        "phone": us["data"]["phone"]
      });

      globals.userLoggedIn.elo = 0;
    } else {
      await db.collection("users").doc(us["uid"]).set({
        "email": us["data"]["email"],
        "elo": us["data"]["elo"] - us["level"]["lose"],
        "name": us["data"]["name"],
        "password": us["data"]["password"],
        "username": us["data"]["username"],
        "phone": us["data"]["phone"]
      });

      globals.userLoggedIn.elo = us["data"]["elo"] - us["level"]["lose"];
    }
  }
}

Future<void> editUser(
    String name, String password, String username, String phone) async {
  Future<List> users = getUsers();

  User u = globals.userLoggedIn;

  List list = await users;

  var us = list.firstWhere((element) => element["data"]["email"] == u.email);

  await db.collection("users").doc(us["uid"]).set({
    "email": us["data"]["email"],
    "elo": us["data"]["elo"],
    "name": name,
    "password": password,
    "username": username,
    "phone": phone
  });

  globals.userLoggedIn.name = name;
  globals.userLoggedIn.username = username;
  globals.userLoggedIn.phone = phone;
  globals.userLoggedIn.password = password;
  globals.userLoggedIn.elo = us["data"]["elo"];
}

Future<void> deleteUser() async {
  Future<List> users = getUsers();

  User u = globals.userLoggedIn;

  List list = await users;
  var us = list.firstWhere((element) => element["data"]["email"] == u.email);

  await db.collection("users").doc(us["uid"]).delete();

  globals.isLoggedIn = false;
  globals.userLoggedIn.name = "";
  globals.userLoggedIn.username = "";
  globals.userLoggedIn.phone = "";
  globals.userLoggedIn.password = "";
}

Future<void> saveGame(int? localGoals, int? awayGoals, Lineup? lineup) async {
  Future<List> users = getUsers();

  User u = globals.userLoggedIn;

  List list = await users;
  var us = list.firstWhere((element) => element["data"]["email"] == u.email);
  await db
      .collection("games")
      .add({
        "local_goals": localGoals,
        "away_goals": awayGoals,
        "score": localGoals! > awayGoals! ? 1 : 2,
      })
      .then((value) => value.collection("lineup").add({
            "local_lineup": lineup?.getLocalLineup,
            "away_lineup": lineup?.getAwayLineup
          }))
      .then((value) => db.collection("user_game").add({
            "game_id": value.parent.parent?.id,
            "user_id": us["uid"],
          }));
}

//TODO: Obtener el usuario logueado

userLoggedIn() async {
  // Future<List> users = getUsers();

  // User u = globals.userLoggedIn;

  // List list = await users;
  // var us = list.firstWhere((element) => element["data"]["email"] == u.email);

  // final userLogged = {
  //   "uid": us["uid"],
  //   "data": us["data"],
  //   "level": us["level"]
  // };

  // return userLogged;
}

Future<void> savePlayer(Map<String, dynamic> p) async {
  Player player = p["player"] as Player;
  var category = "Bronze";
  var position = "";
  if (player.getRating >= 70 && player.getRating < 85) {
    category = "Silver";
  } else if (player.getRating >= 85) {
    category = "Gold";
  }
  switch (player.getPosition) {
    case "ST":
    case "CF":
    case "RW":
    case "LW":
      position = "DL";
      break;
    case "CAM":
    case "CM":
    case "CDM":
    case "RM":
    case "LM":
      position = "MC";
      break;
    case "CB":
    case "LB":
    case "RWB":
    case "LWB":
    case "RB":
      position = "DF";
      break;
    case "GK":
      position = "PT";
      break;
    default:
  }
  if (player.getDefense != 0 &&
      player.getDribbling != 0 &&
      player.getPassing != 0 &&
      player.getShooting != 0 &&
      player.getSpeed != 0 &&
      player.getStrength != 0) {
    var player_db = await db.collection("players").add({
      "name": player.getName,
      "position": position == "" ? player.getPosition : position,
      "rating": player.getRating,
      "defense": player.getDefense,
      "dribbling": player.getDribbling,
      "passing": player.getPassing,
      "shooting": player.getShooting,
      "speed": player.getSpeed,
      "strength": player.getStrength,
      "club_id": player.getClubId,
      "country_id": player.getCountryId,
      "category": category
    });
    // var leagueId = await getLeagueByApiId(p["league"]);
    // var clubId = await getClubByApiId(p["club"]);
    // await db.collection("player_league").add({
    //   "player_id": player_db.id,
    //   "league_id": leagueId,
    // });
    // if (clubId != "") {
    //   await db.collection("player_club").add({
    //     "player_id": player_db.id,
    //     "club_id": clubId,
    //   });
    // }
  }
}

Future<void> saveLeague(League? l) async {
  await db.collection("leagues").add({
    "name": l?.getName,
    "api_id": l?.getApiId,
    "country_id": l?.getCountryId
  });
}

Future<void> saveClub(Club? c) async {
  await db.collection("clubs").add({
    "name": c?.getName,
    "api_id": c?.getApiId,
    "league_id": c?.getleagueId,
  });
}

Future<String?> getLeagueByApiId(int? apiId) async {
  QuerySnapshot q =
      await db.collection("leagues").where('api_id', isEqualTo: apiId).get();
  var l = q.docs[0].id;
  return l;
}

Future<String?> getClubByApiId(int? apiId) async {
  QuerySnapshot q =
      await db.collection("clubs").where('api_id', isEqualTo: apiId).get();
  var c = "";
  if (q.docs.length != 0) {
    c = q.docs[0].id;
  }
  return c;
}

Future<Map<String, List<dynamic>>> getRandomPlayers() async {
  Map<String, List<dynamic>> res = {};
  QuerySnapshot pt =
      await db.collection("players").where("position", isEqualTo: "PT").get();
  QuerySnapshot df =
      await db.collection("players").where("position", isEqualTo: "DF").get();
  QuerySnapshot mc =
      await db.collection("players").where("position", isEqualTo: "MC").get();
  QuerySnapshot dl =
      await db.collection("players").where("position", isEqualTo: "DL").get();
  var npt = 0;
  var ndf = 0;
  var nmc = 0;
  var ndl = 0;
  List<dynamic> lpt = [];
  List<dynamic> ldf = [];
  List<dynamic> lmc = [];
  List<dynamic> ldl = [];

  while (npt < 3) {
    Random r = new Random();
    int rn = r.nextInt(pt.docs.length);
    var player = pt.docs[rn].data();
    lpt.add(player);
    npt++;
  }
  res.putIfAbsent("PT", () => lpt);

  while (ndf < 12) {
    Random r = new Random();
    int rn = r.nextInt(df.docs.length);
    var player = df.docs[rn].data();
    ldf.add(player);
    ndf++;
  }
  res.putIfAbsent("DF", () => ldf);

  while (nmc < 15) {
    Random r = new Random();
    int rn = r.nextInt(mc.docs.length);
    var player = mc.docs[rn].data();
    lmc.add(player);
    nmc++;
  }
  res.putIfAbsent("MC", () => lmc);

  while (ndl < 10) {
    Random r = new Random();
    int rn = r.nextInt(dl.docs.length);
    var player = dl.docs[rn].data();
    ldl.add(player);
    ndl++;
  }
  res.putIfAbsent("DL", () => ldl);

  return res;
}

Future<void> saveCountry(Country? c) async {
  await db.collection("countries").add({
    "name": c?.getName,
    "api_id": c?.getApiId,
  });
}
