import '../theme/app_motion.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:convert';
import 'package:url_launcher/url_launcher.dart';
import '../models/flashcard_review.dart';
import '../providers/app_state.dart';
import '../services/profile_storage.dart';
import '../theme/app_theme.dart';

class FlashcardScreen extends StatefulWidget {
  final ProfileStorage? profileStorage;
  const FlashcardScreen({super.key, this.profileStorage});

  @override
  State<FlashcardScreen> createState() => _FlashcardScreenState();
}

class _FlashcardScreenState extends State<FlashcardScreen> {
  String _selectedCategory = 'Matematik';
  int _currentIndex = 0;
  bool _showAnswer = false;
  final List<String> _knownIds = [];
  final Map<String, FlashcardReview> _reviews = {};
  bool _dueOnly = false;
  String? _loadedProfileId;
  int _loadGeneration = 0;
  bool _knownLoaded = false;
  bool _isSavingKnown = false;
  String? _knownStorageError;
  List<String>? _pendingKnownIds;
  Map<String, FlashcardReview>? _pendingReviews;
  bool _pendingRatingAdvance = false, _pendingReset = false;
  ProfileStorage get _storage =>
      widget.profileStorage ?? ProfileStorage.instance;

  final Map<String, List<Flashcard>> _cards = {
    'Matematik': [
      Flashcard(
        'mat_1',
        'Pisagor Teoremi nedir?',
        'a\u00B2 + b\u00B2 = c\u00B2\nDik üçgenin iki dik kenarının kareleri toplamı hipotenüsün karesine eşittir.',
      ),
      Flashcard(
        'mat_2',
        'Diskriminant nedir?',
        'a ≠ 0 ve a, b, c gerçek sayılar olmak üzere ax² + bx + c = 0 için:\nΔ = b² − 4ac\nΔ > 0: İki farklı gerçek kök\nΔ = 0: Çakışık iki gerçek kök\nΔ < 0: Gerçek sayılarda kök yok',
        sourceLabel: 'MEB OGM Materyal · Matematik 10',
        sourceUrl:
            'https://ogmmateryal.eba.gov.tr/panel/upload/etkilesimli/kitap/kazanim_kavrama/pdf/10/matematik.pdf',
      ),
      Flashcard(
        'mat_3',
        'Faktoryel nedir?\n5! = ?',
        '5! = 5 x 4 x 3 x 2 x 1 = 120\n0! = 1 (tanım gereği)',
      ),
      Flashcard(
        'mat_4',
        'Logaritma özellikleri?',
        'Taban a > 0 ve a ≠ 1; x > 0, y > 0 ve r gerçek sayı olmak üzere:\nlogₐ(xy) = logₐ(x) + logₐ(y)\nlogₐ(x/y) = logₐ(x) − logₐ(y)\nlogₐ(xʳ) = r · logₐ(x)',
        sourceLabel: 'MEB OGM Materyal · Matematik 12, Logaritma',
        sourceUrl:
            'https://ogmmateryal.eba.gov.tr/panel/upload/etkilesimli/kitap/matematik/12/unite1/files/basic-html/page11.html',
      ),
      Flashcard(
        'mat_5',
        'Türev nedir?',
        'Bir fonksiyonun anlık değişim hızı.\nf\'(x) = lim(\u0394x→0) [f(x+\u0394x) - f(x)] / \u0394x',
      ),
      Flashcard(
        'mat_6',
        'İntegral nedir?',
        'F′(x) = f(x) ise belirsiz integral:\n∫f(x) dx = F(x) + C\nBelirli integral işaretli birikimi verir. [a, b] aralığında grafikle x ekseni arasındaki geometrik alan ∫ₐᵇ|f(x)| dx ile hesaplanır.',
        sourceLabel: 'MEB OGM Materyal · Matematik 12, İntegral ile alan',
        sourceUrl:
            'https://ogmmateryal.eba.gov.tr/panel/upload/etkilesimli/kitap/matematik/12/unite6/files/basic-html/page49.html',
      ),
      Flashcard(
        'mat_7',
        'sin\u00B2x + cos\u00B2x = ?',
        'sin\u00B2x + cos\u00B2x = 1\n(Temel trigonometrik özdeşlik)',
      ),
      Flashcard(
        'mat_8',
        'Aritmetik dizide an = ?',
        'an = a1 + (n-1)d\nd: ortak fark',
      ),
    ],
    'Fizik': [
      Flashcard(
        'fiz_1',
        'Newton\'un 1. yasası?',
        'Eylemsizlik yasası: Net kuvvet sıfırsa cisim durgun kalır veya sabit hızla doğrusal hareketini sürdürür.',
      ),
      Flashcard(
        'fiz_2',
        'Newton\'un 2. yasası?',
        'ΣF = m · a\nNet (bileşke) kuvvet = Kütle × İvme\nKuvvet birimi: Newton (N = kg·m/s²)',
      ),
      Flashcard(
        'fiz_3',
        'Enerji korunumu?',
        'Yalıtılmış sistemin toplam enerjisi korunur. Yalnızca korunumlu kuvvetler iş yaptığında mekanik enerji (Ek + Ep) korunur. Sürtünme gibi etkiler mekanik enerjiyi iç enerjiye dönüştürebilir.',
        sourceLabel: 'MEB OGM Materyal · Fizik 11',
        sourceUrl:
            'https://ogmmateryal.eba.gov.tr/panel/upload/etkilesimli/kitap/kavram_calismalari/11/fizik/files/basic-html/page112.html',
      ),
      Flashcard(
        'fiz_4',
        'Ohm yasası?',
        'V = I x R\nV: Gerilim (Volt)\nI: Akım (Amper)\nR: Direnç (Ohm)',
      ),
      Flashcard(
        'fiz_5',
        'Serbest düşme?',
        'Cisim durgunluktan bırakılıyor, hava direnci yok ve aşağı yön pozitif seçilmişse:\nv = gt\nh = 1/2 gt\u00B2\ng değerini sorudan al; verilmemişse kullandığın yaklaşımı belirt.',
      ),
      Flashcard(
        'fiz_6',
        'İş-enerji teoremi?',
        'Wnet = \u0394Ek = 1/2mv\u00B2 - 1/2mv0\u00B2\nNet iş = Kinetik enerji değişimi',
      ),
    ],
    'Kimya': [
      Flashcard(
        'kim_1',
        'Mol nedir?',
        '1 mol ≈ 6,022 × 10\u00B2\u00B3 tanecik\nn = m/M\nn: mol, m: kütle (g), M: mol kütlesi (g/mol)',
      ),
      Flashcard(
        'kim_2',
        'İdeal gaz denklemi?',
        'PV = nRT (ideal gaz, T kelvin)\nR ≈ 0,082 L·atm/(mol·K)\nR ≈ 8,314 J/(mol·K)',
      ),
      Flashcard(
        'kim_3',
        'pH nedir?',
        'Seyreltik sulu çözeltiler için yaklaşık:\npH = −log[H⁺]\n25 °C sıcaklıkta:\npH < 7: Asidik\npH = 7: Nötr\npH > 7: Bazik',
        sourceLabel: 'MEB OGM Materyal · Kimya 11',
        sourceUrl:
            'https://ogmmateryal.eba.gov.tr/panel/upload/etkilesimli/kitap/beceri_temelli/11/kimya/files/basic-html/page121.html',
      ),
      Flashcard(
        'kim_4',
        'Elektron dizilimi kuralları?',
        '1. Aufbau: Elektronlar en düşük enerjili orbitalden başlayarak yerleşir.\n2. Pauli: Bir atomda iki elektronun dört kuantum sayısı aynı olamaz; bu yüzden bir orbitalde en fazla 2 zıt spinli elektron bulunur.\n3. Hund: Eş enerjili orbitallere elektronlar önce aynı spinle tek tek yerleşir.',
      ),
      Flashcard(
        'kim_5',
        'Kimyasal denge nedir?',
        'İleri ve geri tepkime hızlarının eşit, derişimlerin sabit kaldığı dinamik durum.\n\naA + bB ⇌ cC + dD için:\nKc = [C]^c[D]^d / ([A]^a[B]^b)\nSaf katı ve sıvılar Kc bağıntısına yazılmaz.',
        sourceLabel: 'MEB OGM Materyal · Kimya 11, Kimyasal Denge',
        sourceUrl:
            'https://ogmmateryal.eba.gov.tr/panel/upload/etkilesimli/kitap/beceri_temelli/11/kimya/files/basic-html/page111.html',
      ),
      Flashcard(
        'kim_6',
        'Le Chatelier ilkesi?',
        'Dengedeki sisteme yapılan etki, dengeyi bu etkiyi azaltacak yöne kaydırır.',
      ),
    ],
    'Biyoloji': [
      Flashcard(
        'bio_1',
        'Hücre zarı modeli?',
        'Akıcı mozaik model:\n- Fosfolipit çift tabaka\n- Yapısal ve taşıyıcı proteinler\n- Kolesterol (hayvan hücresi)',
      ),
      Flashcard(
        'bio_2',
        'Mitoz bölünme evreleri?',
        'Hücresel döngü: interfaz, ardından mitoz ve sitokinez.\nMitoz evreleri: Profaz -> Metafaz -> Anafaz -> Telofaz.\nBölünme sonunda kromozom sayısı korunur (2n -> 2n).',
        sourceLabel: 'MEB OGM Materyal · Fen Lisesi Biyoloji 10',
        sourceUrl:
            'https://ogmmateryal.eba.gov.tr/panel/upload/etkilesimli/kitap/fenlisesibiyoloji/10/unite1/files/basic-html/page7.html',
      ),
      Flashcard(
        'bio_3',
        'Mayoz bölünmenin farkı?',
        'Mayoz I: Tetrat oluşur, crossing over görülebilir; homolog kromozomlar ayrılır ve kromozom sayısı yarıya iner (2n → n).\nMayoz II: Mitoza benzer; kardeş kromatitler ayrılır (n → n).\nSonuç: genetik olarak farklı olabilen 4 hücre.',
      ),
      Flashcard(
        'bio_4',
        'Fotosentezin aşamaları?',
        'Işığa bağımlı tepkimeler: Tilakoit zarda gerçekleşir; su parçalanır, O₂ açığa çıkar, ATP ve NADPH üretilir.\nKalvin döngüsü: Stromada CO₂, ATP ve NADPH kullanılarak organik bileşiklerin öncülleri üretilir. Bunlardan glikoz ve diğer organik bileşikler sentezlenebilir.',
        sourceLabel: 'MEB OGM Materyal · Biyoloji 12, Kalvin döngüsü',
        sourceUrl:
            'https://ogmmateryal.eba.gov.tr/panel/upload/etkilesimli/kitap/fenlisesibiyoloji/12/unite2/files/basic-html/page12.html',
      ),
      Flashcard(
        'bio_5',
        'DNA replikasyonu?',
        'Yarı korumacı (semi-konservatif)\nHelikaz: Açma\nPrimaz: Primer sentezi\nDNA Polimeraz: Yeni zincir sentezi\nLigaz: Birleştirme',
      ),
      Flashcard(
        'bio_6',
        'Mendel yasaları?',
        '1. Ayrılma (segregasyon): Bir gene ait iki alel gamet oluşurken birbirinden ayrılır.\n2. Bağımsız dağılım: Farklı kromozomlardaki (bağlı olmayan) genler gametlere birbirinden bağımsız dağılır.\nGenotip: Alel bileşimi (AA, Aa, aa)\nFenotip: Gözlenen özellik',
      ),
    ],
  };

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final profileId = context.watch<AppState>().activeProfile.id;
    if (profileId == _loadedProfileId) return;
    _loadedProfileId = profileId;
    _knownIds.clear();
    _reviews.clear();
    _knownLoaded = false;
    _isSavingKnown = false;
    _knownStorageError = null;
    _pendingKnownIds = null;
    _pendingReviews = null;
    _pendingRatingAdvance = false;
    _pendingReset = false;
    _loadKnown(profileId, ++_loadGeneration);
  }

  Future<void> _loadKnown(String profileId, int generation) async {
    try {
      final storage = _storage;
      final values = await Future.wait([
        storage.readStringForProfile(profileId, 'flashcard_known'),
        storage.readStringForProfile(profileId, 'flashcard_reviews'),
      ]);
      final data = values[0];
      final decoded = data == null ? const <String>[] : jsonDecode(data);
      if (decoded is! List || decoded.any((item) => item is! String)) {
        throw const FormatException('Kart ilerleme biçimi geçersiz.');
      }
      final reviewData = values[1] == null
          ? const FlashcardReviewData({})
          : FlashcardReviewData.fromJson(jsonDecode(values[1]!));
      final reviews = Map<String, FlashcardReview>.of(reviewData.cards);
      final knownIds = decoded.cast<String>().toSet();
      var needsMigration = false;
      for (final id in knownIds) {
        if (!reviews.containsKey(id)) {
          reviews[id] = FlashcardReview.legacyKnown(DateTime.now());
          needsMigration = true;
        }
      }
      if (!mounted || generation != _loadGeneration) return;
      setState(() {
        _knownIds
          ..clear()
          ..addAll(knownIds);
        _reviews
          ..clear()
          ..addAll(reviews);
        _knownLoaded = true;
        _knownStorageError = null;
      });
      if (needsMigration) await _saveKnown();
    } catch (_) {
      if (!mounted || generation != _loadGeneration) return;
      setState(() {
        _knownLoaded = false;
        _knownStorageError = 'Kart ilerlemesi yüklenemedi.';
      });
    }
  }

  Future<bool> _saveKnown({
    List<String>? ids,
    Map<String, FlashcardReview>? reviews,
  }) async {
    if (!_knownLoaded || _isSavingKnown) return false;
    final profileId = _loadedProfileId;
    if (profileId == null) return false;
    final generation = _loadGeneration;
    final nextIds = List<String>.of(ids ?? _pendingKnownIds ?? _knownIds);
    final nextReviews = Map<String, FlashcardReview>.of(
      reviews ?? _pendingReviews ?? _reviews,
    );
    _pendingKnownIds = nextIds;
    _pendingReviews = nextReviews;
    setState(() => _isSavingKnown = true);
    try {
      await _storage.writeStringsForProfile(profileId, {
        'flashcard_known': jsonEncode(nextIds),
        'flashcard_reviews': jsonEncode(
          FlashcardReviewData(Map.unmodifiable(nextReviews)).toJson(),
        ),
      });
      if (!mounted || generation != _loadGeneration) return false;
      setState(() {
        _knownIds
          ..clear()
          ..addAll(nextIds);
        _reviews
          ..clear()
          ..addAll(nextReviews);
        _pendingKnownIds = null;
        _pendingReviews = null;
        _isSavingKnown = false;
        _knownStorageError = null;
      });
      return true;
    } catch (_) {
      if (!mounted || generation != _loadGeneration) return false;
      setState(() {
        _isSavingKnown = false;
        _knownStorageError =
            'Kart ilerlemesi kaydedilemedi. Kart değişmedi; yeniden dene.';
      });
      return false;
    }
  }

  void _finishSavedCardChange() {
    final advance = _pendingRatingAdvance, reset = _pendingReset;
    _pendingRatingAdvance = false;
    _pendingReset = false;
    if (reset) {
      setState(() {
        _currentIndex = 0;
        _showAnswer = false;
      });
    } else if (advance) {
      if (_dueOnly) {
        setState(() {
          if (_currentIndex >= _visibleCards.length) _currentIndex = 0;
          _showAnswer = false;
        });
      } else {
        _nextCard();
      }
    }
  }

  Future<void> _retryKnownStorage() async {
    final profileId = _loadedProfileId;
    if (profileId == null) return;
    if (_knownLoaded) {
      if (await _saveKnown() && mounted) _finishSavedCardChange();
    } else {
      setState(() => _knownStorageError = null);
      await _loadKnown(profileId, ++_loadGeneration);
    }
  }

  Future<void> _confirmResetKnown(
    BuildContext context,
    List<Flashcard> cards,
  ) async {
    if (!_knownLoaded || _isSavingKnown || _pendingReviews != null) return;
    final cardIds = cards.map((card) => card.id).toSet();
    final categoryReviewCount = _reviews.keys.where(cardIds.contains).length;
    if (categoryReviewCount == 0) return;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Kart geçmişini sıfırla?'),
        content: Text(
          '$_selectedCategory için $categoryReviewCount kartın tekrar geçmişi silinecek ve yeniden çalışmaya hazır olacak.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text('Vazgeç'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            child: const Text('Sıfırla'),
          ),
        ],
      ),
    );
    if (confirmed != true || !mounted) return;
    final ids = _knownIds.where((id) => !cardIds.contains(id)).toList();
    final reviews = Map<String, FlashcardReview>.of(_reviews)
      ..removeWhere((id, _) => cardIds.contains(id));
    _pendingReset = true;
    if (await _saveKnown(ids: ids, reviews: reviews) && mounted) {
      _finishSavedCardChange();
    }
  }

  Future<void> _openSource(String url) async {
    final uri = Uri.tryParse(url);
    var opened = false;
    try {
      opened =
          uri != null &&
          await launchUrl(uri, mode: LaunchMode.externalApplication);
    } catch (_) {
      opened = false;
    }
    if (!opened && mounted) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Kaynak açılamadı.')));
    }
  }

  List<Flashcard> get _currentCards => _cards[_selectedCategory] ?? [];

  List<Flashcard> _cardsDueAt(DateTime now) => _currentCards
      .where((card) => _reviews[card.id]?.isDueAt(now) ?? true)
      .toList(growable: false);

  List<Flashcard> get _visibleCards =>
      _dueOnly ? _cardsDueAt(DateTime.now()) : _currentCards;

  Future<void> _rateCard(FlashcardRating rating) async {
    final cards = _visibleCards;
    if (!_knownLoaded ||
        _isSavingKnown ||
        _pendingReviews != null ||
        !_showAnswer ||
        cards.isEmpty) {
      return;
    }
    final card = cards[_currentIndex.clamp(0, cards.length - 1).toInt()];
    final oldReview = _reviews[card.id];
    final review =
        (oldReview ??
                const FlashcardReview(
                  lastRating: null,
                  repetitions: 0,
                  intervalDays: 0,
                  lastReviewedAt: null,
                  nextReviewAt: null,
                ))
            .rate(rating, DateTime.now());
    final reviews = Map<String, FlashcardReview>.of(_reviews)
      ..[card.id] = review;
    final ids = List<String>.of(_knownIds);
    if (rating == FlashcardRating.remembered) {
      if (!ids.contains(card.id)) ids.add(card.id);
    } else {
      ids.remove(card.id);
    }
    _pendingRatingAdvance = true;
    if (await _saveKnown(ids: ids, reviews: reviews) && mounted) {
      _finishSavedCardChange();
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final categories = _cards.keys.toList();
    final categoryColors = [
      AppTheme.accentPurple,
      AppTheme.accentOrange,
      AppTheme.accentCyan,
      AppTheme.accentGreen,
    ];
    final allCards = _currentCards;
    final dueCards = _cardsDueAt(DateTime.now());
    final cards = _dueOnly ? dueCards : allCards;
    final knownCount = allCards.where((c) => _knownIds.contains(c.id)).length;
    final reviewedCount = allCards
        .where((c) => _reviews.containsKey(c.id))
        .length;
    final dueCount = dueCards.length;
    final totalCardCount = _cards.values.fold<int>(
      0,
      (total, categoryCards) => total + categoryCards.length,
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Bilgi Kartları'),
        actions: [
          TextButton(
            onPressed: !_knownLoaded || _isSavingKnown || reviewedCount == 0
                ? null
                : () => _confirmResetKnown(context, allCards),
            child: Text(
              'Sıfırla',
              style: textTheme.labelLarge?.copyWith(
                color: colors.onSurfaceVariant,
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          // Category chips
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: List.generate(categories.length, (i) {
                  final cat = categories[i];
                  final color = categoryColors[i];
                  final isSelected = cat == _selectedCategory;
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: ChoiceChip(
                      label: Text(cat),
                      selected: isSelected,
                      showCheckmark: false,
                      selectedColor: color,
                      backgroundColor: color.withValues(alpha: 0.1),
                      side: BorderSide(
                        color: color.withValues(alpha: isSelected ? 1 : 0.3),
                      ),
                      labelStyle: TextStyle(
                        color: isSelected
                            ? (ThemeData.estimateBrightnessForColor(color) ==
                                      Brightness.dark
                                  ? Colors.white
                                  : Colors.black)
                            : colors.onSurfaceVariant,
                        fontWeight: FontWeight.w600,
                        fontSize: 13,
                      ),
                      onSelected: (selected) {
                        if (!selected ||
                            _isSavingKnown ||
                            _pendingReviews != null) {
                          return;
                        }
                        setState(() {
                          _selectedCategory = cat;
                          _currentIndex = 0;
                          _showAnswer = false;
                        });
                      },
                    ),
                  );
                }),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: colors.tertiaryContainer.withValues(alpha: 0.55),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: colors.tertiary.withValues(alpha: 0.35),
                ),
              ),
              child: Text(
                'Başlangıç seti: $totalCardCount kart. Set tüm müfredatı kapsamaz. Tekrar aralığı yerel ve basit bir çalışma önerisidir; öğrenme garantisi vermez.',
                style: textTheme.bodySmall?.copyWith(
                  color: colors.onSurface,
                  fontSize: 11,
                  height: 1.35,
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                FilterChip(
                  avatar: const Icon(Icons.replay_rounded, size: 18),
                  label: Text('Çalışılacak · $dueCount'),
                  selected: _dueOnly,
                  onSelected:
                      !_knownLoaded || _isSavingKnown || _pendingReviews != null
                      ? null
                      : (selected) => setState(() {
                          _dueOnly = selected;
                          _currentIndex = 0;
                          _showAnswer = false;
                        }),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Hatırladım: 1, 3, sonra en fazla 30 gün',
                    style: textTheme.bodySmall?.copyWith(
                      color: colors.onSurfaceVariant,
                      fontSize: 10,
                    ),
                  ),
                ),
                Tooltip(
                  message:
                      'Unuttum: 1 gün. Tereddüt: 1 gün veya önceki aralığın yarısı. Hatırladım: 1 ve 3 gün; sonra aralık ikiye katlanır, en çok 30 gün olur.',
                  child: Icon(
                    Icons.info_outline_rounded,
                    size: 18,
                    color: colors.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),

          // Progress
          if (_knownStorageError != null)
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: colors.errorContainer,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  children: [
                    Icon(Icons.error_outline, color: colors.onErrorContainer),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        _knownStorageError!,
                        style: textTheme.bodySmall?.copyWith(
                          color: colors.onErrorContainer,
                        ),
                      ),
                    ),
                    TextButton(
                      onPressed: _isSavingKnown ? null : _retryKnownStorage,
                      child: Text(
                        _knownLoaded ? 'Yeniden kaydet' : 'Yeniden yükle',
                      ),
                    ),
                  ],
                ),
              ),
            ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${cards.isEmpty ? 0 : _currentIndex + 1} / ${cards.length}',
                  style: textTheme.bodySmall?.copyWith(
                    color: colors.onSurfaceVariant,
                  ),
                ),
                Text(
                  _knownLoaded
                      ? '$knownCount / ${allCards.length} son yanıtta bildim'
                      : 'İlerleme yükleniyor',
                  style: textTheme.bodySmall?.copyWith(color: colors.secondary),
                ),
              ],
            ),
          ),
          const SizedBox(height: 4),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: allCards.isEmpty ? 0 : knownCount / allCards.length,
                minHeight: 4,
                backgroundColor: colors.outlineVariant,
                valueColor: AlwaysStoppedAnimation(colors.secondary),
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Flashcard
          Expanded(
            child: cards.isEmpty
                ? Center(
                    child: Text(
                      _dueOnly
                          ? 'Şu an tekrar zamanı gelen kart yok.'
                          : 'Kart yok',
                      style: textTheme.bodyMedium?.copyWith(
                        color: colors.onSurfaceVariant,
                      ),
                    ),
                  )
                : Semantics(
                    button: true,
                    label:
                        'Kartı çevir. ${_showAnswer ? cards[_currentIndex].answer : cards[_currentIndex].question}',
                    hint: _showAnswer
                        ? 'Soruyu görmek için dokun'
                        : 'Cevabı görmek için dokun',
                    excludeSemantics: true,
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(24),
                        onTap: () => setState(() => _showAnswer = !_showAnswer),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 24),
                          child: AnimatedSwitcher(
                            duration: AppMotion.duration(
                              context,
                              AppMotion.standard,
                            ),
                            child: Container(
                              key: ValueKey(
                                '${cards[_currentIndex].id}_$_showAnswer',
                              ),
                              width: double.infinity,
                              padding: const EdgeInsets.all(24),
                              decoration: BoxDecoration(
                                gradient: _showAnswer
                                    ? LinearGradient(
                                        colors: [
                                          colors.secondary.withValues(
                                            alpha: 0.1,
                                          ),
                                          colors.surfaceContainerLow,
                                        ],
                                        begin: Alignment.topLeft,
                                        end: Alignment.bottomRight,
                                      )
                                    : LinearGradient(
                                        colors: [
                                          colors.primary.withValues(alpha: 0.1),
                                          colors.surfaceContainerLow,
                                        ],
                                        begin: Alignment.topLeft,
                                        end: Alignment.bottomRight,
                                      ),
                                borderRadius: BorderRadius.circular(24),
                                border: Border.all(
                                  color: _showAnswer
                                      ? colors.secondary.withValues(alpha: 0.3)
                                      : colors.primary.withValues(alpha: 0.3),
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color:
                                        (_showAnswer
                                                ? colors.secondary
                                                : colors.primary)
                                            .withValues(alpha: 0.1),
                                    blurRadius: 20,
                                    offset: const Offset(0, 8),
                                  ),
                                ],
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 12,
                                      vertical: 4,
                                    ),
                                    decoration: BoxDecoration(
                                      color:
                                          (_showAnswer
                                                  ? colors.secondary
                                                  : colors.primary)
                                              .withValues(alpha: 0.15),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Text(
                                      _showAnswer ? 'CEVAP' : 'SORU',
                                      style: TextStyle(
                                        color: _showAnswer
                                            ? colors.secondary
                                            : colors.primary,
                                        fontWeight: FontWeight.w700,
                                        fontSize: 11,
                                        letterSpacing: 2,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 24),
                                  Text(
                                    _showAnswer
                                        ? cards[_currentIndex].answer
                                        : cards[_currentIndex].question,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: colors.onSurface,
                                      fontSize: _showAnswer ? 15 : 18,
                                      fontWeight: _showAnswer
                                          ? FontWeight.w400
                                          : FontWeight.w600,
                                      height: 1.8,
                                    ),
                                  ),
                                  if (_showAnswer &&
                                      cards[_currentIndex].sourceUrl != null)
                                    TextButton.icon(
                                      onPressed: () => _openSource(
                                        cards[_currentIndex].sourceUrl!,
                                      ),
                                      icon: const Icon(
                                        Icons.open_in_new,
                                        size: 14,
                                      ),
                                      label: Text(
                                        'Kaynak: ${cards[_currentIndex].sourceLabel}',
                                      ),
                                    ),
                                  const SizedBox(height: 24),
                                  if (!_showAnswer)
                                    Text(
                                      'Cevabı görmek için dokun',
                                      style: TextStyle(
                                        color: colors.onSurfaceVariant,
                                        fontSize: 11,
                                      ),
                                    ),
                                  if (_reviews.containsKey(
                                    cards[_currentIndex].id,
                                  ))
                                    Container(
                                      margin: const EdgeInsets.only(top: 12),
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 10,
                                        vertical: 4,
                                      ),
                                      decoration: BoxDecoration(
                                        color: colors.secondary.withValues(
                                          alpha: 0.15,
                                        ),
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Text(
                                        _reviewStatus(
                                          _reviews[cards[_currentIndex].id]!,
                                        ),
                                        style: TextStyle(
                                          color: colors.secondary,
                                          fontSize: 11,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
          ),
          const SizedBox(height: 12),

          // Controls
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    _ratingButton(
                      context,
                      label: 'Unuttum',
                      rating: FlashcardRating.forgotten,
                      color: colors.error,
                      enabled:
                          _knownLoaded &&
                          !_isSavingKnown &&
                          _pendingReviews == null &&
                          _showAnswer &&
                          cards.isNotEmpty,
                    ),
                    const SizedBox(width: 8),
                    _ratingButton(
                      context,
                      label: 'Tereddüt',
                      rating: FlashcardRating.hesitant,
                      color: colors.tertiary,
                      enabled:
                          _knownLoaded &&
                          !_isSavingKnown &&
                          _pendingReviews == null &&
                          _showAnswer &&
                          cards.isNotEmpty,
                    ),
                    const SizedBox(width: 8),
                    _ratingButton(
                      context,
                      label: 'Hatırladım',
                      rating: FlashcardRating.remembered,
                      color: colors.secondary,
                      enabled:
                          _knownLoaded &&
                          !_isSavingKnown &&
                          _pendingReviews == null &&
                          _showAnswer &&
                          cards.isNotEmpty,
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton.icon(
                      onPressed:
                          _pendingReviews != null ||
                              _isSavingKnown ||
                              cards.isEmpty ||
                              _currentIndex == 0
                          ? null
                          : () => setState(() {
                              _currentIndex--;
                              _showAnswer = false;
                            }),
                      icon: const Icon(Icons.arrow_back_rounded, size: 16),
                      label: const Text('Önceki'),
                    ),
                    Text(
                      _showAnswer
                          ? 'Tekrar aralığını seç'
                          : 'Değerlendirmek için cevabı aç',
                      style: textTheme.bodySmall?.copyWith(
                        color: colors.onSurfaceVariant,
                        fontSize: 10,
                      ),
                    ),
                    TextButton.icon(
                      onPressed:
                          _pendingReviews != null ||
                              _isSavingKnown ||
                              cards.isEmpty
                          ? null
                          : () => _nextCard(),
                      iconAlignment: IconAlignment.end,
                      icon: const Icon(Icons.arrow_forward_rounded, size: 16),
                      label: const Text('Atla'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _nextCard() {
    if (_pendingReviews != null || _isSavingKnown) return;
    final cards = _visibleCards;
    if (cards.isEmpty) {
      setState(() {
        _currentIndex = 0;
        _showAnswer = false;
      });
      return;
    }
    if (_currentIndex < cards.length - 1) {
      setState(() {
        _currentIndex++;
        _showAnswer = false;
      });
    } else {
      // Loop back
      setState(() {
        _currentIndex = 0;
        _showAnswer = false;
      });
    }
  }

  Widget _ratingButton(
    BuildContext context, {
    required String label,
    required FlashcardRating rating,
    required Color color,
    required bool enabled,
  }) {
    final colors = Theme.of(context).colorScheme;
    return Expanded(
      child: Semantics(
        button: true,
        enabled: enabled,
        label: label,
        child: InkWell(
          borderRadius: BorderRadius.circular(14),
          onTap: enabled ? () => _rateCard(rating) : null,
          child: AnimatedContainer(
            duration: AppMotion.duration(context, AppMotion.press),
            padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 4),
            decoration: BoxDecoration(
              color: enabled
                  ? color.withValues(alpha: 0.14)
                  : colors.surfaceContainerHighest.withValues(alpha: 0.55),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: enabled
                    ? color.withValues(alpha: 0.55)
                    : colors.outlineVariant,
              ),
            ),
            child: Center(
              child: Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: enabled ? color : colors.onSurfaceVariant,
                  fontWeight: FontWeight.w600,
                  fontSize: 12,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  String _reviewStatus(FlashcardReview review) {
    final rating = switch (review.lastRating) {
      FlashcardRating.forgotten => 'Unuttum',
      FlashcardRating.hesitant => 'Tereddüt ettim',
      FlashcardRating.remembered => 'Hatırladım',
      null => 'Henüz değerlendirilmedi',
    };
    final due = review.nextReviewAt;
    if (due == null || !due.isAfter(DateTime.now().toUtc())) {
      return 'Son yanıt: $rating · Tekrar zamanı geldi';
    }
    final days = (due.difference(DateTime.now().toUtc()).inHours / 24).ceil();
    return 'Son yanıt: $rating · $days gün sonra';
  }
}

class Flashcard {
  final String id;
  final String question;
  final String answer;
  final String? sourceLabel;
  final String? sourceUrl;

  Flashcard(
    this.id,
    this.question,
    this.answer, {
    this.sourceLabel,
    this.sourceUrl,
  });
}
