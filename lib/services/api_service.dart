import 'dart:convert' as convert;
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:my_app/entities/club.dart';
import 'package:my_app/entities/league.dart';
import 'package:my_app/entities/player.dart';
import 'package:my_app/services/firebase_service.dart';

const String apiKey = "b7745036-86bb-4216-907a-b2f4e50f2f76";
const String urlPlayers = "https://futdb.app/api/players?page=20";
const String urlLeagues = "https://futdb.app/api/leagues";
const String urlClubs = "https://futdb.app/api/clubs?page=";

void getLeagues() async {
  final response = await http.get(
    Uri.parse(urlLeagues),
    // Send authorization headers to the backend.
    headers: {
      "X-AUTH-TOKEN": apiKey,
    },
  );
  // Await the http get response, then decode the json-formatted response.

  if (response.statusCode == 200) {
    var jsonResponse =
        convert.jsonDecode(response.body) as Map<String, dynamic>;
    jsonResponse["items"].forEach((e) {
      if (e["id"] == 13 ||
          e["id"] == 16 ||
          e["id"] == 19 ||
          e["id"] == 31 ||
          e["id"] == 53) {
        League? l = League();
        l.newLeague(e["name"], e["id"]);
        saveLeague(l);
      }
    });
  }
}

void getClubs() async {
  int totalPages = 0;
  final response = await http.get(
    Uri.parse('${urlClubs}1'),
    // Send authorization headers to the backend.
    headers: {
      "X-AUTH-TOKEN": apiKey,
    },
  );
  // Await the http get response, then decode the json-formatted response.

  if (response.statusCode == 200) {
    var jsonResponse =
        convert.jsonDecode(response.body) as Map<String, dynamic>;
    jsonResponse["items"].forEach((e) {
      if (e["league"] == 13 ||
          e["league"] == 16 ||
          e["league"] == 19 ||
          e["league"] == 31 ||
          e["league"] == 53) {
        if (e["name"] != 'HERO') {
          Club? c = Club();
          c.newClub(e["name"], e["id"]);
          saveClub(c);
        }
      }
    });
    totalPages = jsonResponse["pagination"]["pageTotal"];
    for (var i = 2; i <= totalPages; i++) {
      var r = await http.get(
        Uri.parse('$urlClubs$i'),
        // Send authorization headers to the backend.
        headers: {
          "X-AUTH-TOKEN": apiKey,
        },
      );
      if (response.statusCode == 200) {
        var jr = convert.jsonDecode(r.body) as Map<String, dynamic>;
        jr["items"].forEach((e) {
          if (e["league"] == 13 ||
              e["league"] == 16 ||
              e["league"] == 19 ||
              e["league"] == 31 ||
              e["league"] == 53) {
            if (e["name"] != 'HERO') {
              Club? c = Club();
              c.newClub(e["name"], e["id"]);
              saveClub(c);
            }
          }
        });
      }
    }
  }
}

void getPlayers() async {
  // This example uses the Google Books API to search for books about http.
  // https://developers.google.com/books/docs/overview

  final response = await http.get(
    Uri.parse(urlPlayers),
    // Send authorization headers to the backend.
    headers: {
      "X-AUTH-TOKEN": apiKey,
    },
  );
  // Await the http get response, then decode the json-formatted response.

  if (response.statusCode == 200) {
    var jsonResponse =
        convert.jsonDecode(response.body) as Map<String, dynamic>;
    //var itemCount = jsonResponse['totalItems'];
    //print('Number of books about http: $itemCount.');
    List addPlayers = [];
    jsonResponse["items"].forEach((e) {
      if ((e["league"] == 13 ||
              e["league"] == 16 ||
              e["league"] == 19 ||
              e["league"] == 31 ||
              e["league"] == 53) &&
          !(addPlayers.contains(e["name"])) &&
          e["club"] != 114605) {
        Player p = Player();
        p.newPlayer(
            e["name"],
            e["position"],
            e["rating"],
            e["defending"],
            e["dribbling"],
            e["passing"],
            e["shooting"],
            e["pace"],
            e["physicality"]);
        addPlayers.add(e["name"]);
        final player = {"player": p, "league": e["league"], "club": e["club"]};
        savePlayer(player);
      }
    });
  } else {
    print('Request failed with status: ${response.statusCode}.');
  }
}
