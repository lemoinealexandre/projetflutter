import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:miagedprojet/class/Profil.dart';
import 'package:miagedprojet/pages/creeVetement.dart';

import '../main.dart';

late Profil profilUser;
var db = FirebaseFirestore.instance;

TextEditingController nomController = TextEditingController();
TextEditingController motdepasseController = TextEditingController();
TextEditingController anniversaireController = TextEditingController();
TextEditingController adresseController = TextEditingController();
TextEditingController codepostalController = TextEditingController();
TextEditingController villeController = TextEditingController();
late UserCredential user;

class CreerCompte extends StatelessWidget {
  const CreerCompte({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Créer un compte'),
        ),
        body: const CreerCompteUser(),
      ),
    );
  }
}

class CreerCompteUser extends StatefulWidget {
  const CreerCompteUser({Key? key}) : super(key: key);
  @override
  State<CreerCompteUser> createState() => _CreerCompteUser();
}

class _CreerCompteUser extends State<CreerCompteUser> {
  @override
  Widget build(BuildContext context) {
    final User? user = FirebaseAuth.instance.currentUser;
    final id = user?.uid;

    return Padding(
        padding: const EdgeInsets.all(10),
        child: ListView(children: <Widget>[
          Container(
            padding: EdgeInsets.all(10),
            child: TextField(
              controller: nomController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Adresse mail',
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
            child: TextField(
              obscureText: true,

              controller: motdepasseController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Mot de passe',
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.all(10),
            child: TextField(
              controller: anniversaireController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Anniversaire',
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.all(10),
            child: TextField(
              controller: adresseController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Adresse',
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.all(10),
            child: TextField(
              controller: codepostalController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Code Postal',
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.all(10),
            child: TextField(
              controller: villeController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Ville',
              ),
            ),
          ),
          Container(
              height: 60,
              padding: const EdgeInsets.fromLTRB(10, 20, 10, 0),
              child: ElevatedButton(
                style: OutlinedButton.styleFrom(
                  backgroundColor: Colors.green, //<-- SEE HERE
                ),
                child: const Text('Créer'),
                onPressed: () async {
                  try {
                    UserCredential userCredential = await FirebaseAuth.instance
                        .createUserWithEmailAndPassword(
                            email: nomController.text,
                            password: motdepasseController.text);
                    final createAccount = <String, dynamic>{
                      "adresse": adresseController.text,
                      "anniversaire": anniversaireController.text,
                      "codePostal": codepostalController.text,
                      "mail": nomController.text,
                      "ville": villeController.text,
                    };
                    db.collection("Profil").doc(userCredential.user!.uid).set(createAccount);
                    List<dynamic>? listIdVetements = [];
                    db.collection("Panier").doc(userCredential.user!.uid).set({'idVetements': listIdVetements});
                    nomController.clear();
                    anniversaireController.clear();
                    adresseController.clear();
                    codepostalController.clear();
                    villeController.clear();

                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => MyApp()),
                    );
                  } on FirebaseAuthException catch (e) {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) =>
                          _buildPopupDialog(context, "Erreur"),
                    );
                  }
                },
              )),
          Container(
              height: 60,
              padding: const EdgeInsets.fromLTRB(10, 20, 10, 0),
              child: ElevatedButton(
                style: OutlinedButton.styleFrom(
                  backgroundColor: Colors.red, //<-- SEE HERE
                ),
                child: const Text('Retour'),
                onPressed: () async {
                  Navigator.of(context, rootNavigator: true).pushReplacement(
                      MaterialPageRoute(builder: (context) => const MyApp()));
                },
              )),
        ]));
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
