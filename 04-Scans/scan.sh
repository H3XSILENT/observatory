#!/usr/bin/env bash
source config.sh
source utils.sh

mkdir -p data/scan
cd data/scan || exit

log "Tech fingerprint..."
httpx -l ../crawl/urls.txt -tech-detect -json -o tech.json

log "HTTP status report..."
httpx -l ../crawl/urls.txt -mc "$STATUS_CODES" -title -cl -timeout $TIMEOUT -threads $THREADS > status.txt

# Heavy tools (manual trigger recommended)
if [[ "$1" == "--aggressive" ]]; then
    log "Running nuclei..."
    nuclei -l ../recon/resolv.txt -t "$NUCLEI_TEMPLATES" -c $THREADS -o nuclei.txt

    log "Running subjack..."
    subjack -w ../recon/subs.txt -o takeover.txt -v

    log "Running Dalfox..."
    dalfox pipe ../params/parameters.txt --skip-bav -o xss.txt

    log "Running SQLMap (LOW THREADS!)"
    sqlmap -m ../params/parameters.txt --batch --threads=2 --level=2 --risk=1 -o sqlmap.txt
fi
