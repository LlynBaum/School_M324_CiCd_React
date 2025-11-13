# --- Stage 1: Build React app ---
FROM node:20-alpine AS build

# Set working directory
WORKDIR /app

# Install dependencies first (better layer caching)
COPY package*.json ./
RUN npm ci

# Copy the rest of the source code
COPY . .

# Build the app for production
RUN npm run build

# --- Stage 2: Run with Nginx ---
FROM nginx:alpine

# Copy build output to Nginx web root
COPY --from=build /app/build /usr/share/nginx/html

# Optional: custom Nginx config (e.g. for SPA routing)
# COPY nginx.conf /etc/nginx/conf.d/default.conf

EXPOSE 80

# Default container command
CMD ["nginx", "-g", "daemon off;"]
