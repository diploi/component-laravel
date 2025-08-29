FROM dunglas/frankenphp:1-php8.2-alpine AS base

ARG FOLDER=/app

# Docker build stage
FROM base AS builder 

WORKDIR ${FOLDER}

RUN apk add --no-cache \
    git \
    curl \
    unzip \
    bash \
    && curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer \
    && mkdir -p /data/caddy/locks

RUN addgroup -g 1000 devgroup && \
adduser -u 1000 -G devgroup -s /bin/sh -D devuser

COPY --chown=devuser:devgroup . /app

RUN composer install --no-dev --optimize-autoloader --no-interaction

# Docker running stage
FROM base AS runner

WORKDIR ${FOLDER}

RUN addgroup -g 1000 devgroup && \
    adduser -u 1000 -G devgroup -s /bin/sh -D devuser \
    && mkdir -p /data/caddy/locks

COPY --from=builder --chown=devuser:devgroup /app /app 

USER devuser

EXPOSE 80

CMD ["frankenphp", "php-server"]