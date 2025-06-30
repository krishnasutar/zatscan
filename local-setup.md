# Local Ubuntu Server Setup Guide

## Prerequisites
- Ubuntu server running in VirtualBox (bridge mode)
- Network access to the VM

## Quick Installation Steps

### 1. Install Node.js 20
```bash
# Update system
sudo apt update && sudo apt upgrade -y

# Install Node.js 20
curl -fsSL https://deb.nodesource.com/setup_20.x | sudo -E bash -
sudo apt-get install -y nodejs

# Verify installation
node --version
npm --version
```

### 2. Clone and Setup Project
```bash
# Clone your repository
git clone [your-repo-url]
cd zatca-qr-scanner

# Install dependencies (with legacy peer deps to handle conflicts)
npm install --legacy-peer-deps

# Build the application
npm run build

# Start the production server
npm start
```

### Alternative if still having issues:
```bash
# Force install dependencies
npm install --force

# Or use specific Node.js version
npm install --legacy-peer-deps --no-optional
```

### 3. Access the Application
- **Local VM access**: http://localhost:5000
- **From host machine**: http://[VM-IP-ADDRESS]:5000
- **From any network device**: http://[VM-IP-ADDRESS]:5000

### 4. Find your VM IP Address
```bash
# Get IP address
ip addr show | grep inet
# or
hostname -I
```

## Development Mode (Optional)
If you want to make changes and test:
```bash
# Run in development mode
npm run dev
```

## Network Configuration
Since you're using bridge mode:
- The VM gets its own IP on your network
- The application will be accessible from any device on the same network
- Perfect for testing on phones/tablets for QR scanning

## Firewall (if needed)
```bash
# Allow port 5000 through firewall
sudo ufw allow 5000
sudo ufw enable
```

## Testing Checklist
- [ ] Node.js installed successfully
- [ ] Project builds without errors
- [ ] Application starts on port 5000
- [ ] Can access from VM browser
- [ ] Can access from host machine
- [ ] Can access from mobile device (for QR testing)