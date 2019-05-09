FROM alpine:3.8

RUN apk add --update --no-cache --virtual=run-deps \
  python3 \
  ca-certificates \
  py3-psycopg2 \
  git \
  && rm -rf /var/cache/apk/*

ENV DEBUG False
ENV DB_NAME drifter.db
ENV DB_TYPE sqlite
ENV TMP_FOLDER /tmp

WORKDIR /opt/app
CMD ["python3", "-u", "drifter.py"]

COPY requirements.txt /opt/app/
RUN pip3 install --no-cache-dir -r /opt/app/requirements.txt

COPY app /opt/app/
