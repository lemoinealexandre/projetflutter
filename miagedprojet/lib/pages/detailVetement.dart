import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:miagedprojet/class/Panier.dart';
import 'package:miagedprojet/class/Vetement.dart';


class DetailVetement extends StatelessWidget {
  DetailVetement({Key? key, required this.vetementSelectionne})
      : super(key: key);
  final Vetement vetementSelectionne;
  static const String _title = 'Vetement Selectionné';
  @override
  Widget build(BuildContext context) {
    final User? user = FirebaseAuth.instance.currentUser;
    final id = user?.uid;

    return MaterialApp(
      title: _title,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSwatch().copyWith(
          primary: Colors.indigo,
          //secondary: Colors.green,
        ),
      ),
      home: Scaffold(
        appBar: AppBar(

            leading: IconButton(
              icon: Icon(
                Icons.arrow_back,
                color: Colors.black,
              ),
              color: Colors.black,
              onPressed: () {
                Navigator.pop(context);
              },
            ),

            actions: <Widget>[
            ]),
        body: Padding(
          padding: const EdgeInsets.fromLTRB(0, 0, 0, 10),
          child: ListView(children: <Widget>[
            Container(
                alignment: Alignment.center,
                child: ClipRRect(
                  child: SizedBox.fromSize(
                    child: Image.network(
                      vetementSelectionne.image,
                      fit: BoxFit.cover,
                    ),
                  ),
                )),
            Container(
                alignment: Alignment.topCenter,
                child: Text(
                  vetementSelectionne.titre,
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                )),
            Container(
                alignment: Alignment.topLeft,
                child: Text(
                  vetementSelectionne.categorie +
                      " - " +
                      vetementSelectionne.marque,
                  style: TextStyle(fontSize: 20),
                )),
            Container(
                alignment: Alignment.topLeft,
                child: Text(
                  vetementSelectionne.taille,
                  style: TextStyle(fontSize: 20),
                )),
            Container(
                alignment: Alignment.center,
                child: Text(
                  vetementSelectionne.prix.toString() + " €",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                )),
            Container(
                height: 60,
                padding: const EdgeInsets.fromLTRB(10, 20, 10, 0),
                child: ElevatedButton(
                  style: OutlinedButton.styleFrom(
                    backgroundColor: Colors.green, //<-- SEE HERE
                  ),
                  child: const Text('Ajouter au panier'),
                  onPressed: ()  async {

                    try{
                      DocumentReference docRef = FirebaseFirestore.instance.collection("Panier").doc(id);
                      List<dynamic>? listIdVetements;
                      listIdVetements = await docRef.get().then((value) {
                          return value.get('idVetements');
                      });
                      listIdVetements?.add(vetementSelectionne.id);
                      FirebaseFirestore.instance.collection("Panier").doc(id).update({'idVetements': listIdVetements});

                      showDialog(
                        context: context,
                        builder: (BuildContext context) => _buildPopupDialog(context, "Article ajouté au panier"),
                      );
                    }
                    on FirebaseException catch (e){
                      builder: (BuildContext context) => _buildPopupDialog(context, "Erreur article non ajouté au panier");
                  }
                  },
                )),
          ]),
        ),
      ),
    );
  }

  Widget _buildPopupDialog(BuildContext context, String text) {
    return AlertDialog(
      title: Text(text),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
      ),
    );
  }
}
