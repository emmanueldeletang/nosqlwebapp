Content-Type: multipart/mixed; boundary="//"
MIME-Version: 1.0

--//
Content-Type: text/cloud-config; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename="cloud-config.txt"

#cloud-config
cloud_final_modules:
- [scripts-user, always]

--//
Content-Type: text/x-shellscript; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename="userdata.txt"

#!/bin/bash
sudo yum install git -y
sudo yum install jq -y

export region=$(curl http://169.254.169.254/latest/meta-data/placement/region)
export rediscluster=$(aws ssm get-parameter --name redis-endpoint --region $region | jq --raw-output .Parameter | jq -r .Value)
export clusterendpoint=$(aws ssm get-parameter --name docdb-endpoint --region $region | jq --raw-output .Parameter | jq -r .Value)
export NEPTUNE_ENDPOINT=$(aws ssm get-parameter --name neptune-endpoint --region $region | jq --raw-output .Parameter | jq -r .Value)
export username=$(aws secretsmanager get-secret-value --secret-id /nosqldemo/docdb/masteruser --region $region | jq --raw-output .SecretString | jq -r .username)
export password=$(aws secretsmanager get-secret-value --secret-id /nosqldemo/docdb/masteruser --region $region | jq --raw-output .SecretString | jq -r .password)


mkdir ~/.aws
cat << EOF > ~/.aws/config
[default]
region=$region
EOF

cat << EOF > /etc/yum.repos.d/mongodb-org-5.0.repo
[mongodb-org-5.0]
name=MongoDB Repository
baseurl=https://repo.mongodb.org/yum/amazon/2/mongodb-org/5.0/x86_64/
gpgcheck=1
enabled=1
gpgkey=https://www.mongodb.org/static/pgp/server-5.0.asc
EOF

sudo yum install -y mongodb-org


sudo git clone https://github.com/emmanueldeletang/nosqlwebapp /usr/src/app
cd /usr/src/app
python3 -m pip install -r requirements.txt
pip3 install markupsafe==2.0.1
pip3 install Flask==2.0.1

wget https://s3.amazonaws.com/rds-downloads/rds-combined-ca-bundle.pem

mongoimport --ssl --host ${clusterendpoint}:27017 --sslCAFile=rds-combined-ca-bundle.pem --username $username --password $password -d restaurant -c menu --file=menu.json

python3 /usr/src/app/app.py 