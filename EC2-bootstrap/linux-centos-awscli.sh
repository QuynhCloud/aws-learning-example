#!/bin/bash

curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
sudo ./aws/install

yum install httpd -y
service httpd start
chkconfig httpd on

cd /var/www/html
echo "<html>" > index.html
METADATA='http://169.254.169.254'

echo "<h1>Welcome to EC2</h1>" >> index.html
echo "<h4>You are running instance from this IP (This is for testing purpose only, you should not public this to user):</h4>"
status_code=$(curl -s -o /dev/null -w "%{http_code}" $METADATA/latest/meta-data/)
instance_id=$(curl -s http://169.254.169.254/latest/meta-data/instance-id)

if [[ "$status_code" -eq 200 ]]
then
    export privateIp=`curl $METADATA/latest/meta-data/local-ipv4`
    export publicIP=`curl $METADATA/latest/meta-data/public-ipv4`
    export AWS_DEFAULT_REGION="Your AWS Region"
                                /usr/bin/aws ec2 create-tags --resources $instance_id --tags'Key="abcde",Value=12345'`
else
    TOKEN=`curl -X PUT "$METADATA/latest/api/token" -H "X-aws-ec2-metadata-token-ttl-seconds: 21600"`
    export privateIp=`curl -H "X-aws-ec2-metadata-token: $TOKEN" -v $METADATA/latest/meta-data/local-ipv4`
    export publicIP=`curl -H "X-aws-ec2-metadata-token: $TOKEN" -v $METADATA/latest/meta-data/public-ipv4`
    export AWS_DEFAULT_REGION="Your AWS Region"
                                /usr/bin/aws ec2 create-tags --resources $instance_id --tags'Key="abcde",Value=12345'`
fi   
echo "<br>Private IP: " >> index.html
echo $privateIp >> index.html

echo "<br>Public IP: " >> index.html
echo $publicIP >> index.html 
echo "</html>" >> index.html
