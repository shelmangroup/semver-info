FROM alpine:3.10
RUN apk add --no-cache --upgrade bash
ADD https://raw.githubusercontent.com/fsaintjacques/semver-tool/3.0.0/src/semver /usr/local/bin/
RUN chmod 755 /usr/local/bin/semver
COPY entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
ENTRYPOINT ["/entrypoint.sh"]
