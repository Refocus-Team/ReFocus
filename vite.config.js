import { defineConfig } from 'vite';
import react from '@vitejs/plugin-react';

export default defineConfig({
  plugins: [react()],
  base: '/ReFocus/', 
  server: {
    port: 5173,
  },
});