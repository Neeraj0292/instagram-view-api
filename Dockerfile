FROM python:3.10-slim

RUN apt-get update && apt-get install -y \
    wget unzip curl gnupg2 ca-certificates \
    fonts-liberation libappindicator3-1 libasound2 libnspr4 libnss3 libxss1 xdg-utils libgbm-dev \
    && rm -rf /var/lib/apt/lists/*

RUN wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb \
    && apt install -y ./google-chrome-stable_current_amd64.deb

RUN CHROME_VERSION=$(google-chrome --version | cut -d " " -f 3) && \
    CHROMEDRIVER_VERSION=$(curl -sS "https://chromedriver.storage.googleapis.com/LATEST_RELEASE") && \
    wget -O /tmp/chromedriver.zip "https://chromedriver.storage.googleapis.com/${CHROMEDRIVER_VERSION}/chromedriver_linux64.zip" && \
    unzip /tmp/chromedriver.zip chromedriver -d /usr/local/bin/

WORKDIR /app
COPY . /app

RUN pip install -r requirements.txt

CMD ["python", "main.py"]
