#!/bin/bash

DATE=$(date +%F)
LOGSDIR=/tmp
SCRIPT_NAME=$0
LOGFILE=$LOGSDIR/$0-$DATE.log
USERID=$(id -u)
R="\e[31m"
N="\e[0m"
Y="\e[33m"
G="\e[32m"

if [ $USERID -ne 0 ];
then
    echo -e "$R ERROR:: Please run this script with root access $N"
    exit 1
fi

VALIDATE(){
    if [ $1 -ne 0 ];
    then
        echo -e "$2...$R FAILURE $N"
        exit 1
    else
        echo -e "$2...$G SUCCESS $N"
    fi
}

curl -sL https://rpm.nodesource.com/setup_lts.x | bash &>>$LOGFILE

VALIDATE $? "Setting up NPM Source"

yum install nodejs -y &>>$LOGFILE

VALIDATE $? "Installing NodeJs"

useradd roboshop &>>$LOGFILE

mkdir /app &>>$LOGFILE

curl -o /tmp/user.zip https://roboshop-builds.s3.amazonaws.com/user.zip &>>$LOGFILE

VALIDATE $? "Downloding user artifact"

cd /app &>>$LOGFILE

VALIDATE $? "Moving to app directory"

unzip /tmp/user.zip &>>$LOGFILE

VALIDATE $? "unzipping the file"

npm install &>>$LOGFILE

VALIDATE $? "Installing Dependencies"

cp /home/centos/roboshop-shell/user.service  /etc/systemd/system/user.service &>>$LOGFILE

VALIDATE $? "Copying user.service"

systemctl daemon-reload &>>$LOGFILE

VALIDATE $? "Daemon reload"

systemctl enable user &>>$LOGFILE

VALIDATE $? "Enabling user"

systemctl start user &>>$LOGFILE

VALIDATE $? "Starting user"

cp /home/centos/roboshop-shell/mongo.repo /etc/yum.repos.d/mongo.repo &>>$LOGFILE

VALIDATE $? "Copying mongo repo"

yum install mongodb-org-shell -y &>>$LOGFILE

VALIDATE $? "Installing mongo client"

mongo --host mongodb.joindevops.shop </app/schema/user.js &>>$LOGFILE

VALIDATE $? "Loading user data into mongodb"