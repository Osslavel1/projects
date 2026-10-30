import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

// ============================================================
// NATCO Merchant — التصميم المحدث كلياً حسب الطلب
// ============================================================

const navyDark = Color(0xFF0C192C);
const navyCard = Color(0xFF14243E);
const blueAccent = Color(0xFF1677FF);
const tealAccent = Color(0xFF14B8A6);
const bgLight = Color(0xFFF8FAFC);
const textDark = Color(0xFF0F172A);
const textMuted = Color(0xFF64748B);
const borderColor = Color(0xFFE2E8F0);
const dangerColor = Color(0xFFEF4444);

const apiBaseUrl = String.fromEnvironment(
  'AI_API_BASE_URL',
  defaultValue: 'https://site--natco-merchant-ai--mw6pjw7sw7wl.code.run',
);

void main() => runApp(const NatcoMerchantApp());

class NatcoMerchantApp extends StatelessWidget {
  const NatcoMerchantApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'NATCO Merchant',
      theme: ThemeData(
        useMaterial3: true,
        fontFamily: 'Arial',
        scaffoldBackgroundColor: bgLight,
        colorScheme: ColorScheme.fromSeed(
          seedColor: blueAccent,
          primary: blueAccent,
          surface: Colors.white,
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: bgLight,
          foregroundColor: textDark,
          elevation: 0,
          centerTitle: false,
          titleTextStyle: TextStyle(
            color: textDark, fontSize: 18, fontWeight: FontWeight.w900,
          ),
        ),
      ),
      builder: (context, child) => Directionality(
        textDirection: TextDirection.rtl,
        child: child ?? const SizedBox.shrink(),
      ),
      home: const WelcomeSplashView(),
    );
  }
}

// ------------------------- شاشة البداية (تصميم كحلي وأبيض) -------------------------

class WelcomeSplashView extends StatelessWidget {
  const WelcomeSplashView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: navyDark,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 52,
                    height: 52,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(colors: [blueAccent, tealAccent]),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: const Icon(Icons.shopping_bag_rounded, color: Colors.white, size: 28),
                  ),
                  const SizedBox(width: 12),
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('NATCO', style: TextStyle(
                        fontSize: 24, fontWeight: FontWeight.w900, color: Colors.white,
                      )),
                      Text('Merchant', style: TextStyle(fontSize: 11, color: tealAccent)),
                    ],
                  ),
                ],
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: navyCard,
                  borderRadius: BorderRadius.circular(28),
                  border: Border.all(color: Colors.white12),
                ),
                child: Column(
                  children: const [
                    Icon(Icons.devices_other_rounded, size: 70, color: tealAccent),
                    SizedBox(height: 16),
                    Text('Let’s connect with each other',
                        style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
                    SizedBox(height: 8),
                    Text('إدارة متجرك وطلباتك بذكاء وسهولة تامة عبر بوابة ناتكو.',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: textMuted, fontSize: 12)),
                  ],
                ),
              ),
              const Spacer(),
              ElevatedButton(
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (_) => const MerchantShell()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: blueAccent,
                  foregroundColor: Colors.white,
                  minimumSize: const Size(double.infinity, 54),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  textStyle: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                ),
                child: const Text('Let’s Start →'),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}

// ------------------------- هيكل المنتجات -------------------------

class Product {
  final String id, name, category, sku, description, imageUrl;
  final int stock, salesCount;
  final double price, rating;
  final List<Color> availableColors;

  const Product({
    required this.id,
    required this.name,
    required this.category,
    required this.sku,
    required this.description,
    required this.imageUrl,
    required this.stock,
    required this.salesCount,
    required this.price,
    required this.rating,
    required this.availableColors,
  });
}

const demoProducts = <Product>[
  Product(
    id: 'P-101',
    name: 'هاتف ذكي X Pro',
    category: 'هواتف',
    sku: 'NT-MOB-101',
    description: 'هاتف عملي بشاشة عالية الوضوح وأداء سريع للاستخدام اليومي المكثف.',
    imageUrl: 'https://images.unsplash.com/photo-1511709268805-7b3e0b8c7c8a?auto=format&fit=crop&w=500&q=85',
    stock: 12,
    salesCount: 130,
    price: 185000,
    rating: 4.3,
    availableColors: [Color(0xFF0C192C), Color(0xFF1677FF), Color(0xFF14B8A6)],
  ),
  Product(
    id: 'P-102',
    name: 'سماعات لاسلكية Air',
    category: 'إكسسوارات',
    sku: 'NT-AUD-102',
    description: 'سماعات لاسلكية بتصميم مريح وعلبة شحن صغيرة بطارية تدوم طويلاً.',
    imageUrl: 'https://images.unsplash.com/photo-1505740420928-5e560c06d30e?auto=format&fit=crop&w=500&q=85',
    stock: 36,
    salesCount: 83,
    price: 18500,
    rating: 4.8,
    availableColors: [Colors.white, Colors.black, Color(0xFF1677FF)],
  ),
  Product(
    id: 'P-103',
    name: 'ساعة ذكية Active',
    category: 'أجهزة ذكية',
    sku: 'NT-WAT-103',
    description: 'ساعة ذكية متطورة لمتابعة اللياقة البدنية ونبضات القلب والتنبيهات اليومية.',
    imageUrl: 'https://images.unsplash.com/photo-1523275335684-37898b6baf30?auto=format&fit=crop&w=500&q=85',
    stock: 4,
    salesCount: 254,
    price: 45000,
    rating: 4.5,
    availableColors: [Colors.black, Color(0xFF64748B)],
  ),
  Product(
    id: 'P-104',
    name: 'شاحن سريع 65 واط',
    category: 'إكسسوارات',
    sku: 'NT-CHG-104',
    description: 'شاحن سريع متعدد المنافذ بتقنية حماية الذكية وحجم مدمج للسفر.',
    imageUrl: 'https://images.unsplash.com/photo-1583394838336-acd977736f90?auto=format&fit=crop&w=500&q=85',
    stock: 21,
    salesCount: 60,
    price: 9500,
    rating: 4.1,
    availableColors: [Colors.white, Colors.black],
  ),
];

class DemoOrder {
  final String id, date, status, payment;
  final double total;
  final List<MapEntry<Product, int>> lines;

  DemoOrder(this.id, this.date, this.status, this.payment, this.total, this.lines);
}

// ------------------------- الحاوية الرئيسية (الشيل) -------------------------

class MerchantShell extends StatefulWidget {
  const MerchantShell({super.key});
  @override
  State<MerchantShell> createState() => _MerchantShellState();
}

class _MerchantShellState extends State<MerchantShell> {
  int tab = 0;
  final Map<String, int> cart = {};
  final Set<String> wishlist = {};
  final List<DemoOrder> orders = [
    DemoOrder('NT-24081', '٢٨ أكتوبر ٢٠٢٦', 'قيد التجهيز', 'الدفع عند الاستلام', 239000,
      [MapEntry(demoProducts[0], 1), MapEntry(demoProducts[3], 2)]),
  ];

  int get cartCount => cart.values.fold(0, (sum, q) => sum + q);
  double get cartTotal => cart.entries.fold(0, (sum, entry) {
    final product = demoProducts.firstWhere((p) => p.id == entry.key);
    return sum + product.price * entry.value;
  });

  void add(Product product, [int count = 1]) {
    setState(() => cart[product.id] = (cart[product.id] ?? 0) + count);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('تمت الإضافة إلى السلة بنجاح'), duration: Duration(seconds: 1)),
    );
  }

  void toggleWishlist(Product product) {
    setState(() {
      if (wishlist.contains(product.id)) {
        wishlist.remove(product.id);
      } else {
        wishlist.add(product.id);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final pages = <Widget>[
      DashboardPage(onProduct: _openProduct, onAdd: add, wishlist: wishlist, onToggleWishlist: toggleWishlist),
      CatalogPage(onOpen: _openProduct, onAdd: add, wishlist: wishlist, onToggleWishlist: toggleWishlist),
      const AiChatScreenTab(),
      OrdersPage(orders: orders),
      ProfilePage(),
    ];

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(64),
        child: AppBar(
          title: Row(
            children: [
              Expanded(
                child: Container(
                  height: 40,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: borderColor),
                  ),
                  child: TextField(
                    decoration: const InputDecoration(
                      hintText: 'ابحث في الكتالوج...',
                      hintStyle: TextStyle(fontSize: 11, color: textMuted),
                      prefixIcon: Icon(Icons.search_rounded, size: 18, color: textMuted),
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(vertical: 10),
                    ),
                    onSubmitted: (_) => setState(() => tab = 1),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              // المفضلة
              IconButton(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (_) => WishlistScreen(
                    wishlist: wishlist, onOpen: _openProduct, onAdd: add, onToggleWishlist: toggleWishlist,
                  )));
                },
                icon: Badge(
                  isLabelVisible: wishlist.isNotEmpty,
                  label: Text('${wishlist.length}'),
                  child: const Icon(Icons.favorite_rounded, color: dangerColor, size: 20),
                ),
              ),
              // السلة
              IconButton(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (_) => CartScreenModal(
                    cart: cart, total: cartTotal, onQty: (p, q) => setState(() {
                      if (q <= 0) cart.remove(p.id); else cart[p.id] = q;
                    }),
                  )));
                },
                icon: Badge(
                  isLabelVisible: cartCount > 0,
                  label: Text('$cartCount'),
                  child: const Icon(Icons.shopping_bag_outlined, color: textDark, size: 20),
                ),
              ),
            ],
          ),
        ),
      ),
      body: SafeArea(child: IndexedStack(index: tab, children: pages)),
      bottomNavigationBar: NavigationBar(
        selectedIndex: tab,
        onDestinationSelected: (i) => setState(() => tab = i),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.grid_view_rounded), label: 'الرئيسية'),
          NavigationDestination(icon: Icon(Icons.category_rounded), label: 'الأقسام'),
          NavigationDestination(icon: Icon(Icons.auto_awesome_rounded), label: 'المساعد الذكي'),
          NavigationDestination(icon: Icon(Icons.receipt_long_rounded), label: 'الطلبات'),
          NavigationDestination(icon: Icon(Icons.person_outline_rounded), label: 'حسابي'),
        ],
      ),
    );
  }

  void _openProduct(Product product) {
    Navigator.push(context, MaterialPageRoute(
      builder: (_) => ProductDetailsPage(
        product: product,
        onAdd: (qty) => add(product, qty),
        isFavorite: wishlist.contains(product.id),
        onToggleWishlist: () => toggleWishlist(product),
        onOpenRelated: _openProduct,
      ),
    ));
  }
}

// ------------------------- الشاشة الرئيسية (منظمة ونظيفة بدون مبيعات أو طلبات) -------------------------

class DashboardPage extends StatelessWidget {
  final ValueChanged<Product> onProduct;
  final ValueChanged<Product> onAdd;
  final Set<String> wishlist;
  final ValueChanged<Product> onToggleWishlist;

  const DashboardPage({
    super.key,
    required this.onProduct,
    required this.onAdd,
    required this.wishlist,
    required this.onToggleWishlist,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // بانر ترويجي عصري
          Container(
            height: 140,
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              gradient: const LinearGradient(colors: [navyDark, navyCard]),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Text('تشكيلة منتجات ناتكو الجديدة',
                          style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold)),
                      SizedBox(height: 8),
                      Text('اكتشف أحدث العروض والتقنيات المتاحة للمتاجر.',
                          style: TextStyle(color: textMuted, fontSize: 11)),
                    ],
                  ),
                ),
                const Icon(Icons.storefront_rounded, size: 60, color: tealAccent),
              ],
            ),
          ),
          const SizedBox(height: 20),
          const Text('المنتجات المميزة', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w900, color: textDark)),
          const SizedBox(height: 12),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: demoProducts.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 0.75,
            ),
            itemBuilder: (_, i) => ProductCard(
              product: demoProducts[i],
              onTap: () => onProduct(demoProducts[i]),
              onAdd: () => onAdd(demoProducts[i]),
              isFavorite: wishlist.contains(demoProducts[i].id),
              onToggleWishlist: () => onToggleWishlist(demoProducts[i]),
            ),
          ),
        ],
      ),
    );
  }
}

// ------------------------- قسم الأقسام / الكتالوج المرتب -------------------------

class CatalogPage extends StatefulWidget {
  final ValueChanged<Product> onOpen;
  final ValueChanged<Product> onAdd;
  final Set<String> wishlist;
  final ValueChanged<Product> onToggleWishlist;

  const CatalogPage({
    super.key,
    required this.onOpen,
    required this.onAdd,
    required this.wishlist,
    required this.onToggleWishlist,
  });

  @override
  State<CatalogPage> createState() => _CatalogPageState();
}

class _CatalogPageState extends State<CatalogPage> {
  String selectedCategory = 'الكل';

  @override
  Widget build(BuildContext context) {
    final categories = ['الكل', 'هواتف', 'إكسسوارات', 'أجهزة ذكية'];
    final filtered = selectedCategory == 'الكل'
        ? demoProducts
        : demoProducts.where((p) => p.category == selectedCategory).toList();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text('الأقسام والكتالوج', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: textDark)),
          const SizedBox(height: 12),
          SizedBox(
            height: 40,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: categories.length,
              separatorBuilder: (_, __) => const SizedBox(width: 8),
              itemBuilder: (_, i) {
                final cat = categories[i];
                final isSelected = selectedCategory == cat;
                return ChoiceChip(
                  label: Text(cat),
                  selected: isSelected,
                  onSelected: (_) => setState(() => selectedCategory = cat),
                  selectedColor: blueAccent,
                  labelStyle: TextStyle(
                    color: isSelected ? Colors.white : textDark,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 16),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: filtered.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 0.75,
            ),
            itemBuilder: (_, i) => ProductCard(
              product: filtered[i],
              onTap: () => widget.onOpen(filtered[i]),
              onAdd: () => widget.onAdd(filtered[i]),
              isFavorite: widget.wishlist.contains(filtered[i].id),
              onToggleWishlist: () => widget.onToggleWishlist(filtered[i]),
            ),
          ),
        ],
      ),
    );
  }
}

// ------------------------- تصميم بطاقة المنتج -------------------------

class ProductCard extends StatelessWidget {
  final Product product;
  final VoidCallback onTap, onAdd, onToggleWishlist;
  final bool isFavorite;

  const ProductCard({
    super.key,
    required this.product,
    required this.onTap,
    required this.onAdd,
    required this.isFavorite,
    required this.onToggleWishlist,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: borderColor),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Stack(
                children: [
                  Center(child: Image.network(product.imageUrl, fit: BoxFit.contain)),
                  Positioned(
                    top: 0,
                    right: 0,
                    child: IconButton(
                      icon: Icon(
                        isFavorite ? Icons.favorite_rounded : Icons.favorite_border_rounded,
                        color: isFavorite ? dangerColor : textMuted,
                        size: 18,
                      ),
                      onPressed: onToggleWishlist,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            Text(product.name, maxLines: 1, overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 11, color: textDark)),
            const SizedBox(height: 2),
            Text('${product.price.toStringAsFixed(0)} ر.ي',
                style: const TextStyle(color: blueAccent, fontWeight: FontWeight.w900, fontSize: 11)),
            const SizedBox(height: 4),
            Row(
              children: [
                Text('${product.salesCount} Sales', style: const TextStyle(color: textMuted, fontSize: 9)),
                const Spacer(),
                const Icon(Icons.star_rounded, color: Colors.amber, size: 12),
                Text('${product.rating}', style: const TextStyle(fontSize: 9, fontWeight: FontWeight.bold)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// ------------------------- تفاصيل المنتج (الألوان في الأسفل + بضائع ذات صلة) -------------------------

class ProductDetailsPage extends StatefulWidget {
  final Product product;
  final ValueChanged<int> onAdd;
  final bool isFavorite;
  final VoidCallback onToggleWishlist;
  final ValueChanged<Product> onOpenRelated;

  const ProductDetailsPage({
    super.key,
    required this.product,
    required this.onAdd,
    required this.isFavorite,
    required this.onToggleWishlist,
    required this.onOpenRelated,
  });

  @override
  State<ProductDetailsPage> createState() => _ProductDetailsPageState();
}

class _ProductDetailsPageState extends State<ProductDetailsPage> {
  int selectedColorIndex = 0;

  @override
  Widget build(BuildContext context) {
    final relatedProducts = demoProducts.where((p) => p.id != widget.product.id).toList();

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.product.name),
        actions: [
          IconButton(
            icon: Icon(widget.isFavorite ? Icons.favorite_rounded : Icons.favorite_border_rounded, color: dangerColor),
            onPressed: widget.onToggleWishlist,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              height: 220,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: borderColor),
              ),
              child: Center(child: Image.network(widget.product.imageUrl, height: 180, fit: BoxFit.contain)),
            ),
            const SizedBox(height: 16),
            Text(widget.product.name, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w900, color: textDark)),
            const SizedBox(height: 6),
            Text('${widget.product.price.toStringAsFixed(0)} ر.ي',
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: blueAccent)),
            const SizedBox(height: 16),
            const Text('الوصف', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: textDark)),
            const SizedBox(height: 4),
            Text(widget.product.description, style: const TextStyle(color: textMuted, fontSize: 12, height: 1.5)),
            const SizedBox(height: 20),

            // خيارات الألوان في الأسفل
            const Text('الألوان المتاحة', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: textDark)),
            const SizedBox(height: 8),
            Row(
              children: List.generate(widget.product.availableColors.length, (i) {
                final color = widget.product.availableColors[i];
                final isSelected = selectedColorIndex == i;
                return GestureDetector(
                  onTap: () => setState(() => selectedColorIndex = i),
                  child: Container(
                    margin: const EdgeInsets.only(left: 10),
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: color,
                      shape: BoxShape.circle,
                      border: Border.all(color: isSelected ? blueAccent : borderColor, width: isSelected ? 2.5 : 1),
                    ),
                  ),
                );
              }),
            ),
            const SizedBox(height: 30),

            // بضائع ذات صلة في الأسفل
            const Text('بضائع ذات صلة', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w900, color: textDark)),
            const SizedBox(height: 12),
            SizedBox(
              height: 175,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: relatedProducts.length,
                separatorBuilder: (_, __) => const SizedBox(width: 10),
                itemBuilder: (_, i) {
                  final p = relatedProducts[i];
                  return SizedBox(
                    width: 130,
                    child: InkWell(
                      onTap: () => widget.onOpenRelated(p),
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(color: borderColor),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(child: Center(child: Image.network(p.imageUrl, fit: BoxFit.contain))),
                            const SizedBox(height: 4),
                            Text(p.name, maxLines: 1, overflow: TextOverflow.ellipsis,
                                style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold)),
                            Text('${p.price.toStringAsFixed(0)} ر.ي',
                                style: const TextStyle(fontSize: 10, color: blueAccent, fontWeight: FontWeight.bold)),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: () {
                widget.onAdd(1);
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: navyDark,
                foregroundColor: Colors.white,
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
              ),
              child: const Text('إضافة إلى السلة'),
            ),
          ],
        ),
      ),
    );
  }
}

// ------------------------- نافذة السلة -------------------------

class CartScreenModal extends StatelessWidget {
  final Map<String, int> cart;
  final double total;
  final void Function(Product, int) onQty;

  const CartScreenModal({super.key, required this.cart, required this.total, required this.onQty});

  @override
  Widget build(BuildContext context) {
    final lines = cart.entries.map((e) => MapEntry(
      demoProducts.firstWhere((p) => p.id == e.key), e.value,
    )).toList();

    return Scaffold(
      appBar: AppBar(title: const Text('سلة المشتريات')),
      body: lines.isEmpty
          ? const Center(child: Text('السلة فارغة حالياً'))
          : ListView(
              padding: const EdgeInsets.all(16),
              children: [
                ...lines.map((e) => ListTile(
                  title: Text(e.key.name),
                  subtitle: Text('${e.value} × ${e.key.price.toStringAsFixed(0)} ر.ي'),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete_outline, color: dangerColor),
                    onPressed: () => onQty(e.key, 0),
                  ),
                )),
                const Divider(height: 30),
                Text('الإجمالي: ${total.toStringAsFixed(0)} ر.ي',
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('تم تأكيد الطلب بنجاح!')));
                    Navigator.pop(context);
                  },
                  child: const Text('إتمام الطلب'),
                ),
              ],
            ),
    );
  }
}

// ------------------------- نافذة المفضلة -------------------------

class WishlistScreen extends StatelessWidget {
  final Set<String> wishlist;
  final ValueChanged<Product> onOpen, onAdd, onToggleWishlist;

  const WishlistScreen({super.key, required this.wishlist, required this.onOpen, required this.onAdd, required this.onToggleWishlist});

  @override
  Widget build(BuildContext context) {
    final items = demoProducts.where((p) => wishlist.contains(p.id)).toList();
    return Scaffold(
      appBar: AppBar(title: const Text('المفضلة')),
      body: items.isEmpty
          ? const Center(child: Text('لا توجد منتجات في المفضلة'))
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: items.length,
              itemBuilder: (_, i) => ListTile(
                leading: Image.network(items[i].imageUrl, width: 40, height: 40),
                title: Text(items[i].name),
                subtitle: Text('${items[i].price.toStringAsFixed(0)} ر.ي'),
                trailing: IconButton(
                  icon: const Icon(Icons.delete_outline, color: dangerColor),
                  onPressed: () => onToggleWishlist(items[i]),
                ),
                onTap: () => onOpen(items[i]),
              ),
            ),
    );
  }
}

class OrdersPage extends StatelessWidget {
  final List<DemoOrder> orders;
  const OrdersPage({super.key, required this.orders});

  @override
  Widget build(BuildContext context) => const Center(child: Text('سجل الطلبات'));
}

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) => const Center(child: Text('حسابي'));
}

class AiChatScreenTab extends StatelessWidget {
  const AiChatScreenTab({super.key});

  @override
  Widget build(BuildContext context) => const Center(child: Text('المساعد الذكي'));
}
