FROM 123.59.14.139:5000/kingfile/redis:python2.7

RUN apt-get install -y keepalived module-init-tools net-tools psmisc

COPY ./tools/redis_ctl.sh /usr/local/bin/
COPY ./entrypoint.sh /
COPY ./conf/keepalived.conf /etc/keepalived/

EXPOSE 22 6379

ENTRYPOINT ["/entrypoint.sh"]
CMD /usr/sbin/keepalived -f /etc/keepalived/keepalived.conf --dont-fork --log-console -D
