FROM microsoft/mssql-server-linux:latest

COPY start.sh /

RUN chmod 550 /start.sh && \
	apt-get update && \
	apt-get install -y tzdata && \
    apt-get clean

CMD ["/start.sh"]