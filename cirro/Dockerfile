# Use an official Python runtime as a parent image
FROM python:3.8

# Set the working directory to /app
WORKDIR /app

# Copy the application code and requirements.txt
COPY . /app

# Install any needed packages specified in requirements.txt
RUN python -m pip install --upgrade pip && python -m pip install cirrocumulus

EXPOSE 5000

# Run cirrocumulus when the container launches with the specified command
CMD ["cirro", "launch", "/app/cirro_data", "--no-open"]

