FROM nginx:1.15-perl
WORKDIR /root
RUN apt-get update && apt-get install -y curl
RUN curl 'https://hg.nginx.org/pkg-oss/raw-file/tip/build_module.sh' > build_module.sh && chmod +x build_module.sh
RUN echo "#!/bin/sh\n"'exec "$@"' > /usr/local/bin/sudo && chmod +x /usr/local/bin/sudo
RUN /bin/bash -c "./build_module.sh -n fancyindex -y -v \${NGINX_VERSION//-*} -o /root/ https://github.com/aperezdc/ngx-fancyindex.git"
RUN dpkg -i /root/*.deb

FROM nginx:1.15-perl
COPY nginx-entrypoint /
RUN chmod +x nginx-entrypoint
ENTRYPOINT ["/nginx-entrypoint"]
CMD ["nginx", "-g", "daemon off;"]
COPY --from=0 /etc/nginx/modules/ngx_http_fancyindex_module.so /etc/nginx/modules/ngx_http_fancyindex_module.so
COPY fancyindex.conf /etc/nginx/load.d/fancyindex.conf
RUN sed -ri '/index  index\.html/a         fancyindex on;\n        fancyindex_exact_size off;\n' /etc/nginx/conf.d/default.conf
