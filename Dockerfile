FROM node:20-alpine3.17 AS dev

WORKDIR /app

COPY package*.json .

RUN npm install

COPY . .

RUN npm run build

ENV HOST=0.0.0.0

EXPOSE 5173

CMD ["npm", "run", "dev", "--", "--host"]
# HOW TO RUN THE DEVELOPMENT BUILD
# docker build --target dev -t abbreve .
# docker run --name abbreve -p 3000:5173 abbreve

FROM nginx:alpine as final
EXPOSE 80
COPY --from=dev /app/dist/ /usr/share/nginx/html
CMD ["nginx", "-g", "daemon off;"]
# HOW TO RUN THE PRODUCTION BUILD
# docker build -t abbreve-prod .
# docker run --rm -d --name abbreve -p 8080:80 abbreve-prod
