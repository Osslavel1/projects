import http from 'node:http';

const PORT = Number(process.env.PORT || 3000);
const OPENAI_API_KEY = process.env.OPENAI_API_KEY;
const OPENAI_MODEL = process.env.OPENAI_MODEL || 'gpt-4.1-mini';
const MAX_BODY_BYTES = 100_000;

const server = http.createServer(async (req, res) => {
  res.setHeader('Access-Control-Allow-Origin', process.env.ALLOWED_ORIGIN || '*');
  res.setHeader('Access-Control-Allow-Methods', 'POST, GET, OPTIONS');
  res.setHeader('Access-Control-Allow-Headers', 'Content-Type, Authorization');
  res.setHeader('Content-Type', 'application/json; charset=utf-8');
  if (req.method === 'OPTIONS') { res.writeHead(204); return res.end(); }
  if (req.method === 'GET' && req.url === '/health') {
    res.writeHead(200); return res.end(JSON.stringify({ ok: true, service: 'natco-merchant-ai' }));
  }
  if (req.method !== 'POST' || req.url !== '/api/chat') {
    res.writeHead(404); return res.end(JSON.stringify({ error: 'المسار غير موجود.' }));
  }
  if (!OPENAI_API_KEY) {
    res.writeHead(503); return res.end(JSON.stringify({ error: 'خدمة AI غير مهيأة: أضف OPENAI_API_KEY إلى متغيرات بيئة الخادم.' }));
  }
  try {
    let raw = '';
    for await (const chunk of req) {
      raw += chunk;
      if (Buffer.byteLength(raw) > MAX_BODY_BYTES) {
        res.writeHead(413); return res.end(JSON.stringify({ error: 'الرسالة كبيرة جدًا.' }));
      }
    }
    const body = JSON.parse(raw || '{}');
    const message = typeof body.message === 'string' ? body.message.trim() : '';
    if (!message) { res.writeHead(400); return res.end(JSON.stringify({ error: 'اكتب رسالة أولًا.' })); }
    if (message.length > 8000) { res.writeHead(413); return res.end(JSON.stringify({ error: 'الرسالة أطول من الحد المسموح.' })); }

    const history = Array.isArray(body.history) ? body.history.slice(-12).map(item => ({
      role: item?.role === 'assistant' ? 'assistant' : 'user',
      content: String(item?.content || '').slice(0, 8000),
    })) : [];
    const input = [...history, { role: 'user', content: message }];
    const aiResponse = await fetch('https://api.openai.com/v1/responses', {
      method: 'POST',
      headers: { 'Authorization': `Bearer ${OPENAI_API_KEY}`, 'Content-Type': 'application/json' },
      body: JSON.stringify({
        model: OPENAI_MODEL,
        instructions: 'أنت مساعد ذكاء اصطناعي محترف لتجار التجزئة وأصحاب الأعمال في اليمن والمنطقة العربية. أجب باللغة العربية ما لم يطلب المستخدم غير ذلك. كن عمليًا، واضحًا، منظمًا، واطرح أسئلة توضيحية عند نقص المعلومات. ساعد في التسويق والمبيعات وخدمة العملاء وإدارة المتجر والتخطيط التجاري. لا تدّعِ الوصول إلى أنظمة NATCO أو المخزون أو الأسعار أو الطلبات أو المحافظ الإلكترونية؛ لا تملك أي تكامل مباشر معها في هذه النسخة. لا تختلق حقائق أو نتائج. لا تقدم نفسك كموظف رسمي في NATCO.',
        input,
        max_output_tokens: 1000,
      }),
      signal: AbortSignal.timeout(65000),
    });
    const payload = await aiResponse.json().catch(() => ({}));
    if (!aiResponse.ok) {
      const status = aiResponse.status;
      console.error('OpenAI API error:', status, JSON.stringify(payload).slice(0, 1200));
      const message = status === 401 ? 'مفتاح OpenAI غير صحيح أو غير صالح.'
        : status === 429 ? 'تم تجاوز حد الاستخدام أو لا يوجد رصيد كافٍ في حساب AI. تحقق من الفوترة والحدود.'
        : 'تعذّر على خدمة الذكاء الاصطناعي إكمال الطلب. حاول مرة أخرى لاحقًا.';
      res.writeHead(502); return res.end(JSON.stringify({ error: message }));
    }
    const reply = (payload.output || []).flatMap(item => item.content || [])
      .filter(item => item.type === 'output_text').map(item => item.text || '').join('\n').trim();
    if (!reply) {
      res.writeHead(502); return res.end(JSON.stringify({ error: 'لم تُرجع خدمة AI نصًا. حاول مجددًا.' }));
    }
    res.writeHead(200); return res.end(JSON.stringify({ reply }));
  } catch (err) {
    console.error('Request failed:', err?.message || err);
    res.writeHead(500); return res.end(JSON.stringify({ error: 'حدث خطأ في الخادم أثناء معالجة الطلب.' }));
  }
});

server.listen(PORT, '0.0.0.0', () => console.log(`NATCO AI server listening on port ${PORT}`));

