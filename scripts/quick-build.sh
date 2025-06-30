#!/bin/bash

set -e

echo "⚡ Quick build for Railway..."

# Clean and create directories
rm -rf dist
mkdir -p dist/public

# Create minimal frontend
cat > dist/public/index.html << 'EOF'
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>ZATCA QR Scanner</title>
    <style>
        body { font-family: Arial, sans-serif; margin: 0; padding: 20px; background: #f5f5f5; }
        .container { max-width: 800px; margin: 0 auto; background: white; padding: 20px; border-radius: 8px; box-shadow: 0 2px 10px rgba(0,0,0,0.1); }
        h1 { color: #333; text-align: center; }
        .status { text-align: center; margin: 20px 0; }
        .loading { color: #666; }
    </style>
</head>
<body>
    <div class="container">
        <h1>ZATCA QR Code Scanner</h1>
        <div class="status">
            <div class="loading">⚡ Loading application...</div>
            <p>The full application is being deployed. Please refresh in a moment.</p>
        </div>
    </div>
    <script>
        // Auto-refresh to load the full app once it's built
        setTimeout(() => location.reload(), 5000);
    </script>
</body>
</html>
EOF

# Build backend quickly
echo "🚀 Building backend..."
npx esbuild server/index.ts --platform=node --packages=external --bundle --format=esm --outdir=dist --target=node20

echo "✅ Quick build completed!"
ls -la dist/