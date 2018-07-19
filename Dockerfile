FROM microsoft/mssql-server-linux:latest

COPY start.sh /

RUN chmod 550 /start.sh

CMD ["/start.sh"]