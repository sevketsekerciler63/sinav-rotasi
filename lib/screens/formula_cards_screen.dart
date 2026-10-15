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
        'Dik ucgenin iki dik kenari ve hipotenüs iliskisi',
      ),
      FormulaItem(
        'Ikinci Derece Denklem',
        'x = (-b \u00B1 \u221A(b\u00B2-4ac)) / 2a',
        'ax\u00B2 + bx + c = 0 denkleminin kokleri',
      ),
      FormulaItem(
        'Aritmetik Dizi Toplami',
        'Sn = n(a1 + an) / 2',
        'n: terim sayisi, a1: ilk terim, an: son terim',
      ),
      FormulaItem(
        'Geometrik Dizi Toplami',
        'Sn = a1(1 - r^n) / (1 - r)',
        'r: ortak oran, r \u2260 1',
      ),
      FormulaItem(
        'Permutasyon',
        'P(n,r) = n! / (n-r)!',
        'n eleman icinden r tanesinin siralamasi',
      ),
      FormulaItem(
        'Kombinasyon',
        'C(n,r) = n! / (r!(n-r)!)',
        'n eleman icinden r tanesinin secimi',
      ),
      FormulaItem(
        'Binom Acilimi',
        '(a+b)^n = \u03A3 C(n,k) a^(n-k) b^k',
        'k=0 dan n ye kadar',
      ),
      FormulaItem('Daire Alani', 'A = \u03C0r\u00B2', 'r: yaricap'),
      FormulaItem('Kure Hacmi', 'V = 4/3 \u03C0r\u00B3', 'r: yaricap'),
      FormulaItem(
        'Silindir Hacmi',
        'V = \u03C0r\u00B2h',
        'r: taban yaricapi, h: yukseklik',
      ),
      FormulaItem(
        'Koni Hacmi',
        'V = 1/3 \u03C0r\u00B2h',
        'r: taban yaricapi, h: yukseklik',
      ),
      FormulaItem(
        'Logaritma Kurali',
        'log_a(xy) = log_a(x) + log_a(y)',
        'Carpimin logaritmasi',
      ),
      FormulaItem('Turev Kural', 'd/dx [x^n] = nx^(n-1)', 'Kuvvet kurali'),
      FormulaItem(
        'Integral Kural',
        '\u222Bx^n dx = x^(n+1)/(n+1) + C',
        'n \u2260 -1',
      ),
    ],
    'Fizik': [
      FormulaItem('Newton 2. Yasa', 'F = m \u00D7 a', 'Kuvvet = Kutle x Ivme'),
      FormulaItem('Kinetik Enerji', 'Ek = 1/2 mv\u00B2', 'm: kutle, v: hiz'),
      FormulaItem(
        'Potansiyel Enerji',
        'Ep = mgh',
        'm: kutle, g: yercekimi, h: yukseklik',
      ),
      FormulaItem(
        'Is-Enerji',
        'W = F \u00D7 d \u00D7 cos\u03B8',
        'F: kuvvet, d: yer degistirme',
      ),
      FormulaItem('Hiz Formulu', 'v = v0 + at', 'Duzgun ivmeli hareket'),
      FormulaItem(
        'Yol Formulu',
        'x = v0t + 1/2at\u00B2',
        'Duzgun ivmeli hareket',
      ),
      FormulaItem(
        'Ohm Yasasi',
        'V = I \u00D7 R',
        'V: gerilim, I: akim, R: direnc',
      ),
      FormulaItem('Guc', 'P = W / t = F \u00D7 v', 'P: guc, W: is, t: zaman'),
      FormulaItem('Coulomb Yasasi', 'F = k(q1q2)/r\u00B2', 'Elektrik kuvveti'),
      FormulaItem(
        'Dalga Hizi',
        'v = f \u00D7 \u03BB',
        'f: frekans, \u03BB: dalga boyu',
      ),
      FormulaItem('Elastik PE', 'Ep = 1/2 kx\u00B2', 'k: yay sabiti, x: uzama'),
      FormulaItem('Moment', 'M = F \u00D7 d', 'Kuvvet kolunun momenti'),
    ],
    'Kimya': [
      FormulaItem(
        'Mol Hesabi',
        'n = m / M',
        'n: mol, m: kutle, M: mol kutlesi',
      ),
      FormulaItem('Ideal Gaz', 'PV = nRT', 'R = 0.082 L.atm/mol.K'),
      FormulaItem('Molarite', 'M = n / V(L)', 'Cozelti derismesi'),
      FormulaItem(
        'Molalite',
        'm = n / m_cozucu(kg)',
        'Cozucu kutlesi cinsinden',
      ),
      FormulaItem(
        'pH Hesabi',
        'pH = -log[H+]',
        '[H+]: hidrojen iyon derismesi',
      ),
      FormulaItem(
        'pOH Hesabi',
        'pOH = -log[OH-]',
        '25 °C\'de sulu çözeltilerde pH + pOH = pKw ≈ 14',
      ),
      FormulaItem(
        'Denge Sabiti',
        'Kc = [C]^c[D]^d / [A]^a[B]^b',
        'aA + bB ⇌ cC + dD. Üsler katsayıdır; saf katı ve sıvılar bağıntıya yazılmaz.',
        sourceLabel: 'MEB OGM Materyal · Kimya 11',
        sourceUrl:
            'https://ogmmateryal.eba.gov.tr/panel/upload/etkilesimli/kitap/beceri_temelli/11/kimya/files/basic-html/page111.html',
      ),
      FormulaItem('Avogadro', '1 mol = 6.022 x 10^23', 'Avogadro sayisi'),
      FormulaItem(
        'Gibbs Serbest Enerjisi',
        '\u0394G = \u0394H - T\u0394S',
        'Sabit sıcaklık ve basınçta; T mutlak sıcaklıktır.',
      ),
      FormulaItem(
        'Hessin Yasasi',
        '\u0394Hrxn = \u03A3\u0394Hf(urun) - \u03A3\u0394Hf(girent)',
        'Reaksiyon entalpisi',
      ),
    ],
    'Biyoloji': [
      FormulaItem(
        'Fotosentez',
        '6CO2 + 6H2O -> C6H12O6 + 6O2',
        'Isik enerjisi gerekir',
      ),
      FormulaItem(
        'Solunum',
        'C6H12O6 + 6O2 -> 6CO2 + 6H2O + ATP',
        'Hucrsel solunum',
      ),
      FormulaItem(
        'DNA Baz Eslesmesi',
        'A-T ve G-C',
        'Adenin=Timin, Guanin=Sitozin',
      ),
      FormulaItem('Chargaff Kurali', 'A = T, G = C', 'Baz esitligi'),
      FormulaItem(
        'Hardy-Weinberg',
        'p\u00B2 + 2pq + q\u00B2 = 1',
        'p + q = 1, populasyon genetigi',
      ),
      FormulaItem(
        'Osmotik Basinc',
        '\u03C0 = MRT',
        'M: molarite, R: gaz sabiti',
      ),
      FormulaItem(
        'Hücresel Solunumda ATP',
        'Glikoliz → Pirüvat oksidasyonu → Krebs → ETS',
        'ATP verimi hücreye ve kullanılan hesaplama modeline göre değişir; tek bir toplam sayı olarak ezberleme.',
      ),
      FormulaItem(
        'Mitoz',
        'Profaz->Metafaz->Anafaz->Telofaz',
        '2n -> 2n (eslesiksiz bolunme)',
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
