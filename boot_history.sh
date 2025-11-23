#!/bin/bash

echo "Displaying the 5 most recent system boots:"
last reboot | head -n 5
