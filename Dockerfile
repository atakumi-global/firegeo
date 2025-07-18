FROM node:18-alpine

# Configure DNS to prefer IPv4
RUN echo 'precedence ::ffff:0:0/96  100' >> /etc/gai.conf

# Install yarn
RUN npm install -g yarn

# Set yarn registry
RUN yarn config set registry https://registry.npmjs.org/

WORKDIR /app

# Copy package files
COPY package*.json ./

# Install dependencies with yarn
RUN yarn install --verbose

# Copy source code
COPY . .

# Build the application
RUN yarn build

# Expose port
EXPOSE 3000

# Start the application
CMD ["yarn", "start"]
