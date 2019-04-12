FROM ruby:2.6-alpine3.9
MAINTAINER Vuong Hoang <vuongh3@fpt.com.vn>

# Install build base, supervisor, set timezone
RUN apk add autoconf automake ca-certificates make bash build-base supervisor tzdata \
    && cp /usr/share/zoneinfo/Asia/Ho_Chi_Minh /etc/localtime \
    && echo "Asia/Ho_Chi_Minh" > /etc/timezone \
    && mkdir -p /var/log/supervisor

# Copy supervisor config file
COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf

# Install nutcracker, nutcracker-web
RUN gem install nutcracker \
    && gem install nutcracker-web

# Delete cache
RUN apk del make automake autoconf build-base \
    && rm -rf /var/cache/apk/* /tmp/*

# Expose port
EXPOSE 9292 22222 22100 22101 22110 22111

# Start service
CMD ["/usr/bin/supervisord", "-c", "/etc/supervisor/conf.d/supervisord.conf"]
