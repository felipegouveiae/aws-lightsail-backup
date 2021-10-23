FROM node:16.3-alpine3.12

WORKDIR /home/node/

COPY package.json .

RUN npm i --silent

COPY main.js .

ENTRYPOINT ["node" , "/home/node/main.js"]