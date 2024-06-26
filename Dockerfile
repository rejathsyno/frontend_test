FROM  node:16.15.0 as build

RUN mkdir -p /app/node_modules && chown -R node:node /app

WORKDIR /app

COPY --chown=node:node . .

USER node 

RUN npm install --force

RUN npm run build
#FROM nginx:latest
#COPY --from=build /app/build /usr/share/nginx/html
EXPOSE 80
#CMD ["nginx", "-g", "daemon off;"]
FROM caddy:2.7-alpine
COPY --from=build /app/build /home/build
COPY ./Caddyfile /etc/caddy/
CMD ["caddy", "run", "--config", "/etc/caddy/Caddyfile"]
