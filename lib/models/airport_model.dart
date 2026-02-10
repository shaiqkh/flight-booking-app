class AirportModel {
  final String code;
  final String name;
  final String city;

  AirportModel({required this.code, required this.name, required this.city});

  factory AirportModel.fromJson(Map<String, dynamic> json) {
    return AirportModel(
      code: json['code'],
      name: json['name'],
      city: json['city'],
    );
  }
}
