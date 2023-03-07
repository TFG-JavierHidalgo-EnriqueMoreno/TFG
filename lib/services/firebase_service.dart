import 'dart:convert';
import 'dart:developer';

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
        "lose": 0,
        "num_bronzes": 20,
        "num_golds": 2,
        "num_silvers": 13,
        "team_value": 350
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
          "name": nextLevel.docs[0].data()["name"],
          "min": nextLevel.docs[0].data()["min"],
          "max": nextLevel.docs[0].data()["max"],
          "next": nextLevel.docs[0].data()["next"],
          "previous": nextLevel.docs[0].data()["previous"],
          "victory": nextLevel.docs[0].data()["victory"],
          "lose": nextLevel.docs[0].data()["lose"],
          "num_bronzes": nextLevel.docs[0].data()["num_bronzes"],
          "num_golds": nextLevel.docs[0].data()["num_golds"],
          "num_silvers": nextLevel.docs[0].data()["num_silvers"],
          "team_value": nextLevel.docs[0].data()["team_value"]
        });
        globals.userLevel.name = us["level"]["next"];
        globals.userLevel.teamValue = nextLevel.docs[0].data()["team_value"];
        globals.userLevel.numBronzes = nextLevel.docs[0].data()["num_bronzes"];
        globals.userLevel.numSilvers = nextLevel.docs[0].data()["num_silvers"];
        globals.userLevel.numGolds = nextLevel.docs[0].data()["num_golds"];
      }
      await db.collection("users").doc(us["uid"]).set({
        "email": us["data"]["email"],
        "elo": us["data"]["elo"] + us["level"]["victory"],
        "name": us["data"]["name"],
        "password": us["data"]["password"],
        "username": us["data"]["username"],
        "phone": us["data"]["phone"],
        "status": us["data"]["status"],
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
        "phone": us["data"]["phone"],
        "status": us["data"]["status"],
      });

      globals.userLoggedIn.elo = 250;
    } else {
      await db.collection("users").doc(us["uid"]).set({
        "email": us["data"]["email"],
        "elo": us["data"]["elo"] + us["level"]["victory"],
        "name": us["data"]["name"],
        "password": us["data"]["password"],
        "username": us["data"]["username"],
        "phone": us["data"]["phone"],
        "status": us["data"]["status"],
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
          "name": previousLevel.docs[0].data()["name"],
          "min": previousLevel.docs[0].data()["min"],
          "max": previousLevel.docs[0].data()["max"],
          "next": previousLevel.docs[0].data()["next"],
          "previous": previousLevel.docs[0].data()["previous"],
          "victory": previousLevel.docs[0].data()["victory"],
          "lose": previousLevel.docs[0].data()["lose"],
          "num_bronzes": previousLevel.docs[0].data()["num_bronzes"],
          "num_golds": previousLevel.docs[0].data()["num_golds"],
          "num_silvers": previousLevel.docs[0].data()["num_silvers"],
          "team_value": previousLevel.docs[0].data()["team_value"]
        });
        globals.userLevel.name = us["level"]["previous"];
        globals.userLevel.teamValue =
            previousLevel.docs[0].data()["team_value"];
        globals.userLevel.numBronzes =
            previousLevel.docs[0].data()["num_bronzes"];
        globals.userLevel.numSilvers =
            previousLevel.docs[0].data()["num_silvers"];
        globals.userLevel.numGolds = previousLevel.docs[0].data()["num_golds"];
      }
      await db.collection("users").doc(us["uid"]).set({
        "email": us["data"]["email"],
        "elo": us["data"]["elo"] - us["level"]["lose"],
        "name": us["data"]["name"],
        "password": us["data"]["password"],
        "username": us["data"]["username"],
        "phone": us["data"]["phone"],
        "status": us["data"]["status"],
      });

      globals.userLoggedIn.elo = us["data"]["elo"] - us["level"]["lose"];
    } else if (us["data"]["elo"] - us["level"]["lose"] <= us["level"]["min"]) {
      await db.collection("users").doc(us["uid"]).set({
        "email": us["data"]["email"],
        "elo": 0,
        "name": us["data"]["name"],
        "password": us["data"]["password"],
        "username": us["data"]["username"],
        "phone": us["data"]["phone"],
        "status": us["data"]["status"],
      });

      globals.userLoggedIn.elo = 0;
    } else {
      await db.collection("users").doc(us["uid"]).set({
        "email": us["data"]["email"],
        "elo": us["data"]["elo"] - us["level"]["lose"],
        "name": us["data"]["name"],
        "password": us["data"]["password"],
        "username": us["data"]["username"],
        "phone": us["data"]["phone"],
        "status": us["data"]["status"],
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
    "phone": phone,
    "status": "not_playing",
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

Future<void> saveGame(int? localGoals, int? awayGoals) async {
  Future<List> users = getUsers();
  User u = globals.userLoggedIn;

  List list = await users;
  var us = list.firstWhere((element) => element["data"]["email"] == u.email);

  QuerySnapshot<Map<String, dynamic>> lastGame = await getLastGame();

  await db.collection("games").doc(lastGame.docs[0].id).update({
    "local_goals": localGoals,
    "away_goals": awayGoals,
    "score": localGoals! > awayGoals! ? 1 : 2,
  });
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
  var category = "";
  var position = "";
  var price = 0;
  if (player.getRating < 70) {
    //MAX: 24
    category = "Bronze";
    price = (player.getRating * 0.35).round();
  } else if (player.getRating >= 70 && player.getRating < 85) {
    //MIN: 35 MAX: 42
    category = "Silver";
    price = (player.getRating * 0.5).round();
  } else {
    //MIN:52  MAX: 59
    category = "Gold";
    price = (player.getRating * 0.6).round();
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
      "category": category,
      "price": price
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

  QuerySnapshot players = await db.collection('players').get();

  var npt = 0;
  var ndf = 0;
  var nmc = 0;
  var ndl = 0;
  List<dynamic> lpt = [];
  List<dynamic> ldf = [];
  List<dynamic> lmc = [];
  List<dynamic> ldl = [];
  int oro = 0;
  int plata = 0;
  int bronce = 0;
  int oroMax = globals.userLevel.getNumGolds;
  int plataMax = globals.userLevel.getNumSilvers;
  int bronceMax = globals.userLevel.getNumBronzes;

  while (npt < 3 || ndf < 11 || nmc < 12 || ndl < 9) {
    Random r = new Random();
    int rn = r.nextInt(players.docs.length);
    var player = players.docs[rn].data() as Map;
    var idPlayer = players.docs[rn].id.toString();
    player["bd_id"] = idPlayer;

    switch (player["category"]) {
      case "Gold":
        if (oro < oroMax) {
          switch (player["position"]) {
            case "DL":
              if (ndl < 9) {
                ldl.add(player);
                ndl++;
                oro++;
              }
              break;
            case "MC":
              if (nmc < 12) {
                lmc.add(player);
                nmc++;
                oro++;
              }
              break;
            case "DF":
              if (ndf < 11) {
                ldf.add(player);
                ndf++;
                oro++;
              }
              break;
            case "PT":
              if (npt < 3) {
                lpt.add(player);
                npt++;
                oro++;
              }
              break;
            default:
          }
        }
        break;
      case "Silver":
        if (plata < plataMax) {
          switch (player["position"]) {
            case "DL":
              if (ndl < 9) {
                ldl.add(player);
                ndl++;
                plata++;
              }
              break;
            case "MC":
              if (nmc < 12) {
                lmc.add(player);
                nmc++;
                plata++;
              }
              break;
            case "DF":
              if (ndf < 11) {
                ldf.add(player);
                ndf++;
                plata++;
              }
              break;
            case "PT":
              if (npt < 3) {
                lpt.add(player);
                npt++;
                plata++;
              }
              break;
            default:
          }
        }
        break;
      case "Bronze":
        if (bronce < bronceMax) {
          switch (player["position"]) {
            case "DL":
              if (ndl < 9) {
                ldl.add(player);
                ndl++;
                bronce++;
              }
              break;
            case "MC":
              if (nmc < 12) {
                lmc.add(player);
                nmc++;
                bronce++;
              }
              break;
            case "DF":
              if (ndf < 11) {
                ldf.add(player);
                ndf++;
                bronce++;
              }
              break;
            case "PT":
              if (npt < 3) {
                lpt.add(player);
                npt++;
                bronce++;
              }
              break;
            default:
          }
        }
        break;
      default:
    }
  }

  lpt.sort((b, a) => a['price'].compareTo(b['price']));
  ldf.sort((b, a) => a['price'].compareTo(b['price']));
  lmc.sort((b, a) => a['price'].compareTo(b['price']));
  ldl.sort((b, a) => a['price'].compareTo(b['price']));

  res.putIfAbsent("PT", () => lpt);
  res.putIfAbsent("DF", () => ldf);
  res.putIfAbsent("MC", () => lmc);
  res.putIfAbsent("DL", () => ldl);

  return res;
}

Future<void> saveCountry(Country? c) async {
  await db.collection("countries").add({
    "name": c?.getName,
    "api_id": c?.getApiId,
  });
}

Future<Map<String, List<dynamic>>> searchGame() async {
  Map<String, List<dynamic>> res = {};
  var player1 = await db
      .collection('users')
      .where('email', isEqualTo: globals.userLoggedIn.email)
      .get();

  db
      .collection("users")
      .doc(player1.docs[0].id)
      .update({"status": "searching"});

  int max = player1.docs[0].data()["elo"] + 20;
  int min = player1.docs[0].data()["elo"] - 20;

  var allPlayers = await db
      .collection('users')
      .where('status', isEqualTo: "searching")
      .where('elo', isLessThanOrEqualTo: max)
      .where('elo', isGreaterThanOrEqualTo: min)
      .get();
  var player2;
  if (allPlayers.docs.length > 1) {
    player2 = allPlayers.docs.firstWhere(
        (element) => element.data()["email"] != globals.userLoggedIn.email);
    await db
        .collection("users")
        .doc(player1.docs[0].id)
        .update({"status": "playing"});

    await db.collection("users").doc(player2.id).update({"status": "playing"});

    await db
        .collection("games")
        .add({"away_goals": 0, "local_goals": 0, "score": 0}).then((value) {
      db.collection("user_game").add({
        "game_id": value.id,
        "user_id": player1.docs[0].id,
        "created_at": Timestamp.now()
      });

      db.collection("user_game").add({
        "game_id": value.id,
        "user_id": player2.id,
        "created_at": Timestamp.now()
      });
    });
    res.putIfAbsent("player1", () => [player1.docs[0].data()]);
    res.putIfAbsent("player2", () => [player2]);
    return res;
  }
  return {};
}

resetPlayerState() async {
  var player = await db
      .collection('users')
      .where('email', isEqualTo: globals.userLoggedIn.email)
      .get();
  await db
      .collection("users")
      .doc(player.docs[0].id)
      .update({"status": "not_playing"});
}

Future<String> checkPlayerStatus() async {
  var player = await db
      .collection('users')
      .where('email', isEqualTo: globals.userLoggedIn.email)
      .get();

  return player.docs[0].data()["status"];
}

Future<String> checkOtherPlayerStatus() async {
  var player2 = await getPlayer2();

  return player2.data()["status"];
}

getPlayer2() async {
  var player = await db
      .collection('users')
      .where('email', isEqualTo: globals.userLoggedIn.email)
      .get();
  var game = await db
      .collection('user_game')
      .where('user_id', isEqualTo: player.docs[0].id)
      .orderBy('created_at', descending: true)
      .limit(1)
      .get();
  var otherPlayer = await db
      .collection('user_game')
      .where('game_id', isEqualTo: game.docs[0].data()["game_id"])
      .where('user_id', isNotEqualTo: player.docs[0].id)
      .get();
  var player2 = await db
      .collection('users')
      .doc(otherPlayer.docs[0].data()["user_id"])
      .get();
  return player2;
}

Future<QuerySnapshot<Map<String, dynamic>>> getLastGame() async {
  var player = await db
      .collection('users')
      .where('email', isEqualTo: globals.userLoggedIn.email)
      .get();
  var game = await db
      .collection('user_game')
      .where('user_id', isEqualTo: player.docs[0].id)
      .orderBy('created_at', descending: true)
      .limit(1)
      .get();

  return game;
}

readyPlayer() async {
  var player1 = await db
      .collection('users')
      .where('email', isEqualTo: globals.userLoggedIn.email)
      .get();

  db.collection("users").doc(player1.docs[0].id).update({"status": "ready"});
}

saveUserPlayer(Lineup? lineup, Map<int, dynamic> selectedPlayers) async {
  Future<List> users = getUsers();
  User u = globals.userLoggedIn;

  List list = await users;
  var us = list.firstWhere((element) => element["data"]["email"] == u.email);

  QuerySnapshot<Map<String, dynamic>> lastGame = await getLastGame();

  await db
      .collection("games")
      .doc(lastGame.docs[0]["game_id"])
      .collection("lineup")
      .add({
    "local_lineup": lineup?.getLocalLineup,
    "away_lineup": lineup?.getAwayLineup
  });
  var gameUser = await db
      .collection("user_game")
      .where("game_id", isEqualTo: lastGame.docs[0]["game_id"])
      .where("user_id", isEqualTo: us["uid"])
      .get();

  await db
      .collection("user_game")
      .where("game_id", isEqualTo: lastGame.docs[0].data()["game_id"])
      .where("user_id", isEqualTo: us["uid"])
      .get()
      .then((value) {
    print(value.docs[0].id);
    inspect(value.docs[0].data());
    db.collection("user_game").doc(value.docs[0].id).collection("players").add({
      "player0": selectedPlayers[0]["bd_id"],
      "player1": selectedPlayers[1]["bd_id"],
      "player2": selectedPlayers[2]["bd_id"],
      "player3": selectedPlayers[3]["bd_id"],
      "player4": selectedPlayers[4]["bd_id"],
      "player5": selectedPlayers[5]["bd_id"],
      "player6": selectedPlayers[6]["bd_id"],
      "player7": selectedPlayers[7]["bd_id"],
      "player8": selectedPlayers[8]["bd_id"],
      "player9": selectedPlayers[9]["bd_id"],
      "player10": selectedPlayers[10]["bd_id"]
    });
  });
}

getPlayer2Players() async {
  var player2 = await getPlayer2();
  var game = await getLastGame();
  var res = await db
      .collection("user_game")
      .where("game_id", isEqualTo: game.docs[0].id)
      .where("user_id", isEqualTo: player2.id)
      .get();

  return await db
      .collection("user_game")
      .doc(res.docs[0].id)
      .collection("players")
      .get();
}
