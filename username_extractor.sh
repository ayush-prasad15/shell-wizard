#!/bin/bash

echo "Extracting usernames from /etc/passwd into userlist.txt"
cut -d: -f1 /etc/passwd >> userlist.txt
