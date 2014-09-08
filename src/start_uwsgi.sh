#!/bin/bash
exec /usr/local/bin/uwsgi \
    --http-socket=:8080 \
    --wsgi-file=/opt/trac/trac.wsgi \
    --callable=application
