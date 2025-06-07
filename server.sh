#!/bin/bash

# Simple FFmpeg API using Python + Flask

apt-get update && apt-get install -y python3 python3-pip curl
pip3 install flask

cat <<EOF > /app/api.py
from flask import Flask, request, send_file
import subprocess
import os

app = Flask(__name__)

@app.route("/generate", methods=["POST"])
def generate_video():
    quote = request.form.get("quote")
    audio_url = request.form.get("audio_url")
    output_name = request.form.get("output_name", "clip.mp4")

    subprocess.run(["curl", "-L", audio_url, "-o", "music.mp3"], check=True)

    cmd = [
        "ffmpeg", "-f", "lavfi", "-i", "color=c=black:s=1080x1920:d=15",
        "-i", "music.mp3",
        "-vf", f"drawtext=fontfile=/usr/share/fonts/truetype/dejavu/DejaVuSans-Bold.ttf:text='{quote}':fontcolor=white:fontsize=60:x=(w-text_w)/2:y=(h-text_h)/2:box=1:boxcolor=black@0.5:boxborderw=30",
        "-shortest", "-c:v", "libx264", "-t", "15", "-pix_fmt", "yuv420p", "-y", output_name
    ]
    
    subprocess.run(cmd, check=True)
    return send_file(output_name, as_attachment=True)

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=80)
EOF

python3 /app/api.py
