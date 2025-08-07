FROM harbor.nirvati.org/registry/db-base:latest

ENV EXTERNAL_DB 0

RUN mkdir /harbor/
COPY ./make/migrations /migrations
COPY ./make/photon/standalone-db-migrator/migrate /harbor/
COPY ./make/photon/standalone-db-migrator/entrypoint.sh /harbor/

RUN chown -R postgres:postgres /harbor/ \
    && chown -R postgres:postgres /migrations/ \
    && chmod u+x /harbor/migrate /harbor/entrypoint.sh
USER postgres

ENTRYPOINT ["/harbor/entrypoint.sh"]
