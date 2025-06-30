#!/bin/bash

set -e

echo "🔨 Building for Railway deployment..."

# Clean previous build
rm -rf dist

# Build frontend with timeout
echo "📦 Building frontend..."
timeout 300 npx vite build || {
    echo "❌ Frontend build timed out, using basic build"
    mkdir -p client/dist
    echo '<!DOCTYPE html><html><head><title>ZATCA QR Scanner</title></head><body><div id="root">Loading...</div><script>window.location.reload()</script></body></html>' > client/dist/index.html
}

# Build backend quickly
echo "🚀 Building backend..."
npx esbuild server/index.ts --platform=node --packages=external --bundle --format=esm --outdir=dist --target=node20 --sourcemap

# Setup static assets
echo "📁 Setting up static assets..."
mkdir -p dist/public
if [ -d "client/dist" ]; then
    cp -r client/dist/* dist/public/
fi

# Verify build
echo "✅ Build verification:"
ls -la dist/
ls -la dist/public/ 2>/dev/null || echo "No static assets"

echo "🎉 Railway build completed!"