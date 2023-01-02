import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:miagedprojet/class/Profil.dart';
import 'package:miagedprojet/main.dart';
import 'package:miagedprojet/pages/creeVetement.dart';


late Profil profilUser;
var db = FirebaseFirestore.instance;

TextEditingController nomController = TextEditingController();
TextEditingController motdepasseController = TextEditingController(text: "************");
TextEditingController anniversaireController = TextEditingController();
TextEditingController adresseController = TextEditingController();
TextEditingController codepostalController = TextEditingController();
TextEditingController villeController = TextEditingController();
late UserCredential user;


class Profils extends StatelessWidget {
  const Profils({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        colorScheme: ColorScheme.fromSwatch().copyWith(
        ),
      ),
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Mon profil'),
            actions: <Widget>[
              Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: IconButton(
                    icon: Icon(
                      Icons.save,
                    ),
                    color: Colors.black,
                    onPressed: () {
                      final User? user = FirebaseAuth.instance.currentUser;
                      final id = user?.uid;

                      final profilUser = <String, dynamic>{
                        "adresse":adresseController.text,
                        "anniversaire":anniversaireController.text,
                        "codePostal":codepostalController.text,
                        "ville":villeController.text,
                      };

                      FirebaseFirestore.instance.collection("Profil").doc(id).update(profilUser);

                      if(motdepasseController.text != "************"){
                        user?.updatePassword(motdepasseController.text);
                      }
                    },
                  )),
            ],
        ),        body: const UpdateProfileUser(),
      ),
    );
  }
}

class UpdateProfileUser extends StatefulWidget {
  const UpdateProfileUser({Key? key}) : super(key: key);
  @override
  State<UpdateProfileUser> createState() => _UpdateProfileUserState();
}

class _UpdateProfileUserState extends State<UpdateProfileUser> {





  @override
  Widget build(BuildContext context) {

    final User? user = FirebaseAuth.instance.currentUser;
    final id = user?.uid;

    FirebaseFirestore.instance.collection("Profil").doc(id).get().then(
          (DocumentSnapshot doc) {
        final data = doc.data() as Map<String, dynamic>;
        Profil userInformations =  Profil.fromJson(data);
        villeController.text = userInformations.ville.toString();
        codepostalController.text = userInformations.codePostal.toString();
        adresseController.text = userInformations.adresse.toString();
        anniversaireController.text = userInformations.anniversaire.toString();
        nomController.text = userInformations.mail.toString();

        return userInformations;
      },
      onError: (e) => print("Error getting document: $e"),
    );


    return Padding(
        padding: const EdgeInsets.all(10),
        child: ListView(children: <Widget>[
          Container(
            padding: EdgeInsets.all(10),
            child: TextField(
              enabled: false,
              controller: nomController,
              decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Login',
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
                child: const Text('Mettre en vente un vetement'),
                onPressed: ()  {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => const CreeVetement(),),(route) => false,
                  );
                },
              )),
          Container(
              height: 60,
              padding: const EdgeInsets.fromLTRB(10, 20, 10, 0),
              child: ElevatedButton(
                style: OutlinedButton.styleFrom(
                  backgroundColor: Colors.red, //<-- SEE HERE
                ),
                child: const Text('Se deconnecter'),
                onPressed: () async {
                  FirebaseAuth.instance.signOut();
                  Navigator.of(
                      context, rootNavigator : true).pushReplacement(MaterialPageRoute(builder: (context) => const MyApp())

                  );
                },
              )),
        ]));
  }


}
