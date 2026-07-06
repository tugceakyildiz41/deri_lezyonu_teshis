class DiseaseInfo {
  final String anahtar;
  final String adi;
  final String aciklama;
  final List<String> belirtiler;
  final List<String> oneriler;
  final bool yuksekBulasicilik;

  const DiseaseInfo({
    required this.anahtar,
    required this.adi,
    required this.aciklama,
    required this.belirtiler,
    required this.oneriler,
    this.yuksekBulasicilik = false,
  });
}

final Map<String, DiseaseInfo> hastalikBilgileri = {
  'atopic_dermatitis': const DiseaseInfo(
    anahtar: 'atopic_dermatitis',
    adi: 'Atopik Dermatit (Egzama)',
    aciklama:
        'Genellikle çocukluk döneminde başlayan, kronik ve tekrarlayan seyirli, '
        'kaşıntılı bir cilt iltihabıdır. Alerjik yapı (astım, alerjik nezle) ile '
        'birlikte görülebilir.',
    belirtiler: [
      'Kuru, kaşıntılı ve kızarık cilt',
      'Genellikle diz arkası, dirsek içi, boyun ve yüzde yerleşim',
      'Kaşıntı sonrası kabuklanma ve kalınlaşma',
      'Dönem dönem alevlenme ve sakinleşme',
    ],
    oneriler: [
      'Cildi düzenli olarak nemlendirin (parfümsüz nemlendiriciler)',
      'Sıcak duş/banyo süresini kısa tutun',
      'Tahriş edici sabun, deterjan ve kumaşlardan (yün gibi) kaçının',
      'Tırnakları kısa tutarak kaşıma sonucu enfeksiyonu önleyin',
    ],
  ),
  'chickenpox': const DiseaseInfo(
    anahtar: 'chickenpox',
    adi: 'Suçiçeği',
    aciklama:
        'Varicella zoster virüsünün yol açtığı, çok bulaşıcı bir viral '
        'enfeksiyondur. Genellikle çocuklarda görülür ve aşı ile önlenebilir.',
    belirtiler: [
      'Vücutta yaygın, kaşıntılı, sıvı dolu küçük kabarcıklar',
      'Kabarcıkların farklı evrelerde (kızarıklık, kabarcık, kabuk) bir arada görülmesi',
      'Ateş, halsizlik, iştahsızlık',
    ],
    oneriler: [
      'Bulaşıcı olduğu için diğer çocuklarla (özellikle hamile/bağışıklığı düşük kişilerle) teması sınırlayın',
      'Tırnakları kısa tutun, kaşımayı önlemeye çalışın (iz/enfeksiyon riski)',
      'Ateş için doktor onayı olmadan ilaç vermeyin',
      'Belirtiler başladığında bir hekime başvurun',
    ],
    yuksekBulasicilik: true,
  ),
  'herpes': const DiseaseInfo(
    anahtar: 'herpes',
    adi: 'Herpes (Uçuk)',
    aciklama:
        'Herpes simpleks virüsünün yol açtığı, genellikle dudak çevresi, '
        'ağız veya cilt üzerinde gruplaşmış küçük kabarcıklarla kendini '
        'gösteren bulaşıcı bir enfeksiyondur.',
    belirtiler: [
      'Yanma, karıncalanma veya kaşıntı ile başlayan bölge',
      'Kümeler halinde küçük, sıvı dolu kabarcıklar',
      'Kabarcıkların patlayıp kabuklanması',
    ],
    oneriler: [
      'Lezyona dokunmaktan ve ovuşturmaktan kaçının, bulaşıcıdır',
      'El hijyenine dikkat edin, ortak eşya (havlu, bardak) kullanmayın',
      'Sık tekrarlıyorsa veya yaygınsa bir hekime başvurun',
    ],
    yuksekBulasicilik: true,
  ),
  'impetigo': const DiseaseInfo(
    anahtar: 'impetigo',
    adi: 'İmpetigo',
    aciklama:
        'Genellikle stafilokok veya streptokok bakterilerinin yol açtığı, '
        'çocuklarda sık görülen, bulaşıcı yüzeyel bir cilt enfeksiyonudur.',
    belirtiler: [
      'Genellikle yüz, burun ve ağız çevresinde bal rengi kabuklu yaralar',
      'Kızarık, sıvı dolu küçük kabarcıklar',
      'Kaşıntı',
    ],
    oneriler: [
      'Bulaşıcı olduğu için havlu, kıyafet gibi eşyaların paylaşılmamasına özen gösterin',
      'Bölgeyi temiz ve kuru tutun',
      'Genellikle antibiyotik tedavisi gerekir; bir hekime başvurun',
    ],
    yuksekBulasicilik: true,
  ),
  'kizamik_measles': const DiseaseInfo(
    anahtar: 'kizamik_measles',
    adi: 'Kızamık',
    aciklama:
        'Kızamık virüsünün yol açtığı, çok yüksek bulaşıcılığa sahip, '
        'aşı ile önlenebilir ciddi bir viral enfeksiyondur.',
    belirtiler: [
      'Yüksek ateş, öksürük, burun akıntısı, gözlerde kızarıklık',
      'Önce yüzden başlayıp vücuda yayılan kırmızı-kahverengi döküntü',
      'Ağız içinde küçük beyaz lekeler (erken belirti)',
    ],
    oneriler: [
      'Çok bulaşıcıdır, mutlaka bir sağlık kuruluşuna başvurun',
      'Diğer kişilerle (özellikle aşısız çocuklar, bebekler) teması sınırlayın',
      'Aşı takvimini kontrol ettirin',
    ],
    yuksekBulasicilik: true,
  ),
  'lyme': const DiseaseInfo(
    anahtar: 'lyme',
    adi: 'Lyme Hastalığı',
    aciklama:
        'Enfekte kenelerin ısırması yoluyla bulaşan bakteriyel bir '
        'enfeksiyondur. Erken evrede fark edilip tedavi edilmesi önemlidir.',
    belirtiler: [
      'Isırık bölgesinde genişleyen, halka/hedef tahtası şeklinde kızarıklık ("öküz gözü")',
      'Ateş, yorgunluk, baş ağrısı, kas/eklem ağrıları',
      'Bazı durumlarda döküntü olmadan da seyredebilir',
    ],
    oneriler: [
      'Yakın zamanda kene ısırığı/orman-çayır gezisi öyküsü varsa belirtin',
      'Erken tedavi (antibiyotik) komplikasyonları önlemede çok önemlidir',
      'Bir hekime başvurarak değerlendirilmesini sağlayın',
    ],
  ),
  'maymun_cicegi': const DiseaseInfo(
    anahtar: 'maymun_cicegi',
    adi: 'Maymun Çiçeği (Mpox)',
    aciklama:
        'Viral bir enfeksiyon olup, ateş ve deri üzerinde kabarcık/püstül '
        'şeklinde lezyonlarla seyreder.',
    belirtiler: [
      'Ateş, halsizlik, kas ağrıları, şişmiş lenf bezleri',
      'Yüz ve vücutta kabarcık/püstül şeklinde, evreler halinde değişen lezyonlar',
    ],
    oneriler: [
      'Bulaşıcı olabilir, diğer kişilerle yakın temastan kaçının',
      'Vakit kaybetmeden bir sağlık kuruluşuna başvurun',
      'Lezyonlara dokunmaktan ve sıkmaktan kaçının',
    ],
    yuksekBulasicilik: true,
  ),
  'scabies': const DiseaseInfo(
    anahtar: 'scabies',
    adi: 'Uyuz (Scabies)',
    aciklama:
        'Uyuz akarının deri altına yerleşmesiyle oluşan, oldukça bulaşıcı '
        've yoğun kaşıntıyla seyreden bir cilt hastalığıdır.',
    belirtiler: [
      'Özellikle geceleri artan, çok yoğun kaşıntı',
      'Parmak araları, bilekler, koltuk altı, bel çevresinde ince, çizgisel izler',
      'Küçük kırmızı kabarcıklar/döküntüler',
    ],
    oneriler: [
      'Bulaşıcıdır; aile içi yakın temas olan kişiler de değerlendirilmeli',
      'Çarşaf, havlu ve kıyafetlerin sıcak yıkanması gerekir',
      'Doktor tarafından reçete edilen krem/losyon tedavisi gereklidir',
    ],
    yuksekBulasicilik: true,
  ),
};