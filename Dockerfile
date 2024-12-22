FROM golang:1.17-alpine3.13

ENV PATH="$PATH:/opt/bento4/bin" \
    BENTO4_BIN="/opt/bento4/bin" \
    BENTO4_BASE_URL="http://zebulon.bok.net/Bento4/source/" \
    BENTO4_VERSION="1-6-0-641" \
    BENTO4_CHECKSUM="ed3e2603489f4748caadccb794cf37e5e779422e" \
    BENTO4_TYPE="SRC" \
    BENTO4_PATH="/opt/bento4"

# Instalar dependências
RUN apk add --no-cache --update \
    bash make ffmpeg python2 python2-dev unzip gcc g++ scons \
    && ln -sf /usr/bin/python2 /usr/bin/python \
    && wget -q ${BENTO4_BASE_URL}/Bento4-${BENTO4_TYPE}-${BENTO4_VERSION}.zip \
    && echo "${BENTO4_CHECKSUM}  Bento4-${BENTO4_TYPE}-${BENTO4_VERSION}.zip" | sha1sum -c - \
    && mkdir -p ${BENTO4_PATH} \
    && unzip Bento4-${BENTO4_TYPE}-${BENTO4_VERSION}.zip -d ${BENTO4_PATH} \
    && rm Bento4-${BENTO4_TYPE}-${BENTO4_VERSION}.zip \
    && cd ${BENTO4_PATH} \
    && python2 $(which scons) -u build_config=Release target=x86_64-unknown-linux \
    && cp -R ${BENTO4_PATH}/Build/Targets/x86_64-unknown-linux/Release ${BENTO4_BIN} \
    && cp -R ${BENTO4_PATH}/Source/Python/utils ${BENTO4_PATH}/utils \
    && cp -a ${BENTO4_PATH}/Source/Python/wrappers/. ${BENTO4_BIN} \
    && apk del gcc g++ scons python2-dev \
    && rm -rf /var/cache/apk/* /tmp/*

WORKDIR /go/src

CMD ["tail", "-f", "/dev/null"]

