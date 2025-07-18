FROM node:18-alpine

# Disable IPv6 completely in the container
RUN echo 'net.ipv6.conf.all.disable_ipv6 = 1' >> /etc/sysctl.conf || true
RUN echo 'net.ipv6.conf.default.disable_ipv6 = 1' >> /etc/sysctl.conf || true

# Configure DNS to prefer IPv4
RUN echo 'precedence ::ffff:0:0/96  100' >> /etc/gai.conf

# Use Google DNS (IPv4 only)
RUN echo 'nameserver 8.8.8.8' > /etc/resolv.conf
RUN echo 'nameserver 8.8.4.4' >> /etc/resolv.conf

# Set npm registry and timeouts
RUN npm config set registry https://registry.npmjs.org/
RUN npm config set fetch-retry-mintimeout 20000
RUN npm config set fetch-retry-maxtimeout 120000
RUN npm config set fetch-retries 5

WORKDIR /app

# Copy package files
COPY package*.json ./

# Install dependencies with verbose logging
RUN npm install --verbose

# Copy source code
COPY . .

# Build the application
RUN npm run build

# Expose port
EXPOSE 3000

# Start the application
CMD ["npm", "start"]
