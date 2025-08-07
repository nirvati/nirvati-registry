FROM harbor.nirvati.org/registry/nginx-base:latest

VOLUME /var/cache/nginx /var/log/nginx /run

STOPSIGNAL SIGQUIT

HEALTHCHECK CMD curl --fail -s http://localhost:8080 || exit 1

USER nginx

CMD ["nginx", "-g", "daemon off;"]
