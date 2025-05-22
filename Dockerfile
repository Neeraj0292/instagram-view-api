FROM python:3.10-slim

# Install required system packages
RUN apt-get update && apt-get install -y \
    wget gnupg curl unzip fonts-liberation libappindicator3-1 \
    libasound2 libnspr4 libnss3 libxss1 xdg-utils libgbm-dev \
    libu2f-udev libvulkan1 libdrm2 libgtk-3-0 libxcomposite1 libxcursor1 \
    libxdamage1 libxi6 libxtst6 \
    && rm -rf /var/lib/apt/lists/*

# Download and install Chrome
RUN wget -q -O google-chrome.deb https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb \
    && apt-get update && apt-get install -y ./google-chrome.deb \
    && rm google-chrome.deb

# Install ChromeDriver matching the installed Chrome version
RUN CHROME_VERSION=$(google-chrome --version | sed 's/Google Chrome //') && \
    DRIVER_VERSION=$(curl -s "https://chromedriver.storage.googleapis.com/LATEST_RELEASE") && \
    wget -q "https://chromedriver.storage.googleapis.com/${DRIVER_VERSION}/chromedriver_linux64.zip" && \
    unzip chromedriver_linux64.zip && mv chromedriver /usr/local/bin/ && chmod +x /usr/local/bin/chromedriver && \
    rm chromedriver_linux64.zip

# Set display port (for headless mode)
ENV DISPLAY=:99

# Set working directory
WORKDIR /app

# Copy files
COPY . .

# Install Python dependencies
RUN pip install -r requirements.txt

# Run app
CMD ["python", "main.py"]

