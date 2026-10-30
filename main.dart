import 'package:flutter/material.dart';

void main() => runApp(const NatcoMerchantApp());

const navy = Color(0xFF102A43);
const navy2 = Color(0xFF163E60);
const blue = Color(0xFF1769AA);
const teal = Color(0xFF14B8A6);
const pale = Color(0xFFF3F6FA);
const ink = Color(0xFF182B3A);
const muted = Color(0xFF718096);
const line = Color(0xFFE4EAF1);

class NatcoMerchantApp extends StatelessWidget {
  const NatcoMerchantApp({super.key});
  @override
  Widget build(BuildContext context) => MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'NATCO Merchant',
        theme: ThemeData(
          useMaterial3: true,
          scaffoldBackgroundColor: pale,
          colorScheme: ColorScheme.fromSeed(seedColor: blue, primary: blue, secondary: teal),
          fontFamily: 'Arial',
          appBarTheme: const AppBarTheme(backgroundColor: pale, foregroundColor: ink, elevation: 0, centerTitle: false),
          inputDecorationTheme: InputDecorationTheme(
            filled: true,
            fillColor: Colors.white,
            contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 16),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: const BorderSide(color: line)),
            enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: const BorderSide(color: line)),
            focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: const BorderSide(color: blue, width: 1.5)),
          ),
        ),
        builder: (context, child) => Directionality(textDirection: TextDirection.rtl, child: child ?? const SizedBox()),
        home: const AuthScreen(),
      );
}

class BrandMark extends StatelessWidget {
  final double size;
  const BrandMark({super.key, this.size = 54});
  @override
  Widget build(BuildContext context) => Container(
        width: size, height: size,
        decoration: BoxDecoration(
          gradient: const LinearGradient(colors: [Color(0xFF2387CA), Color(0xFF0D477B)], begin: Alignment.topRight, end: Alignment.bottomLeft),
          borderRadius: BorderRadius.circular(size * .28),
          boxShadow: [BoxShadow(color: blue.withOpacity(.2), blurRadius: 18, offset: const Offset(0, 7))],
        ),
        child: Center(child: Stack(alignment: Alignment.center, children: [
          Icon(Icons.shopping_bag_rounded, color: Colors.white, size: size * .54),
          Positioned(left: size * .16, top: size * .17, child: Container(width: size * .17, height: size * .17, decoration: const BoxDecoration(color: teal, shape: BoxShape.circle))),
        ])),
      );
}

class AuthScreen extends StatefulWidget { const AuthScreen({super.key}); @override State<AuthScreen> createState() => _AuthScreenState(); }
class _AuthScreenState extends State<AuthScreen> {
  bool login = true, hidePassword = true, hideConfirmPassword = true, acceptedTerms = false;
  String businessType = 'متجر تجزئة';
  final name = TextEditingController(), store = TextEditingController(), phone = TextEditingController(), email = TextEditingController(), password = TextEditingController(), confirmPassword = TextEditingController(), city = TextEditingController(), address = TextEditingController(), commercialNumber = TextEditingController();
  final formKey = GlobalKey<FormState>();
  @override void dispose() { name.dispose(); store.dispose(); phone.dispose(); email.dispose(); password.dispose(); confirmPassword.dispose(); city.dispose(); address.dispose(); commercialNumber.dispose(); super.dispose(); }
  String? requiredField(String? v) => v == null || v.trim().isEmpty ? 'هذا الحقل مطلوب' : null;
  String? validEmail(String? v) => v == null || !RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(v.trim()) ? 'أدخل بريدًا إلكترونيًا صحيحًا' : null;
  String? validPhone(String? v) => v == null || v.replaceAll(RegExp(r'[^0-9+]'), '').length < 7 ? 'أدخل رقم هاتف صحيحًا' : null;
  void submit() {
    if (!(formKey.currentState?.validate() ?? false)) return;
    if (!login && !acceptedTerms) { _toast(context, 'يرجى الموافقة على شروط الاستخدام وسياسة الخصوصية التجريبية.'); return; }
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => login ? const MerchantShell() : const PendingApprovalScreen()));
  }
  @override Widget build(BuildContext context) => Scaffold(body: SafeArea(child: Center(child: SingleChildScrollView(padding: const EdgeInsets.all(22), child: ConstrainedBox(constraints: const BoxConstraints(maxWidth: 480), child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
    const SizedBox(height: 12), Row(mainAxisAlignment: MainAxisAlignment.center, children: [const BrandMark(size: 60), const SizedBox(width: 14), const Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text('NATCO', style: TextStyle(fontSize: 29, fontWeight: FontWeight.w900, letterSpacing: 2, color: navy)), SizedBox(height: 3), Text('MERCHANT  •  بوابة التاجر', style: TextStyle(fontSize: 11, letterSpacing: .6, color: muted))])]),
    const SizedBox(height: 30), Container(padding: const EdgeInsets.all(5), decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: line)), child: Row(children: [Expanded(child: _tab('تسجيل الدخول', login, () => setState(() => login = true))), Expanded(child: _tab('إنشاء حساب', !login, () => setState(() => login = false)))])),
    const SizedBox(height: 25), Text(login ? 'مرحباً بعودتك 👋' : 'أنشئ حساب التاجر', style: const TextStyle(fontSize: 27, fontWeight: FontWeight.w900, color: navy)), const SizedBox(height: 8), Text(login ? 'كل أعمال متجرك في مكان واحد، بوضوح وسهولة.' : 'أكمل بياناتك التجارية لإرسال طلب انضمامك إلى شبكة NATCO.', style: const TextStyle(color: muted, height: 1.7)),
    if (!login) ...[const SizedBox(height: 18), Container(padding: const EdgeInsets.all(14), decoration: BoxDecoration(gradient: const LinearGradient(colors: [Color(0xFFEAF4FC), Color(0xFFF0FBF9)]), borderRadius: BorderRadius.circular(16), border: Border.all(color: const Color(0xFFD7EAF7))), child: const Row(crossAxisAlignment: CrossAxisAlignment.start, children: [Icon(Icons.verified_user_outlined, color: blue), SizedBox(width: 10), Expanded(child: Text('بعد إرسال الطلب، ستراجعه الشركة قبل تفعيل الحساب. هذه نسخة تجريبية ولا يتم إرسال البيانات إلى NATCO فعليًا.', style: TextStyle(color: navy, fontSize: 12, height: 1.7)))]))],
    const SizedBox(height: 20), Form(key: formKey, child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
      if (!login) ...[
        _sectionLabel('بيانات صاحب الحساب'), const SizedBox(height: 10),
        _field('الاسم الكامل لصاحب المتجر', name, Icons.person_outline_rounded, validator: requiredField, textCapitalization: TextCapitalization.words), const SizedBox(height: 12),
        _field('اسم النشاط التجاري', store, Icons.storefront_outlined, validator: requiredField), const SizedBox(height: 12),
        DropdownButtonFormField<String>(value: businessType, decoration: const InputDecoration(labelText: 'نوع النشاط التجاري', prefixIcon: Icon(Icons.business_outlined)), items: const ['متجر تجزئة', 'موزّع', 'تاجر جملة', 'شركة', 'نشاط آخر'].map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(), onChanged: (v) => setState(() => businessType = v ?? businessType)), const SizedBox(height: 12),
      ],
      _field(login ? 'رقم الهاتف أو البريد الإلكتروني' : 'رقم الهاتف للتواصل', phone, Icons.phone_iphone_rounded, validator: login ? requiredField : validPhone, keyboard: TextInputType.phone),
      if (!login) ...[const SizedBox(height: 12), _field('البريد الإلكتروني', email, Icons.mail_outline_rounded, keyboard: TextInputType.emailAddress, validator: validEmail), const SizedBox(height: 12), _field('المدينة', city, Icons.location_city_outlined, validator: requiredField), const SizedBox(height: 12), _field('عنوان المتجر أو موقع النشاط', address, Icons.location_on_outlined, validator: requiredField), const SizedBox(height: 12), _field('رقم السجل التجاري (اختياري)', commercialNumber, Icons.badge_outlined, keyboard: TextInputType.text)],
      const SizedBox(height: 12), TextFormField(controller: password, obscureText: hidePassword, validator: (v) => v == null || v.length < 8 ? 'استخدم كلمة مرور من 8 أحرف على الأقل' : null, decoration: InputDecoration(labelText: 'كلمة المرور', prefixIcon: const Icon(Icons.lock_outline_rounded), suffixIcon: IconButton(onPressed: () => setState(() => hidePassword = !hidePassword), icon: Icon(hidePassword ? Icons.visibility_outlined : Icons.visibility_off_outlined)))),
      if (!login) ...[const SizedBox(height: 12), TextFormField(controller: confirmPassword, obscureText: hideConfirmPassword, validator: (v) => v != password.text ? 'كلمتا المرور غير متطابقتين' : null, decoration: InputDecoration(labelText: 'تأكيد كلمة المرور', prefixIcon: const Icon(Icons.lock_reset_rounded), suffixIcon: IconButton(onPressed: () => setState(() => hideConfirmPassword = !hideConfirmPassword), icon: Icon(hideConfirmPassword ? Icons.visibility_outlined : Icons.visibility_off_outlined)))), const SizedBox(height: 8), CheckboxListTile(value: acceptedTerms, onChanged: (v) => setState(() => acceptedTerms = v ?? false), contentPadding: EdgeInsets.zero, controlAffinity: ListTileControlAffinity.leading, title: const Text('أوافق على شروط الاستخدام وسياسة الخصوصية التجريبية', style: TextStyle(fontSize: 12, height: 1.5, color: muted)), activeColor: blue)],
    ])),
    if (login) Align(alignment: Alignment.centerLeft, child: TextButton(onPressed: () => _toast(context, 'استعادة كلمة المرور غير مفعّلة في النسخة التجريبية.'), child: const Text('نسيت كلمة المرور؟'))),
    const SizedBox(height: 10), SizedBox(height: 56, child: FilledButton(onPressed: submit, style: FilledButton.styleFrom(backgroundColor: navy, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16))), child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [Text(login ? 'الدخول إلى لوحة التاجر' : 'إرسال طلب إنشاء الحساب', style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 15)), const SizedBox(width: 10), const Icon(Icons.arrow_back_rounded)]))),
    const SizedBox(height: 20), Container(padding: const EdgeInsets.all(14), decoration: BoxDecoration(color: const Color(0xFFF4F7FA), borderRadius: BorderRadius.circular(15), border: Border.all(color: line)), child: const Row(crossAxisAlignment: CrossAxisAlignment.start, children: [Icon(Icons.shield_outlined, color: blue), SizedBox(width: 10), Expanded(child: Text('حساب تجريبي: لا يتم تخزين بيانات التسجيل أو إرسالها إلى خادم. لا تستخدم كلمة مرورك الحقيقية.', style: TextStyle(color: navy, fontSize: 12, height: 1.7)))])),
    const SizedBox(height: 22), const Center(child: Text('NATCO  •  MERCHANT EXPERIENCE', style: TextStyle(color: muted, fontSize: 10, letterSpacing: 1))),
  ]))))));
  Widget _tab(String text, bool active, VoidCallback onTap) => InkWell(onTap: onTap, borderRadius: BorderRadius.circular(12), child: Container(padding: const EdgeInsets.symmetric(vertical: 14), decoration: BoxDecoration(color: active ? navy : Colors.transparent, borderRadius: BorderRadius.circular(12)), child: Text(text, textAlign: TextAlign.center, style: TextStyle(color: active ? Colors.white : muted, fontWeight: FontWeight.w800))));
  Widget _sectionLabel(String text) => Text(text, style: const TextStyle(color: navy, fontSize: 14, fontWeight: FontWeight.w900));
  Widget _field(String label, TextEditingController c, IconData icon, {String? Function(String?)? validator, TextInputType keyboard = TextInputType.text, TextCapitalization textCapitalization = TextCapitalization.none}) => TextFormField(controller: c, validator: validator, keyboardType: keyboard, textCapitalization: textCapitalization, decoration: InputDecoration(labelText: label, prefixIcon: Icon(icon)));
}
class PendingApprovalScreen extends StatelessWidget {
  const PendingApprovalScreen({super.key});
  @override
  Widget build(BuildContext context) => Scaffold(
        body: SafeArea(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(28),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const BrandMark(size: 76),
                  const SizedBox(height: 28),
                  Container(
                    width: 90,
                    height: 90,
                    decoration: BoxDecoration(color: const Color(0xFFFFF4DA), borderRadius: BorderRadius.circular(28)),
                    child: const Icon(Icons.hourglass_top_rounded, color: Color(0xFFD99217), size: 46),
                  ),
                  const SizedBox(height: 24),
                  const Text('تم تقديم طلبك بنجاح!', style: TextStyle(fontSize: 26, fontWeight: FontWeight.w900, color: navy)),
                  const SizedBox(height: 12),
                  const Text('شكرًا لانضمامك إلى NATCO. تم تسجيل طلبك للعرض فقط، وستظهر الموافقة من خلال الشركة عند ربط النظام الفعلي.', textAlign: TextAlign.center, style: TextStyle(color: muted, height: 1.9)),
                  const SizedBox(height: 26),
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton(
                      onPressed: () => Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (_) => const AuthScreen()), (_) => false),
                      child: const Text('العودة إلى تسجيل الدخول'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
}

class Product {
  final String id, name, category, sku, description;
  final int stock;
  final double price;
  final IconData icon;
  const Product(this.id, this.name, this.category, this.sku, this.description, this.stock, this.price, this.icon);
}
const demoProducts = <Product>[
  Product('P-101', 'هاتف ذكي X Pro', 'هواتف ذكية', 'NT-MOB-101', 'هاتف عملي بشاشة عالية الوضوح وأداء سريع للاستخدام اليومي والأعمال.', 12, 185000, Icons.phone_android_rounded),
  Product('P-102', 'سماعات لاسلكية Air', 'إكسسوارات', 'NT-AUD-102', 'سماعات لاسلكية بتصميم مريح وعلبة شحن صغيرة.', 36, 18500, Icons.headphones_rounded),
  Product('P-103', 'ساعة ذكية Active', 'أجهزة ذكية', 'NT-WAT-103', 'ساعة ذكية لمتابعة النشاط والتنبيهات اليومية.', 4, 45000, Icons.watch_rounded),
  Product('P-104', 'شاحن سريع 65 واط', 'إكسسوارات', 'NT-CHG-104', 'شاحن سريع متعدد الاستخدامات بتصميم مدمج.', 21, 9500, Icons.battery_charging_full_rounded),
  Product('P-105', 'حافظة حماية فاخرة', 'إكسسوارات', 'NT-ACC-105', 'حافظة حماية مرنة بحواف معززة ومظهر أنيق.', 58, 3500, Icons.smartphone_rounded),
  Product('P-106', 'جهاز لوحي Business', 'أجهزة لوحية', 'NT-TAB-106', 'جهاز لوحي مناسب للاجتماعات ومهام العمل اليومية.', 9, 132000, Icons.tablet_android_rounded),
  Product('P-107', 'سماعة رأس Studio', 'صوتيات', 'NT-AUD-107', 'سماعة رأس مريحة للاستخدام الطويل والمكالمات.', 16, 27500, Icons.headset_mic_rounded),
  Product('P-108', 'باور بنك 20000', 'إكسسوارات', 'NT-PWR-108', 'بطارية متنقلة بسعة كبيرة ومؤشرات للطاقة.', 7, 22000, Icons.battery_charging_full_rounded),
];

class DemoOrder {
  final String id, date, status, payment;
  final double total;
  final List<MapEntry<Product, int>> lines;
  DemoOrder(this.id, this.date, this.status, this.payment, this.total, this.lines);
}

class MerchantShell extends StatefulWidget { const MerchantShell({super.key}); @override State<MerchantShell> createState() => _MerchantShellState(); }
class _MerchantShellState extends State<MerchantShell> {
  int tab = 0;
  final Map<String, int> cart = {};
  final List<DemoOrder> orders = [
    DemoOrder('NT-24081', '٢٨ أكتوبر ٢٠٢٦', 'قيد التجهيز', 'الدفع عند الاستلام', 239000, [MapEntry(demoProducts[0], 1), MapEntry(demoProducts[3], 2)]),
    DemoOrder('NT-24066', '٢٥ أكتوبر ٢٠٢٦', 'تم الشحن', 'تحويل بنكي', 82000, [MapEntry(demoProducts[2], 1), MapEntry(demoProducts[1], 2)]),
    DemoOrder('NT-24012', '١٩ أكتوبر ٢٠٢٦', 'تم التسليم', 'الدفع عند الاستلام', 55000, [MapEntry(demoProducts[1], 1), MapEntry(demoProducts[4], 2)]),
  ];
  int get cartCount => cart.values.fold(0, (a, b) => a + b);
  double get cartTotal => cart.entries.fold(0, (sum, e) => sum + demoProducts.firstWhere((p) => p.id == e.key).price * e.value);
  void add(Product p, [int count = 1]) => setState(() => cart[p.id] = (cart[p.id] ?? 0) + count);
  void setQty(Product p, int qty) => setState(() { if (qty <= 0) { cart.remove(p.id); } else { cart[p.id] = qty; } });
  void placeOrder() {
    if (cart.isEmpty) return;
    final lines = cart.entries.map((e) => MapEntry(demoProducts.firstWhere((p) => p.id == e.key), e.value)).toList();
    setState(() { orders.insert(0, DemoOrder('NT-${25000 + orders.length * 17}', '٢٩ أكتوبر ٢٠٢٦', 'طلب جديد', 'الدفع عند الاستلام', cartTotal, lines)); cart.clear(); tab = 2; });
    _toast(context, 'تم إنشاء طلب تجريبي بنجاح');
  }
  @override Widget build(BuildContext context) {
    final pages = <Widget>[
      DashboardPage(orders: orders, cartCount: cartCount, onTab: (v) => setState(() => tab = v), onProduct: (p) => _productDetails(p)),
      CatalogPage(onAdd: add, onOpen: _productDetails),
      OrdersPage(orders: orders, onOpen: _orderDetails, onReorder: (o) { for (final e in o.lines) add(e.key, e.value); setState(() => tab = 3); _toast(context, 'تمت إضافة منتجات الطلب إلى السلة'); }),
      CartPage(cart: cart, onQty: setQty, total: cartTotal, onCheckout: placeOrder, onBrowse: () => setState(() => tab = 1)),
      AssistantPage(onSupport: () => _openSupport()),
      ProfilePage(onNavigate: (destination) => _openUtility(destination)),
    ];
    return Scaffold(
      body: SafeArea(child: IndexedStack(index: tab, children: pages)),
      bottomNavigationBar: NavigationBar(selectedIndex: tab, onDestinationSelected: (i) => setState(() => tab = i), backgroundColor: Colors.white, indicatorColor: const Color(0xFFDDEFFC), height: 70, destinations: [
        const NavigationDestination(icon: Icon(Icons.grid_view_rounded), label: 'الرئيسية'),
        const NavigationDestination(icon: Icon(Icons.widgets_outlined), label: 'الكتالوج'),
        const NavigationDestination(icon: Icon(Icons.receipt_long_outlined), label: 'الطلبات'),
        NavigationDestination(icon: _BadgeIcon(icon: Icons.shopping_bag_outlined, count: cartCount), label: 'السلة'),
        const NavigationDestination(icon: Icon(Icons.auto_awesome_outlined), label: 'المساعد'),
        const NavigationDestination(icon: Icon(Icons.person_outline_rounded), label: 'حسابي'),
      ]),
    );
  }
  void _productDetails(Product p) => Navigator.push(context, MaterialPageRoute(builder: (_) => ProductDetailsPage(product: p, onAdd: (q) { add(p, q); _toast(context, 'تمت إضافة ${p.name} إلى السلة'); })));
  void _orderDetails(DemoOrder o) => Navigator.push(context, MaterialPageRoute(builder: (_) => OrderDetailsPage(order: o, onReorder: () { for (final e in o.lines) add(e.key, e.value); Navigator.pop(context); setState(() => tab = 3); _toast(context, 'تمت إضافة الطلب إلى السلة'); })));
  void _openSupport() => Navigator.push(context, MaterialPageRoute(builder: (_) => const SupportCenterPage()));
  void _openUtility(String title) => Navigator.push(context, MaterialPageRoute(builder: (_) => UtilityPage(title: title)));
}

class _BadgeIcon extends StatelessWidget { final IconData icon; final int count; const _BadgeIcon({required this.icon, required this.count}); @override Widget build(BuildContext context) => Stack(clipBehavior: Clip.none, children: [Icon(icon), if (count > 0) Positioned(top: -7, right: -10, child: Container(padding: const EdgeInsets.all(4), constraints: const BoxConstraints(minWidth: 18, minHeight: 18), decoration: const BoxDecoration(color: Color(0xFFE24A4A), shape: BoxShape.circle), child: Text('$count', textAlign: TextAlign.center, style: const TextStyle(color: Colors.white, fontSize: 9, fontWeight: FontWeight.bold))))]); }

class PageFrame extends StatelessWidget {
  final String title, subtitle; final Widget child; final Widget? trailing;
  const PageFrame({super.key, required this.title, required this.subtitle, required this.child, this.trailing});
  @override Widget build(BuildContext context) => CustomScrollView(slivers: [SliverToBoxAdapter(child: Padding(padding: const EdgeInsets.fromLTRB(20, 18, 20, 22), child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [Row(children: [Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(title, style: const TextStyle(color: navy, fontWeight: FontWeight.w900, fontSize: 25)), const SizedBox(height: 5), Text(subtitle, style: const TextStyle(color: muted, fontSize: 12, height: 1.5))])), if (trailing != null) trailing!]), const SizedBox(height: 20), child]))) ]);
}

class DashboardPage extends StatelessWidget {
  final List<DemoOrder> orders; final int cartCount; final ValueChanged<int> onTab; final ValueChanged<Product> onProduct;
  const DashboardPage({super.key, required this.orders, required this.cartCount, required this.onTab, required this.onProduct});
  @override Widget build(BuildContext context) => PageFrame(title: 'صباح النشاط 👋', subtitle: 'إليك ملخص متجرك اليوم', trailing: IconButton(onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const NotificationsPage())), icon: const _NotificationBell()), child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
    Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(colors: [navy, Color(0xFF1769AA)], begin: Alignment.topRight, end: Alignment.bottomLeft),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [BoxShadow(color: navy.withOpacity(.14), blurRadius: 22, offset: const Offset(0, 10))],
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          Container(width: 44, height: 44, decoration: BoxDecoration(color: Colors.white.withOpacity(.13), borderRadius: BorderRadius.circular(14)), child: const Icon(Icons.storefront_rounded, color: Colors.white)),
          const SizedBox(width: 12),
          const Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text('متجر النخبة', style: TextStyle(color: Colors.white, fontSize: 17, fontWeight: FontWeight.w900)),
            SizedBox(height: 4),
            Text('حساب تاجر تجريبي  •  NT-00482', style: TextStyle(color: Colors.white70, fontSize: 10)),
          ])),
          const Icon(Icons.verified_rounded, color: Color(0xFF65E2C4)),
        ]),
        const SizedBox(height: 24),
        const Text('إجمالي مشترياتك هذا الشهر', style: TextStyle(color: Colors.white70, fontSize: 12)),
        const SizedBox(height: 7),
        const Text('١٬٢٨٤٬٥٠٠ ر.ي', style: TextStyle(color: Colors.white, fontSize: 29, fontWeight: FontWeight.w900)),
        const SizedBox(height: 15),
        Row(children: [
          const Icon(Icons.trending_up_rounded, color: Color(0xFF65E2C4), size: 18),
          const SizedBox(width: 5),
          const Text('12.8% ', style: TextStyle(color: Color(0xFF65E2C4), fontWeight: FontWeight.bold)),
          const Text('مقارنة بالشهر الماضي', style: TextStyle(color: Colors.white70, fontSize: 11)),
        ]),
      ]),
    ),
    const SizedBox(height: 17), Row(children: [Expanded(child: _metric('الطلبات النشطة', '${orders.where((o) => o.status != 'تم التسليم').length}', Icons.inventory_2_outlined, blue, () => onTab(2))), const SizedBox(width: 10), Expanded(child: _metric('في السلة', '$cartCount', Icons.shopping_bag_outlined, teal, () => onTab(3)))]), const SizedBox(height: 10), Row(children: [Expanded(child: _metric('منتجات متاحة', '${demoProducts.length}', Icons.widgets_outlined, const Color(0xFF8B5CF6), () => onTab(1))), const SizedBox(width: 10), Expanded(child: _metric('تحتاج إعادة طلب', '02', Icons.warning_amber_rounded, const Color(0xFFD99217), () => onTab(1)))]),
    const SizedBox(height: 24), _sectionTitle('إجراءات سريعة', 'كل ما تحتاجه بنقرة'), const SizedBox(height: 12), Row(children: [Expanded(child: _quickAction('تصفح المنتجات', Icons.grid_view_rounded, () => onTab(1))), const SizedBox(width: 10), Expanded(child: _quickAction('طلباتي', Icons.receipt_long_rounded, () => onTab(2))), const SizedBox(width: 10), Expanded(child: _quickAction('مساعد NATCO', Icons.auto_awesome_rounded, () => onTab(4)))]),
    const SizedBox(height: 24), _sectionTitle('منتجات مختارة', 'منتجات مقترحة لمتجرك'), const SizedBox(height: 12), SizedBox(height: 180, child: ListView.separated(scrollDirection: Axis.horizontal, itemCount: 4, separatorBuilder: (_, __) => const SizedBox(width: 10), itemBuilder: (_, i) => SizedBox(width: 155, child: ProductMiniCard(product: demoProducts[i], onTap: () => onProduct(demoProducts[i]))))),
    const SizedBox(height: 24), _sectionTitle('آخر الطلبات', 'تابع حالة طلباتك'), const SizedBox(height: 10), ...orders.take(2).map((o) => OrderSummaryCard(order: o, onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => OrderDetailsPage(order: o, onReorder: () => _toast(context, 'افتح سجل الطلبات لإعادة الطلب')))))),
    const SizedBox(height: 10), OutlinedButton(onPressed: () => onTab(2), child: const Text('عرض كل الطلبات')),
  ]));
}

Widget _metric(String title, String value, IconData icon, Color color, VoidCallback onTap) => InkWell(onTap: onTap, borderRadius: BorderRadius.circular(18), child: Container(padding: const EdgeInsets.all(15), decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(18), border: Border.all(color: line)), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Container(width: 38, height: 38, decoration: BoxDecoration(color: color.withOpacity(.1), borderRadius: BorderRadius.circular(12)), child: Icon(icon, color: color)), const SizedBox(height: 15), Text(value, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w900, color: navy)), const SizedBox(height: 4), Text(title, style: const TextStyle(color: muted, fontSize: 11))])));
Widget _sectionTitle(String title, String subtitle) => Row(children: [Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(title, style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w900, color: navy)), const SizedBox(height: 4), Text(subtitle, style: const TextStyle(fontSize: 11, color: muted))])), const Icon(Icons.arrow_back_ios_new_rounded, size: 14, color: muted)]);
Widget _quickAction(String title, IconData icon, VoidCallback onTap) => InkWell(onTap: onTap, borderRadius: BorderRadius.circular(16), child: Container(padding: const EdgeInsets.symmetric(vertical: 17, horizontal: 6), decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: line)), child: Column(children: [Icon(icon, color: blue, size: 25), const SizedBox(height: 9), Text(title, textAlign: TextAlign.center, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w800, color: navy))])));
class _NotificationBell extends StatelessWidget {
  const _NotificationBell();
  @override
  Widget build(BuildContext context) => Stack(children: [
        const Padding(padding: EdgeInsets.all(8), child: Icon(Icons.notifications_none_rounded, color: navy, size: 27)),
        Positioned(
          top: 5,
          left: 6,
          child: Container(
            width: 8,
            height: 8,
            decoration: const BoxDecoration(color: Color(0xFFE24A4A), shape: BoxShape.circle),
          ),
        ),
      ]);
}

class CatalogPage extends StatefulWidget { final void Function(Product) onOpen; final void Function(Product) onAdd; const CatalogPage({super.key, required this.onOpen, required this.onAdd}); @override State<CatalogPage> createState() => _CatalogPageState(); }
class _CatalogPageState extends State<CatalogPage> {
  String query = '', category = 'الكل'; final search = TextEditingController();
  @override void dispose() { search.dispose(); super.dispose(); }
  @override Widget build(BuildContext context) {
    final categories = ['الكل', ...demoProducts.map((p) => p.category).toSet()];
    final filtered = demoProducts.where((p) => (category == 'الكل' || p.category == category) && '${p.name} ${p.sku} ${p.category}'.toLowerCase().contains(query.toLowerCase())).toList();
    return PageFrame(title: 'كتالوج المنتجات', subtitle: 'اكتشف المنتجات والأسعار والكميات المتاحة', trailing: IconButton(onPressed: () => _toast(context, 'قائمة المقارنة تجريبية'), icon: const Icon(Icons.tune_rounded, color: blue)), child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [TextField(controller: search, onChanged: (v) => setState(() => query = v), decoration: const InputDecoration(hintText: 'ابحث بالاسم أو رقم المنتج...', prefixIcon: Icon(Icons.search_rounded), suffixIcon: Icon(Icons.qr_code_scanner_rounded))), const SizedBox(height: 15), SingleChildScrollView(scrollDirection: Axis.horizontal, child: Row(children: categories.map((c) => Padding(padding: const EdgeInsets.only(left: 8), child: ChoiceChip(label: Text(c), selected: category == c, onSelected: (_) => setState(() => category = c), selectedColor: const Color(0xFFDDEFFC), labelStyle: TextStyle(color: category == c ? navy : muted, fontWeight: FontWeight.w700)))).toList())), const SizedBox(height: 15), Row(children: [Text('${filtered.length} منتجات', style: const TextStyle(fontWeight: FontWeight.w900, color: navy)), const Spacer(), const Icon(Icons.sort_rounded, size: 18, color: muted), const SizedBox(width: 4), const Text('الأكثر صلة', style: TextStyle(color: muted, fontSize: 11))]), const SizedBox(height: 12), if (filtered.isEmpty) const Padding(padding: EdgeInsets.all(35), child: Text('لا توجد منتجات مطابقة لبحثك.', textAlign: TextAlign.center, style: TextStyle(color: muted))), ...filtered.map((p) => ProductListTile(product: p, onTap: () => widget.onOpen(p), onAdd: () { widget.onAdd(p); _toast(context, 'تمت إضافة المنتج إلى السلة'); }))]));
  }
}

class ProductListTile extends StatelessWidget { final Product product; final VoidCallback onTap, onAdd; const ProductListTile({super.key, required this.product, required this.onTap, required this.onAdd}); @override Widget build(BuildContext context) => InkWell(onTap: onTap, borderRadius: BorderRadius.circular(18), child: Container(margin: const EdgeInsets.only(bottom: 11), padding: const EdgeInsets.all(13), decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(18), border: Border.all(color: line)), child: Row(children: [ProductIcon(product: product, size: 66), const SizedBox(width: 12), Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(product.name, style: const TextStyle(fontWeight: FontWeight.w900, color: navy, fontSize: 13)), const SizedBox(height: 5), Text('${product.category}  •  ${product.sku}', style: const TextStyle(color: muted, fontSize: 10)), const SizedBox(height: 8), Text(_money(product.price), style: const TextStyle(fontSize: 14, color: blue, fontWeight: FontWeight.w900)), const SizedBox(height: 4), Text(product.stock < 6 ? 'المخزون منخفض: ${product.stock}' : 'متوفر: ${product.stock} قطعة', style: TextStyle(fontSize: 10, color: product.stock < 6 ? const Color(0xFFD99217) : teal, fontWeight: FontWeight.w700))])), const SizedBox(width: 5), IconButton.filledTonal(onPressed: onAdd, icon: const Icon(Icons.add_shopping_cart_rounded), tooltip: 'أضف للسلة')]))); }
class ProductMiniCard extends StatelessWidget { final Product product; final VoidCallback onTap; const ProductMiniCard({super.key, required this.product, required this.onTap}); @override Widget build(BuildContext context) => InkWell(onTap: onTap, borderRadius: BorderRadius.circular(17), child: Container(padding: const EdgeInsets.all(12), decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(17), border: Border.all(color: line)), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Expanded(child: Center(child: ProductIcon(product: product, size: 75))), const SizedBox(height: 8), Text(product.name, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(color: navy, fontWeight: FontWeight.w800, fontSize: 11)), const SizedBox(height: 5), Text(_money(product.price), style: const TextStyle(color: blue, fontWeight: FontWeight.w900, fontSize: 12))]))); }
class ProductIcon extends StatelessWidget { final Product product; final double size; const ProductIcon({super.key, required this.product, this.size = 70}); @override Widget build(BuildContext context) => Container(width: size, height: size, decoration: BoxDecoration(gradient: const LinearGradient(colors: [Color(0xFFEAF4FC), Color(0xFFF2F6FB)], begin: Alignment.topRight, end: Alignment.bottomLeft), borderRadius: BorderRadius.circular(size * .23)), child: Icon(product.icon, size: size * .48, color: blue)); }

class ProductDetailsPage extends StatefulWidget { final Product product; final void Function(int) onAdd; const ProductDetailsPage({super.key, required this.product, required this.onAdd}); @override State<ProductDetailsPage> createState() => _ProductDetailsPageState(); }
class _ProductDetailsPageState extends State<ProductDetailsPage> { int qty = 1; @override Widget build(BuildContext context) { final p = widget.product; return Scaffold(appBar: AppBar(title: const Text('تفاصيل المنتج')), body: ListView(padding: const EdgeInsets.all(20), children: [Container(height: 230, decoration: BoxDecoration(gradient: const LinearGradient(colors: [Color(0xFFE8F3FC), Colors.white]), borderRadius: BorderRadius.circular(26)), child: Center(child: ProductIcon(product: p, size: 145))), const SizedBox(height: 22), Row(children: [Expanded(child: Text(p.name, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w900, color: navy))), Container(padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7), decoration: BoxDecoration(color: const Color(0xFFE1F8F2), borderRadius: BorderRadius.circular(10)), child: const Text('متاح للطلب', style: TextStyle(color: Color(0xFF0B8D7A), fontSize: 10, fontWeight: FontWeight.bold)))]), const SizedBox(height: 7), Text('${p.category}  •  رمز المنتج: ${p.sku}', style: const TextStyle(color: muted, fontSize: 12)), const SizedBox(height: 16), Text(_money(p.price), style: const TextStyle(fontSize: 28, color: blue, fontWeight: FontWeight.w900)), const SizedBox(height: 22), const Text('وصف المنتج', style: TextStyle(color: navy, fontSize: 16, fontWeight: FontWeight.w900)), const SizedBox(height: 8), Text(p.description, style: const TextStyle(color: muted, height: 1.9)), const SizedBox(height: 20), _detailInfo(Icons.inventory_2_outlined, 'المخزون المتاح', '${p.stock} قطعة'), _detailInfo(Icons.local_shipping_outlined, 'التوريد', 'حسب توفر المخزون ومنطقة التوصيل'), _detailInfo(Icons.verified_outlined, 'الضمان', 'تختلف التغطية حسب المنتج'), const SizedBox(height: 25), Row(children: [const Text('الكمية', style: TextStyle(color: navy, fontWeight: FontWeight.w800)), const Spacer(), _qtyButton(Icons.remove, () => setState(() { if (qty > 1) qty--; })), Padding(padding: const EdgeInsets.symmetric(horizontal: 20), child: Text('$qty', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w900))), _qtyButton(Icons.add, () => setState(() { if (qty < p.stock) qty++; }))]), const SizedBox(height: 22), SizedBox(height: 54, child: FilledButton.icon(onPressed: p.stock == 0 ? null : () { widget.onAdd(qty); Navigator.pop(context); }, icon: const Icon(Icons.shopping_cart_checkout_rounded), label: Text('إضافة للسلة  •  ${_money(p.price * qty)}'), style: FilledButton.styleFrom(backgroundColor: navy, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)))))])); } }
Widget _detailInfo(IconData icon, String title, String value) => Padding(padding: const EdgeInsets.only(bottom: 12), child: Row(children: [Icon(icon, color: blue, size: 20), const SizedBox(width: 10), Text(title, style: const TextStyle(color: muted, fontSize: 12)), const Spacer(), Flexible(child: Text(value, textAlign: TextAlign.left, style: const TextStyle(color: navy, fontSize: 12, fontWeight: FontWeight.w700)))]));
Widget _qtyButton(IconData icon, VoidCallback onTap) => InkWell(onTap: onTap, borderRadius: BorderRadius.circular(10), child: Container(width: 36, height: 36, decoration: BoxDecoration(color: const Color(0xFFEAF4FC), borderRadius: BorderRadius.circular(10)), child: Icon(icon, color: blue, size: 18)));

class CartPage extends StatelessWidget {
  final Map<String, int> cart;
  final void Function(Product, int) onQty;
  final double total;
  final VoidCallback onCheckout, onBrowse;
  const CartPage({super.key, required this.cart, required this.onQty, required this.total, required this.onCheckout, required this.onBrowse});

  @override
  Widget build(BuildContext context) {
    final lines = cart.entries.map((e) => MapEntry(demoProducts.firstWhere((p) => p.id == e.key), e.value)).toList();
    final empty = Container(
      padding: const EdgeInsets.fromLTRB(20, 45, 20, 40),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(22)),
      child: Column(children: [
        Container(width: 90, height: 90, decoration: BoxDecoration(color: const Color(0xFFEAF4FC), borderRadius: BorderRadius.circular(28)), child: const Icon(Icons.shopping_bag_outlined, color: blue, size: 42)),
        const SizedBox(height: 18),
        const Text('سلتك فارغة حاليًا', style: TextStyle(color: navy, fontSize: 19, fontWeight: FontWeight.w900)),
        const SizedBox(height: 8),
        const Text('أضف المنتجات التي يحتاجها متجرك ثم أنشئ طلبًا تجريبيًا.', textAlign: TextAlign.center, style: TextStyle(color: muted, height: 1.7)),
        const SizedBox(height: 20),
        FilledButton.icon(onPressed: onBrowse, icon: const Icon(Icons.widgets_outlined), label: const Text('تصفح الكتالوج')),
      ]),
    );
    final content = Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
      Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)),
        child: Row(children: [
          const Icon(Icons.check_circle_outline_rounded, color: teal),
          const SizedBox(width: 9),
          Text('${lines.length} أصناف في السلة', style: const TextStyle(color: navy, fontWeight: FontWeight.w800)),
          const Spacer(),
          Text('${cart.values.fold(0, (a, b) => a + b)} قطعة', style: const TextStyle(color: muted, fontSize: 11)),
        ]),
      ),
      const SizedBox(height: 12),
      ...lines.map((e) => Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(13),
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(17), border: Border.all(color: line)),
        child: Row(children: [
          ProductIcon(product: e.key, size: 58),
          const SizedBox(width: 11),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(e.key.name, style: const TextStyle(color: navy, fontWeight: FontWeight.w900, fontSize: 12)),
            const SizedBox(height: 6),
            Text(_money(e.key.price), style: const TextStyle(color: blue, fontWeight: FontWeight.w900)),
            const SizedBox(height: 8),
            Row(children: [
              _qtyButton(Icons.remove, () => onQty(e.key, e.value - 1)),
              Padding(padding: const EdgeInsets.symmetric(horizontal: 14), child: Text('${e.value}', style: const TextStyle(fontWeight: FontWeight.w900))),
              _qtyButton(Icons.add, () => onQty(e.key, e.value + 1)),
            ]),
          ])),
          Text(_money(e.key.price * e.value), style: const TextStyle(color: navy, fontWeight: FontWeight.w900, fontSize: 11)),
        ]),
      )),
      const SizedBox(height: 8),
      Container(
        padding: const EdgeInsets.all(17),
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(18), border: Border.all(color: line)),
        child: Column(children: [
          _priceLine('المجموع الفرعي', _money(total)),
          const SizedBox(height: 11),
          _priceLine('رسوم التوصيل', 'تحدد لاحقًا'),
          const Divider(height: 25),
          _priceLine('الإجمالي التقديري', _money(total), bold: true),
        ]),
      ),
      const SizedBox(height: 12),
      Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(color: const Color(0xFFFFF5DF), borderRadius: BorderRadius.circular(13)),
        child: const Row(children: [
          Icon(Icons.info_outline_rounded, color: Color(0xFFB77913)),
          SizedBox(width: 8),
          Expanded(child: Text('هذا طلب تجريبي؛ لن يتم خصم أي مبلغ أو إرسال الطلب إلى الشركة.', style: TextStyle(color: Color(0xFF8A641C), fontSize: 11, height: 1.6))),
        ]),
      ),
      const SizedBox(height: 18),
      SizedBox(height: 54, child: FilledButton.icon(onPressed: onCheckout, icon: const Icon(Icons.receipt_long_rounded), label: const Text('إنشاء طلب تجريبي'), style: FilledButton.styleFrom(backgroundColor: navy, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15))))),
    ]);
    return PageFrame(title: 'سلة المشتريات', subtitle: 'راجع المنتجات والكميات قبل إنشاء الطلب', child: lines.isEmpty ? empty : content);
  }
}
Widget _priceLine(String label, String value, {bool bold = false}) => Row(children: [Text(label, style: TextStyle(color: bold ? navy : muted, fontWeight: bold ? FontWeight.w900 : FontWeight.normal)), const Spacer(), Text(value, style: TextStyle(color: bold ? blue : navy, fontWeight: bold ? FontWeight.w900 : FontWeight.w700, fontSize: bold ? 17 : 12))]);

class OrdersPage extends StatefulWidget { final List<DemoOrder> orders; final ValueChanged<DemoOrder> onOpen; final ValueChanged<DemoOrder> onReorder; const OrdersPage({super.key, required this.orders, required this.onOpen, required this.onReorder}); @override State<OrdersPage> createState() => _OrdersPageState(); }
class _OrdersPageState extends State<OrdersPage> { String filter = 'الكل'; final filters = ['الكل', 'طلب جديد', 'قيد التجهيز', 'تم الشحن', 'تم التسليم']; @override Widget build(BuildContext context) { final filtered = widget.orders.where((o) => filter == 'الكل' || o.status == filter).toList(); return PageFrame(title: 'الطلبات', subtitle: 'سجل الطلبات وحالات التوريد وإعادة الطلب', child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [Container(padding: const EdgeInsets.all(16), decoration: BoxDecoration(gradient: const LinearGradient(colors: [navy, navy2]), borderRadius: BorderRadius.circular(18)), child: Row(children: [const Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text('إجمالي الطلبات', style: TextStyle(color: Colors.white70, fontSize: 12)), SizedBox(height: 7), Text('سجل مشتريات متجرك', style: TextStyle(color: Colors.white, fontSize: 17, fontWeight: FontWeight.w900))])), Text('${widget.orders.length}', style: const TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.w900))])), const SizedBox(height: 15), SingleChildScrollView(scrollDirection: Axis.horizontal, child: Row(children: filters.map((f) => Padding(padding: const EdgeInsets.only(left: 7), child: ChoiceChip(label: Text(f), selected: filter == f, onSelected: (_) => setState(() => filter = f), selectedColor: const Color(0xFFDDEFFC)))).toList())), const SizedBox(height: 14), if (filtered.isEmpty) const Padding(padding: EdgeInsets.all(30), child: Text('لا توجد طلبات في هذه الحالة.', textAlign: TextAlign.center)), ...filtered.map((o) => OrderSummaryCard(order: o, onTap: () => widget.onOpen(o), onReorder: () => widget.onReorder(o))) ])); } }
class OrderSummaryCard extends StatelessWidget { final DemoOrder order; final VoidCallback onTap; final VoidCallback? onReorder; const OrderSummaryCard({super.key, required this.order, required this.onTap, this.onReorder}); @override Widget build(BuildContext context) { final color = _statusColor(order.status); return InkWell(onTap: onTap, borderRadius: BorderRadius.circular(17), child: Container(margin: const EdgeInsets.only(bottom: 11), padding: const EdgeInsets.all(15), decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(17), border: Border.all(color: line)), child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [Row(children: [Container(width: 40, height: 40, decoration: BoxDecoration(color: const Color(0xFFEAF4FC), borderRadius: BorderRadius.circular(12)), child: const Icon(Icons.receipt_long_rounded, color: blue)), const SizedBox(width: 10), Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text('طلب #${order.id}', style: const TextStyle(color: navy, fontWeight: FontWeight.w900)), const SizedBox(height: 4), Text(order.date, style: const TextStyle(color: muted, fontSize: 10))])), Container(padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 6), decoration: BoxDecoration(color: color.withOpacity(.1), borderRadius: BorderRadius.circular(8)), child: Text(order.status, style: TextStyle(color: color, fontSize: 10, fontWeight: FontWeight.w800)))]), const Divider(height: 24), Row(children: [Text('${order.lines.length} أصناف', style: const TextStyle(color: muted, fontSize: 11)), const Spacer(), Text(_money(order.total), style: const TextStyle(color: navy, fontWeight: FontWeight.w900, fontSize: 14))]), if (onReorder != null) Align(alignment: Alignment.centerLeft, child: TextButton.icon(onPressed: onReorder, icon: const Icon(Icons.replay_rounded, size: 17), label: const Text('إعادة الطلب'))) ]))); } }
class OrderDetailsPage extends StatelessWidget {
  final DemoOrder order;
  final VoidCallback onReorder;
  const OrderDetailsPage({super.key, required this.order, required this.onReorder});

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('تفاصيل الطلب')),
    body: ListView(padding: const EdgeInsets.all(20), children: [
      Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(gradient: const LinearGradient(colors: [navy, blue]), borderRadius: BorderRadius.circular(22)),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const Text('رقم الطلب', style: TextStyle(color: Colors.white70, fontSize: 12)),
          const SizedBox(height: 6),
          Text('#${order.id}', style: const TextStyle(color: Colors.white, fontSize: 25, fontWeight: FontWeight.w900)),
          const SizedBox(height: 14),
          Row(children: [
            const Icon(Icons.circle, color: Color(0xFF65E2C4), size: 10),
            const SizedBox(width: 7),
            Text(order.status, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w800)),
            const Spacer(),
            Text(order.date, style: const TextStyle(color: Colors.white70, fontSize: 10)),
          ]),
        ]),
      ),
      const SizedBox(height: 20),
      const Text('المنتجات المطلوبة', style: TextStyle(color: navy, fontSize: 17, fontWeight: FontWeight.w900)),
      const SizedBox(height: 12),
      ...order.lines.map((e) => Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(13),
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(15), border: Border.all(color: line)),
        child: Row(children: [
          ProductIcon(product: e.key, size: 55),
          const SizedBox(width: 12),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(e.key.name, style: const TextStyle(color: navy, fontWeight: FontWeight.w800)),
            const SizedBox(height: 5),
            Text('الكمية: ${e.value}', style: const TextStyle(color: muted, fontSize: 11)),
          ])),
          Text(_money(e.key.price * e.value), style: const TextStyle(color: blue, fontWeight: FontWeight.w900, fontSize: 12)),
        ]),
      )),
      const SizedBox(height: 10),
      Container(
        padding: const EdgeInsets.all(17),
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(17)),
        child: Column(children: [
          _priceLine('طريقة الدفع', order.payment),
          const SizedBox(height: 12),
          _priceLine('الشحن', 'حسب التوفر'),
          const Divider(height: 24),
          _priceLine('الإجمالي', _money(order.total), bold: true),
        ]),
      ),
      const SizedBox(height: 22),
      SizedBox(height: 52, child: FilledButton.icon(onPressed: onReorder, icon: const Icon(Icons.replay_rounded), label: const Text('إعادة الطلب'))),
    ]),
  );
}

class AssistantPage extends StatefulWidget { final VoidCallback onSupport; const AssistantPage({super.key, required this.onSupport}); @override State<AssistantPage> createState() => _AssistantPageState(); }
class _AssistantPageState extends State<AssistantPage> {
  final input = TextEditingController();
  final scroll = ScrollController();
  final List<Map<String, dynamic>> messages = [
    {'bot': true, 'text': 'أهلًا بك في مساعد NATCO الذكي 👋\nيمكنني مساعدتك في أسئلة المنتجات والطلبات وإدارة متجرك. ما الذي تريد معرفته؟'},
  ];

  @override
  void dispose() { input.dispose(); scroll.dispose(); super.dispose(); }

  void send([String? suggestion]) {
    final s = (suggestion ?? input.text).trim();
    if (s.isEmpty) return;
    setState(() {
      messages.add({'bot': false, 'text': s});
      messages.add({'bot': true, 'text': _answer(s)});
      input.clear();
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (scroll.hasClients) {
        scroll.animateTo(scroll.position.maxScrollExtent, duration: const Duration(milliseconds: 250), curve: Curves.easeOut);
      }
    });
  }

  String _answer(String s) {
    final q = s.toLowerCase();
    if (q.contains('طلب')) return 'يمكنك متابعة طلباتك من تبويب «الطلبات»، وفتح أي طلب لمراجعة الأصناف والحالة. إعادة الطلب تضيف المنتجات إلى السلة ولا ترسل طلبًا تلقائيًا.';
    if (q.contains('منتج') || q.contains('سعر') || q.contains('مخزون')) return 'افتح «الكتالوج» للبحث باسم المنتج أو رمزه، ثم افتح تفاصيله لمراجعة السعر والمخزون وإضافته إلى السلة.';
    if (q.contains('دفع') || q.contains('سداد')) return 'هذه نسخة عرض. تظهر طريقة الدفع التوضيحية في تفاصيل الطلب، ولا تتم أي عملية مالية فعلية.';
    if (q.contains('دعم') || q.contains('مشكلة')) return 'يمكنك فتح مركز الدعم التجريبي من الزر أدناه، وإنشاء تذكرة محلية للعرض دون إرسالها إلى الشركة.';
    return 'شكرًا لسؤالك. هذه واجهة مساعد تجريبية بإجابات إرشادية محلية وليست متصلة بنموذج ذكاء اصطناعي أو خادم NATCO. جرّب أحد الأسئلة المقترحة أو تواصل مع مركز الدعم.';
  }

  @override
  Widget build(BuildContext context) => PageFrame(
    title: 'مساعد NATCO',
    subtitle: 'مساعد إرشادي لتسهيل إدارة متجرك',
    child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
      Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(gradient: const LinearGradient(colors: [navy, blue]), borderRadius: BorderRadius.circular(20)),
        child: Row(children: [
          Container(width: 50, height: 50, decoration: BoxDecoration(color: Colors.white.withOpacity(.16), borderRadius: BorderRadius.circular(15)), child: const Icon(Icons.auto_awesome_rounded, color: Colors.white, size: 27)),
          const SizedBox(width: 12),
          const Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text('NATCO AI Assistant', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 15)),
            SizedBox(height: 5),
            Text('مساعد تجريبي • يعمل محليًا', style: TextStyle(color: Colors.white70, fontSize: 11)),
          ])),
          const Icon(Icons.circle, size: 9, color: Color(0xFF65E2C4)),
        ]),
      ),
      const SizedBox(height: 15),
      Wrap(spacing: 7, runSpacing: 7, children: ['كيف أتابع طلباتي؟', 'كيف أبحث عن منتج؟', 'كيف أطلب الدعم؟'].map((s) => ActionChip(
        label: Text(s, style: const TextStyle(fontSize: 10)),
        onPressed: () => send(s),
        avatar: const Icon(Icons.bolt_rounded, size: 15, color: blue),
        backgroundColor: Colors.white,
      )).toList()),
      const SizedBox(height: 13),
      Container(
        height: 330,
        padding: const EdgeInsets.all(13),
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(18), border: Border.all(color: line)),
        child: ListView(controller: scroll, children: messages.map((m) => Align(
          alignment: m['bot'] ? Alignment.centerRight : Alignment.centerLeft,
          child: Container(
            margin: const EdgeInsets.only(bottom: 10),
            padding: const EdgeInsets.all(12),
            constraints: const BoxConstraints(maxWidth: 290),
            decoration: BoxDecoration(color: m['bot'] ? const Color(0xFFEAF4FC) : navy, borderRadius: BorderRadius.circular(14)),
            child: Text(m['text'] as String, style: TextStyle(color: m['bot'] ? navy : Colors.white, fontSize: 12, height: 1.7)),
          ),
        )).toList()),
      ),
      const SizedBox(height: 12),
      Row(children: [
        Expanded(child: TextField(controller: input, onSubmitted: (_) => send(), decoration: const InputDecoration(hintText: 'اكتب سؤالك هنا...', prefixIcon: Icon(Icons.chat_bubble_outline_rounded)))),
        const SizedBox(width: 8),
        IconButton.filled(onPressed: send, style: IconButton.styleFrom(backgroundColor: navy), icon: const Icon(Icons.send_rounded)),
      ]),
      const SizedBox(height: 13),
      OutlinedButton.icon(onPressed: widget.onSupport, icon: const Icon(Icons.support_agent_rounded), label: const Text('فتح مركز الدعم'), style: OutlinedButton.styleFrom(padding: const EdgeInsets.all(15), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)))),
    ]),
  );
}

class SupportCenterPage extends StatefulWidget { const SupportCenterPage({super.key}); @override State<SupportCenterPage> createState() => _SupportCenterPageState(); }
class _SupportCenterPageState extends State<SupportCenterPage> {
  final subject = TextEditingController();
  final details = TextEditingController();
  String priority = 'عادي';
  final List<String> tickets = ['#SUP-1024  •  استفسار عن حالة طلب  •  مفتوحة'];

  @override
  void dispose() { subject.dispose(); details.dispose(); super.dispose(); }

  void createTicket() {
    if (subject.text.trim().isEmpty || details.text.trim().isEmpty) {
      _toast(context, 'أدخل عنوان المشكلة والتفاصيل');
      return;
    }
    setState(() {
      tickets.insert(0, '#SUP-${1025 + tickets.length}  •  ${subject.text.trim()}  •  قيد المراجعة ($priority)');
      subject.clear();
      details.clear();
    });
    _toast(context, 'تم إنشاء تذكرة محلية للعرض فقط');
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('مركز الدعم')),
    body: ListView(padding: const EdgeInsets.all(20), children: [
      Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(gradient: const LinearGradient(colors: [navy, blue]), borderRadius: BorderRadius.circular(20)),
        child: const Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Icon(Icons.support_agent_rounded, color: Colors.white, size: 34),
          SizedBox(height: 12),
          Text('كيف يمكننا مساعدتك؟', style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.w900)),
          SizedBox(height: 7),
          Text('أنشئ تذكرة تجريبية لمتابعة استفسارك.', style: TextStyle(color: Colors.white70, height: 1.6)),
        ]),
      ),
      const SizedBox(height: 20),
      const Text('تذكرة جديدة', style: TextStyle(color: navy, fontSize: 17, fontWeight: FontWeight.w900)),
      const SizedBox(height: 12),
      TextField(controller: subject, decoration: const InputDecoration(labelText: 'عنوان المشكلة', prefixIcon: Icon(Icons.subject_rounded))),
      const SizedBox(height: 12),
      TextField(controller: details, maxLines: 4, decoration: const InputDecoration(labelText: 'اشرح لنا ما تحتاجه', alignLabelWithHint: true)),
      const SizedBox(height: 12),
      DropdownButtonFormField<String>(
        value: priority,
        decoration: const InputDecoration(labelText: 'الأولوية'),
        items: const [DropdownMenuItem(value: 'عادي', child: Text('عادي')), DropdownMenuItem(value: 'مرتفع', child: Text('مرتفع'))],
        onChanged: (v) => setState(() => priority = v ?? 'عادي'),
      ),
      const SizedBox(height: 15),
      SizedBox(height: 50, child: FilledButton.icon(onPressed: createTicket, icon: const Icon(Icons.add_task_rounded), label: const Text('إنشاء تذكرة تجريبية'))),
      const SizedBox(height: 25),
      const Text('تذاكر الدعم', style: TextStyle(color: navy, fontSize: 17, fontWeight: FontWeight.w900)),
      const SizedBox(height: 10),
      ...tickets.map((t) => Container(
        margin: const EdgeInsets.only(bottom: 9),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(14), border: Border.all(color: line)),
        child: Row(children: [
          const Icon(Icons.confirmation_number_outlined, color: blue),
          const SizedBox(width: 10),
          Expanded(child: Text(t, style: const TextStyle(color: navy, fontSize: 12, height: 1.5, fontWeight: FontWeight.w700))),
        ]),
      )),
      const SizedBox(height: 12),
      const Text('تنبيه: التذاكر محفوظة داخل الواجهة أثناء الاستخدام فقط ولا تصل إلى فريق الدعم فعليًا.', style: TextStyle(color: muted, fontSize: 11, height: 1.7)),
    ]),
  );
}

class ProfilePage extends StatelessWidget { final ValueChanged<String> onNavigate; const ProfilePage({super.key, required this.onNavigate}); @override Widget build(BuildContext context) => PageFrame(title: 'حساب التاجر', subtitle: 'ملف متجرك وتفضيلات التجربة', child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [Container(padding: const EdgeInsets.all(22), decoration: BoxDecoration(gradient: const LinearGradient(colors: [navy, blue]), borderRadius: BorderRadius.circular(22)), child: Column(children: [Container(width: 76, height: 76, decoration: BoxDecoration(color: Colors.white.withOpacity(.15), borderRadius: BorderRadius.circular(24)), child: const Icon(Icons.storefront_rounded, color: Colors.white, size: 40)), const SizedBox(height: 13), const Text('متجر النخبة', style: TextStyle(color: Colors.white, fontSize: 21, fontWeight: FontWeight.w900)), const SizedBox(height: 5), const Text('NATCO Merchant ID: NT-00482', style: TextStyle(color: Colors.white70, fontSize: 11)), const SizedBox(height: 13), Container(padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7), decoration: BoxDecoration(color: const Color(0xFFDAF8F0), borderRadius: BorderRadius.circular(10)), child: const Text('حساب تجريبي نشط', style: TextStyle(color: Color(0xFF0B8D7A), fontWeight: FontWeight.w800, fontSize: 11)))])), const SizedBox(height: 19), const Text('إدارة الحساب', style: TextStyle(color: navy, fontSize: 17, fontWeight: FontWeight.w900)), const SizedBox(height: 10), _profileRow(context, Icons.store_mall_directory_outlined, 'معلومات المتجر', 'بيانات النشاط ووسائل التواصل', () => onNavigate('معلومات المتجر')), _profileRow(context, Icons.account_balance_wallet_outlined, 'المدفوعات والمستحقات', 'ملخص مالي تجريبي', () => onNavigate('المدفوعات والمستحقات')), _profileRow(context, Icons.notifications_none_rounded, 'الإشعارات', 'التنبيهات وتفضيلاتها', () => Navigator.push(context, MaterialPageRoute(builder: (_) => const NotificationsPage()))), _profileRow(context, Icons.support_agent_rounded, 'مركز الدعم', 'التذاكر والأسئلة الشائعة', () => Navigator.push(context, MaterialPageRoute(builder: (_) => const SupportCenterPage()))), _profileRow(context, Icons.settings_outlined, 'الإعدادات', 'اللغة والمظهر والخصوصية', () => Navigator.push(context, MaterialPageRoute(builder: (_) => const SettingsPage()))), const SizedBox(height: 14), SizedBox(height: 51, child: OutlinedButton.icon(onPressed: () => Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (_) => const AuthScreen()), (_) => false), icon: const Icon(Icons.logout_rounded, color: Colors.red), label: const Text('تسجيل الخروج', style: TextStyle(color: Colors.red)), style: OutlinedButton.styleFrom(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)))))])); }
Widget _profileRow(BuildContext context, IconData icon, String title, String sub, VoidCallback onTap) => Container(margin: const EdgeInsets.only(bottom: 9), decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(15), border: Border.all(color: line)), child: ListTile(leading: Container(width: 42, height: 42, decoration: BoxDecoration(color: const Color(0xFFEAF4FC), borderRadius: BorderRadius.circular(12)), child: Icon(icon, color: blue)), title: Text(title, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 13, color: navy)), subtitle: Text(sub, style: const TextStyle(fontSize: 10, color: muted)), trailing: const Icon(Icons.chevron_left_rounded, color: muted), onTap: onTap));

class NotificationsPage extends StatefulWidget { const NotificationsPage({super.key}); @override State<NotificationsPage> createState() => _NotificationsPageState(); }
class _NotificationsPageState extends State<NotificationsPage> {
  final notices = <Map<String, dynamic>>[
    {'title': 'تم تحديث حالة الطلب', 'body': 'طلب NT-24081 أصبح قيد التجهيز.', 'time': 'منذ ١٥ دقيقة', 'icon': Icons.local_shipping_outlined, 'read': false},
    {'title': 'منتج منخفض المخزون', 'body': 'مخزون الساعة الذكية Active منخفض.', 'time': 'منذ ساعتين', 'icon': Icons.inventory_2_outlined, 'read': false},
    {'title': 'مرحبًا بك في NATCO', 'body': 'اكتشف الكتالوج وأدِر طلباتك من مكان واحد.', 'time': 'أمس', 'icon': Icons.waving_hand_outlined, 'read': true},
  ];

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      title: const Text('الإشعارات'),
      actions: [TextButton(onPressed: () => setState(() { for (final n in notices) { n['read'] = true; } }), child: const Text('قراءة الكل'))],
    ),
    body: ListView(padding: const EdgeInsets.all(18), children: [
      Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(color: const Color(0xFFEAF4FC), borderRadius: BorderRadius.circular(16)),
        child: const Row(children: [
          Icon(Icons.notifications_active_outlined, color: blue, size: 25),
          SizedBox(width: 10),
          Expanded(child: Text('ابقَ على اطلاع بحالة الطلبات والتنبيهات المهمة.', style: TextStyle(color: navy, fontSize: 12, height: 1.6))),
        ]),
      ),
      const SizedBox(height: 15),
      ...notices.map((n) => InkWell(
        onTap: () => setState(() => n['read'] = true),
        child: Container(
          margin: const EdgeInsets.only(bottom: 10),
          padding: const EdgeInsets.all(15),
          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: line)),
          child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Container(width: 44, height: 44, decoration: BoxDecoration(color: const Color(0xFFEAF4FC), borderRadius: BorderRadius.circular(13)), child: Icon(n['icon'] as IconData, color: blue)),
            const SizedBox(width: 12),
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(n['title'] as String, style: const TextStyle(color: navy, fontWeight: FontWeight.w900, fontSize: 13)),
              const SizedBox(height: 6),
              Text(n['body'] as String, style: const TextStyle(color: muted, fontSize: 11, height: 1.6)),
              const SizedBox(height: 7),
              Text(n['time'] as String, style: const TextStyle(color: muted, fontSize: 10)),
            ])),
            if (!(n['read'] as bool)) Container(width: 8, height: 8, decoration: const BoxDecoration(color: blue, shape: BoxShape.circle)),
          ]),
        ),
      )),
      const SizedBox(height: 8),
      const Text('الإشعارات المعروضة تجريبية ولا تعتمد على خدمة إشعارات فعلية.', style: TextStyle(color: muted, fontSize: 11, height: 1.7)),
    ]),
  );
}

class SettingsPage extends StatefulWidget { const SettingsPage({super.key}); @override State<SettingsPage> createState() => _SettingsPageState(); }
class _SettingsPageState extends State<SettingsPage> {
  bool orderAlerts = true, stockAlerts = true, offers = false, biometric = false;
  String language = 'العربية';

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('الإعدادات')),
    body: ListView(padding: const EdgeInsets.all(20), children: [
      const Text('التفضيلات العامة', style: TextStyle(color: navy, fontSize: 17, fontWeight: FontWeight.w900)),
      const SizedBox(height: 10),
      Container(
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(17), border: Border.all(color: line)),
        child: Column(children: [
          _settingRow(Icons.language_rounded, 'لغة التطبيق', trailing: DropdownButton<String>(
            value: language,
            underline: const SizedBox(),
            items: const [DropdownMenuItem(value: 'العربية', child: Text('العربية')), DropdownMenuItem(value: 'English', child: Text('English'))],
            onChanged: (v) => setState(() => language = v ?? 'العربية'),
          )),
          const Divider(height: 1, indent: 16, endIndent: 16),
          _settingSwitch(Icons.notifications_active_outlined, 'تنبيهات الطلبات', orderAlerts, (v) => setState(() => orderAlerts = v)),
          const Divider(height: 1, indent: 16, endIndent: 16),
          _settingSwitch(Icons.inventory_2_outlined, 'تنبيهات المخزون', stockAlerts, (v) => setState(() => stockAlerts = v)),
          const Divider(height: 1, indent: 16, endIndent: 16),
          _settingSwitch(Icons.local_offer_outlined, 'العروض والتحديثات', offers, (v) => setState(() => offers = v)),
        ]),
      ),
      const SizedBox(height: 22),
      const Text('الأمان والخصوصية', style: TextStyle(color: navy, fontSize: 17, fontWeight: FontWeight.w900)),
      const SizedBox(height: 10),
      Container(
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(17), border: Border.all(color: line)),
        child: Column(children: [
          _settingSwitch(Icons.fingerprint_rounded, 'تسجيل دخول سريع (تجريبي)', biometric, (v) => setState(() => biometric = v)),
          const Divider(height: 1, indent: 16, endIndent: 16),
          ListTile(
            leading: const Icon(Icons.lock_outline_rounded, color: blue),
            title: const Text('سياسة الخصوصية', style: TextStyle(color: navy, fontWeight: FontWeight.w700, fontSize: 13)),
            subtitle: const Text('عرض توضيحي', style: TextStyle(color: muted, fontSize: 10)),
            trailing: const Icon(Icons.chevron_left_rounded),
            onTap: () => _infoDialog(context, 'الخصوصية', 'هذه نسخة تجريبية لا ترسل بياناتك إلى خادم. لا تستخدم بيانات حقيقية أو كلمات مرورك الفعلية.'),
          ),
        ]),
      ),
      const SizedBox(height: 20),
      Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(color: const Color(0xFFFFF5DF), borderRadius: BorderRadius.circular(14)),
        child: const Text('تغييرات الإعدادات محلية ومؤقتة، وستُعاد عند إغلاق التطبيق. يلزم ربط النظام بالخادم لحفظها.', style: TextStyle(color: Color(0xFF8A641C), fontSize: 11, height: 1.7)),
      ),
    ]),
  );
}
Widget _settingRow(IconData icon, String title, {required Widget trailing}) => Padding(padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 4), child: Row(children: [Icon(icon, color: blue), const SizedBox(width: 12), Expanded(child: Text(title, style: const TextStyle(color: navy, fontSize: 13, fontWeight: FontWeight.w700))), trailing]));
Widget _settingSwitch(IconData icon, String title, bool value, ValueChanged<bool> onChanged) => SwitchListTile(value: value, onChanged: onChanged, secondary: Icon(icon, color: blue), title: Text(title, style: const TextStyle(color: navy, fontSize: 13, fontWeight: FontWeight.w700)), activeColor: blue, dense: true);

class UtilityPage extends StatelessWidget {
  final String title;
  const UtilityPage({super.key, required this.title});

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: Text(title)),
    body: ListView(padding: const EdgeInsets.all(20), children: [
      Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20), border: Border.all(color: line)),
        child: Column(children: [
          Container(width: 70, height: 70, decoration: BoxDecoration(color: const Color(0xFFEAF4FC), borderRadius: BorderRadius.circular(22)), child: Icon(title == 'معلومات المتجر' ? Icons.storefront_rounded : Icons.account_balance_wallet_outlined, color: blue, size: 34)),
          const SizedBox(height: 14),
          Text(title, style: const TextStyle(color: navy, fontSize: 20, fontWeight: FontWeight.w900)),
          const SizedBox(height: 8),
          const Text('هذه شاشة توضيحية ضمن نموذج NATCO Merchant. البيانات هنا افتراضية وليست سجلات مالية أو تجارية حقيقية.', textAlign: TextAlign.center, style: TextStyle(color: muted, height: 1.8)),
          const SizedBox(height: 20),
          if (title == 'معلومات المتجر') ...[
            _infoLine('اسم المتجر', 'متجر النخبة'),
            _infoLine('رقم التاجر', 'NT-00482'),
            _infoLine('المدينة', 'صنعاء'),
            _infoLine('رقم التواصل', '+967 7XX XXX XXX'),
          ] else ...[
            _infoLine('الرصيد المستحق', '— ر.ي'),
            _infoLine('الفواتير المفتوحة', '—'),
            _infoLine('آخر تحديث', 'بيانات عرض فقط'),
          ],
        ]),
      ),
    ]),
  );
}
Widget _infoLine(String title, String value) => Padding(padding: const EdgeInsets.symmetric(vertical: 9), child: Row(children: [Text(title, style: const TextStyle(color: muted, fontSize: 12)), const Spacer(), Text(value, style: const TextStyle(color: navy, fontWeight: FontWeight.w800, fontSize: 12))]));

Color _statusColor(String status) { switch (status) { case 'تم التسليم': return const Color(0xFF0B927C); case 'تم الشحن': return const Color(0xFF1769AA); case 'قيد التجهيز': return const Color(0xFFB77913); default: return const Color(0xFF7C5CE7); } }
String _money(double value) => '${value.toStringAsFixed(0).replaceAllMapped(RegExp(r'\B(?=(\d{3})+(?!\d))'), (m) => '٬')} ر.ي';
void _toast(BuildContext context, String text) => ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text), behavior: SnackBarBehavior.floating, backgroundColor: navy));
void _infoDialog(BuildContext context, String title, String body) => showDialog<void>(context: context, builder: (ctx) => AlertDialog(title: Text(title), content: Text(body), actions: [TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('حسنًا'))]));
