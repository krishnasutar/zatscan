# Deployment Guide

This ZATCA QR Code Scanner application is ready for deployment on various platforms. The project has been structured with proper build processes and deployment configurations.

## Project Structure

```
project/
├── client/           # Frontend React application
├── server/           # Backend Express server
├── shared/           # Shared types and schemas
├── dist/            # Production build output (generated)
├── deploy/          # Platform-specific deployment configs
├── scripts/         # Build and utility scripts
├── Dockerfile       # Docker configuration
├── railway.json     # Railway deployment config
├── vercel.json      # Vercel deployment config
└── package.json     # Dependencies and scripts
```

## Build Process

The application supports multiple build strategies optimized for deployment constraints:

### Build Scripts

#### Quick Build (Recommended for Deployment)
```bash
./scripts/quick-build.sh
```
- **Purpose**: Fast deployment build bypassing frontend build timeouts
- **Output**: Minimal HTML + bundled backend server
- **Build time**: ~16ms
- **Use case**: Initial deployment, cloud platforms with build time limits

#### Full Build (Development)
```bash
npm run build
```
- **Purpose**: Complete build with frontend compilation
- **Output**: Full React application + bundled backend
- **Build time**: 5+ minutes (may timeout on some platforms)
- **Use case**: Local development, platforms with generous build limits

### Build Commands

```bash
# Development
npm run dev

# Quick production build (bypasses timeouts)
./scripts/quick-build.sh

# Full production build
npm run build

# Start production server
npm start
```

## Platform Deployment

### 1. Railway (Optimized)

Railway deployment uses Docker with a quick-build strategy to avoid timeout issues:

#### Deployment Process
```bash
# Deploy to Railway
npm install -g @railway/cli
railway login
railway init
railway up
```

#### Configuration Details
- **Builder**: Docker (uses optimized Dockerfile with quick build)
- **Build Process**: Uses `scripts/quick-build.sh` to bypass frontend build timeouts
- **Production Server**: Bundled backend with minimal loading page
- **Health Check**: `/api/health` endpoint with 300s timeout
- **Port Binding**: Dynamic port assignment via `PORT` environment variable
- **Build Time**: ~30 seconds (vs 5+ minutes for full build)

#### Build Output Structure
```
dist/
├── production.js      # Bundled production server (no Vite dependencies)
├── production.js.map  # Source map for debugging
└── public/           # Static frontend assets
    ├── index.html
    └── assets/
```

#### Alternative: Nixpacks-based
Uses `nixpacks.toml` configuration:

```bash
# Change railway.json to use NIXPACKS builder
{
  "build": {
    "builder": "NIXPACKS"
  }
}
```

**Environment Variables Required:**
- `DATABASE_URL` (if using PostgreSQL)
- `NODE_ENV=production`
- `PORT` (automatically set by Railway)

### 2. Vercel

Configured with `vercel.json` for serverless deployment:

```bash
# Deploy to Vercel
npm install -g vercel
vercel
```

### 3. AWS

#### Option A: Elastic Beanstalk
```bash
# Install EB CLI
pip install awsebcli

# Initialize and deploy
eb init
eb create production
eb deploy
```

#### Option B: ECS with Docker
Use the provided `deploy/aws/buildspec.yml` for CodeBuild:

```bash
# Build and push to ECR
docker build -t zatca-scanner .
docker tag zatca-scanner:latest [ACCOUNT].dkr.ecr.[REGION].amazonaws.com/zatca-scanner:latest
docker push [ACCOUNT].dkr.ecr.[REGION].amazonaws.com/zatca-scanner:latest
```

### 4. Azure

Use the provided `deploy/azure/azure-pipelines.yml` for Azure DevOps:

```bash
# Deploy to Azure Container Instances
az container create \
  --resource-group myResourceGroup \
  --name zatca-scanner \
  --image myregistry.azurecr.io/zatca-scanner:latest \
  --cpu 1 \
  --memory 1 \
  --ports 5000
```

### 5. Docker

```bash
# Build image
docker build -t zatca-scanner .

# Run container
docker run -p 5000:5000 -e NODE_ENV=production zatca-scanner
```

### 6. Digital Ocean

```bash
# Deploy to App Platform
doctl apps create --spec .do/app.yaml
```

## Environment Variables

### Required
- `NODE_ENV=production`
- `PORT=5000` (or platform-specific)

### Optional (Database)
- `DATABASE_URL` (PostgreSQL connection string)
- `PGHOST`, `PGPORT`, `PGUSER`, `PGPASSWORD`, `PGDATABASE`

## Build Output

After running `npm run build`, the following structure is created:

```
dist/
├── index.js         # Bundled Express server
├── index.js.map     # Source map
└── public/          # Static frontend assets
    ├── index.html
    ├── assets/
    └── ...
```

## Health Checks

The application includes health check endpoints:

- `GET /` - Frontend application
- `GET /api/sessions` - API health check

## Performance Optimizations

- ✅ Frontend code splitting with Vite
- ✅ Backend bundling with esbuild
- ✅ Static asset optimization
- ✅ Gzip compression (via Express)
- ✅ Production environment variables

## Security Features

- ✅ CORS configuration
- ✅ Helmet security headers
- ✅ Environment-based configuration
- ✅ Client/server separation
- ✅ Input validation with Zod schemas

## Monitoring

The application logs are structured for production monitoring:

```javascript
// Express request logging
app.use((req, res, next) => {
  console.log(`${new Date().toISOString()} - ${req.method} ${req.path}`);
  next();
});
```

## Troubleshooting

### Common Issues

1. **Port binding**: Ensure `PORT` environment variable is set
2. **Static assets**: Verify `dist/public` contains frontend files
3. **Database connection**: Check `DATABASE_URL` format
4. **Memory limits**: Minimum 512MB RAM recommended

### Debug Build

```bash
# Test build locally
npm run build
NODE_ENV=production node dist/index.js
```

## Platform-Specific Notes

### Railway
- Automatically detects Node.js
- Sets PORT environment variable
- Supports PostgreSQL add-on

### Vercel
- Serverless functions for API routes
- Static hosting for frontend
- Limited to 10-second execution time

### AWS
- Use Application Load Balancer for high availability
- Configure auto-scaling groups
- Set up CloudWatch monitoring

### Azure
- Use Azure Container Registry
- Configure App Service for easy scaling
- Enable Application Insights

This deployment guide ensures your ZATCA QR Scanner can be deployed successfully across all major cloud platforms.