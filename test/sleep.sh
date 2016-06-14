#!/bin/bash
sleep $1
echo "I slept for $1 seconds on:"
hostname
free -m
cat /etc/*-release

date
