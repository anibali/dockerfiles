#!/bin/bash

set -e

linkvars() {
  local link_addr_var="${1}${3}_PORT_${2}_ADDR"
  local link_port_var="${1}${3}_PORT_${2}_PORT"

  if [ -n "${!link_addr_var}" ] && [ -n "${!link_port_var}" ]
  then
    link_addr="${!link_addr_var}"
    link_port="${!link_port_var}"
    return 0
  else
    return 1
  fi
}

sed_escape() {
  echo $1 | sed -e 's/[\/&]/\\&/g'
}

cp /etc/maxscale.cnf.template /etc/maxscale.cnf

server_list="dbserver1"

counter=1
while linkvars "DB" "3306_TCP" $counter
do
  echo "
[dbserver$counter]
type=server
address=$link_addr
port=$link_port
protocol=MySQLBackend" >> /etc/maxscale.cnf

  if [ $counter -ne 1 ]
  then
    server_list="$server_list, dbserver$counter"
  fi
  let counter+=1
done

sed -i "s/{{MYSQL_USER}}/$(sed_escape $MYSQL_USER)/g" /etc/maxscale.cnf
sed -i "s/{{MYSQL_PASS}}/$(sed_escape $MYSQL_PASS)/g" /etc/maxscale.cnf
sed -i "s/{{SERVER_LIST}}/$server_list/g" /etc/maxscale.cnf

# Start MaxScale with daemon mode disabled.
maxscale -d
