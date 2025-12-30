#!/bin/bash

# bash required for ${0:0:1}

if /usr/bin/tty -s
then
  if test "${0:0:1}" = "-"; then
    /usr/libexec/device/status/389ds
  fi
fi

