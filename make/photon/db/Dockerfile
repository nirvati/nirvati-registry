FROM harbor.nirvati.org/registry/db-base:latest

VOLUME /var/lib/postgresql/data

COPY ./make/photon/db/docker-entrypoint.sh /docker-entrypoint.sh
COPY ./make/photon/db/initdb.sh /initdb.sh
COPY ./make/photon/db/upgrade.sh /upgrade.sh
COPY ./make/photon/db/docker-healthcheck.sh /docker-healthcheck.sh
COPY ./make/photon/db/initial-registry.sql /docker-entrypoint-initdb.d/
RUN chown -R postgres:postgres /docker-entrypoint.sh /initdb.sh /upgrade.sh \
    /docker-healthcheck.sh /docker-entrypoint-initdb.d \
    && chmod u+x /initdb.sh /upgrade.sh /docker-entrypoint.sh /docker-healthcheck.sh

ENTRYPOINT ["/docker-entrypoint.sh", "14", "15"]
HEALTHCHECK CMD ["/docker-healthcheck.sh"]

USER postgres
