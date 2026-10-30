import http from 'node:http';

const PORT = Number(process.env.PORT || 8080);
const GROQ_API_KEY = process.env.GROQ_API_KEY;
// استخدام نموذج Llama المجاني والسريع عبر Groq
const GROQ_MODEL = process.env.GROQ_MODEL || 'llama-3.3-70b-versatile';
const MAX_BODY_BYTES = 100_000;

const server = http.createServer(async (req, res) => {
  res.setHeader('Access-Control-Allow-Origin', process.env.ALLOWED_ORIGIN || '*');
  res.setHeader('Access-Control-Allow-Methods', 'POST, GET, OPTIONS');
  res.setHeader('Access-Control-Allow-Headers', 'Content-Type, Authorization');
  res.setHeader('Content-Type', 'application/json; charset=utf-8');
  
  if (req.method === 'OPTIONS') { res.writeHead(204); return res.end(); }
  
  if (req.method === 'GET' && req.url === '/health') {
    res.writeHead(200); 
    return res.end(JSON.stringify({ ok: true, service: 'natco-merchant-ai-groq' }));
  }
  
  if (req.method !== 'POST' || req.url !== '/api/chat') {
    res.writeHead(404); return res.end(JSON.stringify({ error: 'المسار غير موجود.' }));
  }
  
  if (!GROQ_API_KEY) {
    res.writeHead(503); return res.end(JSON.stringify({ error: 'خدمة AI غير مهيأة: أضف GROQ_API_KEY إلى متغيرات بيئة الخادم.' }));
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
    
    // تجهيز الرسائل بالصيغة المدعومة (System prompt + History + User message)
    const messages = [
      {
        role: 'system',
        content: 'أنت مساعد ذكاء اصطناعي محترف لتجار التجزئة وأصحاب الأعمال في اليمن والمنطقة العربية. أجب باللغة العربية ما لم يطلب المستخدم غير ذلك. كن عمليًا، واضحًا، منظمًا. لا تدّعِ الوصول المباشر إلى أنظمة NATCO أو المحافظ الإلكترونية.'
      },
      ...history,
      { role: 'user', content: message }
    ];
    
    // الاتصال بمنصة Groq المجانية
    const aiResponse = await fetch('https://api.groq.com/openai/v1/chat/completions', {
      method: 'POST',
      headers: { 'Authorization': `Bearer ${GROQ_API_KEY}`, 'Content-Type': 'application/json' },
      body: JSON.stringify({
        model: GROQ_MODEL,
        messages,
        max_tokens: 1000,
      }),
      signal: AbortSignal.timeout(65000),
    });
    
    const payload = await aiResponse.json().catch(() => ({}));
    if (!aiResponse.ok) {
      console.error('Groq API error:', aiResponse.status, JSON.stringify(payload));
      res.writeHead(502); 
      return res.end(JSON.stringify({ error: payload.error?.message || 'تعذّر إكمال الطلب عبر خدمة AI المجانية.' }));
    }
    
    const reply = payload.choices?.[0]?.message?.content?.trim() || '';
    if (!reply) {
      res.writeHead(502); return res.end(JSON.stringify({ error: 'لم تُرجع خدمة AI نصًا. حاول مجددًا.' }));
    }
    
    res.writeHead(200); return res.end(JSON.stringify({ reply }));
  } catch (err) {
    console.error('Request failed:', err?.message || err);
    res.writeHead(500); return res.end(JSON.stringify({ error: 'حدث خطأ في الخادم أثناء معالجة الطلب.' }));
  }
});

server.listen(PORT, '0.0.0.0', () => console.log(`NATCO Groq AI server listening on port ${PORT}`));
