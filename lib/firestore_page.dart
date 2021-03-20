import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class MyFirestorePage extends StatefulWidget {
  @override
  _MyFirestorePageState createState() => _MyFirestorePageState();
}

class _MyFirestorePageState extends State<MyFirestorePage> {
  Set<String> personList = Set();
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  CollectionReference vehicles;
  @override
  void initState() {
    getData();
    super.initState();
  }

  getData() async {
    vehicles = firestore.collection('vehicles');
    QuerySnapshot snapshot = await vehicles.get();
    snapshot.docs.forEach((QueryDocumentSnapshot queryDocumentSnapshot) {
      personList.add(queryDocumentSnapshot.data()["alıcı"]);
    });
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Flutter"),
        leading: IconButton(
          icon: Icon(Icons.edit),
          onPressed: () async {
            await vehicles.doc("uniqbirbilgidirbura").update(
              {"Satıcı": "Fatih Gemici"},
            );
          },
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            for (var i = 0; i < personList.length; i++)
              ListTile(
                title: Text(personList.toList()[i]),
              )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () async {
          await vehicles.add({"alıcı": "Rıza Lemangil", "yas": 32});
          getData();
        },
      ),
    );
  }
}
