# Ubuntu Server Troubleshooting Guide

## Issue: "This site can't be reached" on 192.168.1.14:5000

This means the server isn't running properly. Let's diagnose step by step.

## Step 1: Check if the build completed successfully
```bash
# Go to your project directory
cd ~/zatscan

# Check if dist folder was created
ls -la dist/

# You should see:
# dist/
# ├── index.js       (bundled server)
# └── public/        (frontend files)
#     ├── index.html
#     ├── assets/
#     └── ...
```

## Step 2: Check if the server process is running
```bash
# Check if Node.js process is running on port 5000
sudo netstat -tlnp | grep 5000

# Or check all Node.js processes
ps aux | grep node

# Check if port 5000 is being used
sudo lsof -i :5000
```

## Step 3: Try starting the server manually with detailed output
```bash
cd ~/zatscan

# Start with verbose logging
NODE_ENV=production node dist/index.js

# If that fails, try development mode
npm run dev
```

## Step 4: Check firewall settings
```bash
# Check if firewall is blocking port 5000
sudo ufw status

# If active, allow port 5000
sudo ufw allow 5000

# Or temporarily disable firewall for testing
sudo ufw disable
```

## Step 5: Test local connection first
```bash
# On the Ubuntu VM, test if server responds locally
curl http://localhost:5000
curl http://127.0.0.1:5000

# Test the health endpoint
curl http://localhost:5000/api/health
```

## Step 6: Check network interface binding
```bash
# Verify the server is binding to all interfaces (0.0.0.0)
# Look for this in server output: "serving on port 5000"
# The server should bind to 0.0.0.0:5000, not 127.0.0.1:5000
```

## Common Issues and Solutions:

### 1. Build Failed
If `npm run build` failed:
```bash
# Clean install
rm -rf node_modules package-lock.json
npm install --legacy-peer-deps
npm run build
```

### 2. Port Already in Use
```bash
# Kill process using port 5000
sudo fuser -k 5000/tcp

# Or find and kill specific process
sudo lsof -t -i:5000 | xargs sudo kill -9
```

### 3. Permission Issues
```bash
# Make sure you have permission to bind to port 5000
# (ports below 1024 require sudo, but 5000 should be fine)

# If needed, try a different port
PORT=8080 node dist/index.js
```

### 4. Missing Files
If dist/index.js doesn't exist:
```bash
# The build process might have failed silently
# Try building step by step:
npm run build 2>&1 | tee build.log
cat build.log
```

## Quick Test Commands:
```bash
# 1. Navigate to project
cd ~/zatscan

# 2. Check if files exist
ls -la dist/

# 3. Start server with output
NODE_ENV=production node dist/index.js

# 4. In another terminal, test locally
curl http://localhost:5000/api/health

# 5. If local works, test from host machine
```

## Expected Success Output:
```
4:30:15 PM [express] serving on port 5000
```

When you see this message, the server is running correctly and should be accessible from your host machine at http://192.168.1.14:5000