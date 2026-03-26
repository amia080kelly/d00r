#!/bin/bash
su -s /bin/bash debian-tor -c "tor -f /etc/tor/torrc" &
sleep 5
python3 /app/api.py
