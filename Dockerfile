FROM marina/python-web:0.5.0
MAINTAINER Steffen Prince <sprin@fastmail.net>

# Pip install Trac
RUN pip install --allow-external Trac --allow-unverified Trac \
    Trac==1.0.5 \
    psycopg2==2.6 \
    genshi==0.6.0

COPY src/ /opt/trac/
COPY uwsgi.ini /opt/trac/uwsgi.ini
COPY config.py.patch /tmp/config.py.patch

# Patch trac to read from environment
RUN yum install -y patch
RUN cd /usr/local/lib/python2.7/site-packages/trac && patch -p0 -i /tmp/config.py.patch

# Expose
EXPOSE  8080

WORKDIR /opt/trac

# Run
CMD ["/usr/local/bin/uwsgi", "--ini", "uwsgi.ini"]
