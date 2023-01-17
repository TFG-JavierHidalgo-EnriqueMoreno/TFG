import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:my_app/entities/globals.dart' as globals;
import 'package:my_app/entities/level.dart';
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
  }).then((value) => value.collection("level").add({"name": "Plata"}));
}

Future<void> calcElo() async {
  Future<List> users = getUsers();

  User u = globals.userLoggedIn;

  List list = await users;

  var us = list.firstWhere((element) => element["data"]["email"] == u.email);

  switch (us["level"]["name"]) {
    case "Bronce":
      if (us["data"]["elo"] + 3 >= 10) {
        QuerySnapshot level = await db
            .collection("users")
            .doc(us["uid"])
            .collection("level")
            .get();
        String levelId = level.docs[0].id;
        await db
            .collection("users")
            .doc(us["uid"])
            .collection("level")
            .doc(levelId)
            .set({"name": "Plata"});
      }
      await db.collection("users").doc(us["uid"]).set({
        "email": us["data"]["email"],
        "elo": us["data"]["elo"] + 3,
        "name": us["data"]["name"],
        "password": us["data"]["password"],
        "username": us["data"]["username"],
        "phone": us["data"]["phone"]
      });

      globals.userLoggedIn.elo = us["data"]["elo"] + 3;
      globals.userLevel.name = us["data"]["elo"] + 3 >= 10 ? "Plata" : "Bronce";
      break;
    case "Plata":
      if (us["data"]["elo"] + 3 >= 15) {
        QuerySnapshot level = await db
            .collection("users")
            .doc(us["uid"])
            .collection("level")
            .get();
        String levelId = level.docs[0].id;
        await db
            .collection("users")
            .doc(us["uid"])
            .collection("level")
            .doc(levelId)
            .set({"name": "Oro"});
      }
      await db.collection("users").doc(us["uid"]).set({
        "email": us["data"]["email"],
        "elo": us["data"]["elo"] + 3,
        "name": us["data"]["name"],
        "password": us["data"]["password"],
        "username": us["data"]["username"],
        "phone": us["data"]["phone"]
      });
      globals.userLoggedIn.elo = us["data"]["elo"] + 3;
      globals.userLevel.name = us["data"]["elo"] + 3 >= 15 ? "Oro" : "Plata";
      break;
    case "Oro":
      await db.collection("users").doc(us["uid"]).set({
        "email": us["data"]["email"],
        "elo": us["data"]["elo"] + 3,
        "name": us["data"]["name"],
        "password": us["data"]["password"],
        "username": us["data"]["username"],
        "phone": us["data"]["phone"]
      });
      globals.userLoggedIn.elo = us["data"]["elo"] + 3;
      break;
    case "Platino":
      await db.collection("users").doc(us["uid"]).set({
        "email": us["data"]["email"],
        "elo": us["data"]["elo"] + 3,
        "name": us["data"]["name"],
        "password": us["data"]["password"],
        "username": us["data"]["username"],
        "phone": us["data"]["phone"]
      });
      globals.userLoggedIn.elo = us["data"]["elo"] + 3;
      break;
    case "Diamante":
      await db.collection("users").doc(us["uid"]).set({
        "email": us["data"]["email"],
        "elo": us["data"]["elo"] + 3,
        "name": us["data"]["name"],
        "password": us["data"]["password"],
        "username": us["data"]["username"],
        "phone": us["data"]["phone"]
      });
      globals.userLoggedIn.elo = us["data"]["elo"] + 3;
      break;
    case "Maestro":
      await db.collection("users").doc(us["uid"]).set({
        "email": us["data"]["email"],
        "elo": us["data"]["elo"] + 3,
        "name": us["data"]["name"],
        "password": us["data"]["password"],
        "username": us["data"]["username"],
        "phone": us["data"]["phone"]
      });
      globals.userLoggedIn.elo = us["data"]["elo"] + 3;
      break;
    default:
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
