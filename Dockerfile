FROM node:18-alpine

# Configure system to prefer IPv4
RUN echo 'precedence ::ffff:0:0/96  100' >> /etc/gai.conf

# Set npm registry and force IPv4 resolution
RUN npm config set registry https://registry.npmjs.org/
RUN npm config set fetch-retry-mintimeout 20000
RUN npm config set fetch-retry-maxtimeout 120000

WORKDIR /app

# Copy package files
COPY package*.json ./

# Install dependencies
RUN npm install

# Copy source code
COPY . .

# Build the application
RUN npm run build

# Expose port
EXPOSE 3000

# Start the application
CMD ["npm", "start"]
