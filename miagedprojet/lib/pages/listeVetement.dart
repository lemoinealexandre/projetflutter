import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../class/Vetement.dart';
import 'detailVetement.dart';

List<Vetement> _listeVetement = [];
int _listeVetementTaille = 0;
var db = FirebaseFirestore.instance;

class ListeVetement extends StatelessWidget {
  const ListeVetement({super.key});

  static const String _title = 'Liste des vetements';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: _title,
      home: DefaultTabController(
        length: 4,
        child: Scaffold(
          appBar: AppBar(
            title: const Text('Liste des vetements'),
          ),
          body: DefaultTextStyle(
            style: Theme.of(context).textTheme.headline2!,
            textAlign: TextAlign.center,
            child: SingleChildScrollView(
              child: FutureBuilder<String>(
                future: takeData(),
              // a previously-obtained Future<String> or null
                builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
                  List<Widget> children;
                  if (snapshot.hasData) {
                    children = <Widget>[
                      GridView.count(
                        primary: false,
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 10,
                        crossAxisCount: 2,
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        children: List.generate(_listeVetementTaille, (index) {
                          return Center(
                            child: Card(
                              child: InkWell(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => DetailVetement(
                                            vetementSelectionne:
                                            _listeVetement[index])),
                                  );
                                },
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: <Widget>[
                                    Image(
                                      image:
                                      NetworkImage(_listeVetement[index].image),
                                      fit: BoxFit.contain,
                                      height: 130,
                                      width: 130,
                                    ),
                                    Row(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        children: <Widget>[
                                          Text(_listeVetement[index].titre),
                                          const SizedBox(width: 15),
                                        ]),
                                    Row(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        children: <Widget>[
                                          Text("taille : " +
                                              _listeVetement[index].taille),
                                          const SizedBox(width: 15),
                                        ]),
                                    Row(
                                        mainAxisAlignment: MainAxisAlignment.end,
                                        children: <Widget>[
                                          Text(
                                            _listeVetement[index].prix.toString() +
                                                " €",
                                            style: TextStyle(
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
                      )
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
          ),
        ),
      ),
    );
  }
  Future<String> takeData() async {
    _listeVetement.clear();
    await db.collection("Vetement").get().then((event) {
      for (var doc in event.docs) {
        //print("${doc.id} => ${doc.data()}");
        var data = doc.data() as Map<String, dynamic>;
        Vetement vetement = Vetement.fromJson(data);
        vetement.id = doc.id;
        _listeVetement.add(vetement);
        print("${vetement.id} ${vetement.titre}");
      }
    });
    _listeVetementTaille = _listeVetement.length;
    print(_listeVetementTaille);
    return "Data Loaded";
  }

}


