class User {
  final String id;
  final String email;
  final String fullname;
  final String? phone;
  final String? password;
  final String? address;
  final String? birthYear;
  final String? gender;
  final int role;

  User({
    required this.id,
    required this.email,
    required this.fullname,
    required this.phone,
    required this.password,
    required this.address,
    required this.birthYear,
    required this.gender,
    required this.role,
  });
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      email: json['email'],
      fullname: json['fullname'],
      phone: json['phone'],
      password: json['password'],
      address: json['address'],
      birthYear: json['birthYear'],
      gender: json['gender'],
      role: json['role'],
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'fullname': fullname,
      'phone': phone,
      'password': password,
      'address': address,
      'birthYear': birthYear,
      'gender': gender,
      'role': role,
    };
  }
}
