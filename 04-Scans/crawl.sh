#!/usr/bin/env bash
source config.sh
source utils.sh

cd data/recon || exit
mkdir -p ../crawl
cd ../crawl || exit

log "Crawling URLs..."

cat ../recon/resolv.txt | gau --subs --threads $THREADS > gau.txt
cat ../recon/resolv.txt | hakrawler -t $THREADS > hakrawler.txt

cat gau.txt hakrawler.txt | sort -u > urls.txt
rm gau.txt hakrawler.txt

log "Crawl done"
