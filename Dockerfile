# Use Node.js 20 LTS
FROM node:20-alpine

# Install curl for health checks
RUN apk add --no-cache curl

# Set working directory
WORKDIR /app

# Copy package files
COPY package*.json ./

# Install ALL dependencies (including devDependencies for build)
RUN npm ci

# Copy source code
COPY . .

# Build the application with quick build
RUN chmod +x scripts/quick-build.sh && ./scripts/quick-build.sh

# Remove devDependencies after build to reduce image size
RUN npm prune --production

# Expose port (Railway will override this with PORT env var)
EXPOSE 5000

# Set environment to production
ENV NODE_ENV=production

# Ensure the application starts properly
HEALTHCHECK --interval=30s --timeout=10s --start-period=5s --retries=3 \
  CMD curl -f http://localhost:${PORT:-5000}/api/health || exit 1

# Start the application
CMD ["node", "dist/index.js"]