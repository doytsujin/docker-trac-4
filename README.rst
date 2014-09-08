===========
docker-trac
===========

Dockerized `trac`_.

.. _trac: http://trac.edgewall.org/

Instructions
============

Create Postgres container and database (optionally restoring from dump):

.. code::

   docker run -d --name trac_project_db -p 192.168.50.5:5432:5432 \
      -e SERVICE_5432_NAME=trac_project_db postgres
   createdb -U postgres -h trac_project_db.service.consul -E UTF-8 trac
   pg_restore -U postgres -h trac_project_db.service.consul -d trac \
      trac_project_db.dump

Create a custom trac.ini, ensuring the correct database name:

.. code::

   vi /var/docker_volumes/trac_project/conf/trac.ini

   database = postgres://postgres@trac_project_db.service.consul/trac

Run:

.. code::

   docker run -d --name trac_project -p 8080:8080 \
       -v /var/docker_volumes/trac_project/conf/trac.ini:/opt/trac/trac_project/conf/trac.ini
