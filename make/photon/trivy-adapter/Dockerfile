FROM harbor.nirvati.org/registry/trivy-adapter-base:latest

COPY ./make/photon/common/install_cert.sh /home/scanner
COPY ./make/photon/trivy-adapter/entrypoint.sh /home/scanner
COPY ./make/photon/trivy-adapter/binary/trivy /usr/local/bin/trivy
COPY ./make/photon/trivy-adapter/binary/scanner-trivy /home/scanner/bin/scanner-trivy


RUN chown -R scanner:scanner /etc/pki/tls/certs \
    && chown scanner:scanner /home/scanner/entrypoint.sh && chmod u+x /home/scanner/entrypoint.sh \
    && chown scanner:scanner /usr/local/bin/trivy && chmod u+x /usr/local/bin/trivy \
    && chown scanner:scanner /home/scanner/bin/scanner-trivy && chmod u+x /home/scanner/bin/scanner-trivy \
    && chown scanner:scanner /home/scanner/install_cert.sh && chmod u+x /home/scanner/install_cert.sh

HEALTHCHECK --interval=30s --timeout=10s --retries=3 CMD curl --fail -s http://localhost:8080/probe/healthy || curl -k --fail -s https://localhost:8443/probe/healthy || exit 1

ENV TRIVY_VERSION=0.64.1

USER scanner

ENTRYPOINT ["/home/scanner/entrypoint.sh"]
