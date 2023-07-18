# Use an official Python runtime as the base image
FROM python:3.9-slim

# Set the working directory in the container
WORKDIR /app

# Create a simple Python script for the "Hello, World!" application
RUN echo "print('Hello, World!')" > app.py

# Define the command to run the application
CMD ["python", "app.py"]
