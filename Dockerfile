# Use an official Node.js image
FROM node:20

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
