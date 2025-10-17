class Speciality {
  final String id;
  final String name;
  final String iconkey;

  Speciality({required this.id, required this.name, required this.iconkey});

  factory Speciality.fromJson(Map<String, dynamic> json) {
    return Speciality(
      id: json['id'],
      name: json['name'],
      iconkey: json['iconkey'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'iconkey': iconkey,
    };
  }
}