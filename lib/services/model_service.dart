import 'dart:io';
import 'package:flutter/services.dart';
import 'package:image/image.dart' as img;
import 'package:tflite_flutter/tflite_flutter.dart';

class ModelService {
  static const String _modelYolu = 'assets/model/derma_model.tflite';
  static const String _etiketYolu = 'assets/model/labels.txt';
  static const int _girisBoyutu = 224;

  Interpreter? _interpreter;
  List<String> _etiketler = [];

  bool get hazirMi => _interpreter != null && _etiketler.isNotEmpty;

  /// Modeli ve etiketleri assets'ten yükler. Uygulama açılışında bir kez çağrılır.
  Future<void> yukle() async {
    _interpreter = await Interpreter.fromAsset(_modelYolu);

    final etiketMetni = await rootBundle.loadString(_etiketYolu);
    _etiketler = etiketMetni
        .split('\n')
        .map((e) => e.trim())
        .where((e) => e.isNotEmpty)
        .toList();
  }

  /// Verilen görsel dosyası için tahmin yapar.
  /// Sonuç: [(etiket, olasılık), ...] büyükten küçüğe sıralı liste.
  Future<List<MapEntry<String, double>>> tahminEt(File gorselDosyasi) async {
    if (!hazirMi) {
      throw Exception('Model henüz yüklenmedi');
    }

    // 1. Görseli oku ve decode et
    final bytes = await gorselDosyasi.readAsBytes();
    img.Image? gorsel = img.decodeImage(bytes);
    if (gorsel == null) {
      throw Exception('Görsel okunamadı veya desteklenmeyen format');
    }

    // 2. 224x224'e resize et (eğitimdeki ile aynı boyut)
    gorsel = img.copyResize(gorsel, width: _girisBoyutu, height: _girisBoyutu);

    // 3. Giriş tensörünü oluştur: [1, 224, 224, 3], piksel değerleri 0-1 arası
    final girisTensoru = List.generate(
      1,
      (_) => List.generate(
        _girisBoyutu,
        (y) => List.generate(
          _girisBoyutu,
          (x) {
            final piksel = gorsel!.getPixel(x, y);
            return [
              piksel.r / 255.0,
              piksel.g / 255.0,
              piksel.b / 255.0,
            ];
          },
        ),
      ),
    );

    // 4. Çıkış tensörü: [1, 8] - her sınıf için olasılık
    final cikisTensoru = List.generate(1, (_) => List.filled(_etiketler.length, 0.0));

    // 5. Modeli çalıştır
    _interpreter!.run(girisTensoru, cikisTensoru);

    // 6. Sonuçları etiketlerle eşleştirip büyükten küçüğe sırala
    final List<MapEntry<String, double>> sonuclar = [];
    for (int i = 0; i < _etiketler.length; i++) {
      sonuclar.add(MapEntry(_etiketler[i], cikisTensoru[0][i]));
    }
    sonuclar.sort((a, b) => b.value.compareTo(a.value));

    return sonuclar;
  }

  void kapat() {
    _interpreter?.close();
  }
}