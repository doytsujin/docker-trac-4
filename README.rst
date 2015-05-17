===========
docker-trac
===========

Dockerized `Trac`_. A small patch to enable injecting environment
variables into trac.ini is used.

.. _Trac: http://trac.edgewall.org/

Instructions
============

It is recommended to use this as a base image. Your image should contain
a custom trac.ini and another other plugins or static assets needed.

For connection parameters, it is recommended to use environment variables.
If you have your connection string in the environment variable
$DATABASE_URL, trac.ini should have:

.. code::

   database = %(DATABASE_URL)s

Run:

.. code::

   docker run -d -p 8080:8080 trac

Database Setup
==============

You need a database before you can run trac commands or use the web interface.

To create a `trac` user in Postgres:

.. code::

   create role trac with login;
   grant connect on database trac to trac;
   grant usage on schema public to trac;
