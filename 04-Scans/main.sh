#!/usr/bin/env bash
source config.sh
source utils.sh

usage() {
    echo "Usage: $0 domain.com [--aggressive]"
    exit 1
}

[[ -z "$1" ]] && usage
DOMAIN="$1"
MODE="$2"

mkdir -p data

log "Target: $DOMAIN"

bash recon.sh "$DOMAIN" || die "Recon failed"
delay

bash crawl.sh || die "Crawl failed"
delay

bash params.sh || die "Params failed"
delay

bash scan.sh "$MODE" || die "Scan failed"

log "RVULN v2 finished"
