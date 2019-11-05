#!/bin/bash

DISPATCHERLIST="HOSTLIST"

if [ -z "$1" ]; then
	echo "usage: dispatcherflush.sh <content-url>"
else
	for DISPATCHER in "$DISPATCHERLIST"; do
		echo -e "$DISPATCHER..."
		curl -X POST -H"CQ-Action: Activate" -H"CQ-Handle: $@" -H"Content-Length: 0" http://$DISPATCHER/dispatcher/invalidate.cache -I 2>&1 | head -n1 | awk '{ if ($2 == "200") { print "Done" } else { print "Failed" } }'
	done
fi
