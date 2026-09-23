FROM node:18-bullseye

# تثبيت أدوات النظام الأساسية ومكتبات التجميع الضرورية لـ node-gyp و ffi-napi
RUN apt-get update && apt-get install -y \
    python3 \
    make \
    g++ \
    build-essential \
    libffi-dev \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app

# نسخ ملفات الاعتمادات أولاً
COPY package.json ./

# تثبيت الحزم مع السماح بإعادة بناء الحزم الثنائية
RUN npm install --build-from-source

# نسخ باقي ملفات المشروع
COPY . .

EXPOSE 3000

CMD ["node", "ssl_pinning_bypass.js"]
