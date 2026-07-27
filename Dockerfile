# --- ETAPA 1: BUILD & TEST (Fail-fast) ---
FROM node:20-alpine AS builder
WORKDIR /app

# Copiar archivos de dependencias e instalar todas (incluidas devDependencies si existen)
COPY package*.json ./
RUN npm ci

# Copiar todo el código fuente
COPY . .

# Ejecutar pruebas unitarias (Si npm test falla, la construcción de la imagen SE CANCELA)
RUN npm test

# --- ETAPA 2: PRODUCCIÓN (Imagen ligera) ---
FROM node:20-alpine AS runner
WORKDIR /app

ENV NODE_ENV=production

# Copiar dependencias e instalar solo las de producción
COPY package*.json ./
RUN npm ci --only=production

# Copiar solo el código necesario para ejecutar la app en producción
COPY server.js db.js ./
COPY public/ ./public/
COPY data/ ./data/

EXPOSE 3000

CMD ["node", "server.js"]