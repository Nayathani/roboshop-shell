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

curl -o /tmp/cart.zip https://roboshop-builds.s3.amazonaws.com/cart.zip &>>$LOGFILE

VALIDATE $? "Downloding cart artifact"

cd /app &>>$LOGFILE

VALIDATE $? "Moving to app directory"

unzip /tmp/cart.zip &>>$LOGFILE

VALIDATE $? "unzipping the file"

npm install &>>$LOGFILE

VALIDATE $? "Installing Dependencies"

cp /home/centos/roboshop-shell/cart.service  /etc/systemd/system/cart.service &>>$LOGFILE

VALIDATE $? "Copying cart.service"

systemctl daemon-reload &>>$LOGFILE

VALIDATE $? "Daemon reload"

systemctl enable cart &>>$LOGFILE

VALIDATE $? "Enabling cart"

systemctl start cart &>>$LOGFILE

VALIDATE $? "Starting cart"

