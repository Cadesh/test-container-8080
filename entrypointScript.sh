#!/bin/bash

# Fetch the YouTube homepage
echo "Fetching YouTube homepage..."
youtube_page=$(curl -s -A "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/91.0.4472.124 Safari/537.36" https://www.youtube.com)

sleep 5

# Extract and clean up video titles
echo "Extracting video titles..."
echo "$youtube_page" | grep -oP '"title":{"runs":\[{"text":"\K[^"]+' | sed 's/&quot;/"/g; s/&#39;/'"'"'/g; s/&amp;/\&/g' | sort -u | nl

echo "Done!"
