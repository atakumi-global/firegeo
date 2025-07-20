# Use an official Node.js image
FROM node:20

# 1. Declare the build-time arg for your API key
ARG BRAND_MONITOR_API_KEY
# 2. Make that arg available to Next.js during build
ENV BRAND_MONITOR_API_KEY=${BRAND_MONITOR_API_KEY}

# Set working directory
WORKDIR /app

# Copy package files and install dependencies early for caching
COPY package*.json ./
RUN npm install

# Copy the rest of the application code
COPY . .

# Force Node to prioritize IPv4
ENV NODE_OPTIONS=--dns-result-order=ipv4first

# Build the Next.js application
RUN npm run build

# Expose Next.js default port
EXPOSE 3000

# Start the production server
CMD ["npm", "run", "start"]
