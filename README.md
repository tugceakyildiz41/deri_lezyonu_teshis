# 🧬 Deri Lezyonu Teşhis Sistemi / Skin Lesion Information App

**EN:** An offline Flutter mobile app that classifies 8 common childhood skin conditions from a photo using a custom CNN (DermaNet-Lite, ~5 MB TFLite). All inference runs on the device; no image leaves the phone. **It is an information tool, not a diagnosis. Always consult a doctor.**

**TR:** Çocukluk çağında sık görülen 8 cilt hastalığı hakkında ebeveynleri bilgilendirmek için geliştirilmiş, internetsiz çalışan bir Flutter uygulamasıdır. **Kesin tanı koymaz, her sonuçta doktora başvuru uyarısı verir.**

Artvin Çoruh Üniversitesi Bilgisayar Mühendisliği bitirme tezi · TÜBİTAK 2209-A destekli
Danışman: Dr. Öğr. Üyesi Ahmet Ulu

## ⚠️ Önemli Uyarı

Bu uygulama bir **bilgilendirme aracıdır**, tıbbi cihaz veya tanı aracı değildir. Sonuçlar hatalı olabilir. Çocuğunuzda cilt belirtisi varsa mutlaka bir sağlık kuruluşuna başvurun.

## 📱 Uygulama

- Kameradan veya galeriden fotoğraf seçme
- Cihaz üzerinde analiz: 224×224 yeniden boyutlandırma → normalizasyon → TFLite çıkarımı
- **Top-3 tahmin** ve her biri için güven yüzdesi
- Her hastalık için kısa bilgi, öneri ve doktora başvuru uyarısı
- **Tamamen çevrimdışı:** internet gerekmez, görüntü cihazdan çıkmaz

## 📸 Ekran Görüntüleri

[Eklenecek]

## 🦠 Tanınan Hastalıklar ve Veri Seti

Toplam **4.766 görüntü**, 8 sınıf. Veri, Kaggle'daki birden fazla veri setinden derlenmiştir: [veri seti adları ve bağlantıları buraya].

| Hastalık | Görüntü Sayısı |
| --- | --- |
| Lyme Hastalığı | 953 |
| Kızamık | 948 |
| Maymun Çiçeği | 670 |
| Atopik Dermatit | 612 |
| Herpes (Uçuk) | 559 |
| Suçiçeği | 513 |
| Uyuz (Scabies) | 358 |
| İmpetigo | 153 |

**Bölme:** Stratified, %72 eğitim / %8 doğrulama / %20 test (`random_state=42`), test seti 954 görüntü.
**Ön işleme:** RGB dönüşümü, 224×224 yeniden boyutlandırma, [0,1] normalizasyon.
**Augmentation (yalnızca eğitimde):** flip, rotation, zoom %15, translation %10, brightness ve contrast ±%15.
**Sınıf dengesizliği:** Class weighting (`balanced`).

## 🏗️ Model: DermaNet-Lite

Transfer öğrenme kullanılmadan **sıfırdan tasarlanmış** bir CNN. **1.362.120 parametre**, float32 TFLite dosyası **5,14 MB**.

```
Giriş 224×224×3
→ Stem: Conv2D 3×3, stride 2 + BN + ReLU            → 112×112×32
→ Blok 1: Depthwise Separable Conv                  → 112×112×64
→ Blok 2: DSConv ×2 + Artık Bağlantı                → 56×56×128
→ Blok 3: DSConv ×2                                 → 28×28×256
→ Blok 4: DSConv ×2 + Artık Bağlantı                → 14×14×512
→ Blok 5: DSConv ×2                                 → 7×7×512
→ Global Average Pooling → Dropout(0.4)
→ Dense(256) + BN + ReLU → Dropout(0.3)
→ Dense(8, Softmax)
```

**Eğitim:** Adam (lr=1e-3), Categorical Cross-Entropy + sınıf ağırlıkları, EarlyStopping (patience=8), ReduceLROnPlateau, 50 epoch (en iyi epoch 44). Google Colab (GPU).

## 📊 Sonuçlar

### Test seti (n = 954)

| Accuracy | F1 (Macro) | AUC (Macro) |
| --- | --- | --- |
| **%74,84** | **0,700** | **0,942** |

### Sınıf bazlı sonuçlar

| Hastalık | Precision | Recall | F1 | AUC |
| --- | --- | --- | --- | --- |
| Kızamık | 0,892 | 0,879 | 0,886 | 0,986 |
| Atopik Dermatit | 0,810 | 0,807 | 0,809 | 0,983 |
| Lyme Hastalığı | 0,789 | 0,786 | 0,788 | 0,951 |
| Suçiçeği | 0,756 | 0,783 | 0,769 | 0,962 |
| Maymun Çiçeği | 0,733 | 0,778 | 0,755 | 0,961 |
| Herpes | 0,679 | 0,690 | 0,685 | 0,930 |
| İmpetigo | 0,548 | 0,461 | 0,500 | 0,938 |
| Uyuz (Scabies) | 0,447 | 0,377 | 0,410 | 0,828 |

### 5 katlı çapraz doğrulama

Hesaplama süresi için **azaltılmış epoch** ile yapılmıştır; bu yüzden değerler nihai modelin test sonucundan düşüktür.

| | Accuracy | F1 (Macro) | AUC (Macro) |
| --- | --- | --- | --- |
| Ortalama ± std | 0,619 ± 0,050 | 0,568 ± 0,048 | 0,894 ± 0,027 |

Katlama doğrulukları: 0,561 · 0,570 · 0,651 · 0,638 · 0,673.

## 🔍 Sınırlılıklar (Dürüst Değerlendirme)

- **İmpetigo (F1 0,50) ve uyuz (F1 0,41) zayıf kalıyor.** İmpetigo en az örneğe sahip sınıf (153 görüntü). Class weighting ve augmentation yetmedi.
- **Veri çocuklara özgü değil.** Görüntüler Kaggle'daki farklı kaynaklardan toplandı ve yaş grubu doğrulanmadı.
- **Veri kalitesi ve etiketler** uzmanlarca doğrulanmadı, farklı kaynakların birleşmesi dağılım farkı yaratabilir.
- Farklı cilt tonları, aydınlatma ve kamera koşulları için ayrı bir analiz yapılmadı.
- Klinik doğrulama yapılmadı. Model bir **araştırma/eğitim prototipidir**.
- Focal loss denendi, performans düştüğü için kullanılmadı.

## 🚀 Kurulum

```
git clone https://github.com/tugceakyildiz41/deri_lezyonu_teshis.git
cd deri_lezyonu_teshis
flutter pub get
flutter run
```

Model ve etiketler `assets/model/` içindedir. Eğitim kodu repodaki Jupyter notebook'tadır.

[APK indir (Releases)](https://github.com/tugceakyildiz41/deri_lezyonu_teshis/releases)  *(yüklenince bağlantı çalışır)*

## 🛠️ Teknolojiler

TensorFlow / Keras · TFLite · Flutter (Dart) · `image_picker` · Google Colab · Python

## 🗺️ Yol Haritası

- [ ] Zayıf sınıflar için daha fazla ve çeşitli veri
- [ ] Çocuk hastalıklarına özgü, doğrulanmış veri seti
- [ ] Model kalibrasyonu ve düşük güvenli sonuçlarda daha net uyarı
- [ ] Grad-CAM ile açıklanabilirlik görselleri
- [ ] Çeviri: uygulama arayüzü için İngilizce dil desteği

## 👩‍💻 Hakkında

Tuğçe Akyıldız, Bilgisayar Mühendisi · [LinkedIn](https://linkedin.com/in/tugceakyildiz) ·