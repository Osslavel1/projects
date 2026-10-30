import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

// ============================================================
// NATCO Merchant — واجهات التاجر
// ملاحظة: المنتجات والطلبات أدناه تجريبية. تم الحفاظ على
// عنوان ومسار مساعد الذكاء الاصطناعي كما في الكود الأصلي.
// ============================================================

const navy = Color(0xFF07182B);
const navy2 = Color(0xFF0D2B49);
const blue = Color(0xFF1677FF);
const teal = Color(0xFF14B8A6);
const cyan = Color(0xFF43D5F5);
const bg = Color(0xFFF4F7FB);
const muted = Color(0xFF718198);
const line = Color(0xFFE4EAF1);
const danger = Color(0xFFD94841);
const apiBaseUrl = String.fromEnvironment(
  'AI_API_BASE_URL',
  defaultValue: 'https://site--natco-merchant-ai--mw6pjw7sw7wl.code.run',
);

void main() => runApp(const NatcoMerchantApp());

class NatcoMerchantApp extends StatelessWidget {
  const NatcoMerchantApp({super.key});

  @override
  Widget build(BuildContext context) {
    final scheme = ColorScheme.fromSeed(
      seedColor: blue,
      primary: blue,
      secondary: teal,
      surface: Colors.white,
    );
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'NATCO Merchant',
      theme: ThemeData(
        useMaterial3: true,
        fontFamily: 'Arial',
        scaffoldBackgroundColor: bg,
        colorScheme: scheme,
        appBarTheme: const AppBarTheme(
          backgroundColor: bg,
          foregroundColor: navy,
          elevation: 0,
          centerTitle: false,
          titleTextStyle: TextStyle(
            color: navy, fontSize: 19, fontWeight: FontWeight.w900,
          ),
        ),
        cardTheme: CardThemeData(
          color: Colors.white,
          elevation: 0,
          margin: EdgeInsets.zero,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
            side: const BorderSide(color: line),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.white,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 15, vertical: 16,
          ),
          labelStyle: const TextStyle(color: muted, fontSize: 13),
          hintStyle: const TextStyle(color: muted, fontSize: 13),
          prefixIconColor: muted,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: const BorderSide(color: line),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: const BorderSide(color: line),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: const BorderSide(color: blue, width: 1.5),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: const BorderSide(color: danger),
          ),
        ),
        filledButtonTheme: FilledButtonThemeData(
          style: FilledButton.styleFrom(
            backgroundColor: navy,
            foregroundColor: Colors.white,
            minimumSize: const Size(48, 52),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            textStyle: const TextStyle(
              fontSize: 14, fontWeight: FontWeight.w800,
            ),
          ),
        ),
        navigationBarTheme: NavigationBarThemeData(
          backgroundColor: Colors.white,
          indicatorColor: const Color(0xFFDDEFFC),
          height: 72,
          labelTextStyle: WidgetStateProperty.resolveWith((states) {
            return TextStyle(
              fontSize: 10,
              fontWeight: states.contains(WidgetState.selected)
                  ? FontWeight.w900
                  : FontWeight.w600,
              color: states.contains(WidgetState.selected) ? navy : muted,
            );
          }),
        ),
      ),
      builder: (context, child) => Directionality(
        textDirection: TextDirection.rtl,
        child: child ?? const SizedBox.shrink(),
      ),
      home: const AuthScreen(),
    );
  }
}

class BrandMark extends StatelessWidget {
  final double size;
  const BrandMark({super.key, this.size = 54});

  @override
  Widget build(BuildContext context) => Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [cyan, blue],
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
          ),
          borderRadius: BorderRadius.circular(size * .28),
          boxShadow: [
            BoxShadow(
              color: blue.withValues(alpha: .20),
              blurRadius: 18,
              offset: const Offset(0, 7),
            ),
          ],
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Icon(Icons.shopping_bag_rounded,
                color: Colors.white, size: size * .54),
            Positioned(
              left: size * .16,
              top: size * .17,
              child: Container(
                width: size * .17,
                height: size * .17,
                decoration: const BoxDecoration(
                  color: teal, shape: BoxShape.circle,
                ),
              ),
            ),
          ],
        ),
      );
}

// ------------------------- المصادقة -------------------------

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});
  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  bool login = true;
  bool hidePassword = true;
  bool hideConfirmPassword = true;
  bool acceptedTerms = false;
  String businessType = 'متجر تجزئة';

  final name = TextEditingController();
  final store = TextEditingController();
  final phone = TextEditingController();
  final email = TextEditingController();
  final password = TextEditingController();
  final confirmPassword = TextEditingController();
  final city = TextEditingController();
  final address = TextEditingController();
  final commercialNumber = TextEditingController();
  final formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    name.dispose();
    store.dispose();
    phone.dispose();
    email.dispose();
    password.dispose();
    confirmPassword.dispose();
    city.dispose();
    address.dispose();
    commercialNumber.dispose();
    super.dispose();
  }

  String? requiredField(String? value) =>
      value == null || value.trim().isEmpty ? 'هذا الحقل مطلوب' : null;

  String? validEmail(String? value) {
    if (value == null ||
        !RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(value.trim())) {
      return 'أدخل بريدًا إلكترونيًا صحيحًا';
    }
    return null;
  }

  String? validPhone(String? value) {
    final normalized = (value ?? '').replaceAll(RegExp(r'[^0-9+]'), '');
    return normalized.length < 7 ? 'أدخل رقم هاتف صحيحًا' : null;
  }

  void submit() {
    FocusScope.of(context).unfocus();
    if (!(formKey.currentState?.validate() ?? false)) return;
    if (!login && !acceptedTerms) {
      showToast(context, 'يرجى الموافقة على شروط الاستخدام وسياسة الخصوصية.');
      return;
    }

    // واجهة تجريبية فقط: اربطها بخدمة المصادقة الفعلية لاحقاً.
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) =>
            login ? const MerchantShell() : const PendingApprovalScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: DecoratedBox(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFEAF4FF), bg, bg],
            stops: [0, .42, 1],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(22),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 480),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: 8),
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        BrandMark(size: 58),
                        SizedBox(width: 13),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('NATCO', style: TextStyle(
                              fontSize: 29, fontWeight: FontWeight.w900,
                              letterSpacing: 2, color: navy,
                            )),
                            SizedBox(height: 3),
                            Text('MERCHANT  •  بوابة التاجر', style: TextStyle(
                              fontSize: 11, letterSpacing: .4, color: muted,
                            )),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 28),
                    Container(
                      padding: const EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(17),
                        border: Border.all(color: line),
                        boxShadow: const [
                          BoxShadow(
                            color: Color(0x0807182B),
                            blurRadius: 20,
                            offset: Offset(0, 7),
                          ),
                        ],
                      ),
                      child: Row(children: [
                        Expanded(child: _tab('تسجيل الدخول', login,
                            () => setState(() => login = true))),
                        Expanded(child: _tab('إنشاء حساب', !login,
                            () => setState(() => login = false))),
                      ]),
                    ),
                    const SizedBox(height: 24),
                    Text(
                      login ? 'مرحباً بعودتك 👋' : 'أنشئ حساب التاجر',
                      style: const TextStyle(
                        fontSize: 27, fontWeight: FontWeight.w900, color: navy,
                      ),
                    ),
                    const SizedBox(height: 7),
                    Text(
                      login
                          ? 'كل أعمال متجرك في مكان واحد، بوضوح وسهولة.'
                          : 'أكمل بياناتك التجارية لبدء طلب الانضمام إلى NATCO.',
                      style: const TextStyle(color: muted, height: 1.7),
                    ),
                    const SizedBox(height: 20),
                    Form(
                      key: formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          if (!login) ...[
                            const SectionLabel('بيانات صاحب الحساب'),
                            const SizedBox(height: 11),
                            _field('الاسم الكامل لصاحب المتجر', name,
                                Icons.person_outline_rounded,
                                validator: requiredField),
                            const SizedBox(height: 12),
                            _field('اسم النشاط التجاري', store,
                                Icons.storefront_outlined,
                                validator: requiredField),
                            const SizedBox(height: 12),
                            DropdownButtonFormField<String>(
                              value: businessType,
                              decoration: const InputDecoration(
                                labelText: 'نوع النشاط التجاري',
                                prefixIcon: Icon(Icons.business_outlined),
                              ),
                              items: const [
                                'متجر تجزئة', 'موزّع', 'تاجر جملة', 'شركة',
                                'نشاط آخر',
                              ].map((item) => DropdownMenuItem(
                                value: item, child: Text(item),
                              )).toList(),
                              onChanged: (value) => setState(
                                () => businessType = value ?? businessType,
                              ),
                            ),
                            const SizedBox(height: 12),
                          ],
                          _field(
                            login ? 'رقم الهاتف أو البريد الإلكتروني' : 'رقم الهاتف للتواصل',
                            phone, Icons.phone_iphone_rounded,
                            validator: login ? requiredField : validPhone,
                            keyboard: login
                                ? TextInputType.emailAddress
                                : TextInputType.phone,
                          ),
                          if (!login) ...[
                            const SizedBox(height: 12),
                            _field('البريد الإلكتروني', email,
                                Icons.mail_outline_rounded,
                                keyboard: TextInputType.emailAddress,
                                validator: validEmail),
                            const SizedBox(height: 12),
                            _field('المدينة', city,
                                Icons.location_city_outlined,
                                validator: requiredField),
                            const SizedBox(height: 12),
                            _field('عنوان المتجر أو موقع النشاط', address,
                                Icons.location_on_outlined,
                                validator: requiredField),
                            const SizedBox(height: 12),
                            _field('رقم السجل التجاري (اختياري)',
                                commercialNumber, Icons.badge_outlined),
                          ],
                          const SizedBox(height: 12),
                          TextFormField(
                            controller: password,
                            obscureText: hidePassword,
                            validator: (value) => value == null || value.length < 8
                                ? 'استخدم كلمة مرور من 8 أحرف على الأقل'
                                : null,
                            decoration: InputDecoration(
                              labelText: 'كلمة المرور',
                              prefixIcon: const Icon(Icons.lock_outline_rounded),
                              suffixIcon: IconButton(
                                onPressed: () => setState(
                                  () => hidePassword = !hidePassword,
                                ),
                                icon: Icon(hidePassword
                                    ? Icons.visibility_outlined
                                    : Icons.visibility_off_outlined),
                              ),
                            ),
                          ),
                          if (!login) ...[
                            const SizedBox(height: 12),
                            TextFormField(
                              controller: confirmPassword,
                              obscureText: hideConfirmPassword,
                              validator: (value) => value != password.text
                                  ? 'كلمتا المرور غير متطابقتين'
                                  : null,
                              decoration: InputDecoration(
                                labelText: 'تأكيد كلمة المرور',
                                prefixIcon: const Icon(Icons.lock_reset_rounded),
                                suffixIcon: IconButton(
                                  onPressed: () => setState(
                                    () => hideConfirmPassword = !hideConfirmPassword,
                                  ),
                                  icon: Icon(hideConfirmPassword
                                      ? Icons.visibility_outlined
                                      : Icons.visibility_off_outlined),
                                ),
                              ),
                            ),
                            const SizedBox(height: 7),
                            CheckboxListTile(
                              value: acceptedTerms,
                              onChanged: (value) => setState(
                                () => acceptedTerms = value ?? false,
                              ),
                              contentPadding: EdgeInsets.zero,
                              controlAffinity: ListTileControlAffinity.leading,
                              title: const Text(
                                'أوافق على شروط الاستخدام وسياسة الخصوصية',
                                style: TextStyle(
                                  fontSize: 12, height: 1.5, color: muted,
                                ),
                              ),
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
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(login
                                ? 'الدخول إلى لوحة التاجر'
                                : 'إرسال طلب إنشاء الحساب'),
                            const SizedBox(width: 10),
                            const Icon(Icons.arrow_back_rounded),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 18),
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.shield_outlined, size: 15, color: muted),
                        SizedBox(width: 6),
                        Text('بوابة التاجر • واجهة تجريبية', style: TextStyle(
                          color: muted, fontSize: 11,
                        )),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _tab(String text, bool active, VoidCallback onTap) => InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          padding: const EdgeInsets.symmetric(vertical: 14),
          decoration: BoxDecoration(
            color: active ? navy : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(text, textAlign: TextAlign.center, style: TextStyle(
            color: active ? Colors.white : muted,
            fontWeight: FontWeight.w800,
          )),
        ),
      );

  Widget _field(
    String label,
    TextEditingController controller,
    IconData icon, {
    String? Function(String?)? validator,
    TextInputType keyboard = TextInputType.text,
  }) => TextFormField(
        controller: controller,
        validator: validator,
        keyboardType: keyboard,
        textInputAction: TextInputAction.next,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon),
        ),
      );
}

class PendingApprovalScreen extends StatelessWidget {
  const PendingApprovalScreen({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
        body: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(28),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const BrandMark(size: 76),
                  const SizedBox(height: 28),
                  Container(
                    width: 92, height: 92,
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFF4DA),
                      borderRadius: BorderRadius.circular(28),
                    ),
                    child: const Icon(Icons.hourglass_top_rounded,
                        color: Color(0xFFD99217), size: 46),
                  ),
                  const SizedBox(height: 24),
                  const Text('تم تقديم طلبك بنجاح!',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 25, fontWeight: FontWeight.w900, color: navy,
                      )),
                  const SizedBox(height: 12),
                  const Text(
                    'شكرًا لاهتمامك بالانضمام إلى NATCO. هذه شاشة توضيحية، ويجب ربط اعتماد الحساب بالخادم عند تفعيل النظام.',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: muted, height: 1.9),
                  ),
                  const SizedBox(height: 26),
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton(
                      onPressed: () => Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (_) => const AuthScreen()),
                        (_) => false,
                      ),
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

// ------------------------- بيانات العرض -------------------------

class Product {
  final String id, name, category, sku, description;
  final int stock;
  final double price;
  final IconData icon;

  const Product(
    this.id, this.name, this.category, this.sku, this.description,
    this.stock, this.price, this.icon,
  );
}

const demoProducts = <Product>[
  Product('P-101', 'هاتف ذكي X Pro', 'هواتف ذكية', 'NT-MOB-101',
      'هاتف عملي بشاشة عالية الوضوح وأداء سريع للاستخدام اليومي.',
      12, 185000, Icons.phone_android_rounded),
  Product('P-102', 'سماعات لاسلكية Air', 'إكسسوارات', 'NT-AUD-102',
      'سماعات لاسلكية بتصميم مريح وعلبة شحن صغيرة.',
      36, 18500, Icons.headphones_rounded),
  Product('P-103', 'ساعة ذكية Active', 'أجهزة ذكية', 'NT-WAT-103',
      'ساعة ذكية لمتابعة النشاط والتنبيهات اليومية.',
      4, 45000, Icons.watch_rounded),
  Product('P-104', 'شاحن سريع 65 واط', 'إكسسوارات', 'NT-CHG-104',
      'شاحن سريع متعدد الاستخدامات بتصميم مدمج.',
      21, 9500, Icons.battery_charging_full_rounded),
  Product('P-105', 'حافظة حماية فاخرة', 'إكسسوارات', 'NT-ACC-105',
      'حافظة حماية مرنة بحواف معززة ومظهر أنيق.',
      58, 3500, Icons.smartphone_rounded),
  Product('P-106', 'جهاز لوحي Business', 'أجهزة لوحية', 'NT-TAB-106',
      'جهاز لوحي مناسب للاجتماعات ومهام العمل.',
      9, 132000, Icons.tablet_android_rounded),
];

class DemoOrder {
  final String id, date, status, payment;
  final double total;
  final List<MapEntry<Product, int>> lines;

  DemoOrder(
    this.id, this.date, this.status, this.payment, this.total, this.lines,
  );
}

// ------------------------- حاوية التطبيق -------------------------

class MerchantShell extends StatefulWidget {
  const MerchantShell({super.key});
  @override
  State<MerchantShell> createState() => _MerchantShellState();
}

class _MerchantShellState extends State<MerchantShell> {
  int tab = 0;
  final Map<String, int> cart = {};
  final List<DemoOrder> orders = [
    DemoOrder('NT-24081', '٢٨ أكتوبر ٢٠٢٦', 'قيد التجهيز',
      'الدفع عند الاستلام', 239000,
      [MapEntry(demoProducts[0], 1), MapEntry(demoProducts[3], 2)]),
    DemoOrder('NT-24066', '٢٥ أكتوبر ٢٠٢٦', 'تم الشحن',
      'تحويل بنكي', 82000,
      [MapEntry(demoProducts[2], 1), MapEntry(demoProducts[1], 2)]),
  ];

  int get cartCount => cart.values.fold(0, (sum, quantity) => sum + quantity);
  double get cartTotal => cart.entries.fold(0, (sum, entry) {
    final product = demoProducts.firstWhere((p) => p.id == entry.key);
    return sum + product.price * entry.value;
  });

  void add(Product product, [int count = 1]) {
    final current = cart[product.id] ?? 0;
    if (current + count > product.stock) {
      showToast(context, 'الكمية المطلوبة تتجاوز المخزون المتاح (${product.stock}).');
      return;
    }
    setState(() => cart[product.id] = current + count);
  }

  void setQty(Product product, int quantity) {
    setState(() {
      if (quantity <= 0) {
        cart.remove(product.id);
      } else {
        cart[product.id] = quantity.clamp(1, product.stock);
      }
    });
  }

  void placeOrder() {
    if (cart.isEmpty) {
      showToast(context, 'أضف منتجًا إلى السلة أولاً.');
      return;
    }
    final lines = cart.entries.map((entry) {
      return MapEntry(
        demoProducts.firstWhere((p) => p.id == entry.key),
        entry.value,
      );
    }).toList();
    final total = cartTotal;
    setState(() {
      orders.insert(0, DemoOrder(
        'NT-${25000 + orders.length * 17}',
        '٢٩ أكتوبر ٢٠٢٦',
        'طلب جديد',
        'الدفع عند الاستلام',
        total,
        lines,
      ));
      cart.clear();
      tab = 2;
    });
    showToast(context, 'تم إنشاء طلب تجريبي بنجاح.');
  }

  @override
  Widget build(BuildContext context) {
    final pages = <Widget>[
      DashboardPage(
        orders: orders,
        cartCount: cartCount,
        onTab: (value) => setState(() => tab = value),
        onProduct: _productDetails,
      ),
      CatalogPage(onAdd: add, onOpen: _productDetails),
      OrdersPage(
        orders: orders,
        onOpen: _orderDetails,
        onReorder: (order) {
          for (final entry in order.lines) {
            add(entry.key, entry.value);
          }
          setState(() => tab = 3);
          showToast(context, 'تمت إضافة المنتجات المتاحة إلى السلة.');
        },
      ),
      CartPage(
        cart: cart,
        onQty: setQty,
        total: cartTotal,
        onCheckout: placeOrder,
        onBrowse: () => setState(() => tab = 1),
      ),
      const AiChatScreenTab(),
      ProfilePage(onNavigate: _openUtility),
    ];

    return Scaffold(
      body: SafeArea(
        child: IndexedStack(index: tab, children: pages),
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: tab,
        onDestinationSelected: (index) => setState(() => tab = index),
        destinations: [
          const NavigationDestination(
            icon: Icon(Icons.grid_view_rounded), label: 'الرئيسية',
          ),
          const NavigationDestination(
            icon: Icon(Icons.widgets_outlined), label: 'الكتالوج',
          ),
          const NavigationDestination(
            icon: Icon(Icons.receipt_long_outlined), label: 'الطلبات',
          ),
          NavigationDestination(
            icon: Badge(
              isLabelVisible: cartCount > 0,
              label: Text(cartCount > 99 ? '99+' : '$cartCount'),
              child: const Icon(Icons.shopping_bag_outlined),
            ),
            label: 'السلة',
          ),
          const NavigationDestination(
            icon: Icon(Icons.auto_awesome_rounded), label: 'المساعد الذكي',
          ),
          const NavigationDestination(
            icon: Icon(Icons.person_outline_rounded), label: 'حسابي',
          ),
        ],
      ),
    );
  }

  void _productDetails(Product product) {
    Navigator.push(context, MaterialPageRoute(
      builder: (_) => ProductDetailsPage(
        product: product,
        onAdd: (quantity) {
          add(product, quantity);
          showToast(context, 'تم تحديث السلة.');
        },
      ),
    ));
  }

  void _orderDetails(DemoOrder order) {
    Navigator.push(context, MaterialPageRoute(
      builder: (_) => OrderDetailsPage(
        order: order,
        onReorder: () {
          for (final entry in order.lines) {
            add(entry.key, entry.value);
          }
          Navigator.pop(context);
          setState(() => tab = 3);
        },
      ),
    ));
  }

  void _openUtility(String title) {
    Navigator.push(context, MaterialPageRoute(
      builder: (_) => UtilityPage(title: title),
    ));
  }
}

// ------------------------- لوحة التحكم -------------------------

class DashboardPage extends StatelessWidget {
  final List<DemoOrder> orders;
  final int cartCount;
  final ValueChanged<int> onTab;
  final ValueChanged<Product> onProduct;

  const DashboardPage({
    super.key,
    required this.orders,
    required this.cartCount,
    required this.onTab,
    required this.onProduct,
  });

  @override
  Widget build(BuildContext context) => PageFrame(
    title: 'لوحة التحكم',
    subtitle: 'مرحباً بك، إليك ملخص متجرك اليوم',
    trailing: IconButton.filledTonal(
      onPressed: () => showToast(context, 'لا توجد إشعارات جديدة.'),
      icon: const Icon(Icons.notifications_none_rounded),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          padding: const EdgeInsets.all(21),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [navy, navy2, blue],
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
            ),
            borderRadius: BorderRadius.circular(25),
            boxShadow: const [
              BoxShadow(
                color: Color(0x1A07182B),
                blurRadius: 22,
                offset: Offset(0, 10),
              ),
            ],
          ),
          child: Stack(
            children: [
              Positioned(
                left: -10, bottom: -18,
                child: Icon(Icons.storefront_rounded,
                  size: 112, color: Colors.white.withValues(alpha: .07)),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: .13),
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: const Text('حساب تجريبي',
                        style: TextStyle(color: Colors.white, fontSize: 10)),
                    ),
                    const Spacer(),
                    const Icon(Icons.verified_rounded,
                      color: cyan, size: 20),
                  ]),
                  const SizedBox(height: 18),
                  const Text('متجر النخبة',
                    style: TextStyle(
                      color: Colors.white, fontSize: 20,
                      fontWeight: FontWeight.w900,
                    )),
                  const SizedBox(height: 16),
                  const Text('إجمالي مبيعات الشهر',
                    style: TextStyle(color: Color(0xFFCFDDED), fontSize: 12)),
                  const SizedBox(height: 5),
                  const Text('١٬٢٨٤٬٥٠٠ ر.ي',
                    style: TextStyle(
                      color: Colors.white, fontSize: 27,
                      fontWeight: FontWeight.w900,
                    )),
                  const SizedBox(height: 12),
                  Row(children: [
                    const Icon(Icons.trending_up_rounded,
                      color: Color(0xFF72E4C3), size: 18),
                    const SizedBox(width: 5),
                    Text('نظرة عامة على أداء المتجر',
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: .85),
                        fontSize: 11,
                      )),
                  ]),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 17),
        const SectionLabel('ملخص سريع'),
        const SizedBox(height: 10),
        Row(children: [
          Expanded(child: MetricCard(
            title: 'الطلبات',
            value: '${orders.length}',
            caption: 'إجمالي الطلبات',
            icon: Icons.receipt_long_rounded,
            color: blue,
            onTap: () => onTab(2),
          )),
          const SizedBox(width: 10),
          Expanded(child: MetricCard(
            title: 'السلة',
            value: '$cartCount',
            caption: 'منتج في السلة',
            icon: Icons.shopping_bag_rounded,
            color: teal,
            onTap: () => onTab(3),
          )),
        ]),
        const SizedBox(height: 23),
        SectionHeading(
          title: 'منتجات مقترحة',
          actionText: 'عرض الكل',
          onAction: () => onTab(1),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 194,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: demoProducts.length,
            separatorBuilder: (_, __) => const SizedBox(width: 12),
            itemBuilder: (_, index) => SizedBox(
              width: 158,
              child: ProductMiniCard(
                product: demoProducts[index],
                onTap: () => onProduct(demoProducts[index]),
              ),
            ),
          ),
        ),
        const SizedBox(height: 23),
        SectionHeading(
          title: 'أحدث الطلبات',
          actionText: 'عرض الطلبات',
          onAction: () => onTab(2),
        ),
        const SizedBox(height: 8),
        if (orders.isEmpty)
          const EmptyState(
            icon: Icons.receipt_long_outlined,
            title: 'لا توجد طلبات حتى الآن',
            subtitle: 'ستظهر طلبات متجرك هنا.',
          )
        else
          ...orders.take(3).map((order) => OrderSummaryTile(
            order: order,
            onTap: () => onTab(2),
          )),
      ],
    ),
  );
}

class MetricCard extends StatelessWidget {
  final String title, value, caption;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const MetricCard({
    super.key,
    required this.title,
    required this.value,
    required this.caption,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) => Material(
    color: Colors.white,
    borderRadius: BorderRadius.circular(20),
    child: InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: line),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(children: [
              Container(
                width: 43, height: 43,
                decoration: BoxDecoration(
                  color: color.withValues(alpha: .10),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(icon, color: color),
              ),
              const Spacer(),
              const Icon(Icons.arrow_outward_rounded,
                size: 16, color: muted),
            ]),
            const SizedBox(height: 15),
            Text(title, style: const TextStyle(
              color: muted, fontSize: 12,
            )),
            const SizedBox(height: 4),
            Text(value, style: const TextStyle(
              color: navy, fontSize: 23, fontWeight: FontWeight.w900,
            )),
            const SizedBox(height: 3),
            Text(caption, style: const TextStyle(
              color: muted, fontSize: 10,
            )),
          ],
        ),
      ),
    ),
  );
}

// ------------------------- الكتالوج -------------------------

class CatalogPage extends StatefulWidget {
  final void Function(Product) onOpen;
  final void Function(Product) onAdd;

  const CatalogPage({
    super.key, required this.onOpen, required this.onAdd,
  });

  @override
  State<CatalogPage> createState() => _CatalogPageState();
}

class _CatalogPageState extends State<CatalogPage> {
  String query = '';
  String category = 'الكل';

  @override
  Widget build(BuildContext context) {
    final categories = ['الكل', ...demoProducts.map((p) => p.category).toSet()];
    final filtered = demoProducts.where((product) {
      final text = '${product.name} ${product.sku} ${product.category}'
          .toLowerCase();
      final matchesQuery = text.contains(query.trim().toLowerCase());
      final matchesCategory =
          category == 'الكل' || product.category == category;
      return matchesQuery && matchesCategory;
    }).toList();

    return PageFrame(
      title: 'كتالوج المنتجات',
      subtitle: '${demoProducts.length} منتجات متاحة في الكتالوج التجريبي',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextField(
            onChanged: (value) => setState(() => query = value),
            decoration: InputDecoration(
              hintText: 'ابحث بالاسم أو رمز المنتج...',
              prefixIcon: const Icon(Icons.search_rounded),
              suffixIcon: query.isEmpty
                  ? null
                  : IconButton(
                      onPressed: () => setState(() => query = ''),
                      icon: const Icon(Icons.close_rounded),
                    ),
            ),
          ),
          const SizedBox(height: 14),
          SizedBox(
            height: 42,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: categories.length,
              separatorBuilder: (_, __) => const SizedBox(width: 8),
              itemBuilder: (_, index) {
                final item = categories[index];
                final selected = item == category;
                return ChoiceChip(
                  label: Text(item),
                  selected: selected,
                  onSelected: (_) => setState(() => category = item),
                  selectedColor: const Color(0xFFDDEFFC),
                  labelStyle: TextStyle(
                    color: selected ? navy : muted,
                    fontWeight: FontWeight.w700,
                    fontSize: 12,
                  ),
                  side: BorderSide(color: selected ? blue : line),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(13),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 15),
          Row(children: [
            Text('${filtered.length} نتيجة',
              style: const TextStyle(color: muted, fontSize: 12)),
            const Spacer(),
            const Icon(Icons.tune_rounded, color: muted, size: 17),
            const SizedBox(width: 5),
            const Text('الكتالوج التجريبي',
              style: TextStyle(color: muted, fontSize: 11)),
          ]),
          const SizedBox(height: 9),
          if (filtered.isEmpty)
            const EmptyState(
              icon: Icons.search_off_rounded,
              title: 'لم نعثر على منتجات',
              subtitle: 'جرّب كلمة بحث أخرى أو اختر تصنيفًا مختلفًا.',
            )
          else
            ...filtered.map((product) => Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: ProductListTile(
                product: product,
                onTap: () => widget.onOpen(product),
                onAdd: () => widget.onAdd(product),
              ),
            )),
        ],
      ),
    );
  }
}

// ------------------------- تفاصيل المنتج -------------------------

class ProductDetailsPage extends StatelessWidget {
  final Product product;
  final ValueChanged<int> onAdd;

  const ProductDetailsPage({
    super.key, required this.product, required this.onAdd,
  });

  @override
  Widget build(BuildContext context) {
    final stockColor = product.stock <= 5 ? const Color(0xFFD99217) : teal;
    return Scaffold(
      appBar: AppBar(title: const Text('تفاصيل المنتج')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Container(
            height: 245,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFFEAF4FC), Color(0xFFF8FBFF)],
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
              ),
              borderRadius: BorderRadius.circular(26),
              border: Border.all(color: line),
            ),
            child: Stack(
              children: [
                Positioned(
                  top: 16, right: 16,
                  child: _Pill(
                    text: product.category,
                    color: blue,
                    background: Colors.white,
                  ),
                ),
                Center(child: Icon(product.icon, size: 100, color: blue)),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Text(product.name, style: const TextStyle(
            color: navy, fontSize: 24, fontWeight: FontWeight.w900,
          )),
          const SizedBox(height: 7),
          Text('رمز المنتج: ${product.sku}',
            style: const TextStyle(color: muted, fontSize: 12)),
          const SizedBox(height: 17),
          Text(_money(product.price), style: const TextStyle(
            color: blue, fontSize: 25, fontWeight: FontWeight.w900,
          )),
          const SizedBox(height: 17),
          Container(
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: line),
            ),
            child: Row(children: [
              Icon(Icons.inventory_2_outlined, color: stockColor),
              const SizedBox(width: 10),
              Expanded(child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('المخزون المتاح', style: TextStyle(
                    color: muted, fontSize: 11,
                  )),
                  const SizedBox(height: 3),
                  Text(
                    product.stock <= 5
                        ? '${product.stock} قطع — مخزون منخفض'
                        : '${product.stock} قطعة متاحة',
                    style: TextStyle(
                      color: stockColor, fontWeight: FontWeight.w800,
                    ),
                  ),
                ],
              )),
            ]),
          ),
          const SizedBox(height: 22),
          const SectionLabel('وصف المنتج'),
          const SizedBox(height: 8),
          Text(product.description, style: const TextStyle(
            color: muted, height: 1.9, fontSize: 14,
          )),
          const SizedBox(height: 28),
          FilledButton.icon(
            onPressed: product.stock <= 0 ? null : () {
              onAdd(1);
              Navigator.pop(context);
            },
            icon: const Icon(Icons.add_shopping_cart_rounded),
            label: const Text('إضافة إلى السلة'),
          ),
        ],
      ),
    );
  }
}

// ------------------------- السلة -------------------------

class CartPage extends StatelessWidget {
  final Map<String, int> cart;
  final void Function(Product, int) onQty;
  final double total;
  final VoidCallback onCheckout, onBrowse;

  const CartPage({
    super.key,
    required this.cart,
    required this.onQty,
    required this.total,
    required this.onCheckout,
    required this.onBrowse,
  });

  @override
  Widget build(BuildContext context) {
    final lines = cart.entries.map((entry) => MapEntry(
      demoProducts.firstWhere((p) => p.id == entry.key), entry.value,
    )).toList();

    return PageFrame(
      title: 'سلة المشتريات',
      subtitle: 'راجع الكميات والإجمالي قبل تأكيد الطلب',
      child: lines.isEmpty
          ? EmptyState(
              icon: Icons.shopping_bag_outlined,
              title: 'سلتك فارغة',
              subtitle: 'تصفح الكتالوج وأضف المنتجات التي تحتاجها.',
              actionLabel: 'تصفح المنتجات',
              onAction: onBrowse,
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(children: [
                  const SectionLabel('المنتجات المختارة'),
                  const Spacer(),
                  Text('${lines.length} أصناف',
                    style: const TextStyle(color: muted, fontSize: 12)),
                ]),
                const SizedBox(height: 12),
                ...lines.map((entry) => Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: CartItemTile(
                    product: entry.key,
                    quantity: entry.value,
                    onDecrease: () => onQty(entry.key, entry.value - 1),
                    onIncrease: () => onQty(entry.key, entry.value + 1),
                    onRemove: () => onQty(entry.key, 0),
                  ),
                )),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(22),
                    border: Border.all(color: line),
                  ),
                  child: Column(children: [
                    _PriceRow(label: 'عدد القطع', value: '${
                      cart.values.fold<int>(0, (sum, qty) => sum + qty)
                    }'),
                    const SizedBox(height: 12),
                    const _PriceRow(label: 'الشحن', value: 'يحدد لاحقاً'),
                    const Divider(height: 25),
                    Row(children: [
                      const Text('الإجمالي المبدئي', style: TextStyle(
                        color: navy, fontWeight: FontWeight.w900, fontSize: 14,
                      )),
                      const Spacer(),
                      Text(_money(total), style: const TextStyle(
                        color: blue, fontWeight: FontWeight.w900, fontSize: 19,
                      )),
                    ]),
                    const SizedBox(height: 6),
                    const Text(
                      'المبلغ تجريبي ولا يشمل أي رسوم شحن محتملة.',
                      style: TextStyle(color: muted, fontSize: 10),
                    ),
                  ]),
                ),
                const SizedBox(height: 15),
                FilledButton.icon(
                  onPressed: onCheckout,
                  icon: const Icon(Icons.check_circle_outline_rounded),
                  label: const Text('تأكيد الطلب التجريبي'),
                ),
                const SizedBox(height: 8),
                OutlinedButton.icon(
                  onPressed: onBrowse,
                  icon: const Icon(Icons.add_rounded),
                  label: const Text('متابعة التسوق'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: navy,
                    minimumSize: const Size(48, 50),
                    side: const BorderSide(color: line),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}

class CartItemTile extends StatelessWidget {
  final Product product;
  final int quantity;
  final VoidCallback onDecrease, onIncrease, onRemove;

  const CartItemTile({
    super.key,
    required this.product,
    required this.quantity,
    required this.onDecrease,
    required this.onIncrease,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(12),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(19),
      border: Border.all(color: line),
    ),
    child: Row(children: [
      Container(
        width: 65, height: 70,
        decoration: BoxDecoration(
          color: const Color(0xFFEAF4FC),
          borderRadius: BorderRadius.circular(15),
        ),
        child: Icon(product.icon, color: blue, size: 31),
      ),
      const SizedBox(width: 12),
      Expanded(child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(product.name, maxLines: 2, overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: navy, fontSize: 12, fontWeight: FontWeight.w800,
            )),
          const SizedBox(height: 5),
          Text(_money(product.price),
            style: const TextStyle(color: blue, fontSize: 12,
              fontWeight: FontWeight.w900)),
          const SizedBox(height: 8),
          Row(mainAxisSize: MainAxisSize.min, children: [
            _QuantityButton(icon: Icons.remove_rounded, onTap: onDecrease),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Text('$quantity', style: const TextStyle(
                fontWeight: FontWeight.w900, color: navy,
              )),
            ),
            _QuantityButton(
              icon: Icons.add_rounded,
              onTap: quantity >= product.stock ? null : onIncrease,
            ),
          ]),
        ],
      )),
      IconButton(
        tooltip: 'حذف المنتج',
        onPressed: onRemove,
        icon: const Icon(Icons.delete_outline_rounded, color: danger),
      ),
    ]),
  );
}

class _QuantityButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onTap;
  const _QuantityButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) => InkWell(
    onTap: onTap,
    borderRadius: BorderRadius.circular(9),
    child: Container(
      width: 29, height: 29,
      decoration: BoxDecoration(
        color: onTap == null ? bg : const Color(0xFFEAF4FC),
        borderRadius: BorderRadius.circular(9),
        border: Border.all(color: line),
      ),
      child: Icon(icon, size: 16, color: onTap == null ? line : navy),
    ),
  );
}

// ------------------------- الطلبات -------------------------

class OrdersPage extends StatefulWidget {
  final List<DemoOrder> orders;
  final ValueChanged<DemoOrder> onOpen, onReorder;

  const OrdersPage({
    super.key,
    required this.orders,
    required this.onOpen,
    required this.onReorder,
  });

  @override
  State<OrdersPage> createState() => _OrdersPageState();
}

class _OrdersPageState extends State<OrdersPage> {
  String filter = 'الكل';

  @override
  Widget build(BuildContext context) {
    final filters = ['الكل', 'طلب جديد', 'قيد التجهيز', 'تم الشحن'];
    final shown = widget.orders.where((order) =>
      filter == 'الكل' || order.status == filter).toList();

    return PageFrame(
      title: 'الطلبات',
      subtitle: 'تابع الطلبات وحالات تجهيزها وشحنها',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [navy, navy2],
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
              ),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(children: [
              const Icon(Icons.receipt_long_rounded, color: cyan, size: 32),
              const SizedBox(width: 12),
              Expanded(child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('إدارة الطلبات',
                    style: TextStyle(color: Colors.white,
                      fontWeight: FontWeight.w900, fontSize: 15)),
                  const SizedBox(height: 4),
                  Text('${widget.orders.length} طلب في السجل التجريبي',
                    style: const TextStyle(color: Color(0xFFCFDDED),
                      fontSize: 11)),
                ],
              )),
            ]),
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 42,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: filters.length,
              separatorBuilder: (_, __) => const SizedBox(width: 8),
              itemBuilder: (_, index) => ChoiceChip(
                label: Text(filters[index]),
                selected: filter == filters[index],
                onSelected: (_) => setState(() => filter = filters[index]),
                selectedColor: const Color(0xFFDDEFFC),
                side: BorderSide(
                  color: filter == filters[index] ? blue : line,
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),
          if (shown.isEmpty)
            const EmptyState(
              icon: Icons.receipt_long_outlined,
              title: 'لا توجد طلبات في هذا التصنيف',
              subtitle: 'اختر تصنيفًا آخر لعرض الطلبات.',
            )
          else
            ...shown.map((order) => Padding(
              padding: const EdgeInsets.only(bottom: 11),
              child: OrderCard(
                order: order,
                onTap: () => widget.onOpen(order),
                onReorder: () => widget.onReorder(order),
              ),
            )),
        ],
      ),
    );
  }
}

class OrderCard extends StatelessWidget {
  final DemoOrder order;
  final VoidCallback onTap, onReorder;

  const OrderCard({
    super.key,
    required this.order,
    required this.onTap,
    required this.onReorder,
  });

  @override
  Widget build(BuildContext context) => Material(
    color: Colors.white,
    borderRadius: BorderRadius.circular(20),
    child: InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: line),
        ),
        child: Column(children: [
          Row(children: [
            Container(
              width: 43, height: 43,
              decoration: BoxDecoration(
                color: const Color(0xFFEAF4FC),
                borderRadius: BorderRadius.circular(13),
              ),
              child: const Icon(Icons.receipt_long_rounded, color: blue),
            ),
            const SizedBox(width: 11),
            Expanded(child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('طلب #${order.id}', style: const TextStyle(
                  color: navy, fontWeight: FontWeight.w900, fontSize: 13,
                )),
                const SizedBox(height: 4),
                Text(order.date, style: const TextStyle(
                  color: muted, fontSize: 10,
                )),
              ],
            )),
            StatusPill(status: order.status),
          ]),
          const Divider(height: 25),
          Row(children: [
            const Icon(Icons.shopping_basket_outlined,
              color: muted, size: 17),
            const SizedBox(width: 6),
            Text('${order.lines.length} أصناف',
              style: const TextStyle(color: muted, fontSize: 11)),
            const Spacer(),
            const Text('الإجمالي', style: TextStyle(
              color: muted, fontSize: 11,
            )),
            const SizedBox(width: 8),
            Text(_money(order.total), style: const TextStyle(
              color: navy, fontSize: 13, fontWeight: FontWeight.w900,
            )),
          ]),
          const SizedBox(height: 12),
          Row(children: [
            Expanded(child: OutlinedButton(
              onPressed: onTap,
              style: OutlinedButton.styleFrom(
                foregroundColor: navy,
                side: const BorderSide(color: line),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text('التفاصيل'),
            )),
            const SizedBox(width: 8),
            Expanded(child: FilledButton.tonal(
              onPressed: onReorder,
              style: FilledButton.styleFrom(
                backgroundColor: const Color(0xFFEAF4FC),
                foregroundColor: blue,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text('إعادة الطلب'),
            )),
          ]),
        ]),
      ),
    ),
  );
}

class OrderSummaryTile extends StatelessWidget {
  final DemoOrder order;
  final VoidCallback onTap;
  const OrderSummaryTile({super.key, required this.order, required this.onTap});

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: 8),
    child: ListTile(
      onTap: onTap,
      tileColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: const BorderSide(color: line),
      ),
      leading: Container(
        width: 42, height: 42,
        decoration: BoxDecoration(
          color: const Color(0xFFEAF4FC),
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Icon(Icons.receipt_long_rounded, color: blue),
      ),
      title: Text('طلب #${order.id}', style: const TextStyle(
        color: navy, fontSize: 12, fontWeight: FontWeight.w800,
      )),
      subtitle: Padding(
        padding: const EdgeInsets.only(top: 5),
        child: StatusPill(status: order.status),
      ),
      trailing: const Icon(Icons.chevron_left_rounded, color: muted),
    ),
  );
}

class OrderDetailsPage extends StatelessWidget {
  final DemoOrder order;
  final VoidCallback onReorder;

  const OrderDetailsPage({
    super.key, required this.order, required this.onReorder,
  });

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: Text('طلب #${order.id}')),
    body: ListView(
      padding: const EdgeInsets.all(20),
      children: [
        Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            gradient: const LinearGradient(colors: [navy, navy2]),
            borderRadius: BorderRadius.circular(22),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('حالة الطلب',
                style: TextStyle(color: Color(0xFFCFDDED), fontSize: 12)),
              const SizedBox(height: 8),
              StatusPill(status: order.status, large: true),
              const SizedBox(height: 18),
              Text(_money(order.total), style: const TextStyle(
                color: Colors.white, fontSize: 25, fontWeight: FontWeight.w900,
              )),
              const SizedBox(height: 5),
              Text('تاريخ الطلب: ${order.date}',
                style: const TextStyle(color: Color(0xFFCFDDED), fontSize: 11)),
            ],
          ),
        ),
        const SizedBox(height: 20),
        const SectionLabel('تفاصيل الطلب'),
        const SizedBox(height: 10),
        InfoTile(icon: Icons.payment_rounded,
          label: 'طريقة الدفع', value: order.payment),
        const SizedBox(height: 8),
        InfoTile(icon: Icons.local_shipping_outlined,
          label: 'الشحن', value: 'سيتم تحديث معلومات الشحن لاحقًا'),
        const SizedBox(height: 20),
        const SectionLabel('المنتجات المطلوبة'),
        const SizedBox(height: 10),
        ...order.lines.map((entry) => Container(
          margin: const EdgeInsets.only(bottom: 9),
          padding: const EdgeInsets.all(13),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: line),
          ),
          child: Row(children: [
            Container(
              width: 46, height: 46,
              decoration: BoxDecoration(
                color: const Color(0xFFEAF4FC),
                borderRadius: BorderRadius.circular(13),
              ),
              child: Icon(entry.key.icon, color: blue),
            ),
            const SizedBox(width: 10),
            Expanded(child: Text(entry.key.name,
              style: const TextStyle(color: navy, fontSize: 12,
                fontWeight: FontWeight.w800))),
            Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
              Text('${entry.value} ×', style: const TextStyle(
                color: muted, fontSize: 11,
              )),
              const SizedBox(height: 4),
              Text(_money(entry.key.price * entry.value),
                style: const TextStyle(color: navy,
                  fontSize: 12, fontWeight: FontWeight.w900)),
            ]),
          ]),
        )),
        const SizedBox(height: 15),
        FilledButton.icon(
          onPressed: onReorder,
          icon: const Icon(Icons.refresh_rounded),
          label: const Text('إضافة هذه المنتجات إلى السلة'),
        ),
      ],
    ),
  );
}

// ------------------------- حساب التاجر -------------------------

class ProfilePage extends StatelessWidget {
  final ValueChanged<String> onNavigate;
  const ProfilePage({super.key, required this.onNavigate});

  @override
  Widget build(BuildContext context) => PageFrame(
    title: 'حساب التاجر',
    subtitle: 'إدارة بيانات الحساب والمتجر',
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [navy, navy2],
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
            ),
            borderRadius: BorderRadius.circular(23),
          ),
          child: Row(children: [
            Container(
              width: 62, height: 62,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: .12),
                borderRadius: BorderRadius.circular(19),
              ),
              child: const Icon(Icons.storefront_rounded,
                color: Colors.white, size: 31),
            ),
            const SizedBox(width: 14),
            const Expanded(child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('متجر النخبة', style: TextStyle(
                  color: Colors.white, fontSize: 17,
                  fontWeight: FontWeight.w900,
                )),
                SizedBox(height: 5),
                Text('حساب تاجر تجريبي',
                  style: TextStyle(color: Color(0xFFCFDDED), fontSize: 11)),
              ],
            )),
            const Icon(Icons.edit_outlined, color: cyan),
          ]),
        ),
        const SizedBox(height: 22),
        const SectionLabel('إعدادات الحساب'),
        const SizedBox(height: 10),
        ProfileMenuTile(
          icon: Icons.store_mall_directory_outlined,
          title: 'معلومات المتجر',
          subtitle: 'اسم المتجر والعنوان والنشاط التجاري',
          onTap: () => onNavigate('معلومات المتجر'),
        ),
        ProfileMenuTile(
          icon: Icons.person_outline_rounded,
          title: 'البيانات الشخصية',
          subtitle: 'اسم صاحب الحساب وبيانات التواصل',
          onTap: () => onNavigate('البيانات الشخصية'),
        ),
        ProfileMenuTile(
          icon: Icons.location_on_outlined,
          title: 'العناوين',
          subtitle: 'إدارة عناوين المتجر والتوصيل',
          onTap: () => onNavigate('العناوين'),
        ),
        ProfileMenuTile(
          icon: Icons.help_outline_rounded,
          title: 'المساعدة والدعم',
          subtitle: 'الأسئلة الشائعة والتواصل مع الدعم',
          onTap: () => onNavigate('المساعدة والدعم'),
        ),
        const SizedBox(height: 15),
        OutlinedButton.icon(
          onPressed: () => showDialog<void>(
            context: context,
            builder: (dialogContext) => AlertDialog(
              title: const Text('تسجيل الخروج'),
              content: const Text('هل تريد العودة إلى شاشة تسجيل الدخول؟'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(dialogContext),
                  child: const Text('إلغاء'),
                ),
                FilledButton(
                  onPressed: () {
                    Navigator.pop(dialogContext);
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (_) => const AuthScreen()),
                      (_) => false,
                    );
                  },
                  child: const Text('تسجيل الخروج'),
                ),
              ],
            ),
          ),
          icon: const Icon(Icons.logout_rounded, color: danger),
          label: const Text('تسجيل الخروج',
            style: TextStyle(color: danger)),
          style: OutlinedButton.styleFrom(
            minimumSize: const Size(48, 52),
            side: const BorderSide(color: Color(0xFFF1CECB)),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
          ),
        ),
      ],
    ),
  );
}

class ProfileMenuTile extends StatelessWidget {
  final IconData icon;
  final String title, subtitle;
  final VoidCallback onTap;

  const ProfileMenuTile({
    super.key, required this.icon, required this.title,
    required this.subtitle, required this.onTap,
  });

  @override
  Widget build(BuildContext context) => Container(
    margin: const EdgeInsets.only(bottom: 9),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(17),
      border: Border.all(color: line),
    ),
    child: ListTile(
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 5),
      leading: Container(
        width: 43, height: 43,
        decoration: BoxDecoration(
          color: const Color(0xFFEAF4FC),
          borderRadius: BorderRadius.circular(13),
        ),
        child: Icon(icon, color: blue),
      ),
      title: Text(title, style: const TextStyle(
        color: navy, fontWeight: FontWeight.w800, fontSize: 13,
      )),
      subtitle: Padding(
        padding: const EdgeInsets.only(top: 4),
        child: Text(subtitle, style: const TextStyle(
          color: muted, fontSize: 10,
        )),
      ),
      trailing: const Icon(Icons.chevron_left_rounded, color: muted),
    ),
  );
}

class UtilityPage extends StatelessWidget {
  final String title;
  const UtilityPage({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    final isStore = title == 'معلومات المتجر';
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: line),
            ),
            child: Column(
              children: [
                const BrandMark(size: 58),
                const SizedBox(height: 14),
                Text(title, style: const TextStyle(
                  color: navy, fontWeight: FontWeight.w900, fontSize: 18,
                )),
                const SizedBox(height: 7),
                const Text(
                  'هذه واجهة أولية جاهزة للتطوير وربط بياناتها لاحقًا.',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: muted, height: 1.7, fontSize: 12),
                ),
              ],
            ),
          ),
          const SizedBox(height: 18),
          if (isStore) ...[
            const SectionLabel('بيانات النشاط التجاري'),
            const SizedBox(height: 12),
            const _ReadOnlyInfo(label: 'اسم المتجر', value: 'متجر النخبة'),
            const _ReadOnlyInfo(label: 'نوع النشاط', value: 'متجر تجزئة'),
            const _ReadOnlyInfo(label: 'المدينة', value: 'غير محددة'),
            const _ReadOnlyInfo(label: 'عنوان المتجر', value: 'لم تتم إضافة عنوان'),
            const _ReadOnlyInfo(label: 'رقم السجل التجاري', value: 'غير مضاف'),
            const SizedBox(height: 10),
            FilledButton.icon(
              onPressed: () => showToast(context,
                'نموذج تعديل البيانات سيُربط لاحقًا.'),
              icon: const Icon(Icons.edit_outlined),
              label: const Text('تعديل بيانات المتجر'),
            ),
          ] else
            const EmptyState(
              icon: Icons.construction_rounded,
              title: 'هذه الصفحة قيد التجهيز',
              subtitle: 'تم إعداد مكان الواجهة لإكمالها في مرحلة لاحقة.',
            ),
        ],
      ),
    );
  }
}

class _ReadOnlyInfo extends StatelessWidget {
  final String label, value;
  const _ReadOnlyInfo({required this.label, required this.value});

  @override
  Widget build(BuildContext context) => Container(
    margin: const EdgeInsets.only(bottom: 9),
    padding: const EdgeInsets.all(14),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(15),
      border: Border.all(color: line),
    ),
    child: Row(children: [
      Expanded(child: Text(label,
        style: const TextStyle(color: muted, fontSize: 12))),
      const SizedBox(width: 10),
      Flexible(child: Text(value, textAlign: TextAlign.end,
        style: const TextStyle(
          color: navy, fontSize: 12, fontWeight: FontWeight.w800,
        ))),
    ]),
  );
}

// ------------------------- مساعد الذكاء الاصطناعي -------------------------

class ChatMessage {
  final String text;
  final bool fromUser;
  const ChatMessage(this.text, {required this.fromUser});
}

class AiChatScreenTab extends StatefulWidget {
  const AiChatScreenTab({super.key});
  @override
  State<AiChatScreenTab> createState() => _AiChatScreenTabState();
}

class _AiChatScreenTabState extends State<AiChatScreenTab> {
  final controller = TextEditingController();
  final scroll = ScrollController();
  final messages = <ChatMessage>[];
  bool busy = false;
  String? error;

  @override
  void dispose() {
    controller.dispose();
    scroll.dispose();
    super.dispose();
  }

  Future<void> send([String? preset]) async {
    final text = (preset ?? controller.text).trim();
    if (text.isEmpty || busy) return;
    controller.clear();

    final history = messages.map((message) => {
      'role': message.fromUser ? 'user' : 'assistant',
      'content': message.text,
    }).toList();

    setState(() {
      messages.add(ChatMessage(text, fromUser: true));
      busy = true;
      error = null;
    });
    _toBottom();

    try {
      final response = await http.post(
        Uri.parse('$apiBaseUrl/api/chat'),
        headers: const {'Content-Type': 'application/json'},
        body: jsonEncode({'message': text, 'history': history}),
      ).timeout(const Duration(seconds: 75));

      dynamic data;
      try {
        data = jsonDecode(response.body);
      } on FormatException {
        throw Exception('وصل رد غير مفهوم من الخادم.');
      }

      if (response.statusCode < 200 || response.statusCode >= 300) {
        final message = data is Map
            ? (data['error'] ?? 'تعذّر الاتصال بخدمة الذكاء الاصطناعي.')
            : 'تعذّر الاتصال بخدمة الذكاء الاصطناعي.';
        throw Exception(message.toString());
      }

      final answer = data is Map ? (data['reply'] ?? '').toString().trim() : '';
      if (answer.isEmpty) {
        throw Exception('وصل رد فارغ من خدمة الذكاء الاصطناعي.');
      }
      if (mounted) {
        setState(() => messages.add(ChatMessage(answer, fromUser: false)));
      }
    } catch (exception) {
      if (mounted) setState(() => error = _friendlyError(exception));
    } finally {
      if (mounted) setState(() => busy = false);
      _toBottom();
    }
  }

  String _friendlyError(Object exception) {
    final message = exception.toString();
    if (message.contains('SocketException') ||
        message.contains('Failed host lookup') ||
        message.contains('Connection refused')) {
      return 'تعذّر الوصول إلى الخادم. تحقق من اتصال الإنترنت.';
    }
    if (message.contains('TimeoutException')) {
      return 'استغرق الرد وقتًا أطول من المتوقع. حاول مرة أخرى.';
    }
    return message.replaceFirst('Exception: ', '');
  }

  void _toBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted || !scroll.hasClients) return;
      scroll.animateTo(
        scroll.position.maxScrollExtent + 160,
        duration: const Duration(milliseconds: 280),
        curve: Curves.easeOut,
      );
    });
  }

  void _newChat() {
    if (busy) return;
    setState(() {
      messages.clear();
      error = null;
    });
  }

  @override
  Widget build(BuildContext context) => Column(
    children: [
      Container(
        width: double.infinity,
        padding: const EdgeInsets.fromLTRB(19, 17, 19, 21),
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            colors: [navy, navy2],
          ),
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(26)),
        ),
        child: Row(children: [
          Container(
            width: 46, height: 46,
            decoration: BoxDecoration(
              gradient: const LinearGradient(colors: [cyan, blue]),
              borderRadius: BorderRadius.circular(15),
            ),
            child: const Icon(Icons.auto_awesome_rounded,
              color: Colors.white, size: 25),
          ),
          const SizedBox(width: 12),
          const Expanded(child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('NATCO AI', style: TextStyle(
                fontWeight: FontWeight.w900, letterSpacing: 1.1,
                fontSize: 17, color: Colors.white,
              )),
              SizedBox(height: 4),
              Text('مساعد التاجر الذكي',
                style: TextStyle(fontSize: 11, color: Color(0xFFBBD5EA))),
            ],
          )),
          IconButton(
            tooltip: 'محادثة جديدة',
            onPressed: busy ? null : _newChat,
            icon: const Icon(Icons.add_comment_outlined, color: Colors.white),
          ),
        ]),
      ),
      Expanded(
        child: messages.isEmpty
            ? _welcome()
            : ListView.builder(
                controller: scroll,
                padding: const EdgeInsets.fromLTRB(15, 18, 15, 15),
                itemCount: messages.length + (busy ? 1 : 0),
                itemBuilder: (context, index) {
                  if (index == messages.length) return const _TypingBubble();
                  return _MessageBubble(message: messages[index]);
                },
              ),
      ),
      if (error != null)
        Container(
          margin: const EdgeInsets.fromLTRB(12, 0, 12, 8),
          padding: const EdgeInsets.all(11),
          decoration: BoxDecoration(
            color: const Color(0xFFFFF1F0),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: const Color(0xFFFFD5D1)),
          ),
          child: Row(children: [
            const Icon(Icons.error_outline, color: danger),
            const SizedBox(width: 8),
            Expanded(child: Text(error!, style: const TextStyle(
              color: Color(0xFF8D3029), fontSize: 11, height: 1.5,
            ))),
            IconButton(
              onPressed: busy ? null : () {
                if (messages.isNotEmpty && messages.last.fromUser) {
                  send(messages.last.text);
                }
              },
              icon: const Icon(Icons.refresh_rounded, color: danger),
            ),
          ]),
        ),
      Container(
        padding: const EdgeInsets.fromLTRB(12, 10, 12, 12),
        decoration: const BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Color(0x1007182B), blurRadius: 18,
              offset: Offset(0, -4),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Expanded(child: TextField(
              controller: controller,
              minLines: 1,
              maxLines: 4,
              textInputAction: TextInputAction.send,
              onSubmitted: (_) => send(),
              decoration: const InputDecoration(
                hintText: 'اكتب سؤالك هنا...',
                prefixIcon: Icon(Icons.chat_bubble_outline_rounded,
                  color: muted, size: 21),
              ),
            )),
            const SizedBox(width: 9),
            Container(
              height: 52, width: 52,
              decoration: BoxDecoration(
                gradient: const LinearGradient(colors: [blue, Color(0xFF0D55C7)]),
                borderRadius: BorderRadius.circular(17),
              ),
              child: IconButton(
                onPressed: busy ? null : () => send(),
                icon: busy
                    ? const SizedBox(
                        width: 20, height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2, color: Colors.white,
                        ),
                      )
                    : const Icon(Icons.arrow_upward_rounded,
                        color: Colors.white),
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
        const Text('كيف أستطيع مساعدتك؟', style: TextStyle(
          color: navy, fontSize: 19, fontWeight: FontWeight.w900,
        )),
        const SizedBox(height: 6),
        const Text('اختر موضوعًا للبدء أو اكتب سؤالك مباشرة.',
          style: TextStyle(color: muted, fontSize: 12, height: 1.6)),
        const SizedBox(height: 17),
        _suggestion(Icons.trending_up_rounded,
          'كيف أزيد مبيعات متجري؟',
          'ضع خطة عملية لرفع المبيعات خلال 30 يومًا.'),
        _suggestion(Icons.campaign_outlined,
          'اكتب إعلانًا لمنتج',
          'اكتب نصًا تسويقيًا جذابًا ومناسبًا للتجزئة.'),
        _suggestion(Icons.support_agent_rounded,
          'الرد على عميل غاضب',
          'اقترح ردًا مهنيًا وهادئًا يحافظ على العميل.'),
      ],
    ),
  );

  Widget _suggestion(IconData icon, String title, String prompt) => Padding(
    padding: const EdgeInsets.only(bottom: 10),
    child: Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(17),
      child: InkWell(
        onTap: busy ? null : () => send(prompt),
        borderRadius: BorderRadius.circular(17),
        child: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(17),
            border: Border.all(color: line),
          ),
          child: Row(children: [
            Container(
              width: 42, height: 42,
              decoration: BoxDecoration(
                color: const Color(0xFFEAF4FC),
                borderRadius: BorderRadius.circular(13),
              ),
              child: Icon(icon, color: blue),
            ),
            const SizedBox(width: 12),
            Expanded(child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(
                  color: navy, fontWeight: FontWeight.w800, fontSize: 12,
                )),
                const SizedBox(height: 4),
                Text(prompt, style: const TextStyle(
                  color: muted, fontSize: 10, height: 1.5,
                )),
              ],
            )),
            const Icon(Icons.arrow_back_ios_new_rounded,
              size: 13, color: muted),
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
    final isUser = message.fromUser;
    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.sizeOf(context).width * .84,
        ),
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: isUser ? navy2 : Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(18),
            topRight: const Radius.circular(18),
            bottomLeft: Radius.circular(isUser ? 18 : 4),
            bottomRight: Radius.circular(isUser ? 4 : 18),
          ),
          border: isUser ? null : Border.all(color: line),
        ),
        child: SelectableText(message.text, style: TextStyle(
          color: isUser ? Colors.white : navy,
          height: 1.7, fontSize: 13,
        )),
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
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: line),
        borderRadius: BorderRadius.circular(16),
      ),
      child: const Row(mainAxisSize: MainAxisSize.min, children: [
        SizedBox(width: 14, height: 14,
          child: CircularProgressIndicator(strokeWidth: 2)),
        SizedBox(width: 10),
        Text('المساعد يكتب الرد...', style: TextStyle(
          color: muted, fontSize: 12,
        )),
      ]),
    ),
  );
}

// ------------------------- عناصر تصميم مشتركة -------------------------

class PageFrame extends StatelessWidget {
  final String title, subtitle;
  final Widget child;
  final Widget? trailing;

  const PageFrame({
    super.key,
    required this.title,
    required this.subtitle,
    required this.child,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) => CustomScrollView(
    slivers: [
      SliverToBoxAdapter(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(18, 18, 18, 25),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(children: [
                Expanded(child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: const TextStyle(
                      fontSize: 24, fontWeight: FontWeight.w900, color: navy,
                    )),
                    const SizedBox(height: 5),
                    Text(subtitle, style: const TextStyle(
                      color: muted, fontSize: 11, height: 1.5,
                    )),
                  ],
                )),
                if (trailing != null) trailing!,
              ]),
              const SizedBox(height: 21),
              child,
            ],
          ),
        ),
      ),
    ],
  );
}

class SectionLabel extends StatelessWidget {
  final String text;
  const SectionLabel(this.text, {super.key});

  @override
  Widget build(BuildContext context) => Text(text, style: const TextStyle(
    color: navy, fontSize: 14, fontWeight: FontWeight.w900,
  ));
}

class SectionHeading extends StatelessWidget {
  final String title;
  final String? actionText;
  final VoidCallback? onAction;

  const SectionHeading({
    super.key, required this.title, this.actionText, this.onAction,
  });

  @override
  Widget build(BuildContext context) => Row(children: [
    Expanded(child: SectionLabel(title)),
    if (actionText != null)
      TextButton(
        onPressed: onAction,
        style: TextButton.styleFrom(
          foregroundColor: blue,
          padding: const EdgeInsets.symmetric(horizontal: 4),
        ),
        child: Text(actionText!, style: const TextStyle(
          fontSize: 11, fontWeight: FontWeight.w800,
        )),
      ),
  ]);
}

class ProductListTile extends StatelessWidget {
  final Product product;
  final VoidCallback onTap, onAdd;

  const ProductListTile({
    super.key,
    required this.product,
    required this.onTap,
    required this.onAdd,
  });

  @override
  Widget build(BuildContext context) => Material(
    color: Colors.white,
    borderRadius: BorderRadius.circular(19),
    child: InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(19),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(19),
          border: Border.all(color: line),
        ),
        child: Row(children: [
          Container(
            width: 72, height: 78,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFFEAF4FC), Color(0xFFF6FAFF)],
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
              ),
              borderRadius: BorderRadius.circular(15),
            ),
            child: Icon(product.icon, size: 34, color: blue),
          ),
          const SizedBox(width: 12),
          Expanded(child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(product.name, maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: navy, fontSize: 12, fontWeight: FontWeight.w900,
                )),
              const SizedBox(height: 5),
              Text(product.category, style: const TextStyle(
                color: muted, fontSize: 10,
              )),
              const SizedBox(height: 7),
              Text(_money(product.price), style: const TextStyle(
                color: blue, fontSize: 13, fontWeight: FontWeight.w900,
              )),
              const SizedBox(height: 5),
              Text(
                product.stock <= 5
                    ? 'المتبقي ${product.stock} فقط'
                    : 'متوفر: ${product.stock}',
                style: TextStyle(
                  color: product.stock <= 5 ? const Color(0xFFD99217) : teal,
                  fontSize: 10, fontWeight: FontWeight.w700,
                ),
              ),
            ],
          )),
          const SizedBox(width: 6),
          IconButton.filledTonal(
            tooltip: 'إضافة للسلة',
            onPressed: product.stock > 0 ? onAdd : null,
            icon: const Icon(Icons.add_shopping_cart_rounded, size: 19),
            style: IconButton.styleFrom(
              foregroundColor: blue,
              backgroundColor: const Color(0xFFEAF4FC),
            ),
          ),
        ]),
      ),
    ),
  );
}

class ProductMiniCard extends StatelessWidget {
  final Product product;
  final VoidCallback onTap;

  const ProductMiniCard({
    super.key, required this.product, required this.onTap,
  });

  @override
  Widget build(BuildContext context) => Material(
    color: Colors.white,
    borderRadius: BorderRadius.circular(19),
    child: InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(19),
      child: Container(
        padding: const EdgeInsets.all(11),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(19),
          border: Border.all(color: line),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(child: Stack(
              children: [
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFFEAF4FC), Color(0xFFF8FBFF)],
                    ),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Icon(product.icon, size: 43, color: blue),
                ),
                Positioned(
                  top: 7, right: 7,
                  child: _Pill(
                    text: product.stock <= 5 ? 'مخزون منخفض' : 'متاح',
                    color: product.stock <= 5
                        ? const Color(0xFFD99217) : teal,
                    background: Colors.white,
                  ),
                ),
              ],
            )),
            const SizedBox(height: 9),
            Text(product.name, maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: navy, fontWeight: FontWeight.w800, fontSize: 11,
              )),
            const SizedBox(height: 5),
            Text(_money(product.price), style: const TextStyle(
              color: blue, fontSize: 12, fontWeight: FontWeight.w900,
            )),
          ],
        ),
      ),
    ),
  );
}

class StatusPill extends StatelessWidget {
  final String status;
  final bool large;
  const StatusPill({super.key, required this.status, this.large = false});

  @override
  Widget build(BuildContext context) {
    final Color color;
    final Color background;
    if (status == 'تم الشحن') {
      color = const Color(0xFF187A5B);
      background = const Color(0xFFE2F7EF);
    } else if (status == 'قيد التجهيز') {
      color = const Color(0xFFB77912);
      background = const Color(0xFFFFF2D8);
    } else {
      color = blue;
      background = const Color(0xFFEAF4FC);
    }
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: large ? 13 : 9, vertical: large ? 8 : 6,
      ),
      decoration: BoxDecoration(
        color: background, borderRadius: BorderRadius.circular(30),
      ),
      child: Text(status, style: TextStyle(
        color: color,
        fontSize: large ? 12 : 9,
        fontWeight: FontWeight.w900,
      )),
    );
  }
}

class _Pill extends StatelessWidget {
  final String text;
  final Color color, background;
  const _Pill({
    required this.text, required this.color, required this.background,
  });

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 6),
    decoration: BoxDecoration(
      color: background,
      borderRadius: BorderRadius.circular(30),
      border: Border.all(color: line),
    ),
    child: Text(text, style: TextStyle(
      color: color, fontSize: 9, fontWeight: FontWeight.w900,
    )),
  );
}

class InfoTile extends StatelessWidget {
  final IconData icon;
  final String label, value;

  const InfoTile({
    super.key, required this.icon, required this.label, required this.value,
  });

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(14),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      border: Border.all(color: line),
    ),
    child: Row(children: [
      Icon(icon, color: blue, size: 20),
      const SizedBox(width: 11),
      Expanded(child: Text(label, style: const TextStyle(
        color: muted, fontSize: 11,
      ))),
      Flexible(child: Text(value, textAlign: TextAlign.end,
        style: const TextStyle(
          color: navy, fontSize: 11, fontWeight: FontWeight.w800,
        ))),
    ]),
  );
}

class _PriceRow extends StatelessWidget {
  final String label, value;
  const _PriceRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) => Row(children: [
    Text(label, style: const TextStyle(color: muted, fontSize: 12)),
    const Spacer(),
    Text(value, style: const TextStyle(
      color: navy, fontSize: 12, fontWeight: FontWeight.w800,
    )),
  ]);
}

class EmptyState extends StatelessWidget {
  final IconData icon;
  final String title, subtitle;
  final String? actionLabel;
  final VoidCallback? onAction;

  const EmptyState({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    this.actionLabel,
    this.onAction,
  });

  @override
  Widget build(BuildContext context) => Container(
    width: double.infinity,
    padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 30),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(22),
      border: Border.all(color: line),
    ),
    child: Column(children: [
      Container(
        width: 68, height: 68,
        decoration: BoxDecoration(
          color: const Color(0xFFEAF4FC),
          borderRadius: BorderRadius.circular(22),
        ),
        child: Icon(icon, color: blue, size: 31),
      ),
      const SizedBox(height: 15),
      Text(title, textAlign: TextAlign.center, style: const TextStyle(
        color: navy, fontSize: 15, fontWeight: FontWeight.w900,
      )),
      const SizedBox(height: 7),
      Text(subtitle, textAlign: TextAlign.center, style: const TextStyle(
        color: muted, fontSize: 11, height: 1.7,
      )),
      if (actionLabel != null && onAction != null) ...[
        const SizedBox(height: 17),
        FilledButton(onPressed: onAction, child: Text(actionLabel!)),
      ],
    ]),
  );
}

String _money(num value) => '${value.toStringAsFixed(0)} ر.ي';

void showToast(BuildContext context, String message) {
  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(SnackBar(
      content: Text(message),
      behavior: SnackBarBehavior.floating,
      margin: const EdgeInsets.all(12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
    ));
}
