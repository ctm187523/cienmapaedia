
class Actor {

  final int id;
  final String name;
  final String profilePath; //fotografia del actor
  final String? character;

  //constructor
  Actor({
    required this.id, 
    required this.name, 
    required this.profilePath, 
    required this.character
  }); //papel que desenpeña en la película
}