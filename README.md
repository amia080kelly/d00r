# tor-proxy

A Dockerized Tor SOCKS5 proxy with a Flask HTTP control API.

## Files

| File | Description |
|------|-------------|
| `Dockerfile` | Builds the image (Debian + Tor + Flask) |
| `torrc` | Tor configuration (SOCKS on 9050, control on 9051) |
| `api.py` | Flask API on port 5000 to control Tor |
| `start.sh` | Entrypoint: starts Tor then the API |

## Requirements

- Docker

## Build

```bash
docker build -t tor-proxy .
```

## Run

```bash
docker run -d \
  --name tor-proxy \
  -p 5000:5000 \
  -p 9050:9050 \
  tor-proxy
```

| Port | Purpose |
|------|---------|
| `9050` | Tor SOCKS5 proxy |
| `5000` | Control API |

## API Endpoints

| Endpoint | Description |
|----------|-------------|
| `GET /ip` | Get current Tor exit node IP |
| `GET /reset-ip` | Request a new Tor circuit (new identity) |
| `GET /restart` | Reload Tor config |
| `GET /stop` | Shutdown Tor |
| `GET /start` | Check if Tor is running |

### Examples

```bash
# Get current exit IP
curl http://localhost:5000/ip

# Rotate to a new exit node
curl http://localhost:5000/reset-ip

# Wait a few seconds after reset, then verify new IP
sleep 5 && curl http://localhost:5000/ip
```

## Use as SOCKS5 Proxy

Point any SOCKS5-compatible app to:

```
socks5h://localhost:9050
```

The `h` in `socks5h` ensures DNS is resolved through Tor (recommended).

### Python (requests)

```python
proxies = {
    "http":  "socks5h://localhost:9050",
    "https": "socks5h://localhost:9050",
}
requests.get("https://example.com", proxies=proxies)
```

## Stop / Remove

```bash
docker stop tor-proxy
docker rm tor-proxy
```

## Notes

- After calling `/reset-ip`, wait ~5 seconds before the new circuit is ready
- The control port (9051) has no authentication — do not expose it publicly
- The API (port 5000) has no authentication — restrict access if deploying remotely
