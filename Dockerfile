FROM debian:jessie

RUN apt-get update && apt-get -y install wget build-essential libreadline-dev libncurses5-dev libpcre3-dev libssl-dev && apt-get -q -y clean
RUN wget https://openresty.org/download/openresty-1.15.8.2.tar.gz \
  && tar xvfz openresty-1.15.8.2.tar.gz \
  && cd openresty-1.15.8.2 \
  && ./configure --with-luajit --with-http_gzip_static_module  --with-http_ssl_module \
  && make \
  && make install \
  && rm -rf /ngx_openresty*

EXPOSE 8080

ENV TINI_VERSION v0.18.0
ADD https://github.com/krallin/tini/releases/download/${TINI_VERSION}/tini /tini
RUN chmod +x /tini

ADD start_server.sh /start_server.sh
ADD nginx.conf /usr/local/openresty/nginx/conf/nginx.conf

CMD ["/start_server.sh"]
ENTRYPOINT ["/tini", "--"]
