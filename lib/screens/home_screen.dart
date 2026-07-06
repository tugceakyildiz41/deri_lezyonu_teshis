import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../services/model_service.dart';
import 'result_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  File? _secilenGorsel;
  final ImagePicker _picker = ImagePicker();
  final ModelService _modelServisi = ModelService();

  bool _modelYukleniyor = true;
  bool _analizEdiliyor = false;

  @override
  void initState() {
    super.initState();
    _modeliYukle();
  }

Future<void> _modeliYukle() async {
  try {
    await _modelServisi.yukle();
    debugPrint('MODEL BAŞARIYLA YÜKLENDİ');
  } catch (e, stackTrace) {
    debugPrint('MODEL YÜKLEME HATASI: $e');
    debugPrint('STACK TRACE: $stackTrace');
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Model yüklenemedi: $e'),
          duration: const Duration(seconds: 10),
        ),
      );
    }
  } finally {
    if (mounted) {
      setState(() {
        _modelYukleniyor = false;
      });
    }
  }
}

  Future<void> _gorselSec(ImageSource kaynak) async {
    final XFile? secilen = await _picker.pickImage(
      source: kaynak,
      maxWidth: 1024,
      imageQuality: 85,
    );

    if (secilen != null) {
      setState(() {
        _secilenGorsel = File(secilen.path);
      });
    }
  }

  Future<void> _analizEt() async {
    if (_secilenGorsel == null) return;

    setState(() {
      _analizEdiliyor = true;
    });

    try {
      final sonuclar = await _modelServisi.tahminEt(_secilenGorsel!);

      if (!mounted) return;

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ResultScreen(
            gorsel: _secilenGorsel!,
            sonuclar: sonuclar,
          ),
        ),
      );
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Analiz hatası: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _analizEdiliyor = false;
        });
      }
    }
  }

  @override
  void dispose() {
    _modelServisi.kapat();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Deri Lezyonu Analizi'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            if (_modelYukleniyor)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 8),
                child: Row(
                  children: [
                    SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(strokeWidth: 2)),
                    SizedBox(width: 12),
                    Text('Model yükleniyor...'),
                  ],
                ),
              ),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(12),
                ),
                width: double.infinity,
                child: _secilenGorsel == null
                    ? Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.image_outlined,
                              size: 80, color: Colors.grey.shade400),
                          const SizedBox(height: 12),
                          Text(
                            'Henüz bir görsel seçilmedi',
                            style: TextStyle(color: Colors.grey.shade600),
                          ),
                        ],
                      )
                    : ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.file(_secilenGorsel!, fit: BoxFit.cover),
                      ),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => _gorselSec(ImageSource.camera),
                    icon: const Icon(Icons.camera_alt),
                    label: const Text('Kamera'),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => _gorselSec(ImageSource.gallery),
                    icon: const Icon(Icons.photo_library),
                    label: const Text('Galeri'),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: (_secilenGorsel == null ||
                        _modelYukleniyor ||
                        _analizEdiliyor)
                    ? null
                    : _analizEt,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  foregroundColor: Theme.of(context).colorScheme.onPrimary,
                ),
                child: _analizEdiliyor
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                            strokeWidth: 2, color: Colors.white),
                      )
                    : const Text('Analiz Et',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}