#!/usr/bin/env bash
source config.sh
source utils.sh

DOMAIN="$1"

mkdir -p data/recon
cd data/recon || exit

log "Subdomain discovery..."
subfinder -d "$DOMAIN" -silent -o subfinder.txt
findomain -t "$DOMAIN" -q -u findomain.txt

cat *.txt | sort -u > subs.txt
rm subfinder.txt findomain.txt

log "Resolving live hosts..."
httpx -l subs.txt -silent -o resolv.txt

log "Recon done"
