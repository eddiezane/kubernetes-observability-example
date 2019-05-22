#!/bin/bash

while true; do
  number=$((1 + RANDOM % 10))
  echo -n "$number "
  kubectl -n emojivoto scale deployment --replicas $number vote-bot
  number=$((1 + RANDOM % 10))
  echo -n "$number "
  kubectl scale deployment --replicas $number loadgenerator
  sleep 90
done
