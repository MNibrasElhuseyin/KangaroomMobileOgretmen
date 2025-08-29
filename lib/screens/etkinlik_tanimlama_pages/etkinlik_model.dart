import 'dart:io';
import 'package:flutter/material.dart';

class Etkinlik {
  final int? id; // API'den gelen ID
  final String isim; // Ad
  final String ucret; // Tutar
  final DateTime tarih;
  final TimeOfDay saat;
  final File? dosya;
  final String? aciklama;
  final String? resimBinary;
  final String? resim;   

  const Etkinlik({
    this.id,
    required this.isim,
    required this.ucret,
    required this.tarih,
    required this.saat,
    required this.dosya,
    this.aciklama,
    this.resimBinary,
    this.resim,
  });

  // API modelinden Etkinlik'e dönüştürme
  factory Etkinlik.fromApiModel(Map<String, dynamic> json) {
    // Tarih ve saat parsing
    DateTime parsedDate;
    TimeOfDay parsedTime;

    try {
      parsedDate = DateTime.parse(json['Tarih']);
    } catch (e) {
      parsedDate = DateTime.now();
    }

    try {
      final timeParts = json['Saat'].split(':');
      parsedTime = TimeOfDay(
          hour: int.parse(timeParts[0]),
          minute: int.parse(timeParts[1])
      );
    } catch (e) {
      parsedTime = TimeOfDay.now();
    }

    return Etkinlik(
      id: json['id'],
      isim: json['Ad'] ?? '',
      ucret: json['Tutar'] ?? '',
      tarih: parsedDate,
      saat: parsedTime,
      aciklama: json['Aciklama'],
      resimBinary: json['ResimBinary'],
      resim: json['Resim'],
      dosya: null, // API'den dosya gelmiyor, binary string var
    );
  }

  // API'ye gönderilecek format
  Map<String, dynamic> toApiJson() {
    return {
      if (id != null) 'id': id,
      'Ad': isim,
      'Tutar': ucret,
      'Tarih': tarih.toIso8601String(),
      'Saat': '${saat.hour.toString().padLeft(2, '0')}:${saat.minute.toString().padLeft(2, '0')}',
      'Aciklama': aciklama ?? '',
      'ResimBinary': resimBinary ?? '',
      'Resim': resim ?? '',
    };
  }

  // copyWith metodu - etkinlik güncelleme için kullanılabilir
  Etkinlik copyWith({
    int? id,
    String? isim,
    String? ucret,
    DateTime? tarih,
    TimeOfDay? saat,
    File? dosya,
    String? aciklama,
    String? resimBinary,
    String? resim,
  }) {
    return Etkinlik(
      id: id ?? this.id,
      isim: isim ?? this.isim,
      ucret: ucret ?? this.ucret,
      tarih: tarih ?? this.tarih,
      saat: saat ?? this.saat,
      dosya: dosya ?? this.dosya,
      aciklama: aciklama ?? this.aciklama,
      resimBinary: resimBinary ?? this.resimBinary,
      resim: resim ?? this.resim,
    );
  }

  // toString metodu - debug için kullanışlı
  @override
  String toString() {
    return 'Etkinlik(id: $id, isim: $isim, ucret: $ucret, '
        'tarih: $tarih, saat: $saat, aciklama: $aciklama, resim: $resim)';
  }
}