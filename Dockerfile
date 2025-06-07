FROM jrottenberg/ffmpeg:4.4-ubuntu

WORKDIR /app

COPY server.sh /app/server.sh

RUN chmod +x /app/server.sh

EXPOSE 80

CMD ["bash", "/app/server.sh"]
