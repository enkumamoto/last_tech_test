#!/bin/bash

sudo yum install -y httpd
sudo systemctl start httpd
sudo systemctl enable httpd


TOKEN=$(curl -X PUT "http://169.254.169.254/latest/api/token" -q -H "X-aws-ec2-metadata-token-ttl-seconds: 21600")
INSTANCE_ID=$(curl -H "X-aws-ec2-metadata-token: ${TOKEN}" -q http://169.254.169.254/latest/meta-data/instance-id)
INSTANCE_TYPE=$(curl -H "X-aws-ec2-metadata-token: ${TOKEN}" -q http://169.254.169.254/latest/meta-data/instance-type)

cat <<EOF > /var/www/html/index.html
<!DOCTYPE html>
<html>
  <head>
    <meta charset="utf-8">
    <title>DevOps Test</title>
  </head>
  <body>
    <p>
      <b>Instance ID:</b> ${INSTANCE_ID}</br>
      <b>Instance Type:</b> ${INSTANCE_TYPE}
    </b>
  </body>
</html>
EOF
