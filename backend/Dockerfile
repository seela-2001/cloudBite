FROM node:20-alpine AS builder

WORKDIR /app

COPY package*.json ./

RUN npm install
RUN npm install --omit=dev

COPY . .

EXPOSE 4000

CMD ["node", "server.js"]


#--------------------------------------
# This is the final image that will be used to run the application

FROM node:20-alpine

WORKDIR /app

COPY --from=builder /app/node_modules ./node_modules

COPY . .

EXPOSE 4000

CMD ["node", "server.js"]
