FROM debian:bookworm-slim

RUN apt-get update && apt-get install -y tor python3 python3-pip --no-install-recommends \
    && pip3 install flask requests[socks] --break-system-packages \
    && rm -rf /var/lib/apt/lists/*

COPY torrc /etc/tor/torrc
COPY api.py /app/api.py

# run tor as debian-tor, api as root — use a startup script
COPY start.sh /start.sh
RUN chmod +x /start.sh

CMD ["/start.sh"]
