
class Student {

  int? id;
  late String name;
  late int age;

  Student({
    this.id,
    required this.name,
    required this.age

   });

// Convert the Student into Map
  Map<String,dynamic> toMap() {
    return {
      'id'   : id,
      'name' : name,
      'age'  : age
    };
  }


  // Convert a Map to a Student Object
  Student.fromMap(Map<String,dynamic> map )  {
    id = map['id'];
    name = map['name'];
    age = map['age'];
  }



}