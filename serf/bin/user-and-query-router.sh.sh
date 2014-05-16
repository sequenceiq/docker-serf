#!/bin/sh
HANDLER_DIR=/usr/local/serf/handlers

if [ "$SERF_EVENT" = "user" ]; then
    HANDLER="$HANDLER_DIR/user-$SERF_USER_EVENT"
elif [ "$SERF_EVENT" = "query" ]; then
    HANDLER="$HANDLER_DIR/query-$SERF_QUERY_NAME"
fi

[ -f "$HANDLER" -a -x "$HANDLER" ] && exec "$HANDLER" || :
