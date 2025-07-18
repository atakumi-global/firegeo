FROM node:18-alpine AS builder
# Install apk packages we need
RUN apk add --no-cache curl
# Create a custom npm configuration
RUN npm config set prefer-online false
RUN npm config set registry https://registry.npmjs.org/
RUN npm config set fetch-retry-mintimeout 60000
RUN npm config set fetch-retry-maxtimeout 300000
RUN npm config set fetch-retries 10
# Force IPv4 via environment variables (these come from Coolify Secrets)
ENV NPM_CONFIG_IPV6=false
# Try using a different approach - download packages manually first
WORKDIR /app
# Copy package files
COPY package*.json ./
# Try to install with maximum retries and timeouts
RUN npm install --prefer-offline --no-audit --no-fund --maxsockets 1
# Copy source code
COPY . .
# Build the application
RUN npm run build
# Production stage
FROM node:18-alpine
WORKDIR /app
COPY --from=builder /app/node_modules ./node_modules
COPY --from=builder /app/.next ./.next
COPY --from=builder /app/public ./public
COPY --from=builder /app/package*.json ./
EXPOSE 3000
CMD ["npm", "start"]
