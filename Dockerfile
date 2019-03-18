FROM alpine:latest

LABEL maintainer "Vuong HQ <vuonghq3@fpt.com.vn>"

# install dependencies
RUN apk add --update g++ libtool make automake curl autoconf supervisor

# copy files and create necessary folders
RUN mkdir -p /var/log/supervisor
COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf

# compile twemproxy
RUN curl -qL https://github.com/twitter/twemproxy/archive/v0.4.1.tar.gz | tar xzf -
RUN cd  twemproxy-0.4.1 && autoreconf -fvi && ./configure --enable-debug=log && make && make install

RUN apk del g++ libtool make automake curl autoconf

EXPOSE 22100 22101 22102 22013

CMD ["/usr/bin/supervisord", "-c", "/etc/supervisor/conf.d/supervisord.conf"]
