FROM --platform=$TARGETPLATFORM python:3.6-alpine AS runtime
ARG TARGETPLATFORM
ARG BUILDPLATFORM

LABEL author="jhao104 <j_hao104@163.com>"

ENV DEBIAN_FRONTEND noninteractive
ENV TZ Asia/Shanghai

WORKDIR /app

COPY ./requirements.txt .

RUN set -ex; \
	\
	buildDeps=' \
		tzdata \
		build-base \
	'; \
	\
	runDeps=' \
		libxml2-dev \
		libxslt-dev \
	'; \
	apk add --no-cache --virtual .build-deps \
		$buildDeps \
		$runDeps \
	; \
	\
	pip install --no-cache-dir -r requirements.txt \
	#pip install --no-cache-dir -r requirements.txt -i https://pypi.tuna.tsinghua.edu.cn/simple/ \
	; \
	\
	cp /usr/share/zoneinfo/Asia/Shanghai /etc/localtime; \
	\
	apk add --no-cache --no-network --virtual .run-deps \
		$runDeps \
    ; \
    apk del --no-network .build-deps;


COPY . .

EXPOSE 5010

ENTRYPOINT [ "sh", "start.sh" ]
