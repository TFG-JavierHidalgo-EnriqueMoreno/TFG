import 'package:cloud_firestore/cloud_firestore.dart';

FirebaseFirestore db = FirebaseFirestore.instance;

Future<List> getUsers() async {
  List users = [];

  CollectionReference cUsers = db.collection("users");
  QuerySnapshot q = await cUsers.get();

  for (int i = 0; i < q.docs.length; i++) {
    users.add(q.docs[i].data());
  }

  return users;
}
