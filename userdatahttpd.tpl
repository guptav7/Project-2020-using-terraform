#!/bin/bash
yum install httpd -y
service httpd start
chkconfig httpd on
wget https://python-test-varsha.s3.ap-south-1.amazonaws.com/index.html
cp index.html -d /var/www/html/

