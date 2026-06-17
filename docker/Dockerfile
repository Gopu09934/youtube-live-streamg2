FROM ubuntu:24.04

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && \
    apt-get install -y \
        ffmpeg \
        python3 \
        python3-pip && \
    pip3 install --break-system-packages gdown && \
    apt-get clean

WORKDIR /app

COPY start.sh .

RUN chmod +x start.sh

CMD ["./start.sh"]
