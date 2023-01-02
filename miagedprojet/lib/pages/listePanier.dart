import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../class/Vetement.dart';

List<Vetement> _listeVetementPanier = [];
double totalPanier = 0;
int _listePanierTaille = 0;

List<dynamic>? listIdVetements;

class ListePanier extends StatelessWidget {
  const ListePanier({super.key});

  static const String _title = 'Panier';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: _title,
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Votre panier'),
        ),

        body: const PagePanier(),

      ),
    );
  }
}

var db = FirebaseFirestore.instance;

class PagePanier extends StatefulWidget {
  const PagePanier({super.key});

  @override
  State<PagePanier> createState() => _PagePanier();
}

class _PagePanier extends State<PagePanier> {
  @override
  Widget build(BuildContext context) {
    return DefaultTextStyle(
      style: Theme.of(context).textTheme.headline2!,
      textAlign: TextAlign.center,
      child: SingleChildScrollView(
        child: FutureBuilder<String>(
          future: takeData(), // a previously-obtained Future<String> or null
          builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
            List<Widget> children;
            if (snapshot.hasData) {
              children = <Widget>[
                GridView.count(
                  primary: false,
                  childAspectRatio: 4 / 2.2,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  crossAxisCount: 1,
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  children: List.generate(_listePanierTaille, (index) {
                    return Center(
                      child: Card(
                        child: InkWell(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              Image(
                                image: NetworkImage(
                                    _listeVetementPanier[index].image),
                                fit: BoxFit.contain,
                                height: 130,
                                width: 130,
                              ),
                              Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Text(_listeVetementPanier[index].titre),
                                    const SizedBox(width: 15),
                                    const SizedBox(width: 8),
                                    IconButton(
                                      icon: const Icon(
                                        Icons.close,
                                        color: Colors.red,
                                      ),
                                      color: Colors.black,
                                      onPressed: () {
                                        User? user = FirebaseAuth.instance.currentUser;
                                        var id = user?.uid;
                                        listIdVetements?.remove(_listeVetementPanier[index].id);
                                        FirebaseFirestore.instance.collection("Panier").doc(id).update({'idVetements': listIdVetements});
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  ListePanier()),
                                        );
                                      },
                                    ),
                                  ]),
                              Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: <Widget>[
                                    Text(
                                        "taille : ${_listeVetementPanier[index].taille}"),
                                    const SizedBox(width: 15),
                                  ]),
                              Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Text(
                                      "${_listeVetementPanier[index].prix} €",
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                    const SizedBox(width: 15),
                                  ]),
                            ],
                          ),
                        ),
                      ),
                    );
                  }),
                ),
                BottomAppBar(
                  child: Text(
                    'Total du panier : $totalPanier €',
                    style: const TextStyle(fontSize: 14),
                  ),
                ),

              ];
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
              children = const <Widget>[
                SizedBox(
                  width: 60,
                  height: 60,
                  child: CircularProgressIndicator(),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 16),
                  child: Text('Chargement'),
                ),
              ];
            }
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: children,
              ),
            );
          },
        ),
      ),
    );
  }

  Future<String> takeData() async {
    totalPanier = 0;
    User? user = FirebaseAuth.instance.currentUser;
    var id = user?.uid;
    _listeVetementPanier.clear();
    listIdVetements?.clear();
    print(id);
    DocumentReference docRef =
        FirebaseFirestore.instance.collection("Panier").doc(id);

    listIdVetements = await docRef.get().then((value) {
      return value.get('idVetements');
    });


    for (var doc in listIdVetements!) {
      print(doc);
      await db.collection("Vetement").doc(doc).get().then((DocumentSnapshot doc) {
        final data = doc.data() as Map<String, dynamic>;
        Vetement vetement = Vetement.fromJson(data);
        vetement.id = doc.id;
        _listeVetementPanier.add(vetement);
      });
    }
    print(_listeVetementPanier.length);
    _listePanierTaille = _listeVetementPanier.length;
    for (var val in _listeVetementPanier) {
      print(val.prix);
        totalPanier += val.prix;

    }
    return "Data Loaded";
  }
}
