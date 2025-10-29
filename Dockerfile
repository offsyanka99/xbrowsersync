FROM node:18-alpine AS builder

# Set working directory for source
WORKDIR /app

# Copy package files first
COPY package*.json ./

# Install all dependencies for build
RUN npm ci

# Copy source code
COPY . .

# Build the app
RUN npm run build

# Production stage
FROM node:18-alpine

# Create app directory
RUN mkdir -p /usr/src/api

# Set working directory
WORKDIR /usr/src/api

# Copy built files from builder
COPY --from=builder /app/dist ./dist
COPY --from=builder /app/package*.json ./

# Create config directory
RUN mkdir -p /usr/src/api/config

# Copy default settings
COPY --from=builder /app/config/settings.default.json ./config/

# Install production dependencies only
RUN npm ci --only=production --no-package-lock

# Expose port
EXPOSE 8080

# Custom entrypoint
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
CMD ["node", "dist/api.js"]
