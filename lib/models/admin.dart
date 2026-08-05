class Admin {


  final String id;

  final String name;

  final String email;

  final String role;



  const Admin({

    required this.id,

    required this.name,

    required this.email,

    this.role = "admin",

  });





  // Supabase → Admin

  factory Admin.fromMap(
      Map<String, dynamic> map
      ){


    return Admin(

      id:
      map['id']?.toString() ?? '',


      name:
      map['name'] ?? '',


      email:
      map['email'] ?? '',


      role:
      map['role'] ?? 'admin',


    );


  }






  // Admin → Supabase

  Map<String,dynamic> toMap(){


    return {

      'id':
      id,


      'name':
      name,


      'email':
      email,


      'role':
      role,


    };


  }


}