FROM amazon/aws-cli

WORKDIR /scripts/

COPY backup.sh /scripts/
RUN chmod +x /scripts/backup.sh

ENTRYPOINT ["/scripts/backup.sh"]