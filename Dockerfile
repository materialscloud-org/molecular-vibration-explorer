# Base Python image
FROM python:3.7.10-slim

# System-level dependencies
RUN apt-get update && apt-get install -y \
    build-essential \
    git \
    curl \
    libgl1 \
    libxrender1 \
    libxext6 \
    libsm6 \
    nodejs \
    npm \
    && rm -rf /var/lib/apt/lists/*

# Set working directory
WORKDIR /app

# Copy requirements
COPY requirements.txt .

# Install Python dependencies
RUN pip install --no-cache-dir -r requirements.txt

# Install node + npm for nglview widgets
RUN apt-get update && apt-get install -y nodejs npm && \
    jupyter-nbextension enable --py --sys-prefix nglview && \
    jupyter-nbextension enable --py --sys-prefix widgetsnbextension

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
