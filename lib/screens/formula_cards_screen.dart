import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../theme/app_theme.dart';

class FormulaCardsScreen extends StatefulWidget {
  const FormulaCardsScreen({super.key});

  @override
  State<FormulaCardsScreen> createState() => _FormulaCardsScreenState();
}

class _FormulaCardsScreenState extends State<FormulaCardsScreen> {
  String _selectedCategory = 'Matematik';

  final Map<String, List<FormulaItem>> _formulas = {
    'Matematik': [
      FormulaItem(
        'Pisagor Teoremi',
        'a\u00B2 + b\u00B2 = c\u00B2',
        'Dik üçgende a ve b dik kenarlar, c hipotenüstür.',
        sourceLabel: 'MEB OGM Materyal · Fen Lisesi Matematik 9',
        sourceUrl:
            'https://ogmmateryal.eba.gov.tr/panel/upload/etkilesimli/kitap/fenlisesimatematik/9/unite4/files/basic-html/page27.html',
      ),
      FormulaItem(
        'İkinci Dereceden Denklem',
        'x = (−b ± √Δ) / (2a),  Δ = b² − 4ac',
        'a ≠ 0. Δ = b² − 4ac; gerçek kökler için Δ ≥ 0.',
        sourceLabel: 'MEB OGM Materyal · İkinci Dereceden Denklemler',
        sourceUrl:
            'https://ogmmateryal.eba.gov.tr/panel/upload/etkilesimli/kitap/elazig-telafi/matematik/files/basic-html/page77.html',
      ),
      FormulaItem(
        'Aritmetik Dizi Toplamı',
        'Sn = n(a1 + an) / 2',
        'n: terim sayısı; a1: ilk, an: son terim.',
        sourceLabel: 'MEB OGM Materyal · Fen Lisesi Matematik 12',
        sourceUrl:
            'https://ogmmateryal.eba.gov.tr/panel/upload/etkilesimli/kitap/fenlisesimatematik/12/unite2/files/basic-html/page25.html',
      ),
      FormulaItem(
        'Geometrik Dizi Toplamı',
        'Sn = a1(1 - r^n) / (1 - r)',
        'r: ortak oran, r ≠ 1. r = 1 ise Sn = n · a1.',
        sourceLabel: 'MEB OGM Materyal · Matematik 12',
        sourceUrl:
            'https://ogmmateryal.eba.gov.tr/panel/upload/etkilesimli/kitap/beceri_temelli/12/matematik/files/basic-html/page144.html',
      ),
      FormulaItem(
        'Permütasyon',
        'P(n,r) = n! / (n-r)!',
        'n, r ∈ ℕ ve r ≤ n; sıralama önemlidir.',
        sourceLabel: 'MEB OGM Materyal · Defterim Matematik 10',
        sourceUrl:
            'https://ogmmateryal.eba.gov.tr/panel/upload/etkilesimli/kitap/defterim/10/matematik/files/basic-html/page18.html',
      ),
      FormulaItem(
        'Kombinasyon',
        'C(n,r) = n! / (r!(n-r)!)',
        'n, r ∈ ℕ ve r ≤ n; sıralama önemli değildir.',
        sourceLabel: 'MEB OGM Materyal · Matematik 10',
        sourceUrl:
            'https://ogmmateryal.eba.gov.tr/panel/upload/etkilesimli/kitap/matematik/10/unite1/files/basic-html/page20.html',
      ),
      FormulaItem(
        'Binom Açılımı',
        '(a+b)^n = \u03A3 C(n,k) a^(n-k) b^k',
        'n pozitif tam sayı; k = 0, 1, …, n.',
        sourceLabel: 'MEB OGM Materyal · Matematik 10 Kavram Öğretimi',
        sourceUrl:
            'https://ogmmateryal.eba.gov.tr/panel/upload/etkilesimli/kitap/kavram_calismalari/10/matematik/tek/files/basic-html/page17.html',
      ),
      FormulaItem(
        'Daire Alanı',
        'A = \u03C0r\u00B2',
        'r: yarıçap.',
        sourceLabel: 'MEB OGM Materyal · Matematik 11',
        sourceUrl:
            'https://ogmmateryal.eba.gov.tr/panel/upload/etkilesimli/kitap/matematik/11/unite5/files/basic-html/page39.html',
      ),
      FormulaItem(
        'Küre Hacmi',
        'V = 4/3 \u03C0r\u00B3',
        'r: yarıçap.',
        sourceLabel: 'MEB OGM Materyal · Temel Düzey Matematik 12',
        sourceUrl:
            'https://ogmmateryal.eba.gov.tr/panel/upload/etkilesimli/kitap/matematiktemelduzey/12/unite1/files/basic-html/page138.html',
      ),
      FormulaItem(
        'Silindir Hacmi',
        'V = \u03C0r\u00B2h',
        'Dik dairesel silindir; r: taban yarıçapı, h: yükseklik.',
        sourceLabel: 'MEB OGM Materyal · Temel Düzey Matematik 12',
        sourceUrl:
            'https://ogmmateryal.eba.gov.tr/panel/upload/etkilesimli/kitap/matematiktemelduzey/12/unite1/files/basic-html/page131.html',
      ),
      FormulaItem(
        'Koni Hacmi',
        'V = 1/3 \u03C0r\u00B2h',
        'Dik dairesel koni; r: taban yarıçapı, h: yükseklik.',
        sourceLabel: 'MEB OGM Materyal · Matematik 11 Çalışma Defteri',
        sourceUrl:
            'https://ogmmateryal.eba.gov.tr/panel/upload/etkilesimli/kitap/calisma_defteri/f7/11/matematik/matematik.pdf',
      ),
      FormulaItem(
        'Logaritma Kuralı',
        'log_a(xy) = log_a(x) + log_a(y)',
        'a > 0, a ≠ 1 ve x, y > 0. Çarpımın logaritması.',
        sourceLabel: 'MEB OGM Materyal · Matematik 12',
        sourceUrl:
            'https://ogmmateryal.eba.gov.tr/panel/upload/etkilesimli/kitap/matematik/12/unite1/files/basic-html/page22.html',
      ),
      FormulaItem(
        'Türev Kuralı',
        'd/dx [x^n] = n · x^(n−1)',
        'n pozitif tam sayı.',
        sourceLabel: 'MEB OGM Materyal · Matematik 12',
        sourceUrl:
            'https://ogmmateryal.eba.gov.tr/panel/upload/etkilesimli/kitap/matematik/12/unite5/files/basic-html/page46.html',
      ),
      FormulaItem(
        'İntegral Kuralı',
        '\u222Bx^n dx = x^(n+1)/(n+1) + C',
        'n ∈ ℚ, n ≠ −1; C integral sabitidir.',
        sourceLabel: 'MEB OGM Materyal · Fen Lisesi Matematik 12',
        sourceUrl:
            'https://ogmmateryal.eba.gov.tr/panel/upload/etkilesimli/kitap/fenlisesimatematik/12/unite6/files/basic-html/page6.html',
      ),
    ],
    'Fizik': [
      FormulaItem(
        'Newton\'ın 2. Yasası',
        'ΣF = m × a',
        'ΣF: cisme etki eden bileşke kuvvet; m: kütle, a: ivme.',
        sourceLabel: 'MEB OGM Materyal · Fen Lisesi Fizik 9',
        sourceUrl:
            'https://ogmmateryal.eba.gov.tr/panel/upload/etkilesimli/kitap/fenlisesifizik/9/unite3/files/basic-html/page18.html',
      ),
      FormulaItem(
        'Kinetik Enerji',
        'Ek = 1/2 · m · v²',
        'Öteleme hareketi; m: kütle, v: hız büyüklüğü.',
        sourceLabel: 'MEB OGM Materyal · Fizik 9',
        sourceUrl:
            'https://ogmmateryal.eba.gov.tr/panel/upload/etkilesimli/kitap/kazanim_kavrama/pdf/9/fizik.pdf',
      ),
      FormulaItem(
        'Potansiyel Enerji',
        'Ep = mgh',
        'Yakın yüzeyde g sabit; h seçilen referans düzeyine göredir.',
        sourceLabel: 'MEB OGM Materyal · Fizik 9',
        sourceUrl:
            'https://ogmmateryal.eba.gov.tr/panel/upload/etkilesimli/kitap/kazanim_kavrama/pdf/9/fizik.pdf',
      ),
      FormulaItem(
        'İş',
        'W = F · Δx · cosθ',
        'Sabit kuvvet; θ, kuvvet ile yer değiştirme arasındaki açı.',
        sourceLabel: 'MEB OGM Materyal · Kuvvet ve Hareket',
        sourceUrl:
            'https://ogmmateryal.eba.gov.tr/panel/upload/pdf/bi5zk3rxz4f.pdf',
      ),
      FormulaItem(
        'Hız Formülü',
        'v = v0 + at',
        'Doğrusal sabit ivmeli hareket; v0: ilk hız, t: geçen süre.',
        sourceLabel: 'MEB OGM Materyal · Fen Lisesi Fizik 11',
        sourceUrl:
            'https://ogmmateryal.eba.gov.tr/panel/upload/etkilesimli/kitap/fenlisesifizik/11/unite1/bolum1/files/basic-html/page54.html',
      ),
      FormulaItem(
        'Yer Değiştirme Formülü',
        'Δx = v0t + 1/2 · a · t²',
        't = 0 anından başlayan doğrusal sabit ivmeli hareket.',
        sourceLabel: 'MEB OGM Materyal · Fen Lisesi Fizik 11',
        sourceUrl:
            'https://ogmmateryal.eba.gov.tr/panel/upload/etkilesimli/kitap/fenlisesifizik/11/unite1/bolum1/files/basic-html/page55.html',
      ),
      FormulaItem(
        'Ohm Yasası',
        'V = I · R',
        'Ohmik iletken; V: gerilim, I: akım, R: direnç.',
        sourceLabel: 'MEB OGM Materyal · Fen Lisesi Fizik 10',
        sourceUrl:
            'https://ogmmateryal.eba.gov.tr/panel/upload/etkilesimli/kitap/fenlisesifizik/10/unite1/files/basic-html/page52.html',
      ),
      FormulaItem(
        'Güç',
        'P_ort = W / Δt = ΔE / Δt',
        'Ortalama güç; yapılan iş veya aktarılan enerji / geçen süre.',
        sourceLabel: 'MEB OGM Materyal · Fizik 9',
        sourceUrl:
            'https://ogmmateryal.eba.gov.tr/panel/upload/etkilesimli/kitap/calisma_defteri/f5/9/fizik/fizik.pdf',
      ),
      FormulaItem(
        'Coulomb Yasası',
        'F = k · |q1 · q2| / r²',
        'Noktasal yükler; r aralarındaki uzaklık, k ortamın Coulomb sabitidir.',
        sourceLabel: 'MEB OGM Materyal · Fizik 9',
        sourceUrl:
            'https://ogmmateryal.eba.gov.tr/panel/upload/etkilesimli/kitap/kazanim_kavrama/pdf/9/fizik.pdf',
      ),
      FormulaItem(
        'Dalga Hızı',
        'v = f · λ',
        'v: dalga hızı, f: frekans, λ: dalga boyu; hız ortama bağlıdır.',
        sourceLabel: 'MEB OGM Materyal · Fen Lisesi Fizik 10',
        sourceUrl:
            'https://ogmmateryal.eba.gov.tr/panel/upload/etkilesimli/kitap/fenlisesifizik/10/unite3/files/basic-html/page14.html',
      ),
      FormulaItem(
        'Esneklik Potansiyel Enerjisi',
        'Ep = 1/2 · k · x²',
        'k: yay sabiti; x dengeden uzama/sıkışmadır. Yay esneklik sınırında olmalı.',
        sourceLabel: 'MEB OGM Materyal · Fizik 9',
        sourceUrl:
            'https://ogmmateryal.eba.gov.tr/panel/upload/etkilesimli/kitap/kazanim_kavrama/pdf/9/fizik.pdf',
      ),
      FormulaItem(
        'Tork (Kuvvet Momenti)',
        'τ = F · d⊥',
        'd⊥: dönme eksenine olan dik uzaklık (moment kolu).',
        sourceLabel: 'MEB OGM Materyal · Fen Lisesi Fizik 12',
        sourceUrl:
            'https://ogmmateryal.eba.gov.tr/panel/upload/etkilesimli/kitap/fenlisesifizik/12/unite1/files/basic-html/page43.html',
      ),
    ],
    'Kimya': [
      FormulaItem(
        'Mol Hesabı',
        'n = m / M',
        'Saf madde; m: kütle, M: mol kütlesi.',
        sourceLabel: 'MEB OGM Materyal · Kimya 10',
        sourceUrl:
            'https://ogmmateryal.eba.gov.tr/panel/upload/etkilesimli/kitap/kimya/10/elazig/unite1/files/basic-html/page27.html',
      ),
      FormulaItem(
        'İdeal Gaz',
        'PV = nRT',
        'İdeal gaz modeli; P: atm, V: L, T: K için R = 0,082 L·atm/(mol·K).',
        sourceLabel: 'MEB OGM Materyal · Kimya 11',
        sourceUrl:
            'https://ogmmateryal.eba.gov.tr/panel/upload/etkilesimli/kitap/kimya/11/kimya11_2unite/files/basic-html/page20.html',
      ),
      FormulaItem(
        'Molarite',
        'M = n / V_çözelti(L)',
        'n: çözünen molü; V: son çözeltinin hacmi. Sıcaklığa bağlıdır.',
        sourceLabel: 'MEB OGM Materyal · Fen Lisesi Kimya 11',
        sourceUrl:
            'https://ogmmateryal.eba.gov.tr/panel/upload/etkilesimli/kitap/fenlisesikimya/11/unite3/files/basic-html/page11.html',
      ),
      FormulaItem(
        'Molalite',
        'm = n / m_çözücü(kg)',
        'n: çözünen molü; paydada çözücünün kg cinsinden kütlesi.',
        sourceLabel: 'MEB OGM Materyal · Fen Lisesi Kimya 11',
        sourceUrl:
            'https://ogmmateryal.eba.gov.tr/panel/upload/etkilesimli/kitap/fenlisesikimya/11/unite3/files/basic-html/page13.html',
      ),
      FormulaItem(
        'pH Hesabı',
        'pH = −log[H⁺]',
        'Seyreltik sulu çözeltilerde derişim yaklaşımı; [H⁺] mol/L.',
        sourceLabel: 'MEB OGM Materyal · Fen Lisesi Kimya 11',
        sourceUrl:
            'https://ogmmateryal.eba.gov.tr/panel/upload/etkilesimli/kitap/fenlisesikimya/11/unite6/files/basic-html/page34.html',
      ),
      FormulaItem(
        'pOH Hesabı',
        'pOH = −log[OH⁻]',
        'Seyreltik sulu çözeltilerde derişim yaklaşımı; 25 °C\'de pH + pOH = pKw ≈ 14.',
        sourceLabel: 'MEB OGM Materyal · Kimya 11',
        sourceUrl:
            'https://ogmmateryal.eba.gov.tr/panel/upload/etkilesimli/kitap/beceri_temelli/11/kimya/files/basic-html/page121.html',
      ),
      FormulaItem(
        'Denge Sabiti',
        'Kc = [C]^c[D]^d / [A]^a[B]^b',
        'aA + bB ⇌ cC + dD. Üsler katsayıdır; saf katı ve sıvılar bağıntıya yazılmaz.',
        sourceLabel: 'MEB OGM Materyal · Kimya 11',
        sourceUrl:
            'https://ogmmateryal.eba.gov.tr/panel/upload/etkilesimli/kitap/beceri_temelli/11/kimya/files/basic-html/page111.html',
      ),
      FormulaItem(
        'Avogadro Sayısı',
        '1 mol ≈ 6,02 × 10²³ tanecik',
        'Tanecik türü; atom, molekül, iyon veya başka tanecik olabilir.',
        sourceLabel: 'MEB OGM Materyal · Kimya 10',
        sourceUrl:
            'https://ogmmateryal.eba.gov.tr/panel/upload/etkilesimli/kitap/defterim/10/kimya/files/basic-html/page25.html',
      ),
      FormulaItem(
        'Gibbs Serbest Enerjisi',
        'ΔG = ΔH − TΔS',
        'T sabit ve mutlak sıcaklık (K); G, H ve S aynı sistem değişimleridir.',
        sourceLabel: 'IUPAC Gold Book · Gibbs energy',
        sourceUrl: 'https://goldbook.iupac.org/terms/view/G02629',
      ),
      FormulaItem(
        'Tepkime Entalpisi',
        'ΔH°tepkime = ΣνΔH°f(ürün) − ΣνΔH°f(giren)',
        '25 °C ve 1 atm standart hâllerindeki molar oluşum entalpileri kullanılır; her terim tepkime katsayısıyla çarpılır.',
        sourceLabel: 'MEB OGM Materyal · Kimya 11',
        sourceUrl:
            'https://ogmmateryal.eba.gov.tr/panel/upload/etkilesimli/kitap/beceri_temelli/11/kimya/files/basic-html/page89.html',
      ),
    ],
    'Biyoloji': [
      FormulaItem(
        'Fotosentez',
        '6CO₂ + 6H₂O → C₆H₁₂O₆ + 6O₂',
        'Oksijenli fotosentezin net denklemi; ışık enerjisi ve pigment gerekir.',
        sourceLabel: 'MEB OGM Materyal · Biyoloji 12, s. 11',
        sourceUrl:
            'https://ogmmateryal.eba.gov.tr/panel/upload/etkilesimli/kitap/biyoloji/12/unite2/files/basic-html/page11.html',
      ),
      FormulaItem(
        'Oksijenli Solunum',
        'C₆H₁₂O₆ + 6O₂ → 6CO₂ + 6H₂O',
        'Genel net denklem; ATP üretilir ancak miktarı bu denklemde sabit bir katsayı değildir.',
        sourceLabel: 'MEB OGM Materyal · Biyoloji 12, Çalışma Defteri 5',
        sourceUrl:
            'https://ogmmateryal.eba.gov.tr/panel/upload/etkilesimli/kitap/calisma_defteri/f5/12/biyoloji/biyoloji.pdf',
      ),
      FormulaItem(
        'DNA Baz Eşleşmesi',
        'A–T ve G–C',
        'Çift iplikli DNA’da karşılıklı baz eşleşmesi: adenin-timin, guanin-sitozin.',
        sourceLabel: 'MEB OGM Materyal · Biyoloji 9, s. 54',
        sourceUrl:
            'https://ogmmateryal.eba.gov.tr/panel/upload/etkilesimli/kitap/biyoloji/9/unite1/files/basic-html/page54.html',
      ),
      FormulaItem(
        'Chargaff Kuralı',
        'A = T; G = C',
        'Çift iplikli DNA’da toplam baz sayıları eşittir; (A+T)/(G+C) oranı türe özgüdür.',
        sourceLabel: 'MEB OGM Materyal · Fen Lisesi Biyoloji 12, s. 10',
        sourceUrl:
            'https://ogmmateryal.eba.gov.tr/panel/upload/etkilesimli/kitap/fenlisesibiyoloji/12/unite1/files/basic-html/page10.html',
      ),
      FormulaItem(
        'Hardy–Weinberg',
        'p + q = 1; p² + 2pq + q² = 1',
        'İki alelli lokus; p ve q alel sıklığıdır. Denge varsayımları: büyük popülasyon, rastgele eşleşme, mutasyon/göç/doğal seçilim yok. YKS kapsamı ayrıca doğrulanmalı.',
        sourceLabel: 'OpenStax · Biology 2e, 19.1 Population Evolution',
        sourceUrl:
            'https://openstax.org/books/biology-2e/pages/19-1-population-evolution',
      ),
      FormulaItem(
        'Osmotik Basınç',
        'Π ≈ cRT',
        'Seyreltik ideal çözeltide; c osmotik etkin tanecik derişimi, T (K). R ve c birimleri tutarlı seçilmelidir.',
        sourceLabel: 'IUPAC Gold Book · Osmotic pressure',
        sourceUrl: 'https://goldbook.iupac.org/terms/view/O04344',
      ),
      FormulaItem(
        'Hücresel Solunumda ATP',
        'Glikoliz → Pirüvat oksidasyonu → Krebs döngüsü → ETS',
        'Oksijenli solunum basamakları; ATP verimi hücreye ve hesaplama modeline göre değişir.',
        sourceLabel: 'MEB OGM Materyal · Fen Lisesi Biyoloji 12, s. 26',
        sourceUrl:
            'https://ogmmateryal.eba.gov.tr/panel/upload/etkilesimli/kitap/fenlisesibiyoloji/12/unite2/files/basic-html/page26.html',
      ),
      FormulaItem(
        'Mitoz',
        'Profaz → Metafaz → Anafaz → Telofaz',
        'Diploit ana hücrede kromozom sayısı korunur (2n → 2n); sitokinezle, mutasyon olmadığı durumda iki genetik olarak aynı yavru hücre oluşur.',
        sourceLabel: 'MEB OGM Materyal · Biyoloji 10, s. 8',
        sourceUrl:
            'https://ogmmateryal.eba.gov.tr/panel/upload/etkilesimli/kitap/biyoloji/10/unite1/files/basic-html/page8.html',
      ),
    ],
  };

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final categories = _formulas.keys.toList();
    final totalFormulaCount = _formulas.values.fold<int>(
      0,
      (total, categoryFormulas) => total + categoryFormulas.length,
    );
    final categoryColors = [
      AppTheme.accentPurple,
      AppTheme.accentOrange,
      AppTheme.accentCyan,
      AppTheme.accentGreen,
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('Formül Kartları')),
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
                        if (selected) setState(() => _selectedCategory = cat);
                      },
                    ),
                  );
                }),
              ),
            ),
          ),
          const SizedBox(height: 12),

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
                'Başlangıç seçkisi: $totalFormulaCount formül. Matematik, Fizik, Kimya ve Biyolojiyle sınırlıdır; tam ders kapsamı ve kaynak denetimi değildir.',
                style: textTheme.bodySmall?.copyWith(
                  color: colors.onSurface,
                  fontSize: 11,
                  height: 1.35,
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),

          // Formula count
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                Text(
                  '${_formulas[_selectedCategory]!.length} formül',
                  style: textTheme.bodySmall?.copyWith(
                    color: colors.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),

          // Formula list
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _formulas[_selectedCategory]!.length,
              itemBuilder: (context, index) {
                final formula = _formulas[_selectedCategory]![index];
                final catIndex = categories.indexOf(_selectedCategory);
                final color = categoryColors[catIndex];
                return _buildFormulaCard(context, formula, color, index + 1);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFormulaCard(
    BuildContext context,
    FormulaItem formula,
    Color color,
    int number,
  ) {
    final colors = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: colors.surfaceContainerLow,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: colors.outlineVariant),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 28,
                height: 28,
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Center(
                  child: Text(
                    '$number',
                    style: TextStyle(
                      color: color,
                      fontWeight: FontWeight.w700,
                      fontSize: 12,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  formula.title,
                  style: textTheme.titleSmall?.copyWith(
                    color: colors.onSurface,
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: color.withValues(alpha: 0.2)),
            ),
            child: Text(
              formula.formula,
              style: TextStyle(
                color: colors.onSurface,
                fontWeight: FontWeight.w700,
                fontSize: 16,
                letterSpacing: 1,
              ),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            formula.description,
            style: textTheme.bodySmall?.copyWith(
              color: colors.onSurfaceVariant,
            ),
          ),
          if (formula.sourceLabel != null && formula.sourceUrl != null)
            Align(
              alignment: AlignmentDirectional.centerEnd,
              child: TextButton.icon(
                onPressed: () => _openSource(formula.sourceUrl!),
                icon: const Icon(Icons.open_in_new, size: 14),
                label: Text('Kaynak: ${formula.sourceLabel}'),
              ),
            ),
        ],
      ),
    );
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
}

class FormulaItem {
  final String title;
  final String formula;
  final String description;
  final String? sourceLabel;
  final String? sourceUrl;

  FormulaItem(
    this.title,
    this.formula,
    this.description, {
    this.sourceLabel,
    this.sourceUrl,
  });
}
