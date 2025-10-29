FROM node:18-alpine AS builder

WORKDIR /app
COPY package*.json ./
RUN npm ci
COPY . .
RUN npm run build

FROM node:18-alpine

# Create config directory
RUN mkdir -p /usr/src/api/config

WORKDIR /usr/src/api

# Copy built app
COPY --from=builder /app/dist ./dist
COPY --from=builder /app/package*.json ./

# Copy default settings but DON'T copy to config yet
COPY --from=builder /app/config/settings.default.json ./config/

# Install production deps
RUN npm ci --production

# Expose port
EXPOSE 8080

# Custom entrypoint to handle settings.json properly
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
CMD ["node", "dist/api.js"]
