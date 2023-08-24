#!/bin/bash

NAMES=("mongodb" "redis" "mysql" "rabbitmq" "catalogue" "user" "cart" "shipping" "payment" "dispatch" "web")
INSTANCE_TYPE=""
IMAGE_ID=ami-03265a0778a880afb
SECURITY_GROUP_ID=sg-0255a78c7dec726b0
DOMAIN_NAME=joindevops.shop
for i in "${NAMES[@]}"
do
    if [[ $i == "mongodb" || $i == "mysql"]]
    then
        INSTANCE_TYPE="t3.medium"
    else
        INSTANCE_TYPE="t2.micro"
    fi
    echo "creating $i instance"
    IP_ADDRESS=$(aws ec2 run-instances --image-id $IMAGE_ID --instance-type $INSTANCE_TYPE --security-group-ids 
    $SECURITY_GROUP_ID --tag-specfications "ResourceType=instance,Tags=[{Key=Name,Value=$i}]" | jq -r '.Instances[0].PrivateIpAddress')
    echo "creating $i instance: $IP_ADDRESS"

    
    aws route53 change-resource-record-sets --hosted-zone-id Z003135636O28SQEYEWTP --change-batch '
    {
            "Changes": [{
            "Action": "CREATE",
                        "ResourceRecordSet": {
                            "Name": "'$i.$DOMAIN_NAME'",
                            "Type": "A",
                            "TTL": 300,
                            "ResourceRecords": [{ "Value": "'$IP_ADDRESS'"}]
                        }}]
    }
    '
done