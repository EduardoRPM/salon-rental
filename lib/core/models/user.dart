class User {
  String? id;
  String? name;
  String? email;
  String? password;

  User({this.id, this.name, this.email, this.password});

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    email = json['email'];
    password = json['password'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['email'] = email;
    data['password'] = password;
    return data;
  }
}

// Añadir este método después de la definición de la clase User:

String? validatePassword(String? password) {
  if (password == null || password.isEmpty) {
    return 'La contraseña es obligatoria';
  }
  if (password.length < 6) {
    return 'La contraseña debe tener al menos 6 caracteres';
  }
  return null;
}
