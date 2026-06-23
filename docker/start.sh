#!/bin/bash

set -euo pipefail

# Validate inputs

if [ -z "${VIDEO_URL:-}" ]; then
echo "ERROR: VIDEO_URL is not set"
exit 1
fi

if [ -z "${YOUTUBE_STREAM_KEY:-}" ]; then
echo "ERROR: YOUTUBE_STREAM_KEY is not set"
exit 1
fi

echo "Starting 24/7 YouTube Stream..."
echo "----------------------------------------"

# Split multiple URLs (comma-separated)

IFS=',' read -ra URLS <<< "$VIDEO_URL"

# Infinite playlist loop

while true; do
for url in "${URLS[@]}"; do

```
    echo "Streaming: $url"

    ffmpeg \
        -re \
        -i "$url" \
        -vf "scale=1280:720:force_original_aspect_ratio=decrease,pad=1280:720:(ow-iw)/2:(oh-ih)/2" \
        -r 30 \
        -c:v libx264 \
        -preset ultrafast \
        -tune zerolatency \
        -b:v 3000k \
        -maxrate 3000k \
        -bufsize 6000k \
        -pix_fmt yuv420p \
        -c:a aac \
        -b:a 128k \
        -ar 44100 \
        -ac 2 \
        -f flv \
        "rtmp://a.rtmp.youtube.com/live2/${YOUTUBE_STREAM_KEY}" || true

    echo "Finished: $url"
    sleep 5

done
```

done
