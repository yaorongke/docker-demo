#!/bin/bash

if [ "${myenv}" == "" ]; then
  export myenv=dev
fi

java -jar /data/app.jar  --spring.profiles.active=${myenv}
