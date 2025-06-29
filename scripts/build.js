#!/usr/bin/env node

import { execSync } from 'child_process';
import { rmSync, existsSync, mkdirSync } from 'fs';
import path from 'path';

console.log('🚀 Starting production build...');

// Clean previous build
if (existsSync('dist')) {
  console.log('🧹 Cleaning previous build...');
  rmSync('dist', { recursive: true, force: true });
}

// Create dist directory
mkdirSync('dist', { recursive: true });

try {
  // Build frontend
  console.log('🔨 Building frontend...');
  execSync('vite build', { stdio: 'inherit' });

  // Build backend
  console.log('🔨 Building backend...');
  execSync('esbuild server/index.ts --platform=node --packages=external --bundle --format=esm --outdir=dist --target=node20 --sourcemap', { stdio: 'inherit' });

  // Copy static assets
  console.log('📦 Copying static assets...');
  if (existsSync('client/dist')) {
    execSync('cp -r client/dist dist/public', { stdio: 'inherit' });
  }

  console.log('✅ Build completed successfully!');
  console.log('📁 Output directory: ./dist');
  console.log('🚀 Run "npm start" to start the production server');

} catch (error) {
  console.error('❌ Build failed:', error.message);
  process.exit(1);
}