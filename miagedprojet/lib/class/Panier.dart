import 'package:miagedprojet/class/Vetement.dart';

class Panier{
  String? user;
  String vetementId;
  String? id;
  Vetement? vetement;



  Panier({
    this.user,
    required this.vetementId,
    this.id
    });


  factory Panier.fromJson(Map<String, dynamic> parsedJson){
    return Panier(
      vetementId : parsedJson ['vetement'],
    );
  }

}















