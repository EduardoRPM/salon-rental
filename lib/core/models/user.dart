enum UserType { client, owner }

class User {
  String? id;
  String? name;
  String? email;
  String? password;
  String? phone;
  UserType? userType;
  DateTime? createdAt;

  User({
    this.id,
    this.name,
    this.email,
    this.password,
    this.phone,
    this.userType,
    this.createdAt,
  });

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    email = json['email'];
    password = json['password'];
    phone = json['phone'];
    if (json['userType'] != null) {
      userType = UserType.values.firstWhere(
        (e) => e.toString().split('.').last == json['userType'],
        orElse: () => UserType.client,
      );
    }
    createdAt =
        json['createdAt'] != null ? DateTime.parse(json['createdAt']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['email'] = email;
    data['password'] = password;
    data['phone'] = phone;
    if (userType != null) {
      data['userType'] = userType.toString().split('.').last;
    }
    if (createdAt != null) {
      data['createdAt'] = createdAt!.toIso8601String();
    }
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
