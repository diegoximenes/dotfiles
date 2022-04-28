#!/bin/bash

timedatectl set-local-rtc 1 --adjust-system-clock

# to revert:
# timedatectl set-local-rtc 0 --adjust-system-clock
