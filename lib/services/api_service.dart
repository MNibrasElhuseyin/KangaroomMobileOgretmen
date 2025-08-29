import 'dart:convert';
import 'dart:io';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:mime/mime.dart';
import 'package:kangaroom_mobile/constants/api_constants.dart';
import 'package:kangaroom_mobile/config/global_config.dart';

class ApiService {
  /// Ortak GET metodu
  static Future<List<T>> getList<T>(
    String endpoint,
    T Function(Map<String, dynamic>) fromJson, {
    Map<String, dynamic>? queryParams,
    List<T>? fallbackData,
  }) async {
    final allParams = {
      'personel_id': GlobalConfig.personelID.toString(),
      ...?queryParams,
    };

    final url = Uri.parse(
      ApiConstants.page(endpoint),
    ).replace(queryParameters: allParams);
    print('📡 --> API: ISTEK ATILIYOR → $url');

    try {
      final response = await http.get(url).timeout(const Duration(seconds: 90));
      if (response.statusCode == 200) {
        print("✅ API: GET → ISTEK SONUCU: BAŞARILI");
      } else {
        print('❌ API: GET → ISTEK SONUCU, BAŞARISIZ: ${response.statusCode}');
      }

      if (response.statusCode == 200) {
        final bodyString = utf8.decode(response.bodyBytes);
        final dynamic jsonResponse = jsonDecode(bodyString);

        List<dynamic> jsonList = [];

        if (jsonResponse is List) {
          jsonList = jsonResponse;
        } else if (jsonResponse is Map) {
          if (jsonResponse['data'] is List) {
            jsonList = jsonResponse['data'];
          } else {
            jsonList = [jsonResponse];
          }
        } else {
          jsonList = [];
        }

        final mappedList = jsonList.map((json) => fromJson(json)).toList();

        print('✅ API: GET → Veri sayısı: ${mappedList.length}');
        return mappedList;
      } else {
        throw Exception('GET başarısız: ${response.statusCode}');
      }
    } on TimeoutException catch (e) {
      print('❌ Zaman aşımı hatası: $e');
      if (fallbackData != null) return fallbackData;
      throw Exception('⏱️ Zaman aşımı');
    } on SocketException catch (e) {
      print('❌ Sunucuya ulaşılamadı hatası: $e');
      if (fallbackData != null) return fallbackData;
      throw Exception('📶 İnternet bağlantınızı kontrol ediniz');
    } catch (e) {
      print('❌ GET hatası: $e');
      if (fallbackData != null) return fallbackData;
      throw Exception('⚠️ GET hatası: $e');
    }
  }

  /// Genel POST metodu (bool döner)
  static Future<bool> post(
    String endpoint,
    dynamic body, {
    bool wrapInList = true,
  }) async {
    if (body is! Map<String, dynamic> && body is! List<Map<String, dynamic>>) {
      throw ArgumentError(
        'body must be Map<String, dynamic> or List<Map<String, dynamic>>',
      );
    }

    dynamic fullBody;

    if (body is Map<String, dynamic>) {
      if (wrapInList) {
        fullBody = [
          {'personel_id': GlobalConfig.personelID, ...body},
        ];
      } else {
        fullBody = {'personel_id': GlobalConfig.personelID, ...body};
      }
    } else {
      fullBody =
          body
              .map((e) => {'personel_id': GlobalConfig.personelID, ...e})
              .toList();
    }

    final url = Uri.parse(ApiConstants.page(endpoint));
    print('📡 POST → $url\nBody: $fullBody');

    try {
      final response = await http
          .post(
            url,
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode(fullBody),
          )
          .timeout(const Duration(seconds: 90));

      if (response.statusCode == 200 || response.statusCode == 201) {
        print('✅ POST başarılı → ${response.body}');
        return true;
      } else {
        print('❌ POST başarısız → ${response.statusCode} | ${response.body}');
        return false;
      }
    } catch (e) {
      print('❌ POST hatası: $e');
      return false;
    }
  }

  /// Login için POST, kullanıcı bilgisi döner
  static Future<Map<String, dynamic>?> login({
    required String username,
    required String password,
  }) async {
    final url = Uri.parse(ApiConstants.page("Login"));
    final body = {"username": username, "password": password};

    print('📡 LOGIN → $url\nBody: $body');

    try {
      final response = await http
          .post(
            url,
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode(body),
          )
          .timeout(const Duration(seconds: 15));

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = jsonDecode(response.body);
        print("✅ LOGIN başarılı: $jsonResponse");
        return jsonResponse;
      } else if (response.statusCode == 404) {
        print("❌ LOGIN başarısız: Kullanıcı bulunamadı veya şifre yanlış");
        return null;
      } else {
        print("❌ LOGIN hatası: ${response.statusCode}");
        return null;
      }
    } catch (e) {
      print("❌ LOGIN isteği hatası: $e");
      return null;
    }
  }

  /// Genel PATCH metodu
  static Future<bool> patch(
    String endpoint,
    dynamic body, {
    bool wrapInList = true,
  }) async {
    if (body is! Map<String, dynamic> && body is! List<Map<String, dynamic>>) {
      throw ArgumentError(
        'body must be Map<String, dynamic> or List<Map<String, dynamic>>',
      );
    }

    dynamic fullBody;

    if (body is Map<String, dynamic>) {
      if (wrapInList) {
        fullBody = [
          {'personel_id': GlobalConfig.personelID, ...body},
        ];
      } else {
        fullBody = {'personel_id': GlobalConfig.personelID, ...body};
      }
    } else {
      fullBody =
          body
              .map((e) => {'personel_id': GlobalConfig.personelID, ...e})
              .toList();
    }

    final url = Uri.parse(ApiConstants.page(endpoint));
    print('📡 PATCH → $url\nBody: $fullBody');

    try {
      final response = await http
          .patch(
            url,
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode(fullBody),
          )
          .timeout(const Duration(seconds: 5));

      if (response.statusCode == 200 || response.statusCode == 201) {
        print('✅ PATCH başarılı → ${response.body}');
        return true;
      } else {
        print('❌ PATCH başarısız → ${response.statusCode} | ${response.body}');
        return false;
      }
    } catch (e) {
      print('❌ PATCH hatası: $e');
      return false;
    }
  }

  /// Genel DELETE metodu
  static Future<bool> delete(
    String endpoint,
    dynamic body, {
    bool wrapInList = true,
  }) async {
    if (body is! Map<String, dynamic> && body is! List<Map<String, dynamic>>) {
      throw ArgumentError(
        'body must be Map<String, dynamic> or List<Map<String, dynamic>>',
      );
    }

    dynamic fullBody;

    if (body is Map<String, dynamic>) {
      if (wrapInList) {
        fullBody = [
          {'personel_id': GlobalConfig.personelID, ...body},
        ];
      } else {
        fullBody = {'personel_id': GlobalConfig.personelID, ...body};
      }
    } else {
      fullBody =
          body
              .map((e) => {'personel_id': GlobalConfig.personelID, ...e})
              .toList();
    }

    final url = Uri.parse(ApiConstants.page(endpoint));
    print('📡 DELETE → $url\nBody: $fullBody');

    try {
      final response = await http
          .delete(
            url,
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode(fullBody),
          )
          .timeout(const Duration(seconds: 5));

      if (response.statusCode == 200 || response.statusCode == 201) {
        print('✅ DELETE başarılı → ${response.body}');
        return true;
      } else {
        print('❌ DELETE başarısız → ${response.statusCode} | ${response.body}');
        return false;
      }
    } catch (e) {
      print('❌ DELETE hatası: $e');
      return false;
    }
  }

  /// 📤 Çoklu dosya yükleme (ders_id, ogrenci_id)
  static Future<bool> uploadLessonFiles({
    required int dersId,
    required int ogrenciId,
    required List<File> files,
  }) async {
    final url = Uri.parse(ApiConstants.page("DersResimVideo"));
    final request = http.MultipartRequest('POST', url);

    // Form alanları
    request.fields['ders_id'] = dersId.toString();
    request.fields['ogrenci_id'] = ogrenciId.toString();

    // Dosyalar ekleniyor
    for (var file in files) {
      final mimeType = lookupMimeType(file.path) ?? 'application/octet-stream';
      final mimeSplit = mimeType.split('/');
      request.files.add(
        await http.MultipartFile.fromPath(
          'files',
          file.path,
          contentType: MediaType(mimeSplit[0], mimeSplit[1]),
        ),
      );
    }

    try {
      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200) {
        print("✅ Dosya yükleme başarılı");
        print("Response: ${response.body}");
        return true;
      } else {
        print("❌ Dosya yükleme başarısız: ${response.statusCode}");
        print("Response: ${response.body}");
        return false;
      }
    } catch (e) {
      print("❌ Dosya yükleme hatası: $e");
      return false;
    }
  }
}
