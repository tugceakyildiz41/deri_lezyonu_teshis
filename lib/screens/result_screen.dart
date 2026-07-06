import 'dart:io';
import 'package:flutter/material.dart';
import '../models/disease_info.dart';

class ResultScreen extends StatelessWidget {
  final File gorsel;
  final List<MapEntry<String, double>> sonuclar;

  const ResultScreen({
    super.key,
    required this.gorsel,
    required this.sonuclar,
  });

  @override
  Widget build(BuildContext context) {
    final enIyiTahmin = sonuclar.first;
    final hastalik = hastalikBilgileri[enIyiTahmin.key];
    final guvenYuzdesi = enIyiTahmin.value * 100;
    final dusukGuven = guvenYuzdesi < 50;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Analiz Sonucu'),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.file(
              gorsel,
              height: 200,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(height: 16),

          // DOKTOR UYARISI - her zaman görünür
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.amber.shade50,
              border: Border.all(color: Colors.amber.shade400),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.warning_amber_rounded, color: Colors.amber.shade800),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Bu sonuç bir ön değerlendirmedir ve %100 doğru teşhis '
                    'anlamına gelmez. Kesin tanı ve tedavi için lütfen bir '
                    'sağlık kuruluşuna / doktora başvurun.',
                    style: TextStyle(
                      color: Colors.amber.shade900,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // EN OLASI TAHMİN
          Card(
            elevation: 2,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('En Olası Tahmin',
                      style: TextStyle(color: Colors.grey.shade600, fontSize: 13)),
                  const SizedBox(height: 4),
                  Text(
                    hastalik?.adi ?? enIyiTahmin.key,
                    style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: LinearProgressIndicator(
                      value: enIyiTahmin.value,
                      minHeight: 8,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text('Güven: %${guvenYuzdesi.toStringAsFixed(1)}'),
                  if (dusukGuven) ...[
                    const SizedBox(height: 8),
                    Text(
                      'Modelin bu görsel için güveni düşük. Sonuç belirsiz '
                      'olabilir, lütfen mutlaka bir uzmana danışın.',
                      style: TextStyle(
                        color: Colors.red.shade700,
                        fontSize: 13,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),

          // DİĞER OLASI TAHMİNLER
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Diğer Olası Tahminler',
                      style: TextStyle(color: Colors.grey.shade600, fontSize: 13)),
                  const SizedBox(height: 8),
                  ...sonuclar.skip(1).take(2).map((e) {
                    final bilgi = hastalikBilgileri[e.key];
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(bilgi?.adi ?? e.key),
                          Text('%${(e.value * 100).toStringAsFixed(1)}'),
                        ],
                      ),
                    );
                  }),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          if (hastalik != null) ...[
            _BilgiKarti(
              baslik: 'Hakkında',
              icon: Icons.info_outline,
              child: Text(hastalik.aciklama),
            ),
            const SizedBox(height: 12),
            _BilgiKarti(
              baslik: 'Belirtiler',
              icon: Icons.checklist_rtl,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: hastalik.belirtiler
                    .map((b) => _MaddeSatiri(metin: b))
                    .toList(),
              ),
            ),
            const SizedBox(height: 12),
            _BilgiKarti(
              baslik: 'Ne Yapılmalı?',
              icon: Icons.medical_services_outlined,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: hastalik.oneriler
                    .map((o) => _MaddeSatiri(metin: o))
                    .toList(),
              ),
            ),
            if (hastalik.yuksekBulasicilik) ...[
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.red.shade50,
                  border: Border.all(color: Colors.red.shade200),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Icon(Icons.coronavirus_outlined, color: Colors.red.shade700),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Bu hastalık bulaşıcı olabilir. Diğer kişilerle '
                        'teması sınırlamayı düşünün.',
                        style: TextStyle(color: Colors.red.shade800, fontSize: 13),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],

          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Ana Ekrana Dön'),
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}

class _BilgiKarti extends StatelessWidget {
  final String baslik;
  final IconData icon;
  final Widget child;

  const _BilgiKarti({
    required this.baslik,
    required this.icon,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, size: 20, color: Theme.of(context).colorScheme.primary),
                const SizedBox(width: 8),
                Text(baslik, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              ],
            ),
            const SizedBox(height: 10),
            child,
          ],
        ),
      ),
    );
  }
}

class _MaddeSatiri extends StatelessWidget {
  final String metin;
  const _MaddeSatiri({required this.metin});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('•  '),
          Expanded(child: Text(metin)),
        ],
      ),
    );
  }
}