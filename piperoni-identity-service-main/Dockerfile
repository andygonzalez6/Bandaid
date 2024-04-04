# Use the official Python 3.9 image as the base image
FROM python:3.9

# Set the working direrctory inside the container
WORKDIR /app

# Copy the requirements.txt file to the container
COPY ./requirements.txt /app/requirements.txt

# Install the Python packages for dependencies
RUN pip install --no-cache-dir --upgrade -r /app/requirements.txt

# Copy application source code to the container
COPY . /app

# Start running the application
CMD ["uvicorn", "main:app", "--host", "0.0.0.0", "--port", "80"]