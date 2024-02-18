# Use an official Node.js runtime as the base image
FROM node:18-alpine

# Set the working directory in the container
WORKDIR /app

# create client directory
RUN mkdir client

# Copy the package.json and package-lock.json files to the container
COPY ./client/package*.json ./client/

# Install the dependencies for the React app
RUN cd client && npm install

# copy client files to the container
COPY ./client/ ./client/

# Build the React app
RUN cd client && npm run build

# run post build commands
RUN cd client && npm run post-build

# Copy the entire project directory to the container
COPY ./server .


# Set the output directory
ENV OUTPUT_DIR=/app/output

# Copy the built app to the output directory
RUN cp -r client/build $OUTPUT_DIR

# Set the working directory to the Node.js server
WORKDIR /app

# Copy the package.json and package-lock.json files to the container
COPY ./server/package*.json ./

# Install the dependencies for the Node.js server
RUN npm install

# Expose the port on which the app will run (if needed)
EXPOSE 8000

# Define the command to run the Node.js server
CMD [ "npm", "start" ]


# docker build -t my-app .
# docker run -p 3000:3000 my-app
