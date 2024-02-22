FROM node:16 as builder 
WORKDIR /usr/files
COPY package.json ./
RUN npm install
COPY ./files ./files
RUN rm -rf node_modules
RUN npm ci --only=production

# Final stage
FROM alpine:latest as production
RUN apk --no-cache add nodejs ca-certificates
WORKDIR /root/
COPY --from=builder /usr/files ./
CMD ["node","files/index.js"]