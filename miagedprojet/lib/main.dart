
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:miagedprojet/pages/creeVetement.dart';
import 'package:miagedprojet/pages/creerUnCompte.dart';
import 'firebase_options.dart';
import 'pages/accueil.dart';


Future<void> main() async {
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MaterialApp(
    title: 'Navigation Basics',
    home: MyApp(),
  ));

}


class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  static const String _title = 'MIAGED';
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: _title,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSwatch().copyWith(
          //secondary: Colors.green,
        ),
      ),
      home: Scaffold(
        appBar: AppBar(title: const Text(_title)),
        body: const MyStatefulWidget(),
      ),
    );
  }
}

class MyStatefulWidget extends StatefulWidget {
  const MyStatefulWidget({Key? key}) : super(key: key);
  @override
  State<MyStatefulWidget> createState() => _MyStatefulWidgetState();
}

class _MyStatefulWidgetState extends State<MyStatefulWidget> {
  TextEditingController nomController = TextEditingController();
  TextEditingController motdepasseController = TextEditingController();
  bool loginfail = false;
  late UserCredential user;

  @override
  Widget build(BuildContext context) {

    return Padding(
        padding: const EdgeInsets.all(10),
        child: ListView(
          children: <Widget>[
            Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.all(50),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20), // Image border
                  child: SizedBox.fromSize(
                    child: Image.network('assets/images/vetement.jpg', fit: BoxFit.cover),
                  ),
                )),
            Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.all(10),
                child: const Text(
                  'Connexion',
                  style: TextStyle(fontSize: 20),
                )),
            Container(
              padding:  EdgeInsets.all(10),
              child: TextField(
                autofocus: true,
                controller: nomController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Login',
                  errorText: loginfail ? 'Login ou mot de passe incorrect ' : null
                ),
              ),
            ),
            Container(
              padding:  EdgeInsets.fromLTRB(10, 10, 10, 0),
              child: TextField(
                autofocus: true,
                obscureText: true,
                controller: motdepasseController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Mot de passe',
                ),
              ),
            ),
            /* TextButton(
              onPressed: () {
                //forgot password screen
              },
              child: const Text('Forgot Password',),
            ),*/
            Container(
                height: 60,
                padding: const EdgeInsets.fromLTRB(10, 20, 10, 0),
                child: ElevatedButton(
                  style: OutlinedButton.styleFrom(
                    backgroundColor: Colors.indigo, //<-- SEE HERE
                  ),
                  child: const Text('Se connecter'),
                  onPressed: () async {
                    try {
                      UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
                          email: nomController.text,
                          password: motdepasseController.text
                      );
                      user = userCredential;

                    } on FirebaseAuthException catch (e) {
                      nomController.clear();
                      motdepasseController.clear();
                      loginfail = true;
                      print("Login ou mot de passe incorrect");
                    }
                    if(user != null){
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (context) => const Accueil(),),(route) => false,
                      );
                    }
                  },
                )),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                TextButton(

                  child: const Text(
                    'Créer un comtpe',
                    style: TextStyle(fontSize: 20),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const CreerCompte()),
                    );
                  },
                )
              ],
            ),
          ],
        ));

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

