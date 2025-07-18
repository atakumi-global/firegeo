FROM node:18-alpine as builder

# Install network debugging tools
RUN apk add --no-cache curl netcat-openbsd

# Test connectivity first
RUN curl -4 -I https://registry.npmjs.org/ || echo "IPv4 test failed"
RUN curl -6 -I https://registry.npmjs.org/ || echo "IPv6 test failed"

# Try to force IPv4 DNS resolution
RUN echo "104.16.25.34 registry.npmjs.org" >> /etc/hosts

WORKDIR /app

# Copy package files
COPY package*.json ./

# Install dependencies
RUN npm install

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
