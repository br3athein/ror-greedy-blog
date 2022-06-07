#!/usr/bin/env bash

if [ ! -z "$RAILSUSER" ] ; then
  usermod -u $RAILSUSER rails
fi

exec gosu $RAILSUSER "$@"
