import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

// الألوان الهندسية الموحدة للتطبيق
const navy = Color(0xFF07182B);
const navy2 = Color(0xFF0D2B49);
const blue = Color(0xFF1677FF);
const teal = Color(0xFF14B8A6);
const cyan = Color(0xFF43D5F5);
const bg = Color(0xFFF4F7FB);
const muted = Color(0xFF718198);
const line = Color(0xFFE4EAF1);

// رابط الخادم الخاص بك المتصل بالذكاء الاصطناعي
const apiBaseUrl = String.fromEnvironment(
  'AI_API_BASE_URL',
  defaultValue: 'https://site--natco-merchant-ai--mw6pjw7sw7wl.code.run',
);

void main() => runApp(const NatcoMerchantApp());

class NatcoMerchantApp extends StatelessWidget {
  const NatcoMerchantApp({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'NATCO Merchant',
        theme: ThemeData(
          useMaterial3: true,
          fontFamily: 'Arial',
          scaffoldBackgroundColor: bg,
          colorScheme: ColorScheme.fromSeed(seedColor: blue, primary: blue, secondary: teal),
          inputDecorationTheme: InputDecorationTheme(
            filled: true,
            fillColor: Colors.white,
            contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 16),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
            enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: const BorderSide(color: line)),
            focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: const BorderSide(color: blue, width: 1.5)),
          ),
        ),
        builder: (context, child) => Directionality(textDirection: TextDirection.rtl, child: child ?? const SizedBox()),
        home: const AuthScreen(),
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
          gradient: const LinearGradient(colors: [cyan, blue], begin: Alignment.topRight, end: Alignment.bottomLeft),
          borderRadius: BorderRadius.circular(size * .28),
          boxShadow: [BoxShadow(color: blue.withOpacity(.2), blurRadius: 18, offset: const Offset(0, 7))],
        ),
        child: Center(child: Stack(alignment: Alignment.center, children: [
          Icon(Icons.shopping_bag_rounded, color: Colors.white, size: size * .54),
          Positioned(left: size * .16, top: size * .17, child: Container(width: size * .17, height: size * .17, decoration: const BoxDecoration(color: teal, shape: BoxShape.circle))),
        ])),
      );
}

// شاشة المصادقة وتسجيل الدخول
class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});
  @override
  State<AuthScreen> createState() => _AuthScreenState();
}
class _AuthScreenState extends State<AuthScreen> {
  bool login = true, hidePassword = true, hideConfirmPassword = true, acceptedTerms = false;
  String businessType = 'متجر تجزئة';
  final name = TextEditingController(), store = TextEditingController(), phone = TextEditingController(), email = TextEditingController(), password = TextEditingController(), confirmPassword = TextEditingController(), city = TextEditingController(), address = TextEditingController(), commercialNumber = TextEditingController();
  final formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    name.dispose(); store.dispose(); phone.dispose(); email.dispose(); password.dispose(); confirmPassword.dispose(); city.dispose(); address.dispose(); commercialNumber.dispose(); super.dispose();
  }

  String? requiredField(String? v) => v == null || v.trim().isEmpty ? 'هذا الحقل مطلوب' : null;
  String? validEmail(String? v) => v == null || !RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(v.trim()) ? 'أدخل بريدًا إلكترونيًا صحيحًا' : null;
  String? validPhone(String? v) => v == null || v.replaceAll(RegExp(r'[^0-9+]'), '').length < 7 ? 'أدخل رقم هاتف صحيحًا' : null;

  void submit() {
    if (!(formKey.currentState?.validate() ?? false)) return;
    if (!login && !acceptedTerms) {
      _toast(context, 'يرجى الموافقة على شروط الاستخدام وسياسة الخصوصية التجريبية.');
      return;
    }
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => login ? const MerchantShell() : const PendingApprovalScreen()));
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        body: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(22),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 480),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const BrandMark(size: 60),
                        const SizedBox(width: 14),
                        const Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('NATCO', style: TextStyle(fontSize: 29, fontWeight: FontWeight.w900, letterSpacing: 2, color: navy)),
                            SizedBox(height: 3),
                            Text('MERCHANT  •  بوابة التاجر', style: TextStyle(fontSize: 11, letterSpacing: .6, color: muted)),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 30),
                    Container(
                      padding: const EdgeInsets.all(5),
                      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: line)),
                      child: Row(children: [
                        Expanded(child: _tab('تسجيل الدخول', login, () => setState(() => login = true))),
                        Expanded(child: _tab('إنشاء حساب', !login, () => setState(() => login = false))),
                      ]),
                    ),
                    const SizedBox(height: 25),
                    Text(login ? 'مرحباً بعودتك 👋' : 'أنشئ حساب التاجر', style: const TextStyle(fontSize: 27, fontWeight: FontWeight.w900, color: navy)),
                    const SizedBox(height: 8),
                    Text(login ? 'كل أعمال متجرك في مكان واحد، بوضوح وسهولة.' : 'أكمل بياناتك التجارية لإرسال طلب انضمامك إلى شبكة NATCO.', style: const TextStyle(color: muted, height: 1.7)),
                    const SizedBox(height: 20),
                    Form(
                      key: formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          if (!login) ...[
                            _sectionLabel('بيانات صاحب الحساب'), const SizedBox(height: 10),
                            _field('الاسم الكامل لصاحب المتجر', name, Icons.person_outline_rounded, validator: requiredField), const SizedBox(height: 12),
                            _field('اسم النشاط التجاري', store, Icons.storefront_outlined, validator: requiredField), const SizedBox(height: 12),
                            DropdownButtonFormField<String>(
                              value: businessType,
                              decoration: const InputDecoration(labelText: 'نوع النشاط التجاري', prefixIcon: Icon(Icons.business_outlined)),
                              items: const ['متجر تجزئة', 'موزّع', 'تاجر جملة', 'شركة', 'نشاط آخر'].map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
                              onChanged: (v) => setState(() => businessType = v ?? businessType),
                            ),
                            const SizedBox(height: 12),
                          ],
                          _field(login ? 'رقم الهاتف أو البريد الإلكتروني' : 'رقم الهاتف للتواصل', phone, Icons.phone_iphone_rounded, validator: login ? requiredField : validPhone, keyboard: TextInputType.phone),
                          if (!login) ...[
                            const SizedBox(height: 12), _field('البريد الإلكتروني', email, Icons.mail_outline_rounded, keyboard: TextInputType.emailAddress, validator: validEmail),
                            const SizedBox(height: 12), _field('المدينة', city, Icons.location_city_outlined, validator: requiredField),
                            const SizedBox(height: 12), _field('عنوان المتجر أو موقع النشاط', address, Icons.location_on_outlined, validator: requiredField),
                          ],
                          const SizedBox(height: 12),
                          TextFormField(
                            controller: password,
                            obscureText: hidePassword,
                            validator: (v) => v == null || v.length < 8 ? 'استخدم كلمة مرور من 8 أحرف على الأقل' : null,
                            decoration: InputDecoration(
                              labelText: 'كلمة المرور',
                              prefixIcon: const Icon(Icons.lock_outline_rounded),
                              suffixIcon: IconButton(onPressed: () => setState(() => hidePassword = !hidePassword), icon: Icon(hidePassword ? Icons.visibility_outlined : Icons.visibility_off_outlined)),
                            ),
                          ),
                          if (!login) ...[
                            const SizedBox(height: 12),
                            TextFormField(
                              controller: confirmPassword,
                              obscureText: hideConfirmPassword,
                              validator: (v) => v != password.text ? 'كلمتا المرور غير متطابقتين' : null,
                              decoration: InputDecoration(
                                labelText: 'تأكيد كلمة المرور',
                                prefixIcon: const Icon(Icons.lock_reset_rounded),
                                suffixIcon: IconButton(onPressed: () => setState(() => hideConfirmPassword = !hideConfirmPassword), icon: Icon(hideConfirmPassword ? Icons.visibility_outlined : Icons.visibility_off_outlined)),
                              ),
                            ),
                            const SizedBox(height: 8),
                            CheckboxListTile(
                              value: acceptedTerms,
                              onChanged: (v) => setState(() => acceptedTerms = v ?? false),
                              contentPadding: EdgeInsets.zero,
                              controlAffinity: ListTileControlAffinity.leading,
                              title: const Text('أوافق على شروط الاستخدام وسياسة الخصوصية التجريبية', style: TextStyle(fontSize: 12, height: 1.5, color: muted)),
                              activeColor: blue,
                            ),
                          ],
                        ],
                      ),
                    ),
                    const SizedBox(height: 15),
                    SizedBox(
                      height: 56,
                      child: FilledButton(
                        onPressed: submit,
                        style: FilledButton.styleFrom(backgroundColor: navy, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16))),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(login ? 'الدخول إلى لوحة التاجر' : 'إرسال طلب إنشاء الحساب', style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 15)),
                            const SizedBox(width: 10),
                            const Icon(Icons.arrow_back_rounded),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ),
        ),
      );

  Widget _tab(String text, bool active, VoidCallback onTap) => InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 14),
          decoration: BoxDecoration(color: active ? navy : Colors.transparent, borderRadius: BorderRadius.circular(12)),
          child: Text(text, textAlign: TextAlign.center, style: TextStyle(color: active ? Colors.white : muted, fontWeight: FontWeight.w800)),
        ),
      );

  Widget _sectionLabel(String text) => Text(text, style: const TextStyle(color: navy, fontSize: 14, fontWeight: FontWeight.w900));
  Widget _field(String label, TextEditingController c, IconData icon, {String? Function(String?)? validator, TextInputType keyboard = TextInputType.text}) => TextFormField(
        controller: c,
        validator: validator,
        keyboardType: keyboard,
        decoration: InputDecoration(labelText: label, prefixIcon: Icon(icon)),
      );
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
                    width: 90, height: 90,
                    decoration: BoxDecoration(color: const Color(0xFFFFF4DA), borderRadius: BorderRadius.circular(28)),
                    child: const Icon(Icons.hourglass_top_rounded, color: Color(0xFFD99217), size: 46),
                  ),
                  const SizedBox(height: 24),
                  const Text('تم تقديم طلبك بنجاح!', style: TextStyle(fontSize: 26, fontWeight: FontWeight.w900, color: navy)),
                  const SizedBox(height: 12),
                  const Text('شكرًا لانضمامك إلى NATCO. تم تسجيل طلبك، وستظهر الموافقة من خلال الشركة عند ربط النظام الفعلي.', textAlign: TextAlign.center, style: TextStyle(color: muted, height: 1.9)),
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

// نموذج المنتجات والبيانات التجريبية
class Product {
  final String id, name, category, sku, description;
  final int stock;
  final double price;
  final IconData icon;
  const Product(this.id, this.name, this.category, this.sku, this.description, this.stock, this.price, this.icon);
}

const demoProducts = <Product>[
  Product('P-101', 'هاتف ذكي X Pro', 'هواتف ذكية', 'NT-MOB-101', 'هاتف عملي بشاشة عالية الوضوح وأداء سريع للاستخدام اليومي.', 12, 185000, Icons.phone_android_rounded),
  Product('P-102', 'سماعات لاسلكية Air', 'إكسسوارات', 'NT-AUD-102', 'سماعات لاسلكية بتصميم مريح وعلبة شحن صغيرة.', 36, 18500, Icons.headphones_rounded),
  Product('P-103', 'ساعة ذكية Active', 'أجهزة ذكية', 'NT-WAT-103', 'ساعة ذكية لمتابعة النشاط والتنبيهات اليومية.', 4, 45000, Icons.watch_rounded),
  Product('P-104', 'شاحن سريع 65 واط', 'إكسسوارات', 'NT-CHG-104', 'شاحن سريع متعدد الاستخدامات بتصميم مدمج.', 21, 9500, Icons.battery_charging_full_rounded),
  Product('P-105', 'حافظة حماية فاخرة', 'إكسسوارات', 'NT-ACC-105', 'حافظة حماية مرنة بحواف معززة ومظهر أنيق.', 58, 3500, Icons.smartphone_rounded),
  Product('P-106', 'جهاز لوحي Business', 'أجهزة لوحية', 'NT-TAB-106', 'جهاز لوحي مناسب للاجتماعات ومهام العمل.', 9, 132000, Icons.tablet_android_rounded),
];

class DemoOrder {
  final String id, date, status, payment;
  final double total;
  final List<MapEntry<Product, int>> lines;
  DemoOrder(this.id, this.date, this.status, this.payment, this.total, this.lines);
}

// واجهة التاجر الرئيسية المدمجة (مع تبويب الذكاء الاصطناعي الخادم الحقيقي)
class MerchantShell extends StatefulWidget {
  const MerchantShell({super.key});
  @override
  State<MerchantShell> createState() => _MerchantShellState();
}

class _MerchantShellState extends State<MerchantShell> {
  int tab = 0;
  final Map<String, int> cart = {};
  final List<DemoOrder> orders = [
    DemoOrder('NT-24081', '٢٨ أكتوبر ٢٠٢٦', 'قيد التجهيز', 'الدفع عند الاستلام', 239000, [MapEntry(demoProducts[0], 1), MapEntry(demoProducts[3], 2)]),
    DemoOrder('NT-24066', '٢٥ أكتوبر ٢٠٢٦', 'تم الشحن', 'تحويل بنكي', 82000, [MapEntry(demoProducts[2], 1), MapEntry(demoProducts[1], 2)]),
  ];

  int get cartCount => cart.values.fold(0, (a, b) => a + b);
  double get cartTotal => cart.entries.fold(0, (sum, e) => sum + demoProducts.firstWhere((p) => p.id == e.key).price * e.value);

  void add(Product p, [int count = 1]) => setState(() => cart[p.id] = (cart[p.id] ?? 0) + count);
  void setQty(Product p, int qty) => setState(() { if (qty <= 0) { cart.remove(p.id); } else { cart[p.id] = qty; } });

  void placeOrder() {
    if (cart.isEmpty) return;
    final lines = cart.entries.map((e) => MapEntry(demoProducts.firstWhere((p) => p.id == e.key), e.value)).toList();
    setState(() {
      orders.insert(0, DemoOrder('NT-${25000 + orders.length * 17}', '٢٩ أكتوبر ٢٠٢٦', 'طلب جديد', 'الدفع عند الاستلام', cartTotal, lines));
      cart.clear();
      tab = 2;
    });
    _toast(context, 'تم إنشاء طلب تجريبي بنجاح');
  }

  @override
  Widget build(BuildContext context) {
    final pages = <Widget>[
      DashboardPage(orders: orders, cartCount: cartCount, onTab: (v) => setState(() => tab = v), onProduct: (p) => _productDetails(p)),
      CatalogPage(onAdd: add, onOpen: _productDetails),
      OrdersPage(orders: orders, onOpen: _orderDetails, onReorder: (o) { for (final e in o.lines) add(e.key, e.value); setState(() => tab = 3); _toast(context, 'تمت إضافة المنتجات للسلة'); }),
      CartPage(cart: cart, onQty: setQty, total: cartTotal, onCheckout: placeOrder, onBrowse: () => setState(() => tab = 1)),
      const AiChatScreenTab(), // تبويب مساعد الذكاء الاصطناعي الحقيقي المتصل بالخادم الخاص بك
      ProfilePage(onNavigate: (destination) => _openUtility(destination)),
    ];

    return Scaffold(
      body: SafeArea(child: IndexedStack(index: tab, children: pages)),
      bottomNavigationBar: NavigationBar(
        selectedIndex: tab,
        onDestinationSelected: (i) => setState(() => tab = i),
        backgroundColor: Colors.white,
        indicatorColor: const Color(0xFFDDEFFC),
        height: 70,
        destinations: [
          const NavigationDestination(icon: Icon(Icons.grid_view_rounded), label: 'الرئيسية'),
          const NavigationDestination(icon: Icon(Icons.widgets_outlined), label: 'الكتالوج'),
          const NavigationDestination(icon: Icon(Icons.receipt_long_outlined), label: 'الطلبات'),
          NavigationDestination(icon: _BadgeIcon(icon: Icon(Icons.shopping_bag_outlined).icon, count: cartCount), label: 'السلة'),
          const NavigationDestination(icon: Icon(Icons.auto_awesome_rounded), label: 'المساعد الذكي'),
          const NavigationDestination(icon: Icon(Icons.person_outline_rounded), label: 'حسابي'),
        ],
      ),
    );
  }

  void _productDetails(Product p) => Navigator.push(context, MaterialPageRoute(builder: (_) => ProductDetailsPage(product: p, onAdd: (q) { add(p, q); _toast(context, 'تمت إضافة ${p.name} للسلة'); })));
  void _orderDetails(DemoOrder o) => Navigator.push(context, MaterialPageRoute(builder: (_) => OrderDetailsPage(order: o, onReorder: () { for (final e in o.lines) add(e.key, e.value); Navigator.pop(context); setState(() => tab = 3); })));
  void _openUtility(String title) => Navigator.push(context, MaterialPageRoute(builder: (_) => UtilityPage(title: title)));
}

// شاشة مساعد الذكاء الاصطناعي الذكي (متصلة بالخادم الحقيقي عبر API)
class AiChatScreenTab extends StatefulWidget {
  const AiChatScreenTab({super.key});
  @override
  State<AiChatScreenTab> createState() => _AiChatScreenTabState();
}

class ChatMessage {
  final String text;
  final bool fromUser;
  const ChatMessage(this.text, {required this.fromUser});
}

class _AiChatScreenTabState extends State<AiChatScreenTab> {
  final controller = TextEditingController();
  final scroll = ScrollController();
  final messages = <ChatMessage>[];
  bool busy = false;
  String? error;

  @override
  void dispose() { controller.dispose(); scroll.dispose(); super.dispose(); }

  Future<void> send([String? preset]) async {
    final text = (preset ?? controller.text).trim();
    if (text.isEmpty || busy) return;
    controller.clear();
    setState(() { messages.add(ChatMessage(text, fromUser: true)); busy = true; error = null; });
    _toBottom();
    try {
      final response = await http.post(
        Uri.parse('$apiBaseUrl/api/chat'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'message': text,
          'history': messages.take(messages.length - 1).map((m) => {'role': m.fromUser ? 'user' : 'assistant', 'content': m.text}).toList()
        }),
      ).timeout(const Duration(seconds: 75));

      final data = jsonDecode(response.body);
      if (response.statusCode < 200 || response.statusCode >= 300) {
        throw Exception(data is Map ? (data['error'] ?? 'تعذّر الاتصال بخدمة الذكاء الاصطناعي.') : 'تعذّر الاتصال.');
      }
      final answer = (data['reply'] ?? '').toString().trim();
      if (answer.isEmpty) throw Exception('وصل رد فارغ من خدمة الذكاء الاصطناعي.');
      if (mounted) setState(() => messages.add(ChatMessage(answer, fromUser: false)));
    } catch (e) {
      if (mounted) setState(() => error = _friendlyError(e));
    } finally {
      if (mounted) setState(() => busy = false);
      _toBottom();
    }
  }

  String _friendlyError(Object e) {
    final s = e.toString();
    if (s.contains('SocketException') || s.contains('Failed host lookup') || s.contains('Connection refused')) {
      return 'لم أستطع الوصول إلى خادم الذكاء الاصطناعي. تأكد من اتصال الإنترنت.';
    }
    if (s.contains('TimeoutException')) return 'استغرق الرد وقتًا أطول من المتوقع. حاول مجددًا.';
    return s.replaceFirst('Exception: ', '');
  }

  void _toBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (scroll.hasClients) scroll.animateTo(scroll.position.maxScrollExtent + 160, duration: const Duration(milliseconds: 280), curve: Curves.easeOut);
    });
  }

  @override
  Widget build(BuildContext context) => Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(20, 18, 20, 24),
            decoration: const BoxDecoration(
              gradient: LinearGradient(begin: Alignment.topRight, end: Alignment.bottomLeft, colors: [navy, navy2]),
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(28)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 42, height: 42,
                      decoration: BoxDecoration(gradient: const LinearGradient(colors: [cyan, blue]), borderRadius: BorderRadius.circular(14)),
                      child: const Icon(Icons.auto_awesome_rounded, color: navy, size: 25),
                    ),
                    const SizedBox(width: 12),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('NATCO AI', style: TextStyle(fontWeight: FontWeight.w900, letterSpacing: 1.3, fontSize: 17, color: Colors.white)),
                          Text('مساعد التاجر الذكي المتصل بالخادم', style: TextStyle(fontSize: 12, color: Color(0xFFBBD5EA))),
                        ],
                      ),
                    ),
                    IconButton(
                      tooltip: 'محادثة جديدة',
                      onPressed: busy ? null : () => setState(() { messages.clear(); error = null; }),
                      icon: const Icon(Icons.add_comment_outlined, color: Colors.white),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child: messages.isEmpty ? _welcome() : ListView.builder(
              controller: scroll,
              padding: const EdgeInsets.fromLTRB(16, 20, 16, 16),
              itemCount: messages.length + (busy ? 1 : 0),
              itemBuilder: (context, i) {
                if (i == messages.length) return const _TypingBubble();
                return _MessageBubble(message: messages[i]);
              },
            ),
          ),
          if (error != null)
            Container(
              margin: const EdgeInsets.fromLTRB(14, 0, 14, 8),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(color: const Color(0xFFFFF1F0), borderRadius: BorderRadius.circular(14), border: Border.all(color: const Color(0xFFFFD5D1))),
              child: Row(children: [
                const Icon(Icons.error_outline, color: Color(0xFFC43D32)),
                const SizedBox(width: 9),
                Expanded(child: Text(error!, style: const TextStyle(color: Color(0xFF8D3029), fontSize: 12, height: 1.5))),
                IconButton(onPressed: () => send(messages.isNotEmpty && messages.last.fromUser ? messages.last.text : null), icon: const Icon(Icons.refresh_rounded, color: Color(0xFFC43D32))),
              ]),
            ),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: const BoxDecoration(color: Colors.white, boxShadow: [BoxShadow(color: Color(0x1007182B), blurRadius: 18, offset: Offset(0, -4))]),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Expanded(
                  child: TextField(
                    controller: controller,
                    minLines: 1,
                    maxLines: 4,
                    textInputAction: TextInputAction.send,
                    onSubmitted: (_) => send(),
                    decoration: const InputDecoration(hintText: 'اسأل مساعد التاجر الذكي...', prefixIcon: Icon(Icons.chat_bubble_outline_rounded, color: muted, size: 21)),
                  ),
                ),
                const SizedBox(width: 9),
                Container(
                  height: 52, width: 52,
                  decoration: BoxDecoration(gradient: const LinearGradient(colors: [blue, Color(0xFF0D55C7)]), borderRadius: BorderRadius.circular(18)),
                  child: IconButton(
                    onPressed: busy ? null : () => send(),
                    icon: busy ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white)) : const Icon(Icons.arrow_upward_rounded, color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        ],
      );

  Widget _welcome() => SingleChildScrollView(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('ابدأ المحادثة مع الخادم', style: TextStyle(color: navy, fontSize: 17, fontWeight: FontWeight.w900)),
            const SizedBox(height: 14),
            _suggestion(Icons.trending_up_rounded, 'كيف أزيد مبيعات متجري؟', 'خطة عملية لرفع المبيعات خلال 30 يومًا.'),
            _suggestion(Icons.campaign_outlined, 'اكتب إعلانًا لمنتج', 'نص تسويقي جذاب ومناسب للتجزئة.'),
            _suggestion(Icons.support_agent_rounded, 'الرد على عميل غاضب', 'صياغة رد مهني وهادئ يحافظ على العميل.'),
          ],
        ),
      );

  Widget _suggestion(IconData icon, String title, String prompt) => Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: Material(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          child: InkWell(
            onTap: busy ? null : () => send(prompt),
            borderRadius: BorderRadius.circular(16),
            child: Container(
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(16), border: Border.all(color: line)),
              child: Row(children: [
                Container(width: 40, height: 40, decoration: BoxDecoration(color: const Color(0xFFEAF4FC), borderRadius: BorderRadius.circular(12)), child: Icon(icon, color: blue)),
                const SizedBox(width: 12),
                Expanded(child: Text(title, style: const TextStyle(color: navy, fontWeight: FontWeight.w800, fontSize: 13))),
                const Icon(Icons.arrow_back_ios_new_rounded, size: 14, color: muted),
              ]),
            ),
          ),
        ),
      );
}

class _MessageBubble extends StatelessWidget {
  final ChatMessage message;
  const _MessageBubble({required this.message});
  @override
  Widget build(BuildContext context) {
    final user = message.fromUser;
    return Align(
      alignment: user ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        constraints: BoxConstraints(maxWidth: MediaQuery.sizeOf(context).width * .84),
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: user ? navy2 : Colors.white,
          borderRadius: BorderRadius.only(topLeft: const Radius.circular(18), topRight: const Radius.circular(18), bottomLeft: Radius.circular(user ? 18 : 4), bottomRight: Radius.circular(user ? 4 : 18)),
          border: user ? null : Border.all(color: line),
        ),
        child: SelectableText(message.text, style: TextStyle(color: user ? Colors.white : navy, height: 1.6, fontSize: 13)),
      ),
    );
  }
}

class _TypingBubble extends StatelessWidget {
  const _TypingBubble();
  @override
  Widget build(BuildContext context) => Align(
        alignment: Alignment.centerLeft,
        child: Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(color: Colors.white, border: Border.all(color: line), borderRadius: BorderRadius.circular(16)),
          child: const Row(mainAxisSize: MainAxisSize.min, children: [
            SizedBox(width: 14, height: 14, child: CircularProgressIndicator(strokeWidth: 2)),
            SizedBox(width: 10),
            Text('الخادم يعالج الطلب...', style: TextStyle(color: muted, fontSize: 12)),
          ]),
        ),
      );

// لوحة التحكم الرئيسية (Dashboard)
class DashboardPage extends StatelessWidget {
  final List<DemoOrder> orders;
  final int cartCount;
  final ValueChanged<int> onTab;
  final ValueChanged<Product> onProduct;
  const DashboardPage({super.key, required this.orders, required this.cartCount, required this.onTab, required this.onProduct});

  @override
  Widget build(BuildContext context) => PageFrame(
        title: 'صباح النشاط 👋',
        subtitle: 'إليك ملخص متجرك اليوم',
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: const LinearGradient(colors: [navy, blue], begin: Alignment.topRight, end: Alignment.bottomLeft),
                borderRadius: BorderRadius.circular(24),
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('متجر النخبة التجريبي', style: TextStyle(color: Colors.white, fontSize: 17, fontWeight: FontWeight.w900)),
                  SizedBox(height: 15),
                  Text('إجمالي مبيعات الشهر', style: TextStyle(color: Colors.white70, fontSize: 12)),
                  SizedBox(height: 5),
                  Text('١٬٢٨٤٬٥٠٠ ر.ي', style: TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.w900)),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Row(children: [
              Expanded(child: _metric('الطلبات', '${orders.length}', Icons.inventory_2_outlined, blue, () => onTab(2))),
              const SizedBox(width: 10),
              Expanded(child: _metric('السلة', '$cartCount', Icons.shopping_bag_outlined, teal, () => onTab(3))),
            ]),
            const SizedBox(height: 20),
            const Text('منتجات مقترحة', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w900, color: navy)),
            const SizedBox(height: 10),
            SizedBox(
              height: 170,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: demoProducts.length,
                separatorBuilder: (_, __) => const SizedBox(width: 10),
                itemBuilder: (_, i) => SizedBox(width: 150, child: ProductMiniCard(product: demoProducts[i], onTap: () => onProduct(demoProducts[i]))),
              ),
            ),
          ],
        ),
      );
}

// شاشة الكتالوج
class CatalogPage extends StatefulWidget {
  final void Function(Product) onOpen, onAdd;
  const CatalogPage({super.key, required this.onOpen, required this.onAdd});
  @override State<CatalogPage> createState() => _CatalogPageState();
}
class _CatalogPageState extends State<CatalogPage> {
  String query = '';
  @override
  Widget build(BuildContext context) {
    final filtered = demoProducts.where((p) => '${p.name} ${p.sku}'.toLowerCase().contains(query.toLowerCase())).toList();
    return PageFrame(
      title: 'الكتالوج',
      subtitle: 'تصفح المنتجات المتاحة',
      child: Column(
        children: [
          TextField(onChanged: (v) => setState(() => query = v), decoration: const InputDecoration(hintText: 'ابحث عن منتج...', prefixIcon: Icon(Icons.search))),
          const SizedBox(height: 15),
          ...filtered.map((p) => ProductListTile(product: p, onTap: () => widget.onOpen(p), onAdd: () => widget.onAdd(p))),
        ],
      ),
    );
  }
}

// شاشة السلة
class CartPage extends StatelessWidget {
  final Map<String, int> cart;
  final void Function(Product, int) onQty;
  final double total;
  final VoidCallback onCheckout, onBrowse;
  const CartPage({super.key, required this.cart, required this.onQty, required this.total, required this.onCheckout, required this.onBrowse});

  @override
  Widget build(BuildContext context) {
    final lines = cart.entries.map((e) => MapEntry(demoProducts.firstWhere((p) => p.id == e.key), e.value)).toList();
    return PageFrame(
      title: 'سلة المشتريات',
      subtitle: 'راجع المنتجات قبل إتمام الطلب',
      child: lines.isEmpty
          ? Center(child: Padding(padding: const EdgeInsets.all(30), child: Column(children: [const Text('السلة فارغة'), const SizedBox(height: 10), FilledButton(onPressed: onBrowse, child: const Text('تصفح المنتجات'))]))
          : Column(
              children: [
                ...lines.map((e) => ListTile(title: Text(e.key.name), subtitle: Text('${e.value} × ${_money(e.key.price)}'))),
                const Divider(),
                Text('الإجمالي: ${_money(total)}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                const SizedBox(height: 15),
                SizedBox(width: double.infinity, child: FilledButton(onPressed: onCheckout, child: const Text('تأكيد الطلب التجريبي'))),
              ],
            ),
    );
  }
}

// شاشة الطلبات
class OrdersPage extends StatelessWidget {
  final List<DemoOrder> orders;
  final ValueChanged<DemoOrder> onOpen, onReorder;
  const OrdersPage({super.key, required this.orders, required this.onOpen, required this.onReorder});

  @override
  Widget build(BuildContext context) => PageFrame(
        title: 'الطلبات',
        subtitle: 'سجل الطلبات السابقة',
        child: Column(children: orders.map((o) => ListTile(title: Text('طلب #${o.id}'), subtitle: Text(o.status), trailing: Text(_money(o.total)), onTap: () => onOpen(o))).toList()),
      );
}

// شاشة الحساب
class ProfilePage extends StatelessWidget {
  final ValueChanged<String> onNavigate;
  const ProfilePage({super.key, required this.onNavigate});
  @override
  Widget build(BuildContext context) => PageFrame(
        title: 'حساب التاجر',
        subtitle: 'إدارة الحساب والمتجر',
        child: Column(children: [
          ListTile(leading: const Icon(Icons.store), title: const Text('معلومات المتجر'), onTap: () => onNavigate('معلومات المتجر')),
          ListTile(leading: const Icon(Icons.logout, color: Colors.red), title: const Text('تسجيل الخروج', style: TextStyle(color: Colors.red)), onTap: () => Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (_) => const AuthScreen()), (_) => false)),
        ]),
      );
}

class UtilityPage extends StatelessWidget {
  final String title;
  const UtilityPage({super.key, required this.title});
  @override
  Widget build(BuildContext context) => Scaffold(appBar: AppBar(title: Text(title)), body: Center(child: Text(title)));
}

class ProductDetailsPage extends StatelessWidget {
  final Product product;
  final ValueChanged<int> onAdd;
  const ProductDetailsPage({super.key, required this.product, required this.onAdd});
  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: Text(product.name)),
        body: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(children: [
            Text(product.description),
            const Spacer(),
            FilledButton(onPressed: () { onAdd(1); Navigator.pop(context); }, child: const Text('إضافة للسلة')),
          ]),
        ),
      );
}

class OrderDetailsPage extends StatelessWidget {
  final DemoOrder order;
  final VoidCallback onReorder;
  const OrderDetailsPage({super.key, required this.order, required this.onReorder});
  @override
  Widget build(BuildContext context) => Scaffold(appBar: AppBar(title: Text('طلب #${order.id}')), body: Center(child: Text('حالة الطلب: ${order.status}')));
}

class PageFrame extends StatelessWidget {
  final String title, subtitle;
  final Widget child;
  const PageFrame({super.key, required this.title, required this.subtitle, required this.child});
  @override
  Widget build(BuildContext context) => CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w900, color: navy)),
                  const SizedBox(height: 4),
                  Text(subtitle, style: const TextStyle(color: muted, fontSize: 12)),
                  const SizedBox(height: 20),
                  child,
                ],
              ),
            ),
          ),
        ],
      );
}

class ProductListTile extends StatelessWidget {
  final Product product;
  final VoidCallback onTap, onAdd;
  const ProductListTile({super.key, required this.product, required this.onTap, required this.onAdd});
  @override
  Widget build(BuildContext context) => Card(
        child: ListTile(title: Text(product.name), subtitle: Text(_money(product.price)), trailing: IconButton(icon: const Icon(Icons.add_shopping_cart), onPressed: onAdd), onTap: onTap),
      );
}

class ProductMiniCard extends StatelessWidget {
  final Product product;
  final VoidCallback onTap;
  const ProductMiniCard({super.key, required this.product, required this.onTap});
  @override
  Widget build(BuildContext context) => InkWell(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: line)),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Expanded(child: Center(child: Icon(product.icon, size: 40, color: blue))),
            Text(product.name, maxLines: 1, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
            Text(_money(product.price), style: const TextStyle(color: blue, fontSize: 11)),
          ]),
        ),
      );

class _BadgeIcon extends StatelessWidget {
  final IconData icon; final int count;
  const _BadgeIcon({required this.icon, required this.count});
  @override
  Widget build(BuildContext context) => Stack(clipBehavior: Clip.none, children: [
        Icon(icon),
        if (count > 0) Positioned(top: -5, right: -8, child: Container(padding: const EdgeInsets.all(3), decoration: const BoxDecoration(color: Colors.red, shape: BoxShape.circle), child: Text('$count', style: const TextStyle(color: Colors.white, fontSize: 8)))),
      ]);
}

String _money(double v) => '${v.toStringAsFixed(0)} ر.ي';
void _toast(BuildContext context, String text) => ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text), behavior: SnackBarBehavior.floating));
