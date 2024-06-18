# Stage 1: Build React App
FROM node:16 AS build
WORKDIR /usr/src/app/client

# Copy package.json and package-lock.json
COPY client/package*.json ./

# Clear npm cache
RUN npm cache clean --force

# Install dependencies
RUN npm install

# Copy the rest of the client application code
COPY client .

# Build the React app
RUN npm run build

# Stage 2: Build Node.js Server
FROM node:16
WORKDIR /usr/src/app

# Copy package.json and package-lock.json
COPY package*.json ./

# Install dependencies for production
RUN npm install 

# Copy built React app from the previous stage
COPY --from=build /usr/src/app/client/build ./client/build

# Copy the rest of the server application code
COPY . .

# Expose the port the app runs on
EXPOSE 8080

# Command to run the app
CMD ["node", "server.js"]
