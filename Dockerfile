FROM node:18-alpine

# Configure system to prefer IPv4
RUN echo 'precedence ::ffff:0:0/96  100' >> /etc/gai.conf

# Set npm to use IPv4 only
RUN npm config set ipv6 false
RUN npm config set registry https://registry.npmjs.org/

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
