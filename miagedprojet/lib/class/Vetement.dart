class Vetement{
   String? id;
   String titre;
   String taille;
   double prix;
   String marque;
   String categorie;
   String image;

  Vetement({
       this.id,
       required this.titre,
        required this.taille,
        required this.prix,
        required this.marque,
        required this.categorie,
        required this.image});


  factory Vetement.fromJson(Map<String, dynamic> parsedJson){
    return Vetement(
        titre : parsedJson['titre'],
        taille : parsedJson ['taille'],
      prix : parsedJson ['prix'],
      marque : parsedJson ['marque'],
      categorie : parsedJson ['categorie'],
      image : parsedJson ['image'],
    );
  }

}















