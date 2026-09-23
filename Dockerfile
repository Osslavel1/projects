FROM node:18-bullseye

# تحديث مستودعات النظام وضبطها للإصدارات المستقرة
RUN sed -i 's/deb.debian.org/archive.debian.org/g' /etc/apt/sources.list && \
    sed -i 's/security.debian.org/archive.debian.org/g' /etc/apt/sources.list && \
    sed -i '/buster-updates/d' /etc/apt/sources.list || true

# تثبيت أدوات النظام المطلوبة لـ node-gyp و ffi-napi
RUN apt-get update --allow-insecure-repositories || apt-get update && apt-get install -y --allow-unauthenticated \
    python3 \
    make \
    g++ \
    build-essential \
    libffi-dev \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app

COPY package.json ./

# تثبيت الحزم وتجميعها
RUN npm install --build-from-source

COPY . .

EXPOSE 3000

CMD ["node", "ssl_pinning_bypass.js"]
