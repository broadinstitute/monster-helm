FROM python:3-slim

ARG S3CMD_VERSION

RUN pip install s3cmd==${S3CMD_VERSION}

ENTRYPOINT ["s3cmd"]
