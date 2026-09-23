FROM node:18-alpine

WORKDIR /app

COPY package.json ./

# استخدام التثبيت العادي بدون تجميع معقد
RUN npm install

COPY . .

EXPOSE 3000

CMD ["node", "ssl_pinning_bypass.js"]
