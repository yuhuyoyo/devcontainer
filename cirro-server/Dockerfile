# Use an official Python runtime as a parent image
FROM python:3.11-buster

RUN useradd -m abc

# Set the working directory in the container
WORKDIR /app

# Copy the current directory contents into the container at /app
COPY . /app

# Install any needed packages specified in requirements.txt
RUN python -m pip install --upgrade pip && python -m pip install cirrocumulus

RUN chown -R abc:abc /app

USER abc
