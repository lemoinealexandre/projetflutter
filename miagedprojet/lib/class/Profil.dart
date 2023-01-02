class Profil {
  String adresse;
  String anniversaire;
  String codePostal;
  String ville;
  String? motDePasse;
  String mail;

  Profil(
      { required this.adresse,
        required this.anniversaire,
        required this.codePostal,
        required this.ville,
        this.motDePasse,
        required this.mail});


  factory Profil.fromJson(Map<String, dynamic> parsedJson){
    return Profil(
      adresse : parsedJson['adresse'],
      anniversaire : parsedJson ['anniversaire'],
      codePostal : parsedJson ['codePostal'],
      ville : parsedJson ['ville'],
      mail : parsedJson ['mail'],
    );
  }
}
