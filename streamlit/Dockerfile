# app/Dockerfile

FROM python:3.9-slim

WORKDIR /app

RUN apt-get update && apt-get install -y \
    build-essential \
    curl \
    software-properties-common \
    git \
    && rm -rf /var/lib/apt/lists/*

RUN git clone https://github.com/streamlit/streamlit-example.git .

RUN pip3 install -r requirements.txt

EXPOSE 8501

HEALTHCHECK CMD curl --fail http://application-server:8501/_stcore/health

ENTRYPOINT ["streamlit", "run", "--server.enableCORS", "false", "--server.enableXsrfProtection", "false", "--server.port", "8501", "--browser.serverAddress","0.0.0.0", "streamlit_app.py"]
