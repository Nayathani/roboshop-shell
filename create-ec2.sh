#!/bin/bash

NAMES=("mongodb" "redis" "mysql" "rabbitmq" "catalogue" "user" "cart" "shipping" "payment" "dispatch" "web")
INSTANCE_TYPE=""
for i in "${NAMES[@]}"
do
    if [[ $i == "mongodb" || $i == "mysql"]]
    then
        INSTANCE_TYPE="t3.medium"
    else
        INSTANCE_TYPE="t2.micro"
    fi
    echo "creating $i instance"
    aws 
done