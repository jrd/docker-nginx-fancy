FROM nginx:1.15
WORKDIR /root
RUN apt-get update && apt-get install -y curl
RUN curl 'https://hg.nginx.org/pkg-oss/raw-file/tip/build_module.sh' > build_module.sh && chmod +x build_module.sh
RUN echo "#!/bin/sh\n"'exec "$@"' > /usr/local/bin/sudo && chmod +x /usr/local/bin/sudo
RUN /bin/bash -c "./build_module.sh -n fancyindex -y -v \${NGINX_VERSION//-*} -o /root/ https://github.com/aperezdc/ngx-fancyindex.git"
RUN dpkg -i /root/*.deb

FROM nginx:latest
COPY nginx-entrypoint /
RUN chmod +x nginx-entrypoint
ENTRYPOINT ["/nginx-entrypoint"]
CMD ["nginx", "-g", "daemon off;"]
COPY --from=0 /etc/nginx/modules/ngx_http_fancyindex_module.so /etc/nginx/modules/ngx_http_fancyindex_module.so
COPY fancyindex.conf /etc/nginx/load.d/fancyindex.conf
RUN sed -ri '/index  index\.html/a         fancyindex on;\n        fancyindex_exact_size off;\n' /etc/nginx/conf.d/default.conf
ARG VERSION
ARG BUILD_DATE
ARG VCS_REF
ARG VCS_URL
LABEL maintainer="Cyrille Pontvieux <cyrille@enialis.net>" \
      org.label-schema.schema-version="1.0" \
      org.label-schema.name="nginx-fancy" \
      org.label-schema.description="nginx with fancy index module" \
      org.label-schema.url=$VCS_URL \
      org.label-schema.version=$VERSION \
      org.label-schema.build-date=$BUILD_DATE \
      org.label-schema.vcs-ref=$VCS_REF \
      org.label-schema.vcs-url=$VCS_URL
