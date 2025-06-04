# Base Python image
FROM python:3.7.10-slim

# libX render required for RDkit vis
RUN apt-get update && apt-get install -y \
    build-essential \
    libxrender1 \
    && rm -rf /var/lib/apt/lists/*

# Set working directory
WORKDIR /app

# Copy requirements
COPY requirements.txt .

# Install Python dependencies
RUN pip install -r requirements.txt

    # Copy app code into image
COPY . .

# Expose port
EXPOSE 8080

# Set Voilà as the startup command
CMD ["voila", \
     "--template=materialscloud-discover", \
     "--Voila.ip=0.0.0.0", \
     "--VoilaConfiguration.enable_nbextensions=True", \
     "--VoilaConfiguration.file_whitelist=['.*\\.(png|mol|dat)']", \
     "--port=8080", \
     "--no-browser", \
     "--MappingKernelManager.cull_interval=60", \
     "--MappingKernelManager.cull_idle_timeout=120", \
     "--MappingKernelManager.cull_busy=True"]
