echo "Starting 4K stream..."

# Run ffmpeg with a timeout of 350 minutes (21000 seconds)
timeout 21000s ffmpeg \
    -re \
    -stream_loop -1 \
    -i /app/videos/video.mp4 \
    -c:v libx264 \
    -preset ultrafast \
    -b:v 12000k \
    -maxrate 16000k \
    -bufsize 24000k \
    -pix_fmt yuv420p \
    -g 50 \
    -c:a aac \
    -b:a 128k \
    -ar 44100 \
    -f flv \
    "rtmp://a.rtmp.youtube.com/live2/${YOUTUBE_STREAM_KEY}" || true

echo "Stream timeout reached. Triggering the next workflow run..."

# Fire the GitHub API using the automatic token to launch the next run
curl -X POST \
  -H "Authorization: token ${GITHUB_TOKEN}" \
  -H "Accept: application/vnd.github.v3+json" \
  https://api.github.com/repos/${GITHUB_REPOSITORY}/actions/workflows/stream.yml/dispatches \
  -d '{"ref":"main"}'

echo "Next workflow triggered successfully!"
