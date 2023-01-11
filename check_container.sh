#!/bin/bash
# Author: Jeffry Johar
# Date: 11th Jan 2023
# About: Nagios plugin to check on a container runtime engine and its container
# Usage: container_check.sh [ container name | container id ]

ENGINE=docker
CONTAINER=$1

# A check on user input for container id or name
if [[ -z $1 ]] 
then
 echo "UNKNOWN - Container name or id not specified"
 exit 3
fi

# A check on  container runtime engine  
if ! $ENGINE ps >> /dev/null 2>&1; 
then
 echo "CRITICAL - $ENGINE service is not available"
 exit 2
fi

# A check on the existance of $CONTINER 
if ! $ENGINE inspect --format="{{.State.Running}}" $CONTAINER >> /dev/null 2>&1; 
then
 echo "CRITICAL - $CONTAINER  container does not exist"
 exit 2
fi

# A check on the status of $CONTAINER
if [[  $($ENGINE inspect --format="{{.State.Running}}" $CONTAINER) == "false" ]];
then
 echo "CRITICAL - $CONTAINER container is not running"
 exit 2
fi

# If everything is OK then set the Nagios/Icinga status to OK
echo "OK - $ENGINE service is running. $CONTAINER container is running" 
