FROM marina/python-web:0.5.0

EXPOSE  8080

# Dummy sqlite database so trac-admin will run. Silly Trac needs to connect
# to a database before it will do anything, even copy static files :(
ENV DATABASE_URL=sqlite:db/trac.db

# Pip install Trac
RUN pip install --allow-external Trac --allow-unverified Trac \
    Trac==1.0.5 \
    psycopg2==2.6

# Patch trac to read from environment
COPY config.py.patch /tmp/config.py.patch
RUN yum install -y patch \
    && cd /usr/local/lib/python2.7/site-packages/trac \
    && patch -p0 -i /tmp/config.py.patch

COPY src/ /opt/trac/
COPY uwsgi.ini /opt/trac/uwsgi.ini
# Touch an empty htpasswd file
RUN mkdir /var/trac && touch /var/trac/trac.htpasswd

WORKDIR /opt/trac

# Copy static files
RUN env -i DATABASE_URL=$DATABASE_URL \
    /usr/local/bin/trac-admin /opt/trac/trac_project deploy /chrome

# Copy ini, again, to side-step trac-admin mangling.
COPY src/trac_project/conf/trac.ini /opt/trac/trac_project/conf/trac.ini

# Run
CMD ["/usr/local/bin/uwsgi", "--ini", "uwsgi.ini"]
