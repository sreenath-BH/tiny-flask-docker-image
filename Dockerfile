FROM python:alpine AS builder
RUN apk add --no-cache binutils
COPY requirements.txt /tmp/requirements.txt
RUN pip install --no-cache-dir --prefix=/install -r /tmp/requirements.txt
RUN find /usr/local -name '*.so' | xargs strip -s
RUN set -ex && \
    cd /usr/local/lib/python*/config-*-x86_64-linux-musl/ && rm -rf *.o *.a
RUN rm -rf /usr/local/lib/python*/ensurepip \
           /usr/local/lib/python*/idlelib \
           /usr/local/lib/python*/distutils/command \
           /usr/local/lib/python*/lib2to3 \
           /usr/local/lib/python*/__pycache__/* \
           /usr/local/share/*
RUN find /usr/local/include/python* -not -name pyconfig.h -type f -delete
RUN find /usr/local/bin -not -name 'python*' -type f -delete
RUN apk del binutils

FROM alpine:latest AS final
ENV LANG=C.UTF-8
RUN apk add --no-cache libbz2 expat libffi xz-libs sqlite-libs readline ca-certificates

COPY --from=builder /usr/local/ /usr/local/
COPY --from=builder /install /usr/local/
WORKDIR /app
COPY app.py /app/

EXPOSE 5000
CMD ["gunicorn", "--workers=4", "--threads=2", "--bind=0.0.0.0:5000", "app:app"]

