FROM node:18-bullseye

# تثبيت أدوات التجميع ومكتبات النظام اللازمة لتنجح حزم ffi-napi في البناء
RUN apt-get update && apt-get install -y \
    python3 \
    make \
    g++ \
    build-essential \
    libffi-dev \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app

COPY package.json ./
RUN npm install

COPY . .

EXPOSE 3000

CMD ["node", "ssl_pinning_bypass.js"]
