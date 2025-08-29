# FrankenPHP Docker Development Setup

This setup provides a FrankenPHP-based Laravel development environment with hot reloading support.

## 🚀 Quick Start

### Option 1: Using the dev script (Recommended)
```bash
# Start in background (best for development)
./dev.sh compose-detach

# View logs
./dev.sh logs

# Open shell in container
./dev.sh shell

# Stop containers
./dev.sh stop
```

### Option 2: Using Docker Compose directly
```bash
# Start in background
docker-compose -f docker-compose.dev.yml up -d

# View logs
docker-compose -f docker-compose.dev.yml logs -f

# Stop
docker-compose -f docker-compose.dev.yml down
```

### Option 3: Using docker run
```bash
./docker-dev-backend.sh
```

## 🔥 Hot Reloading Features

The setup is optimized for hot reloading:

- **Volume Mounts**: Your local code is mounted to `/app` in the container
- **Excluded Volumes**: `vendor/`, `node_modules/`, `storage/`, and `bootstrap/cache` are excluded to prevent conflicts
- **Live Updates**: Changes to PHP files, routes, and configurations are reflected immediately
- **FrankenPHP**: Uses the latest FrankenPHP server for optimal performance

## 📁 Volume Mount Strategy

```
Local Directory → Container Path → Purpose
.              → /app           → Your Laravel application code
./storage      → /app/storage   → Laravel storage (logs, cache, etc.)
./bootstrap/cache → /app/bootstrap/cache → Bootstrap cache
/vendor        → /app/vendor    → Composer dependencies (excluded)
/node_modules  → /app/node_modules → Node modules (excluded)
```

## 🐳 Container Details

- **Base Image**: `dunglas/frankenphp:1-php8.2-alpine`
- **Port**: 8000 (accessible at http://localhost:8000)
- **User**: `devuser` (UID 1000, GID 1000)
- **Working Directory**: `/app`

## 🛠️ Development Commands

### Inside Container
```bash
# Access container shell
./dev.sh shell

# Run Laravel commands
php artisan migrate
php artisan make:controller ExampleController
php artisan route:list
```

### Outside Container
```bash
# View logs
./dev.sh logs

# Restart container
./dev.sh stop && ./dev.sh compose-detach

# Rebuild image
docker-compose -f docker-compose.dev.yml build --no-cache
```

## 🔧 Troubleshooting

### Port Already in Use
```bash
# Check what's using port 8000
lsof -i :8000

# Stop existing containers
./dev.sh stop
```

### Permission Issues
```bash
# Fix local permissions
sudo chown -R $(whoami):$(whoami) storage bootstrap/cache

# Rebuild container
docker-compose -f docker-compose.dev.yml build --no-cache
```

### Container Won't Start
```bash
# Check logs
docker-compose -f docker-compose.dev.yml logs

# Verify .env file exists
cp .env.example .env
```

## 📝 Environment Variables

The container automatically sets these for development:
- `APP_ENV=local`
- `APP_DEBUG=true`
- `CACHE_DRIVER=file`
- `SESSION_DRIVER=file`
- `QUEUE_DRIVER=sync`
- `DB_CONNECTION=sqlite`
- `DB_DATABASE=/app/database/database.sqlite`

## 🎯 Best Practices

1. **Use `compose-detach`** for development - it runs in background and allows you to continue using your terminal
2. **Monitor logs** with `./dev.sh logs` to see what's happening
3. **Access container shell** with `./dev.sh shell` for debugging
4. **Rebuild image** when changing Dockerfile or system dependencies
5. **Keep vendor/ excluded** - it's mounted as a volume and shouldn't be copied

## 🔄 Hot Reloading Workflow

1. Start container: `./dev.sh compose-detach`
2. Make changes to your PHP files
3. Changes are immediately available at http://localhost:8000
4. View logs: `./dev.sh logs`
5. Access container: `./dev.sh shell`
6. Stop when done: `./dev.sh stop`

Your Laravel application will automatically reload PHP files, and you'll see changes immediately without restarting the container!
