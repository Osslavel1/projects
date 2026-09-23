FROM node:18-alpine

WORKDIR /app

COPY package.json ./

# تثبيت نظيف ومباشر يتجاوز أي مشاكل في الحزم
RUN npm install --no-audit --no-fund

COPY . .

EXPOSE 3000

CMD ["node", "ssl_pinning_bypass.js"]
