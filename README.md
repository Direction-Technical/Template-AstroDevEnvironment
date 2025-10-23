# Astro Dev Container

This Docker Compose setup lets you develop Astro + TinaCMS + Citrus projects inside a containerized VS Code environment, with dual-mode support for development and static preview.

## 🔧 Setup

1. Clone this repo
2. Copy `.env.example` to `.env` and update the variables as needed
3. Populate the .ssh folder with ssh keys in the form of id_ed25519 and id_ed25519.pub
4. Run dev mode:

   ```bash
   docker-compose up dev
   ```
  
   - Astro dev server: <http://localhost:4321>
5. Run final mode:

   ```bash
   docker-compose up final
   ```

   - Static preview: <http://localhost:8787>

## 🧠 Notes

- Shared volume `astro_workspace` keeps your code and build output
- `final` mimics Cloudflare Pages: `npm run build` → `dist/` → served via astro preview
