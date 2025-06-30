# Deployment Guide

## Quick Setup

```bash
# Build the application
npm run build

# Start production server
npm start
```

## Railway Deployment

1. Connect repository to Railway
2. Railway will automatically:
   - Detect Node.js project
   - Run `npm run build` 
   - Start with `npm start`
   - Set up health checks at `/api/health`

## Environment Variables

- `NODE_ENV=production` (set automatically)
- `PORT` (set automatically by Railway)
- `DATABASE_URL` (optional - uses in-memory storage by default)

## Build Output

```
dist/
├── index.js        # Bundled server
└── public/         # Frontend assets
```

## Health Check

The server provides health endpoint at `/api/health`:

```json
{
  "status": "healthy",
  "uptime": 123.45,
  "timestamp": "2024-01-01T00:00:00.000Z",
  "environment": "production"
}
```

Simple and reliable deployment process.