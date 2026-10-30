import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

// ألوان الثيمات الديناميكية والهوية
class AppColors {
  static const Color navy = Color(0xFF07182B);
  static const Color navy2 = Color(0xFF0D2B49);
  static const Color blue = Color(0xFF1677FF);
  static const Color teal = Color(0xFF14B8A6);
  static const Color cyan = Color(0xFF43D5F5);
  static const Color bgLight = Color(0xFFF4F7FB);
  static const Color bgDark = Color(0xFF121822);
  static const Color cardDark = Color(0xFF1E293B);
  static const Color muted = Color(0xFF718198);
  static const Color line = Color(0xFFE4EAF1);
}

// إعدادات الثيم العالمي
ValueNotifier<bool> isDarkMode = ValueNotifier(false);
ValueNotifier<Color> primaryColorNotifier = ValueNotifier(AppColors.blue);

const apiBaseUrl = String.fromEnvironment(
  'AI_API_BASE_URL',
  defaultValue: 'https://site--natco-merchant-ai--mw6pjw7sw7wl.code.run',
);

void main() => runApp(const NatcoMerchantApp());

class NatcoMerchantApp extends StatelessWidget {
  const NatcoMerchantApp({super.key});

  @override
  Widget build(BuildContext context) => ValueListenableBuilder<bool>(
        valueListenable: isDarkMode,
        builder: (context, dark, _) => ValueListenableBuilder<Color>(
          valueListenable: primaryColorNotifier,
          builder: (context, primaryColor, _) => MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'NATCO Enterprise Merchant',
            theme: ThemeData(
              useMaterial3: true,
              fontFamily: 'Arial',
              brightness: dark ? Brightness.dark : Brightness.light,
              scaffoldBackgroundColor: dark ? AppColors.bgDark : AppColors.bgLight,
              colorScheme: ColorScheme.fromSeed(seedColor: primaryColor, brightness: dark ? Brightness.dark : Brightness.light),
            ),
            builder: (context, child) => Directionality(textDirection: TextDirection.rtl, child: child ?? const SizedBox()),
            home: const AuthScreen(),
          ),
        ),
      );
}

// علامة تجارية موحدة
class BrandMark extends StatelessWidget {
  final double size;
  const BrandMark({super.key, this.size = 54});
  @override
  Widget build(BuildContext context) => Container(
        width: size, height: size,
        decoration: BoxDecoration(
          gradient: LinearGradient(colors: [AppColors.cyan, primaryColorNotifier.value], begin: Alignment.topRight, end: Alignment.bottomLeft),
          borderRadius: BorderRadius.circular(size * .28),
          boxShadow: [BoxShadow(color: primaryColorNotifier.value.withOpacity(.2), blurRadius: 18, offset: const Offset(0, 7))],
        ),
        child: Center(child: Stack(alignment: Alignment.center, children: [
          Icon(Icons.storefront_rounded, color: Colors.white, size: size * .54),
          Positioned(left: size * .16, top: size * .17, child: Container(width: size * .17, height: size * .17, decoration: const BoxDecoration(color: AppColors.teal, shape: BoxShape.circle))),
        ])),
      );
}

// شاشة تسجيل الدخول المتقدمة
class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});
  @override
  State<AuthScreen> createState() => _AuthScreenState();
}
class _AuthScreenState extends State<AuthScreen> {
  bool login = true, hidePassword = true;
  final phone = TextEditingController(), password = TextEditingController(), store = TextEditingController();
  final formKey = GlobalKey<FormState>();

  @override
  void dispose() { phone.dispose(); password.dispose(); store.dispose(); super.dispose(); }

  void submit() {
    if (!(formKey.currentState?.validate() ?? false)) return;
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const MerchantShell()));
  }

  @override
  Widget build(BuildContext context) {
    final dark = isDarkMode.value;
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(22),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 480),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      BrandMark(size: 60),
                      SizedBox(width: 14),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('NATCO B2B', style: TextStyle(fontSize: 27, fontWeight: FontWeight.w900, letterSpacing: 1.5)),
                          SizedBox(height: 3),
                          Text('منصة التجار المعتمدة • اليمن', style: TextStyle(fontSize: 11, color: AppColors.muted)),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 30),
                  Text(login ? 'مرحباً بك أيها الشريك التجاري' : 'إنشاء حساب تاجر جديد', style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w900)),
                  const SizedBox(height: 8),
                  const Text('إدارة الطلبات، الائتمان، والمخزون بذكاء وسرعة.', style: TextStyle(color: AppColors.muted)),
                  const SizedBox(height: 25),
                  Form(
                    key: formKey,
                    child: Column(children: [
                      if (!login) ...[
                        TextFormField(controller: store, decoration: const InputDecoration(labelText: 'اسم النشاط التجاري / المعرض', prefixIcon: Icon(Icons.store)), validator: (v) => v!.isEmpty ? 'حقل مطلوب' : null),
                        const SizedBox(height: 14),
                      ],
                      TextFormField(controller: phone, keyboardType: TextInputType.phone, decoration: const InputDecoration(labelText: 'رقم الهاتف أو البريد', prefixIcon: Icon(Icons.phone)), validator: (v) => v!.isEmpty ? 'حقل مطلوب' : null),
                      const SizedBox(height: 14),
                      TextFormField(controller: password, obscureText: hidePassword, decoration: InputDecoration(labelText: 'كلمة المرور', prefixIcon: const Icon(Icons.lock), suffixIcon: IconButton(onPressed: () => setState(() => hidePassword = !hidePassword), icon: Icon(hidePassword ? Icons.visibility : Icons.visibility_off))), validator: (v) => v!.length < 6 ? 'قصيرة جداً' : null),
                    ]),
                  ),
                  const SizedBox(height: 24),
                  FilledButton(
                    onPressed: submit,
                    style: FilledButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 16), backgroundColor: primaryColorNotifier.value, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14))),
                    child: Text(login ? 'دخول لوحة التجار' : 'تسجيل وحفظ البيانات', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
                  ),
                  const SizedBox(height: 16),
                  TextButton(onPressed: () => setState(() => login = !login), child: Text(login ? 'ليس لديك حساب تجاري؟ سجل هنا' : 'لديك حساب بالفعل؟ سجل دخولك')),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// هيكل المنتجات والطلبات
class Product {
  final String id, name, sku, category;
  final double price, wholesalePrice;
  final int stock;
  final IconData icon;
  const Product(this.id, this.name, this.sku, this.category, this.price, this.wholesalePrice, this.stock, this.icon);
}

const demoProducts = <Product>[
  Product('P-1', 'شاشة ذكية 65 بوصة 4K', 'NT-TV-65', 'شاشات', 280000, 250000, 15, Icons.tv_rounded),
  Product('P-2', 'ثلاجة إنفرتر 18 قدم', 'NT-REF-18', 'أجهزة منزلية', 450000, 410000, 8, Icons.kitchen_rounded),
  Product('P-3', 'غسالة اتوماتيك 10 كيلو', 'NT-WM-10', 'أجهزة منزلية', 320000, 290000, 12, Icons.local_laundry_service_rounded),
  Product('P-4', 'مكيف هواء صحراوي ذكي', 'NT-AC-50', 'تكييف', 190000, 170000, 20, Icons.ac_unit_rounded),
];

class DemoOrder {
  final String id, date, status;
  final double total;
  final List<MapEntry<Product, int>> lines;
  DemoOrder(this.id, this.date, this.status, this.total, this.lines);
}

// الحاوية الرئيسية للتجار (Merchant Shell) مع التبويبات المتطورة
class MerchantShell extends StatefulWidget {
  const MerchantShell({super.key});
  @override
  State<MerchantShell> createState() => _MerchantShellState();
}

class _MerchantShellState extends State<MerchantShell> {
  int tab = 0;
  final Map<String, int> cart = {};
  final List<DemoOrder> orders = [
    DemoOrder('NT-B2B-902', '٢٩ أكتوبر ٢٠٢٦', 'قيد التجهيز في المخزن الرئيسي', 700000, [MapEntry(demoProducts[0], 2)]),
    DemoOrder('NT-B2B-881', '٢٥ أكتوبر ٢٠٢٦', 'تم التسليم بنجاح', 410000, [MapEntry(demoProducts[1], 1)]),
  ];

  int get cartCount => cart.values.fold(0, (a, b) => a + b);
  double get cartTotal => cart.entries.fold(0, (sum, e) => sum + demoProducts.firstWhere((p) => p.id == e.key).wholesalePrice * e.value);

  void add(Product p, [int count = 1]) => setState(() => cart[p.id] = (cart[p.id] ?? 0) + count);

  @override
  Widget build(BuildContext context) {
    final pages = <Widget>[
      AdvancedDashboard(orders: orders, onTabChange: (v) => setState(() => tab = v)),
      QuickOrderScanner(onAdd: add),
      OrdersTimelinePage(orders: orders),
      const SmartNotificationsPage(),
      const EnterpriseProfilePage(),
    ];

    return Scaffold(
      body: SafeArea(child: IndexedStack(index: tab, children: pages)),
      bottomNavigationBar: NavigationBar(
        selectedIndex: tab,
        onDestinationSelected: (i) => setState(() => tab = i),
        height: 68,
        destinations: [
          const NavigationDestination(icon: Icon(Icons.dashboard_rounded), label: 'الرئيسية'),
          const NavigationDestination(icon: Icon(Icons.qr_code_scanner_rounded), label: 'طلب سريع'),
          NavigationDestination(icon: Badge(label: Text('${orders.length}'), child: const Icon(Icons.local_shipping_rounded)), label: 'التتبع'),
          const NavigationDestination(icon: Badge(label: Text('3'), child: Icon(Icons.notifications_active_rounded)), label: 'التنبيهات'),
          const NavigationDestination(icon: Icon(Icons.settings_suggest_rounded), label: 'إعدادات النظام'),
        ],
      ),
    );
  }
}

// 1. لوحة مؤشرات التاجر اللحظية المتقدمة (Advanced Merchant Dashboard)
class AdvancedDashboard extends StatelessWidget {
  final List<DemoOrder> orders;
  final ValueChanged<int> onTabChange;
  const AdvancedDashboard({super.key, required this.orders, required this.onTabChange});

  @override
  Widget build(BuildContext context) {
    const double creditLimit = 5000000; // 5 مليون ريال ائتمان متاح
    const double usedCredit = 1110000;
    const double availableCredit = creditLimit - usedCredit;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.between,
            children: [
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('مرحباً، معرض النخبة التجاري', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900)),
                  SizedBox(height: 2),
                  Text('حساب تاجر معتمد • الفئة (أ)', style: TextStyle(fontSize: 12, color: AppColors.muted)),
                ],
              ),
              IconButton.filledTonal(onPressed: () => onTabChange(3), icon: const Icon(Icons.notifications_outlined)),
            ],
          ),
          const SizedBox(height: 20),
          // بطاقة الائتمان والحد المالي
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(colors: [primaryColorNotifier.value, AppColors.navy2], begin: Alignment.topRight, end: Alignment.bottomLeft),
              borderRadius: BorderRadius.circular(22),
              boxShadow: [BoxShadow(color: primaryColorNotifier.value.withOpacity(.3), blurRadius: 12, offset: const Offset(0, 6))],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(
                  mainAxisAlignment: MainAxisAlignment.between,
                  children: [
                    Text('الائتمان المتاح الممول للتاجر', style: TextStyle(color: Colors.white70, fontSize: 13)),
                    Icon(Icons.account_balance_wallet_rounded, color: Colors.white, size: 20),
                  ],
                ),
                const SizedBox(height: 10),
                Text('${availableCredit.toStringAsFixed(0)} ر.ي', style: const TextStyle(color: Colors.white, fontSize: 26, fontWeight: FontWeight.w900)),
                const SizedBox(height: 14),
                LinearProgressIndicator(value: usedCredit / creditLimit, backgroundColor: Colors.white24, color: AppColors.cyan, minHeight: 6),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.between,
                  children: [
                    Text('المستخدم: ${usedCredit.toStringAsFixed(0)} ر.ي', style: const TextStyle(color: Colors.white70, fontSize: 11)),
                    const Text('السقف: 5,000,000 ر.ي', style: TextStyle(color: Colors.white70, fontSize: 11)),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          // اختصارات إعادة الطلب السريع (One-Tap Reorder)
          const Text('المنتجات الأكثر طلباً (إعادة طلب سريع)', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),
          SizedBox(
            height: 145,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: demoProducts.length,
              separatorBuilder: (_, __) => const SizedBox(width: 12),
              itemBuilder: (context, i) {
                final p = demoProducts[i];
                return Container(
                  width: 140,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(color: Theme.of(context).cardColor, borderRadius: BorderRadius.circular(16), border: Border.all(color: AppColors.line)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(p.icon, color: primaryColorNotifier.value, size: 28),
                      const Spacer(),
                      Text(p.name, maxLines: 1, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                      Text('${p.wholesalePrice} ر.ي', style: TextStyle(color: primaryColorNotifier.value, fontSize: 11, fontWeight: FontWeight.w800)),
                      const SizedBox(height: 6),
                      SizedBox(
                        width: double.infinity,
                        height: 28,
                        child: OutlinedButton(
                          onPressed: () => ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('تمت إضافة ${p.name} للسلة بنجاح'))),
                          style: OutlinedButton.styleFrom(padding: EdgeInsets.zero),
                          child: const Text('طلب سريع', style: TextStyle(fontSize: 10)),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

// 2. واجهة الطلب السريع بالباركود والأكواد (Quick Order & Bulk Scanner)
class QuickOrderScanner extends StatefulWidget {
  final Function(Product) onAdd;
  const QuickOrderScanner({super.key, required this.onAdd});
  @override
  State<QuickOrderScanner> createState() => _QuickOrderScannerState();
}
class _QuickOrderScannerState extends State<QuickOrderScanner> {
  final skuController = TextEditingController();
  Product? foundProduct;

  void searchSku() {
    final query = skuController.text.trim().toUpperCase();
    setState(() {
      try {
        foundProduct = demoProducts.firstWhere((p) => p.sku.toUpperCase() == query || p.name.contains(query));
      } catch (_) {
        foundProduct = null;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text('الطلب الفوري بالباركود أو كود SKU', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900)),
          const SizedBox(height: 6),
          const Text('أدخل رمز المنتج المعتمد أو استخدم الكاميرا لمسح الباركود الخاص بقطع الجملة.', style: TextStyle(color: AppColors.muted, fontSize: 12)),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: skuController,
                  decoration: const InputDecoration(labelText: 'أدخل كود SKU (مثل NT-TV-65)', prefixIcon: Icon(Icons.qr_code)),
                  onSubmitted: (_) => searchSku(),
                ),
              ),
              const SizedBox(width: 10),
              FilledButton.icon(onPressed: searchSku, icon: const Icon(Icons.search), label: const Text('بحث')),
            ],
          ),
          const SizedBox(height: 25),
          if (foundProduct != null)
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Icon(foundProduct!.icon, size: 50, color: primaryColorNotifier.value),
                    const SizedBox(height: 10),
                    Text(foundProduct!.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    Text('الكود: ${foundProduct!.sku} | السعر: ${foundProduct!.wholesalePrice} ر.ي', style: const TextStyle(color: AppColors.muted)),
                    const SizedBox(height: 15),
                    FilledButton(
                      onPressed: () {
                        widget.onAdd(foundProduct!);
                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('تمت الإضافة الفورية للسلة')));
                      },
                      child: const Text('إضافة الكمية المعتمدة للسلة'),
                    ),
                  ],
                ),
              ),
            )
          else
            const Expanded(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.barcode_reader, size: 64, color: AppColors.muted),
                    SizedBox(height: 10),
                    Text('قم بإدخال الكود أو المسح الضوئي للبدء', style: TextStyle(color: AppColors.muted)),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}

// 3. واجهة تتبع الطلب التفاعلية (Live Order Tracking Timeline)
class OrdersTimelinePage extends StatelessWidget {
  final List<DemoOrder> orders;
  const OrdersTimelinePage({super.key, required this.orders});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text('سجل الطلبات وتتبع خط الإمداد', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900)),
          const SizedBox(height: 12),
          Expanded(
            child: ListView.builder(
              itemCount: orders.length,
              itemBuilder: (context, i) {
                final o = orders[i];
                return Card(
                  margin: const EdgeInsets.only(bottom: 14),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.between,
                          children: [
                            Text('طلب رقم: ${o.id}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                            Text('${o.total} ر.ي', style: TextStyle(color: primaryColorNotifier.value, fontWeight: FontWeight.w900)),
                          ],
                        ),
                        const SizedBox(height: 6),
                        Text('التاريخ: ${o.date}', style: const TextStyle(color: AppColors.muted, fontSize: 12)),
                        const Divider(height: 20),
                        Row(
                          children: [
                            const Icon(Icons.local_shipping_rounded, size: 18, color: AppColors.teal),
                            const SizedBox(width: 8),
                            Expanded(child: Text('الحالة: ${o.status}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13))),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: OutlinedButton.icon(
                            onPressed: () => ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('جاري تحميل فاتورة الطلب بصيغة PDF...'))),
                            icon: const Icon(Icons.picture_as_pdf, size: 16),
                            label: const Text('عرض الفاتورة'),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

// 4. مركز الإشعارات والتنبيهات المبوب (Smart Notification Center)
class SmartNotificationsPage extends StatelessWidget {
  const SmartNotificationsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('مركز التنبيهات الذكي'),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'الطلبات والشحن'),
              Tab(text: 'التنبيهات المالية'),
              Tab(text: 'عروض الجملة'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _notifList('تم تجهيز طلبك رقم NT-902 وسيتم الشحن خلال ساعتين.', 'منذ ساعتين', Icons.inventory_2),
            _notifList('تمت الموافقة على زيادة الحد الائتماني المؤقت لمتجرك.', 'أمس', Icons.account_balance),
            _notifList('عرض خاص على الشاشات الذكية، خصم إضافي 3% للكميات.', 'منذ 3 أيام', Icons.local_offer),
          ],
        ),
      ),
    );
  }

  Widget _notifList(String text, String time, IconData icon) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Card(
          child: ListTile(
            leading: Icon(icon, color: primaryColorNotifier.value),
            title: Text(text, style: const TextStyle(fontSize: 13, height: 1.4)),
            subtitle: Padding(padding: const EdgeInsets.only(top: 6), child: Text(time, style: const TextStyle(fontSize: 10, color: AppColors.muted))),
          ),
        ),
      ],
    );
  }
}

// 5. إعدادات النظام المتقدمة وتخصيص الثيمات (Enterprise Profile & Settings)
class EnterpriseProfilePage extends StatelessWidget {
  const EnterpriseProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(18),
      children: [
        const Text('إعدادات وتخصيص النظام', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900)),
        const SizedBox(height: 15),
        SwitchListTile(
          title: const Text('الوضع الليلي الحقيقي (مخصص للطاقة والمستودعات)'),
          value: isDarkMode.value,
          onChanged: (val) {
            isDarkMode.value = val;
            (context as Element).markNeedsBuild();
          },
        ),
        const Divider(),
        const Padding(
          padding: EdgeInsets.symmetric(vertical: 8),
          child: Text('اختر لون الهوية المؤسسية:', style: TextStyle(fontWeight: FontWeight.bold)),
        ),
        Row(
          children: [
            _colorOption(const Color(0xFF1677FF), 'أزرق نايل', context),
            _colorOption(const Color(0xFF0F766E), 'أخضر أعمال', context),
            _colorOption(const Color(0xFF475569), 'رمادي فاخر', context),
          ],
        ),
        const Divider(height: 30),
        ListTile(
          leading: const Icon(Icons.security),
          title: const Text('إدارة الأجهزة الموثوقة والجلسات النشطة'),
          subtitle: const Text('حماية أمنية لمعاملات الجملة B2B'),
          onTap: () => ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('جميع الجلسات مؤمنة ومشفرة'))),
        ),
        ListTile(
          leading: const Icon(Icons.logout, color: Colors.red),
          title: const Text('تسجيل الخروج', style: TextStyle(color: Colors.red)),
          onTap: () => Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const AuthScreen())),
        ),
      ],
    );
  }

  Widget _colorOption(Color color, String name, BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4),
        child: InkWell(
          onTap: () {
            primaryColorNotifier.value = color;
            (context as Element).markNeedsBuild();
          },
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(12)),
            child: Text(name, textAlign: TextAlign.center, style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold)),
          ),
        ),
      ),
    );
  }
}
