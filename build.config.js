import { build } from 'esbuild';
import { fileURLToPath } from 'url';
import { dirname, join } from 'path';

const __filename = fileURLToPath(import.meta.url);
const __dirname = dirname(__filename);

async function buildServer() {
  try {
    await build({
      entryPoints: ['server/index.ts'],
      bundle: true,
      platform: 'node',
      target: 'node20',
      format: 'esm',
      outdir: 'dist',
      external: [
        // External packages that should not be bundled
        'vite',
        '@vitejs/plugin-react',
        '@replit/vite-plugin-cartographer',
        '@replit/vite-plugin-runtime-error-modal'
      ],
      define: {
        'process.env.NODE_ENV': '"production"'
      },
      sourcemap: true,
      minify: true,
      splitting: false,
      treeShaking: true
    });
    
    console.log('✅ Server build completed successfully');
  } catch (error) {
    console.error('❌ Server build failed:', error);
    process.exit(1);
  }
}

buildServer();