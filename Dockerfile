FROM node:18-alpine

WORKDIR /usr/src/app

COPY package*.json ./

RUN npm install

COPY . .
RUN cp -n env.example .env

RUN npm run build

EXPOSE 4173

ENV HOST=0.0.0.0

CMD [ "npm", "run", "preview", "--", "--host"]