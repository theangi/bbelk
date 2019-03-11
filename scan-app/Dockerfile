FROM alpine:3.7

RUN apk add --update \
    python \
    python-dev \
    py-pip \
    build-base \
  && pip install virtualenv \
  && rm -rf /var/cache/apk/*

COPY src/ /app
WORKDIR /app

COPY requirements.txt .
RUN pip install -r /app/requirements.txt

CMD [ "python", "./app.py" ]