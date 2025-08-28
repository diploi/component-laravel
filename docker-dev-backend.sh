#!/bin/bash

echo "🐳 Building Pure Backend Laravel Development Docker image..."
echo "   No Vite, no Node.js, no frontend - just PHP/Laravel!"
docker build -f Dockerfile.dev -t php-dev .

echo "🚀 Starting Pure Backend development container..."
docker run \
  --name php-dev \
  -it \
  --rm \
  -p 8000:8000 \
  -v $(pwd):/app \
  -v /app/vendor \
  -v /app/node_modules \
  -v $(pwd)/storage:/app/storage \
  -v $(pwd)/bootstrap/cache:/app/bootstrap/cache \
  -e APP_ENV=local \
  -e APP_DEBUG=true \
  -e CACHE_DRIVER=file \
  -e SESSION_DRIVER=file \
  -e QUEUE_DRIVER=sync \
  php-dev

echo "✅ Pure Backend Laravel development environment is running!"
