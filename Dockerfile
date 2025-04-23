FROM node:20 AS build
WORKDIR /app

RUN apt-get update && apt-get install -y \
    build-essential \
    python3 \
    python3-pip \
    libvips-dev \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

COPY package.json yarn.lock ./

RUN yarn

COPY . .

RUN yarn build

FROM httpd:2.4 AS runtime
COPY --from=build /app/dist /usr/local/apache2/htdocs/eko/docs
COPY --from=build /app/dist /usr/local/apache2/htdocs/docs

# Add Apache rewrite rules
RUN echo '\
<IfModule mod_rewrite.c>\n\
    RewriteEngine On\n\
    RewriteRule ^/docs/(.*)$ /eko/docs/$1 [L,R=301]\n\
</IfModule>\n\
' >> /usr/local/apache2/conf/httpd.conf

EXPOSE 80