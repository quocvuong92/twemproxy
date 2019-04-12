FROM alpine:latest AS build

RUN apk add --no-cache git

RUN apk add --update g++ libtool make automake curl autoconf \
  && rm -rf /var/cache/apk/* /tmp/*

RUN curl -qL https://github.com/twitter/twemproxy/archive/v0.4.1.tar.gz | tar xzf - \
  && cd  twemproxy-0.4.1 && autoreconf -fvi && ./configure --enable-debug=log && make && mv src/nutcracker /usr/bin/nutcracker




FROM alpine:3.9

LABEL maintainer "Vuong HQ <vuonghq3@fpt.com.vn>"

# install dependencies
RUN apk add --no-cache supervisor curl autoconf automake ruby1.9.1-dev rubygems1.9.1

# copy files and create necessary folders
RUN mkdir -p /var/log/supervisor
COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf

COPY --from=build /usr/bin/nutcracker /usr/bin/nutcracker

RUN gem install nutcracker-web
RUN apk del automake curl autoconf

EXPOSE 22100 22101 22110 22111 9292

CMD ["/usr/bin/supervisord", "-c", "/etc/supervisor/conf.d/supervisord.conf"]
