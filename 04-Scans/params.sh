#!/usr/bin/env bash
source utils.sh

cd data/crawl || exit
mkdir -p ../params
cd ../params || exit

log "Extracting parameters..."
grep "=" ../crawl/urls.txt > parameters.txt
sed 's/=.*/=/' parameters.txt | sort -u > parameters_clean.txt

log "Reflected params scan..."
cat parameters_clean.txt | gxss > reflected.txt

log "Fragments extraction..."
grep "#" ../crawl/urls.txt > fragments.txt
