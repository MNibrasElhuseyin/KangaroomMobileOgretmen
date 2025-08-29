class LoginResponse {
  final int id;
  final String ad;
  final String soyad;
  final String iletisim;
  final String sifreMasked;

  LoginResponse({
    required this.id,
    required this.ad,
    required this.soyad,
    required this.iletisim,
    required this.sifreMasked,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      id: json['Id'] ?? 0,
      ad: json['Ad'] ?? '',
      soyad: json['Soyad'] ?? '',
      iletisim: json['Iletisim'] ?? '',
      sifreMasked: json['Sifre'] ?? '',
    );
  }
}