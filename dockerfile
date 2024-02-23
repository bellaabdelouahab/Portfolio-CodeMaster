# Use an official Node.js runtime as the base image
FROM node:18-alpine

# Set the working directory in the container
WORKDIR /app

# Create a volume to store the public files
VOLUME /app/public

# Copy the entire project directory to the container
COPY ./server .

# Set the output directory
# ENV OUTPUT_DIR=/app/output

# Copy the package.json and package-lock.json files to the container
COPY ./server/package*.json ./

# Install the dependencies for the Node.js server
RUN npm install

# Expose the port on which the app will run (if needed)
EXPOSE 8000

# Define the command to run the Node.js server
CMD [ "npm", "start" ]
