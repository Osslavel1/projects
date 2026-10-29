import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

const navy = Color(0xFF07182B);
const navy2 = Color(0xFF0D2B49);
const blue = Color(0xFF1677FF);
const cyan = Color(0xFF43D5F5);
const bg = Color(0xFFF4F7FB);
const muted = Color(0xFF718198);

const apiBaseUrl = String.fromEnvironment(
  'AI_API_BASE_URL',
  defaultValue: 'https://site--natco-merchant-ai--mw6pjw7sw7wl.code.run',
);

void main() => runApp(const NatcoAiApp());

class NatcoAiApp extends StatelessWidget {
  const NatcoAiApp({super.key});
  @override
  Widget build(BuildContext context) => MaterialApp(
    debugShowCheckedModeBanner: false,
    title: 'NATCO Merchant AI',
    theme: ThemeData(useMaterial3: true, fontFamily: 'Arial', scaffoldBackgroundColor: bg,
      colorScheme: ColorScheme.fromSeed(seedColor: blue),
      inputDecorationTheme: InputDecorationTheme(filled: true, fillColor: Colors.white,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(20), borderSide: BorderSide.none))),
    builder: (context, child) => Directionality(textDirection: TextDirection.rtl, child: child ?? const SizedBox()),
    home: const AiChatScreen(),
  );
}

class ChatMessage {
  final String text;
  final bool fromUser;
  const ChatMessage(this.text, {required this.fromUser});
}

class AiChatScreen extends StatefulWidget {
  const AiChatScreen({super.key});
  @override State<AiChatScreen> createState() => _AiChatScreenState();
}

class _AiChatScreenState extends State<AiChatScreen> {
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
      final response = await http.post(Uri.parse('$apiBaseUrl/api/chat'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'message': text, 'history': messages.take(messages.length - 1).toList().map((m) => {'role': m.fromUser ? 'user' : 'assistant', 'content': m.text}).toList()}),
      ).timeout(const Duration(seconds: 75));
      final data = jsonDecode(response.body);
      if (response.statusCode < 200 || response.statusCode >= 300) {
        throw Exception(data is Map ? (data['error'] ?? 'تعذّر الاتصال بخدمة الذكاء الاصطناعي.') : 'تعذّر الاتصال بخدمة الذكاء الاصطناعي.');
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
      return 'لم أستطع الوصول إلى خادم الذكاء الاصطناعي. تأكد أن الخادم يعمل وأن AI_API_BASE_URL مضبوط على عنوانه الصحيح.';
    }
    if (s.contains('TimeoutException')) return 'استغرق الرد وقتًا أطول من المتوقع. تحقق من اتصال الإنترنت ثم حاول مجددًا.';
    return s.replaceFirst('Exception: ', '');
  }

  void _toBottom() { WidgetsBinding.instance.addPostFrameCallback((_) { if (scroll.hasClients) scroll.animateTo(scroll.position.maxScrollExtent + 160, duration: const Duration(milliseconds: 280), curve: Curves.easeOut); }); }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(backgroundColor: navy, foregroundColor: Colors.white, elevation: 0,
      title: Row(children: [Container(width: 42, height: 42, decoration: BoxDecoration(gradient: const LinearGradient(colors: [cyan, blue]), borderRadius: BorderRadius.circular(14)), child: const Icon(Icons.auto_awesome_rounded, color: navy, size: 25)), const SizedBox(width: 12), const Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text('NATCO', style: TextStyle(fontWeight: FontWeight.w900, letterSpacing: 1.3, fontSize: 17)), Text('مساعد التاجر الذكي', style: TextStyle(fontSize: 12, color: Color(0xFFBBD5EA))) ]))]),
      actions: [IconButton(tooltip: 'محادثة جديدة', onPressed: busy ? null : () => setState(() { messages.clear(); error = null; }), icon: const Icon(Icons.add_comment_outlined)), const SizedBox(width: 6)]),
    body: Column(children: [
      Container(width: double.infinity, padding: const EdgeInsets.fromLTRB(20, 18, 20, 24), decoration: const BoxDecoration(gradient: LinearGradient(begin: Alignment.topRight, end: Alignment.bottomLeft, colors: [navy, navy2]), borderRadius: BorderRadius.vertical(bottom: Radius.circular(28))),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Container(padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 6), decoration: BoxDecoration(color: const Color(0x223FD5F5), borderRadius: BorderRadius.circular(30), border: Border.all(color: const Color(0x5543D5F5))), child: const Row(mainAxisSize: MainAxisSize.min, children: [Icon(Icons.circle, size: 7, color: Color(0xFF4FE3B1)), SizedBox(width: 7), Text('مساعد ذكاء اصطناعي متصل بالخادم', style: TextStyle(color: Color(0xFFD6F6FF), fontSize: 11, fontWeight: FontWeight.w600))])),
          const SizedBox(height: 17), const Text('أهلاً بك، كيف أساعدك؟', style: TextStyle(color: Colors.white, fontSize: 25, fontWeight: FontWeight.w900)),
          const SizedBox(height: 8), const Text('اسألني عن إدارة متجرك، التسويق، المبيعات، خدمة العملاء أو تحليل أفكارك التجارية.', style: TextStyle(color: Color(0xFFBBD0E2), height: 1.65, fontSize: 13)),
        ])),
      Expanded(child: messages.isEmpty ? _welcome() : ListView.builder(controller: scroll, padding: const EdgeInsets.fromLTRB(16, 20, 16, 16), itemCount: messages.length + (busy ? 1 : 0), itemBuilder: (context, i) { if (i == messages.length) return const _TypingBubble(); final m = messages[i]; return _MessageBubble(message: m); })),
      if (error != null) Container(margin: const EdgeInsets.fromLTRB(14, 0, 14, 8), padding: const EdgeInsets.all(12), decoration: BoxDecoration(color: const Color(0xFFFFF1F0), borderRadius: BorderRadius.circular(14), border: Border.all(color: const Color(0xFFFFD5D1))), child: Row(children: [const Icon(Icons.error_outline, color: Color(0xFFC43D32)), const SizedBox(width: 9), Expanded(child: Text(error!, style: const TextStyle(color: Color(0xFF8D3029), fontSize: 12, height: 1.5))), IconButton(onPressed: () => send(messages.isNotEmpty && messages.last.fromUser ? messages.last.text : null), icon: const Icon(Icons.refresh_rounded, color: Color(0xFFC43D32))) ])),
      SafeArea(top: false, child: Container(padding: const EdgeInsets.fromLTRB(12, 10, 12, 12), decoration: const BoxDecoration(color: Colors.white, boxShadow: [BoxShadow(color: Color(0x1007182B), blurRadius: 18, offset: Offset(0, -4))]), child: Row(crossAxisAlignment: CrossAxisAlignment.end, children: [Expanded(child: TextField(controller: controller, minLines: 1, maxLines: 5, textInputAction: TextInputAction.send, onSubmitted: (_) => send(), decoration: InputDecoration(hintText: 'اكتب سؤالك هنا...', hintStyle: const TextStyle(color: Color(0xFF9AA8B8), fontSize: 14), prefixIcon: const Icon(Icons.chat_bubble_outline_rounded, color: muted, size: 21), contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14), filled: true, fillColor: bg, border: OutlineInputBorder(borderRadius: BorderRadius.circular(20), borderSide: BorderSide.none), enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(20), borderSide: BorderSide.none)))), const SizedBox(width: 9), Container(height: 52, width: 52, decoration: BoxDecoration(gradient: const LinearGradient(colors: [blue, Color(0xFF0D55C7)]), borderRadius: BorderRadius.circular(18), boxShadow: const [BoxShadow(color: Color(0x33216BDB), blurRadius: 12, offset: Offset(0, 5))]), child: IconButton(onPressed: busy ? null : () => send(), icon: busy ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white)) : const Icon(Icons.arrow_upward_rounded, color: Colors.white), tooltip: 'إرسال'))]))),
    ]));

  Widget _welcome() => SingleChildScrollView(padding: const EdgeInsets.fromLTRB(18, 22, 18, 20), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
    Row(children: [const Text('ابدأ من هنا', style: TextStyle(color: navy, fontSize: 17, fontWeight: FontWeight.w900)), const Spacer(), Text('اقتراحات ذكية', style: TextStyle(color: muted, fontSize: 11))]), const SizedBox(height: 14),
    _suggestion(Icons.trending_up_rounded, 'كيف أزيد مبيعات متجري؟', 'خطة عملية لرفع المبيعات', 'أعطني خطة عملية لزيادة مبيعات متجري خلال 30 يومًا، بميزانية محدودة.'),
    _suggestion(Icons.campaign_outlined, 'اكتب إعلانًا لمنتج', 'نص تسويقي جاهز للتعديل', 'اكتب لي إعلانًا تسويقيًا جذابًا لمنتج في متجر تجزئة، واسألني عن التفاصيل الناقصة.'),
    _suggestion(Icons.support_agent_rounded, 'الرد على عميل غاضب', 'رد مهني يحافظ على العميل', 'ساعدني في كتابة رد مهني وهادئ لعميل غاضب يشتكي من تأخر طلبه.'),
    _suggestion(Icons.lightbulb_outline_rounded, 'حلّل فكرة تجارية', 'فرص ومخاطر وخطوات أولى', 'ساعدني في تقييم فكرة تجارية، وابدأ بطرح الأسئلة اللازمة لفهمها.'),
    const SizedBox(height: 14), Container(padding: const EdgeInsets.all(14), decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(18), border: Border.all(color: const Color(0xFFE4EBF3))), child: const Row(crossAxisAlignment: CrossAxisAlignment.start, children: [Icon(Icons.verified_user_outlined, color: blue), SizedBox(width: 10), Expanded(child: Text('الردود تأتي من خدمة AI فعلية عبر الخادم. لن تظهر إجابة تجريبية عند تعذّر الاتصال؛ ستظهر لك رسالة خطأ واضحة.', style: TextStyle(color: muted, fontSize: 12, height: 1.6)))])),
  ]));

  Widget _suggestion(IconData icon, String title, String subtitle, String prompt) => Padding(padding: const EdgeInsets.only(bottom: 10), child: Material(color: Colors.white, borderRadius: BorderRadius.circular(18), child: InkWell(onTap: busy ? null : () => send(prompt), borderRadius: BorderRadius.circular(18), child: Container(padding: const EdgeInsets.all(15), decoration: BoxDecoration(borderRadius: BorderRadius.circular(18), border: Border.all(color: const Color(0xFFE4EBF3))), child: Row(children: [Container(width: 43, height: 43, decoration: BoxDecoration(color: const Color(0xFFEAF3FF), borderRadius: BorderRadius.circular(14)), child: Icon(icon, color: blue)), const SizedBox(width: 12), Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(title, style: const TextStyle(color: navy, fontWeight: FontWeight.w800, fontSize: 14)), const SizedBox(height: 4), Text(subtitle, style: const TextStyle(color: muted, fontSize: 11))])), const Icon(Icons.arrow_back_ios_new_rounded, size: 15, color: muted)])))));
}

class _MessageBubble extends StatelessWidget {
  final ChatMessage message;
  const _MessageBubble({required this.message});
  @override Widget build(BuildContext context) { final user = message.fromUser; return Align(alignment: user ? Alignment.centerRight : Alignment.centerLeft, child: Container(constraints: BoxConstraints(maxWidth: MediaQuery.sizeOf(context).width * .84), margin: const EdgeInsets.only(bottom: 13), padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 13), decoration: BoxDecoration(color: user ? navy2 : Colors.white, borderRadius: BorderRadius.only(topLeft: const Radius.circular(19), topRight: const Radius.circular(19), bottomLeft: Radius.circular(user ? 19 : 5), bottomRight: Radius.circular(user ? 5 : 19)), border: user ? null : Border.all(color: const Color(0xFFE4EBF3)), boxShadow: const [BoxShadow(color: Color(0x0807182B), blurRadius: 8, offset: Offset(0, 3))]), child: SelectableText(message.text, style: TextStyle(color: user ? Colors.white : navy, height: 1.65, fontSize: 14)))); }
}

class _TypingBubble extends StatelessWidget { const _TypingBubble(); @override Widget build(BuildContext context) => Align(alignment: Alignment.centerLeft, child: Container(margin: const EdgeInsets.only(bottom: 12), padding: const EdgeInsets.symmetric(horizontal: 17, vertical: 14), decoration: BoxDecoration(color: Colors.white, border: Border.all(color: const Color(0xFFE4EBF3)), borderRadius: BorderRadius.circular(18)), child: const Row(mainAxisSize: MainAxisSize.min, children: [SizedBox(width: 15, height: 15, child: CircularProgressIndicator(strokeWidth: 2)), SizedBox(width: 10), Text('يفكر المساعد...', style: TextStyle(color: muted, fontSize: 12))]))); }
