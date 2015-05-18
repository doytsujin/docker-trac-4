FROM marina/python-web:0.5.0

EXPOSE  8080

# Dummy sqlite database so trac-admin will run. Silly Trac needs to connect
# to a database before it will do anything, even copy static files :(
ENV DATABASE_URL=sqlite:db/trac.db

# Pip install Trac
RUN pip install --allow-external Trac --allow-unverified Trac \
    Trac==1.0.5 \
    psycopg2==2.6 \
    genshi==0.6.0

# Patch trac to read from environment
COPY patches /tmp/patches
RUN yum install -y patch \
    && cd /usr/local/lib/python2.7/site-packages/trac \
    && for f in /tmp/patches/*.patch; do patch -p0 -i $f; done \
    && rm -rf /tmp/patches

COPY src/ /opt/trac/
COPY uwsgi.ini /opt/trac/uwsgi.ini
# Touch an empty htpasswd file
RUN mkdir /var/trac && touch /var/trac/trac.htpasswd

WORKDIR /opt/trac

# Copy static files
RUN /usr/local/bin/trac-admin /opt/trac/trac_project deploy /chrome

# Run
CMD ["/usr/local/bin/uwsgi", "--ini", "uwsgi.ini"]
