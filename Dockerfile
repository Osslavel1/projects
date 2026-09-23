FROM node:16-buster

# تحديث وتثبيت أدوات التوزيع ومكتبات النظام الحيوية لـ node-gyp
RUN apt-get update && apt-get install -y \
    python3 \
    make \
    g++ \
    build-essential \
    libffi-dev \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app

COPY package.json ./

# تثبيت الحزم مع دعم التجميع المباشر
RUN npm install --unsafe-perm --build-from-source

COPY . .

EXPOSE 3000

CMD ["node", "ssl_pinning_bypass.js"]
