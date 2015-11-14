### MaxScale Docker image

[Debian](http://www.debian.org/) + [MaxScale](https://mariadb.com/products/mariadb-maxscale)

`docker pull anibali/maxscale`

* Includes full MaxScale install
* Supports linking MySQL replica containers
* Drop-in replacement for a standard MySQL container

If you are running a normal MySQL database instance, say something similar
to [the official Docker MySQL image](https://hub.docker.com/_/mysql/), then you
should be able to use this as a drop-in replacement. MaxScale has some special
awesome sauce which will automatically spread connections across multiple
database replicas (and split read/writes as appropriate), but to your
application it will just look like a normal database.

#### Configuration

##### Environment variables

When creating a container based on this Docker image, the following environment
variables are expected:

* `MYSQL_USER` and `MYSQL_PASS`: MySQL username and password for connecting to
the database and replicas.
* `DB1_PORT_3306_TCP_ADDR` and `DB1_PORT_3306_TCP_PORT`: Connection details for
replication master.
* `DB2_PORT_3306_TCP_ADDR` and `DB2_PORT_3306_TCP_PORT`: Connection details for
replication slave. Can add more as `DB3`, `DB4`, etc.

MaxScale expects a replication master and at least one replication slave.

#### Usage

##### Example 1: Replicas are in Docker containers

Linking to containers which have the MySQL replica running and listening on
port 3306 will automatically inject most of the required environment variables.

```yaml
db-proxy:
  image: anibali/maxscale
  environment:
    - MYSQL_USER=admin
    - MYSQL_PASS=password
  links:
    - db-master:db1
    - db-slave1:db2
    # ...can specify more slaves...
db-master:
  image: tutum/mysql
  environment:
    - REPLICATION_MASTER=true
    # ...
db-slave1:
  image: tutum/mysql
  environment:
    - REPLICATION_SLAVE=true
    # ...
  links:
    - db-master:mysql
```

##### Example 2: Replicas are external to Docker

When the replicas are running outside of Docker you can manually tell the
container where the replication master and slaves are. This is useful, for
example, if the database is being run in Amazon RDS.

```yaml
db-proxy:
  image: anibali/maxscale
  environment:
    - MYSQL_USER=admin
    - MYSQL_PASS=password
    - DB1_PORT_3306_TCP_ADDR=dbmaster.example.com
    - DB1_PORT_3306_TCP_PORT=3306
    - DB2_PORT_3306_TCP_ADDR=dbslave1.example.com
    - DB2_PORT_3306_TCP_PORT=3306
    # ...can specify more slaves...
```
