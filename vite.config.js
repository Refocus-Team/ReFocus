import { defineConfig } from 'vite';
import react from '@vitejs/plugin-react';

export default defineConfig({
  plugins: [react()],
  base: '/ReFocus/', // Wajib ada agar gambar dan CSS terbaca di GitHub
  server: {
    port: 5173,
  },
});