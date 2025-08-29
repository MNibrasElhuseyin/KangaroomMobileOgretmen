class ApiConstants {
  static const String baseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'http://37.148.210.227:8000',
  );

  static String page(String endpoint) => '$baseUrl/$endpoint';
}
