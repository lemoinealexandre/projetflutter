import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:learning_object_detection/learning_object_detection.dart';
import 'package:miagedprojet/pages/profils.dart';



var db = FirebaseFirestore.instance;

TextEditingController imageController = TextEditingController();
TextEditingController titreController = TextEditingController();
TextEditingController categorieController = TextEditingController();
TextEditingController tailleController = TextEditingController();
TextEditingController marqueController = TextEditingController();
TextEditingController prixController = TextEditingController();

late UserCredential user;


class CreeVetement extends StatelessWidget {
  const CreeVetement({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        colorScheme: ColorScheme.fromSwatch().copyWith(
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
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) =>  Profils()),
              );
            },
          ),
          title: const Text('Mettre en vente un vetement'),
        ),        body: const AddNewVetement(),
      ),
    );
  }
}

class AddNewVetement extends StatefulWidget {
  const AddNewVetement({Key? key}) : super(key: key);
  @override
  State<AddNewVetement> createState() => _AddNewVetementState();
}

class _AddNewVetementState extends State<AddNewVetement> {





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
              controller: imageController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Image',
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.all(10),
            child: TextField(
              controller: titreController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Titre',
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.all(10),
            child: TextField(
              controller: categorieController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Categorie',
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.all(10),
            child: TextField(
              controller: tailleController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Taille',
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.all(10),
            child: TextField(
              controller: marqueController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Marque',
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.all(10),
            child: TextField(
              controller: prixController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Prix de vente',
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
                child: const Text('Mettre en vente'),
                onPressed: () async {
                  final addVetement = <String, dynamic>{
                    "categorie":categorieController.text,
                    "image":imageController.text,
                    "marque":marqueController.text,
                    "prix":double.parse(prixController.text),
                    "taille":tailleController.text,
                    "titre":titreController.text,
                  };
                  
                  db.collection("Vetement").add(addVetement).then((DocumentReference doc) => print('DocumentSnapshot added with ID: ${doc.id}'));

                  categorieController.clear();
                  imageController.clear();
                  marqueController.clear();
                  prixController.clear();
                  tailleController.clear();
                  titreController.clear();
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) =>  Profils()),
                  );
                },
              )),
        ]));
  }



}
