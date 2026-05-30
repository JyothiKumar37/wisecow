FROM ubuntu:22.04

RUN apt-get update && \
    apt-get install -y cowsay fortune-mod netcat-openbsd

ENV PATH="/usr/games:${PATH}"

WORKDIR /app

COPY wisecow.sh .

RUN chmod +x wisecow.sh

EXPOSE 4499

CMD ["./wisecow.sh"]
