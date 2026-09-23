FROM node:18-bullseye

RUN apt-get update && apt-get install -y \
    python3 \
    make \
    g++ \
    build-essential \
    libffi-dev \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app

COPY package.json ./
RUN npm install --build-from-source

COPY . .

EXPOSE 3000

CMD ["node", "ssl_pinning_bypass.js"]
