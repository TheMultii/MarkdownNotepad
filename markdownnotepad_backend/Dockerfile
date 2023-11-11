FROM node:21

WORKDIR /app

COPY . .

RUN npm install

RUN npx prisma generate

CMD ["npm", "run", "start:dev"]