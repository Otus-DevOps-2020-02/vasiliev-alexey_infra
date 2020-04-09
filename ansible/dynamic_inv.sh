#!/bin/bash

if [ "$#" -ne 1 ]; then
    echo "Illegal number of parameters"
fi

if [[ $1 = '--host' ]]
then
    echo "[]"
elif    [[ $1  = "--list" ]]
then
    cat inventory.json
else

    echo  $1 " wrong usage posible --host --list"
fi
