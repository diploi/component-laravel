FROM dunglas/frankenphp:1-php8.4 AS base

ARG FOLDER=/app

# Docker build stage
FROM base AS builder 

WORKDIR ${FOLDER}

RUN apt-get update && apt-get install -y \
    git \
    curl \
    unzip \
    bash \
    libicu-dev \
    libpq-dev \
    && docker-php-ext-install \
    pdo_mysql \
    pdo_pgsql \
    bcmath \
    intl \
    opcache \
    && curl -sS https://getcomposer.org/installer | php \
    -- --install-dir=/usr/local/bin --filename=composer \
    && curl -fsSL https://deb.nodesource.com/setup_22.x | bash - \
    && apt-get install -y nodejs \
    && mkdir -p /data/caddy/locks \
    && rm -rf /var/lib/apt/lists/*

RUN groupadd -g 1000 devgroup && \
    useradd -u 1000 -g devgroup -m -s /bin/bash devuser

COPY --chown=devuser:devgroup . /app

RUN composer install --no-dev --optimize-autoloader --no-interaction

RUN if [ -f vite.config.js ] || [ -f vite.config.ts ]; then \
    echo "Vite config detected, building assets..." \
    && npm ci \
    && npm run build; \
    fi

# Clear config cache to ensure pod env values are loaded
RUN php artisan config:clear

# Run passport key generation if required
RUN if [ ! -d vendor/laravel/passport ]; then \
    echo "laravel/passport is not installed, skipping key generation." \
    exit 0 \
    else \
    echo "Generating Laravel Passport keys..." \
    php artisan passport:keys --force \
    && echo "✅ Passport keys generated successfully"; \
    fi

# Docker running stage
FROM base AS runner

WORKDIR ${FOLDER}

RUN apt-get update && apt-get install -y \
    libicu-dev \
    libpq-dev \
    && docker-php-ext-install \
    pdo_mysql \
    pdo_pgsql \
    bcmath \
    intl \
    opcache \
    && mkdir -p /data/caddy/locks \
    && rm -rf /var/lib/apt/lists/*

RUN groupadd -g 1000 devgroup && \
    useradd -u 1000 -g devgroup -m -s /bin/bash devuser

RUN mkdir -p /data/caddy \
    && chown -R devuser:devgroup /data/caddy

COPY --from=builder --chown=devuser:devgroup /app /app 

USER devuser

EXPOSE 80

WORKDIR ${FOLDER}/public

CMD ["frankenphp", "php-server"]