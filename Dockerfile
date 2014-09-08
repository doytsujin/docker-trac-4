FROM marina/python-web:0.1.0
MAINTAINER Steffen Prince <sprin@fastmail.net>

# Pip install Trac
RUN pip install --allow-external Trac --allow-unverified Trac \
    Trac==0.11.7 \
    psycopg2==2.5.4 \
    genshi==0.6.0

ADD src/ /opt/trac/

RUN chmod +x /opt/trac/start_uwsgi.sh

# Expose
EXPOSE  8080

# Run
CMD ["/opt/trac/start_uwsgi.sh"]
