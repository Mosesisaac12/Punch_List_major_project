class Subcontractor {
  final String? name;
  final String? email;
  final String? phone;

  Subcontractor({
    this.name,
    this.email,
    this.phone,
  });

  factory Subcontractor.fromJson(Map<String, dynamic> json) {
    return Subcontractor(
        name: json['name'], email: json['username'], phone: json['mobile_no']);
  }
}
