FROM node:22-alpine3.21 AS builder

WORKDIR /app
COPY package*.json ./
RUN npm install

COPY . .

RUN npm run build

FROM node:22-alpine3.21

WORKDIR /app

ENV NODE_ENV=production

COPY --from=builder /app/package*.json ./
COPY --from=builder /app/node_modules ./node_modules
COPY --from=builder /app/.next ./.next
COPY --from=builder /app/public ./public
COPY --from=builder /app/next.config.mjs ./next.config.mjs


CMD ["npm", "start" ]