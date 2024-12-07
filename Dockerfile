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

RUN npm install -g yarn

RUN yarn

COPY . .

RUN yarn build

FROM httpd:2.4 AS runtime
COPY --from=build /app/dist /usr/local/apache2/htdocs/docs
EXPOSE 80