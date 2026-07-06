# 🧬 Deri Lezyonu Teşhis Sistemi

Çocuklarda sık görülen 8 cilt hastalığını yapay zekâ ile tanıyan, 
tamamen çevrimdışı çalışan mobil uygulama.

## 📱 Proje Hakkında

Bu proje, Artvin Çoruh Üniversitesi Bilgisayar Mühendisliği Bölümü 
bitirme tezi kapsamında geliştirilmiştir.

**Öğrenci:** Tuğçe AKYILDIZ (220502013)  
**Danışman:** Dr. Öğr. Üyesi Ahmet ULU

## 🦠 Tanınan Hastalıklar

| Hastalık | Görüntü Sayısı |
|----------|---------------|
| Lyme Hastalığı | 953 |
| Kızamık | 948 |
| Maymun Çiçeği | 670 |
| Atopik Dermatit | 612 |
| Herpes (Uçuk) | 559 |
| Suçiçeği | 513 |
| Uyuz | 358 |
| İmpetigo | 153 |

## 📊 Model Performansı

- ✅ **Doğruluk:** %74.84
- ✅ **AUC (Macro):** 0.942
- ✅ **F1 Skoru (Macro):** 0.700

## 🏗️ Kullanılan Teknolojiler

- **Model:** TensorFlow / Keras (DermaNet-Lite — sıfırdan tasarlanmış CNN)
- **Mobil:** Flutter + TFLite
- **Eğitim:** Google Colab (GPU)
- **Dil:** Python, Dart

## 📁 Proje Yapısı
├── lib/                  # Flutter uygulama kodları
├── assets/model/         # TFLite model ve etiketler
├── android/              # Android yapılandırması
└── *.ipynb               # Model eğitim notebook'u

## 🚀 Kurulum

```bash
flutter pub get
flutter run
```

> ⚠️ **Not:** Bu uygulama bir destek aracıdır, kesin tıbbi tanı değildir.
> Her sonuçta kullanıcı sağlık kuruluşuna yönlendirilmektedir.
