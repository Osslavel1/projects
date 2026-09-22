# استخدام بيئة Node الرسمية المستندة إلى نظام لينكس (Debian)
FROM node:18-bullseye

# تثبيت أدوات بناء النظام الأساسية لضمان عمل مكتبات FFI والذاكرة الأصليّة بكفاءة
RUN apt-get update && apt-get install -y \
    build-essential \
    python3 \
    && rm -rf /var/lib/apt/lists/*

# تحديد مجلد العمل داخل حاوية الدوكر
WORKDIR /app

# نسخ ملفات الحزم وتثبيتها
COPY package.json ./
RUN npm install

# نسخ باقي ملفات المشروع إلى الحاوية
COPY . .

# فتح المنفذ الذي يستمع عليه السيرفر
EXPOSE 3000

# أمر تشغيل التطبيق
CMD ["node", "ssl_pinning_bypass.js"]
