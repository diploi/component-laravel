#!/bin/bash

echo "🚀 Laravel FrankenPHP Development Environment"
echo "=============================================="
echo ""

case "$1" in
  "compose")
    echo "🐳 Starting with Docker Compose..."
    docker-compose -f docker-compose.dev.yml up --build
    ;;
  "compose-detach")
    echo "🐳 Starting with Docker Compose (detached)..."
    docker-compose -f docker-compose.dev.yml up --build -d
    echo "✅ Container is running in background"
    echo "📝 View logs: docker-compose -f docker-compose.dev.yml logs -f"
    echo "🛑 Stop: docker-compose -f docker-compose.dev.yml down"
    ;;
  "run")
    echo "🐳 Starting with docker run..."
    ./docker-dev-backend.sh
    ;;
  "stop")
    echo "🛑 Stopping containers..."
    docker-compose -f docker-compose.dev.yml down
    docker stop php-dev 2>/dev/null || true
    docker rm php-dev 2>/dev/null || true
    echo "✅ All containers stopped"
    ;;
  "logs")
    echo "📝 Showing logs..."
    docker-compose -f docker-compose.dev.yml logs -f
    ;;
  "shell")
    echo "🐚 Opening shell in container..."
    docker exec -it laravel-dev /bin/bash
    ;;
  *)
    echo "Usage: $0 {compose|compose-detach|run|stop|logs|shell}"
    echo ""
    echo "Commands:"
    echo "  compose         - Start with docker-compose (interactive)"
    echo "  compose-detach  - Start with docker-compose (background)"
    echo "  run            - Start with docker run command"
    echo "  stop           - Stop all containers"
    echo "  logs           - Show container logs"
    echo "  shell          - Open shell in running container"
    echo ""
    echo "Recommended: Use 'compose-detach' for development with hot reloading"
    echo "Then use 'logs' to monitor output and 'shell' to access container"
    ;;
esac
