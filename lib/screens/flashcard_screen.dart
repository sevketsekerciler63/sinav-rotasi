import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:convert';
import 'package:url_launcher/url_launcher.dart';
import '../models/flashcard_review.dart';
import '../providers/app_state.dart';
import '../services/profile_storage.dart';
import '../theme/app_theme.dart';

class FlashcardScreen extends StatefulWidget {
  const FlashcardScreen({super.key});

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

  final Map<String, List<Flashcard>> _cards = {
    'Matematik': [
      Flashcard(
        'mat_1',
        'Pisagor Teoremi nedir?',
        'a\u00B2 + b\u00B2 = c\u00B2\nDik ucgenin iki dik kenari karelerinin toplami hipotenusun karesine esittir.',
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
        '5! = 5 x 4 x 3 x 2 x 1 = 120\n0! = 1 (tanimla)',
      ),
      Flashcard(
        'mat_4',
        'Logaritma ozellikleri?',
        'log(ab) = log(a) + log(b)\nlog(a/b) = log(a) - log(b)\nlog(a^n) = n.log(a)',
      ),
      Flashcard(
        'mat_5',
        'Turev nedir?',
        'Bir fonksiyonun degisim hizi.\nf\'(x) = lim(\u0394x->0) [f(x+\u0394x) - f(x)] / \u0394x',
      ),
      Flashcard(
        'mat_6',
        'Integral nedir?',
        'Turev\'in tersi. Egri altinda kalan alan.\n\u222Bf(x)dx = F(x) + C',
      ),
      Flashcard(
        'mat_7',
        'sin\u00B2x + cos\u00B2x = ?',
        'sin\u00B2x + cos\u00B2x = 1\n(Temel trigonometrik ozdeslik)',
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
        'Newton\'un 1. yasasi?',
        'Eylemsizlik Yasasi: Cisme etki eden net kuvvet sifirsa, cisim duruyorsa durur, hareket ediyorsa duzgun dogusal hareket yapar.',
      ),
      Flashcard(
        'fiz_2',
        'Newton\'un 2. yasasi?',
        'F = m x a\nKuvvet = Kutle x Ivme\nBirimi: Newton (N)',
      ),
      Flashcard(
        'fiz_3',
        'Enerji korunumu?',
        'Yalitilmis sistemin toplam enerjisi korunur. Mekanik enerji Ek + Ep, yalnizca korunumlu kuvvetler is yaptiginda sabit kalir; surtunme varsa mekanik enerji isi ve isiya donusebilir.',
        sourceLabel: 'MEB OGM Materyal · Fizik 11',
        sourceUrl:
            'https://ogmmateryal.eba.gov.tr/panel/upload/etkilesimli/kitap/kavram_calismalari/11/fizik/files/basic-html/page112.html',
      ),
      Flashcard(
        'fiz_4',
        'Ohm Yasasi?',
        'V = I x R\nV: Gerilim (Volt)\nI: Akim (Amper)\nR: Direnc (Ohm)',
      ),
      Flashcard(
        'fiz_5',
        'Serbest dusme?',
        'Cisim durgunluktan birakiliyor, hava direnci yok ve asagi yon pozitif secilmisse:\nv = gt\nh = 1/2 gt\u00B2\ng degerini soruda verilen degerden al; verilmezse kullanilan yaklasimi belirt.',
      ),
      Flashcard(
        'fiz_6',
        'Is-Enerji teoremi?',
        'Wnet = \u0394Ek = 1/2mv\u00B2 - 1/2mv0\u00B2\nNet is = Kinetik enerji degisimi',
      ),
    ],
    'Kimya': [
      Flashcard(
        'kim_1',
        'Mol nedir?',
        '1 mol = 6.022 x 10\u00B2\u00B3 tane\nn = m/M\nn: mol, m: kutle(g), M: mol kutlesi(g/mol)',
      ),
      Flashcard(
        'kim_2',
        'Ideal gaz denklemi?',
        'PV = nRT\nR = 0.082 L.atm/mol.K\nR = 8.314 J/mol.K',
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
        'Elektron dizilimi kurallari?',
        '1. Aufbau (dusuk enerjiden baslama)\n2. Pauli (max 2 elektron/orbital)\n3. Hund (ayni alt kabuklarda once tek tek)',
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
        'Denge halindeki sisteme yapilan etki, dengeyi bu etkiyi azaltacak yone kaydirir.',
      ),
    ],
    'Biyoloji': [
      Flashcard(
        'bio_1',
        'Hucre zari modeli?',
        'Akici Mozaik Model:\n- Fosfolipit cift tabaka\n- Yapisal ve tasinan proteinler\n- Kolesterol (hayvan hucresi)',
      ),
      Flashcard(
        'bio_2',
        'Mitoz bolunme safhalari?',
        'Hucresel dongu: interfaz, ardindan mitoz ve sitokinez.\nMitoz evreleri: Profaz -> Metafaz -> Anafaz -> Telofaz.\nBolunme sonunda kromozom sayisi korunur (2n -> 2n).',
        sourceLabel: 'MEB OGM Materyal · Fen Lisesi Biyoloji 10',
        sourceUrl:
            'https://ogmmateryal.eba.gov.tr/panel/upload/etkilesimli/kitap/fenlisesibiyoloji/10/unite1/files/basic-html/page7.html',
      ),
      Flashcard(
        'bio_3',
        'Mayoz bolunme farki?',
        'Mayoz I: Tetrat olusumu, crossing over\nMayoz II: Mitoza benzer\n2n -> n (kromozom yariya iner)',
      ),
      Flashcard(
        'bio_4',
        'Fotosentez asamalari?',
        'Isiga bagimli: Tilakoid zarda\n(H2O parcalanir, ATP+NADPH olusur)\nIsiktan bagimsiz (Calvin): Stromada\n(CO2 + ATP -> Glikoz)',
      ),
      Flashcard(
        'bio_5',
        'DNA replikasyonu?',
        'Yari korumaci (semi-konservatif)\nHelikaz: Acma\nPrimaz: Primer sentezi\nDNA Polimeraz: Yeni zincir sentezi\nLigaz: Birlestirme',
      ),
      Flashcard(
        'bio_6',
        'Mendel yasalari?',
        '1. Ayrilma (segregasyon)\n2. Bagimsiz dagilma\nGenotip: Aa, AA, aa\nFenotip: Dis gorunus',
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
    _loadKnown(profileId, ++_loadGeneration);
  }

  Future<void> _loadKnown(String profileId, int generation) async {
    try {
      final storage = ProfileStorage.instance;
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

  Future<void> _saveKnown() async {
    if (!_knownLoaded || _isSavingKnown) return;
    final profileId = _loadedProfileId;
    if (profileId == null) return;
    final generation = _loadGeneration;
    setState(() => _isSavingKnown = true);
    try {
      await ProfileStorage.instance.writeStringsForProfile(profileId, {
        'flashcard_known': jsonEncode(_knownIds),
        'flashcard_reviews': jsonEncode(
          FlashcardReviewData(Map.unmodifiable(_reviews)).toJson(),
        ),
      });
      if (!mounted || generation != _loadGeneration) return;
      setState(() {
        _isSavingKnown = false;
        _knownStorageError = null;
      });
    } catch (_) {
      if (!mounted || generation != _loadGeneration) return;
      setState(() {
        _isSavingKnown = false;
        _knownStorageError = 'Kart ilerlemesi kaydedilemedi.';
      });
    }
  }

  Future<void> _retryKnownStorage() async {
    final profileId = _loadedProfileId;
    if (profileId == null) return;
    if (_knownLoaded) {
      await _saveKnown();
    } else {
      setState(() => _knownStorageError = null);
      await _loadKnown(profileId, ++_loadGeneration);
    }
  }

  Future<void> _confirmResetKnown(
    BuildContext context,
    List<Flashcard> cards,
  ) async {
    if (!_knownLoaded) return;
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
    setState(() {
      _knownIds.removeWhere(cardIds.contains);
      _reviews.removeWhere((id, _) => cardIds.contains(id));
      _currentIndex = 0;
      _showAnswer = false;
    });
    await _saveKnown();
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
    if (!_knownLoaded || _isSavingKnown || !_showAnswer || cards.isEmpty) {
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
    setState(() {
      _reviews[card.id] = review;
      if (rating == FlashcardRating.remembered) {
        if (!_knownIds.contains(card.id)) _knownIds.add(card.id);
      } else {
        _knownIds.remove(card.id);
      }
    });
    await _saveKnown();
    if (!mounted) return;
    if (_dueOnly) {
      setState(() {
        if (_currentIndex >= _visibleCards.length) _currentIndex = 0;
        _showAnswer = false;
      });
    } else {
      _nextCard();
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
                        if (!selected) return;
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
                  onSelected: !_knownLoaded || _isSavingKnown
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
                            duration: const Duration(milliseconds: 300),
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
                          _showAnswer &&
                          cards.isNotEmpty,
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton.icon(
                      onPressed: cards.isEmpty || _currentIndex == 0
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
                      onPressed: cards.isEmpty ? null : () => _nextCard(),
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
            duration: const Duration(milliseconds: 150),
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
